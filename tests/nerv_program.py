"""Actual synchronous-ROM wiring: Lean/RTL replay, independent ISA, and a fetch mutation."""
import random
import sys

from export import cpu_scripts, cpu_lowering, quote

MASK = 2**32 - 1
PAYLOAD = ['rvfi_insn', 'rvfi_pc_rdata', 'rvfi_pc_wdata', 'rvfi_rs1_addr',
           'rvfi_rs2_addr', 'rvfi_rs1_rdata', 'rvfi_rs2_rdata', 'rvfi_rd_addr', 'rvfi_rd_wdata']


def signed(value, width):
    return value - (1 << width) if value >> (width - 1) else value


def isa_step(w, pc, regs):
    """Independent RV32I interpreter; returns a new PC and register file."""
    op, rd, rs1, rs2 = w & 127, (w >> 7) & 31, (w >> 15) & 31, (w >> 20) & 31
    x, y, next_pc = regs[rs1], regs[rs2], (pc + 4) & MASK
    imm = signed(w >> 20, 12)
    if op == 0x63:
        f = (w >> 12) & 7
        take = {0: x == y, 1: x != y, 4: signed(x, 32) < signed(y, 32),
                5: signed(x, 32) >= signed(y, 32), 6: x < y, 7: x >= y}[f]
        offset = ((w >> 31) << 12 | ((w >> 7) & 1) << 11 |
                  ((w >> 25) & 63) << 5 | ((w >> 8) & 15) << 1)
        return ((pc + signed(offset, 13)) & MASK if take else next_pc), regs.copy()
    value = {0x33: lambda: x + y, 0x13: lambda: x + imm,
             0x37: lambda: w & 0xfffff000, 0x17: lambda: (w & 0xfffff000) + pc,
             0x6f: lambda: pc + 4, 0x67: lambda: pc + 4}[op]()
    if op == 0x6f:
        offset = ((w >> 31) << 20 | ((w >> 12) & 255) << 12 |
                  ((w >> 20) & 1) << 11 | ((w >> 21) & 1023) << 1)
        next_pc = (pc + signed(offset, 21)) & MASK
    elif op == 0x67:
        next_pc = ((x + imm) & MASK) & ~1
    out = regs.copy()
    if rd:
        out[rd] = value & MASK
    return next_pc, out


def control_rom():
    def addi(rd, rs, imm):
        return (imm & 4095) << 20 | rs << 15 | rd << 7 | 0x13

    def branch(f, rs1, rs2, offset):
        b = offset & 8191
        return ((b >> 12) << 31 | ((b >> 5) & 63) << 25 | rs2 << 20 | rs1 << 15 |
                f << 12 | ((b >> 1) & 15) << 8 | ((b >> 11) & 1) << 7 | 0x63)

    def jal(rd, offset):
        b = offset & ((1 << 21) - 1)
        return ((b >> 20) << 31 | ((b >> 1) & 1023) << 21 | ((b >> 11) & 1) << 20 |
                ((b >> 12) & 255) << 12 | rd << 7 | 0x6f)

    words = [addi(1, 0, 5), addi(1, 1, -1), branch(1, 1, 0, -4), addi(9, 0, 0)]
    # Both directions of every branch; signed/unsigned disagreement and equality boundaries.
    for f, x, y in [(0, 1, 1), (0, 1, 2), (1, 1, 2), (1, 1, 1),
                    (4, -1, 1), (4, 1, -1), (5, 1, -1), (5, -1, 1),
                    (6, 1, -1), (6, -1, 1), (7, -1, 1), (7, 1, -1)]:
        words += [addi(1, 0, x), addi(2, 0, y), branch(f, 1, 2, 8), addi(30, 30, 1)]
    words.append(jal(5, 0x400 - 4 * len(words)))
    # JALR rd=rs1 reads the old value; bit zero of the target is cleared.
    words.append(addi(6, 0, 4 * (len(words) + 2) + 1))
    words += [6 << 15 | 6 << 7 | 0x67, jal(0, 0)]
    return {**{4 * n: w for n, w in enumerate(words)},
            0x400: addi(9, 9, 1), 0x404: 5 << 15 | 0x67}


def check_nerv_program(args, run, env, root):
    _check_program(args, run, env, root, False)
    _check_program(args, run, env, root, True)
    check_alignment(args, run, env, root)


def _check_program(args, run, env, root, control):
    folder = args.work / ('nerv-control-program' if control else 'nerv-program')
    folder.mkdir(exist_ok=True)
    rng = random.Random(5804)
    # Guaranteed distinct first words, sign extension, x0, aliasing, and all four classes.
    words = [0x800000b7, 0xfff08093, 0x001081b3, 0x00000217]
    for n in range(28):
        rd, rs1, rs2 = (rng.randrange(32) for _ in range(3))
        if n % 4 == 0:
            words.append(rs2 << 20 | rs1 << 15 | rd << 7 | 0x33)
        elif n % 4 == 1:
            words.append(rng.randrange(4096) << 20 | rs1 << 15 | rd << 7 | 0x13)
        else:
            words.append(rng.randrange(2**20) << 12 | rd << 7 | (0x37 if n % 4 == 2 else 0x17))
    memory = {4 * n: w for n, w in enumerate(words)}
    regs = [0] + [rng.randrange(2**32) for _ in range(31)]
    controls = [(int(n in (0, 43)), int(n not in (0, 1, 43, 44) and rng.randrange(4) == 0))
                for n in range(110)]
    if control:
        memory = control_rom()
        controls = [(int(n in (0, 143)),
                     int(n not in (0, 1, 143, 144) and rng.randrange(4) == 0))
                    for n in range(280)]
    rom_lean = '\n'.join(f'  | {pc} => {w}' for pc, w in memory.items())
    init_lean = ', '.join(f'v_cpu_regfile_{n}_ := {regs[n]}' for n in range(1, 32))
    control_lean = ','.join(f'({r},{s})' for r, s in controls)
    # Outputs are sampled before each edge, exactly as in the exported semantics.
    fields = ['state.word', 'o.v_imem_addr', 'state.cpu.v_cpu_pc']
    fields += [f'state.cpu.v_cpu_regfile_{n}_' for n in range(1, 32)]
    fields += ['o.v_rvfi_valid']
    csv = ','.join('{' + f + '.toNat}' for f in fields)
    payload = ','.join('{o.v_' + f + '.toNat}' for f in PAYLOAD)
    runner = folder / 'ProgramReplay.lean'
    runner.write_text('import Examples.NervProgram\nopen NervProgram\n'
        + 'def memory : Program := fun pc ↦ match pc.toNat with\n' + rom_lean + '\n  | _ => 19\n'
        + 'def controls : List Inputs := ([' + control_lean
        + '] : List (BitVec 1 × BitVec 1)).map fun (r, s) ↦\n'
        + '  { (default : Inputs) with v_reset := r, v_stall := s }\n'
        + 'def main : IO Unit := do\n'
        + '  let mut state : Machine := ⟨{ (default : v_NervFetch.State) with ' + init_lean + ' }, 0⟩\n'
        + '  for (i, k) in controls.zipIdx do\n'
        + '    let (o, next) := eval memory i state\n'
        + '    if k >= 2 then\n'
        + f'      IO.println s!"C,{{k}},{csv}"\n'
        + '      if o.v_rvfi_valid == 1 then\n'
        + f'        IO.println s!"P,{{k}},{payload}"\n'
        + '    state := next\n')
    checked = run([sys.executable, root / 'scripts/check_lean.py', '--run', runner], env=env)
    expected = [x for x in checked.stdout.splitlines() if x.startswith(('C,', 'P,'))]
    assert len([x for x in expected if x.startswith('C,')]) == len(controls) - 2
    rom_sv = '\n'.join(f"32'd{pc}: rom=32'd{w};" for pc, w in memory.items())
    control_sv = '\n'.join(f"{n}: begin reset={r}; stall={s}; end" for n, (r, s) in enumerate(controls))
    bench = folder / 'ProgramReplay_tb.sv'
    names = ['word', 'imem_addr', 'dut.pc'] + [f'dut.regfile[{n}]' for n in range(1, 32)] + ['rvfi_valid']
    addresses = ('rvfi_rs1_addr', 'rvfi_rs2_addr', 'rvfi_rd_addr')
    payload_wires = ' '.join(f'wire [{4 if p in addresses else 31}:0] {p};' for p in PAYLOAD)
    connections = ','.join(f'.{p}({p})' for p in PAYLOAD)
    init_sv = ' '.join(f"dut.regfile[{n}]=32'd{regs[n]};" for n in range(32))
    bench.write_text('module tb; reg clock=0,reset,stall; reg [31:0] word=0; '
        + 'wire [31:0] imem_addr; wire rvfi_valid; ' + payload_wires + '\n'
        + 'nerv dut(.clock(clock),.reset(reset),.stall(stall),.imem_addr(imem_addr),'
        + '.imem_data(word),.dmem_rdata(32\'d0),.rvfi_valid(rvfi_valid),' + connections + ');\n'
        + 'function [31:0] rom(input [31:0] addr); case(addr)\n' + rom_sv
        + "\ndefault: rom=32'd19; endcase endfunction\n"
        + 'always @(posedge clock) word <= rom(imem_addr);\n'
        + 'integer k; initial begin ' + init_sv
        + f' for(k=0;k<{len(controls)};k=k+1) begin case(k)\n' + control_sv + '\nendcase\n'
        + '#1; if(k>=2) begin '
        + '$display("C,%0d,' + ','.join('%0d' for _ in names) + '",k,' + ','.join(names) + ');'
        + 'if(rvfi_valid) $display("P,%0d,' + ','.join('%0d' for _ in PAYLOAD)
        + '",k,' + ','.join(PAYLOAD) + '); end clock=1; #1; clock=0; end $finish; end endmodule\n')

    def simulate(source, name):
        binary = folder / (name + '.vvp')
        run([args.iverilog, '-g2012', '-D', 'NERV_RVFI', '-s', 'tb', '-o', binary, source, bench])
        rows = [x for x in run([args.vvp, binary]).stdout.splitlines() if x.startswith(('C,', 'P,'))]
        (folder / (name + '.csv')).write_text('\n'.join(rows) + '\n')
        return rows

    original = root / 'examples/riscv/upstream/nerv/nerv.sv'
    observed = simulate(original, 'Original')
    assert observed == expected, next(((a, b) for a, b in zip(observed, expected) if a != b),
                                     (len(observed), len(expected)))
    # Independent ISA interpreter: instruction selection uses the reference PC, never RTL word.
    pc, previous_reset, reference_regs = 0, False, regs.copy()
    branches, opcodes, visited = set(), set(), set()
    states = {int(x.split(',')[1]): list(map(int, x.split(',')[2:]))
              for x in observed if x.startswith('C,')}
    for n, (reset, stall) in enumerate(controls):
        if n >= 2:
            word, request, actual_pc, *tail = states[n]
            assert actual_pc == pc and tail[:31] == reference_regs[1:], (n, actual_pc, pc)
            if not reset and not previous_reset:
                assert word == memory.get(pc, 19), (n, 'fetch coherence')
                expected_pc, _ = isa_step(memory.get(pc, 19), pc, reference_regs)
                assert request == (pc if stall else expected_pc), (n, 'request')
        if reset or previous_reset:
            pc = MASK - 3 if reset else 0
        elif not stall:
            w = memory.get(pc, 19)
            next_pc, next_regs = isa_step(w, pc, reference_regs)
            opcodes.add(w & 127)
            visited.add(pc)
            if w & 127 == 0x63:
                branches.add(((w >> 12) & 7, next_pc != ((pc + 4) & MASK)))
            pc, reference_regs = next_pc, next_regs
        previous_reset = reset
    if control:
        assert branches == {(f, take) for f in (0, 1, 4, 5, 6, 7) for take in (False, True)}
        assert {0x6f, 0x67, 0x63} <= opcodes and {0x400, 0x404} <= visited
        assert reference_regs[9] == 1 and reference_regs[6] == pc
        print('PASS: stored control flow, 278 edges, countdown/call/return, all six branches '
              'taken and untaken, JALR alias and low-bit clearing; Lean/RTL/independent ISA', flush=True)
        return
    # Corrupt only the actual request; arithmetic and RVFI generation stay untouched.
    before = 'assign imem_addr = (stall || trap || mem_rd_enable_q) ? imem_addr_q : npc;'
    text = original.read_text()
    assert text.count(before) == 1
    bad = folder / 'nerv_fetch_bad.sv'
    bad.write_text(text.replace(before, before.replace(': npc;', ': npc + 4;')))
    broken = simulate(bad, 'WrongFetch')
    assert broken != expected
    first = next(x for x in broken if x.startswith('C,2,')).split(',')
    assert int(first[2]) != memory.get(int(first[4]), 19), 'Mutation must violate the fetch contract'
    prefix = cpu_scripts()['NervFetch'].replace(str(original.relative_to(root)), str(bad)).replace(
        'rename NervFetchHarness NervFetch;', 'rename NervFetchHarness NervFetchBad;')
    model = folder / 'NervFetchBad.lean'
    run([args.yosys, '-Q', '-T', '-m', args.plugin, '-p', prefix + cpu_lowering('NervFetchBad')
         + 'write_lean ' + quote(model)])
    run([sys.executable, root / 'scripts/check_lean.py', model, '--output',
         folder / 'NervFetchBad.olean'], env=env)
    witness = folder / 'WrongFetch.lean'
    witness.write_text('import YosysLean.Check\nimport NervFetchBad\nopen v_NervFetchBad\n'
        + 'def i : Inputs := { (default : Inputs) with v_imem_data := 19 }\n'
        + 'def s : State := default\n'
        + 'theorem wrong_request : s.v_cpu_reset_q = 0 ∧ s.v_cpu_trap = 0 ∧\n'
        + '    s.v_cpu_mem_rd_enable_q = 0 ∧ s.v_cpu_imem_addr_q = s.v_cpu_pc ∧ i.v_reset = 0 ∧\n'
        + '    (eval i s).1.v_imem_addr = 8 ∧ (eval i s).2.v_cpu_pc = 4 := by decide\n'
        + '#check_claim wrong_request\n')
    proof_env = dict(env, LEAN_PATH=str(folder) + ':' + env.get('LEAN_PATH', ''))
    proof = run([sys.executable, root / 'scripts/check_lean.py', witness], env=proof_env)
    (folder / 'WrongFetch.log').write_text(proof.stdout)
    print('PASS: stored-ROM NERV, 108 edges, all registers/PC/requests and valid RVFI agree; '
          'independent ISA, mid-run reset, and certified/replayed wrong-fetch control', flush=True)


def check_alignment(args, run, env, root):
    """Check selected-target alignment, including untaken branches and JALR bit zero."""
    folder = args.work / 'nerv-control-program'
    # JAL +2/+0; JALR x0+3/+1/+2; BEQ +2/+4; BNE +2 (untaken).
    cases = [(0x0020006f, 1), (0x0000006f, 0), (0x00300067, 1), (0x00100067, 0),
             (0x00200067, 1), (0x00000163, 1), (0x00000263, 0), (0x00001163, 0)]
    runner = folder / 'AlignmentReplay.lean'
    runner.write_text('import Examples.NervControlDecode\nopen v_NervAdd\n'
        + 'def main : IO Unit := do\n'
        + '  let words : List (BitVec 32) := [' + ','.join(str(w) for w, _ in cases) + ']\n'
        + '  for (w, k) in words.zipIdx do\n'
        + '    let i : Inputs := { (default : Inputs) with v_imem_data := w }\n'
        + '    let first := (eval { i with v_reset := 1 } default).2\n'
        + '    let ready := (eval i first).2\n'
        + '    IO.println s!"A,{k},{(eval i ready).2.v_cpu_trap.toNat}"\n')
    lean = run([sys.executable, root / 'scripts/check_lean.py', '--run', runner], env=env)
    expected = [f'A,{n},{trap}' for n, (_, trap) in enumerate(cases)]
    assert [x for x in lean.stdout.splitlines() if x.startswith('A,')] == expected
    bench = folder / 'AlignmentReplay_tb.sv'
    init = ' '.join(f'dut.regfile[{n}]=0;' for n in range(32))
    stimuli = ''.join(f"word=32'd{w}; reset=1; tick; reset=0; tick; tick; "
                      f'$display("A,{n},%0d",trap);\n' for n, (w, _) in enumerate(cases))
    bench.write_text('module tb; reg clock=0, reset=0; reg [31:0] word; wire trap;\n'
        + "nerv dut(.clock(clock),.reset(reset),.stall(1'b0),.trap(trap),"
        + ".imem_data(word),.dmem_rdata(32'd0));\n"
        + 'task tick; begin #1; clock=1; #1; clock=0; end endtask\n'
        + 'initial begin ' + init + stimuli + '$finish; end endmodule\n')
    binary = folder / 'AlignmentReplay.vvp'
    run([args.iverilog, '-g2012', '-s', 'tb', '-o', binary,
         root / 'examples/riscv/upstream/nerv/nerv.sv', bench])
    actual = [x for x in run([args.vvp, binary]).stdout.splitlines() if x.startswith('A,')]
    assert actual == expected, (actual, expected)
    print('PASS: eight selected-target alignment cases, Lean and unchanged RTL trap flags; '
          'untaken misaligned branch does not trap', flush=True)
