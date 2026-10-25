"""Independent circuit execution checks with small Python reference models."""
import random
import re
from smt import read_model


def check_examples(args, run, generated, env, root, circuits):
    rng = random.Random(6502)
    total = 0
    for name, (top, source) in circuits.items():
        model = generated / (name + ".lean")
        fields, provenance, _, _ = read_model(model.read_text())
        ins, outs, states = (fields[k] for k in ("Inputs", "Outputs", "State"))
        if name == "IbexALU":
            edges = [0, 1, 0xffffffff, 0x80000000, 0x7fffffff]
            samples = [(op, a, b, 0, 0, 0) for op in range(5) for a in edges for b in edges]
            samples += [(rng.randrange(5), rng.getrandbits(32), rng.getrandbits(32), 0, 0, 0)
                        for _ in range(200)]
        elif name == "ZipSkid":
            samples = [(1, 0, 0, 0), (0, 1, 42, 0), (0, 0, 0, 1)]
            samples += [(int(rng.randrange(37) == 0), rng.randrange(2),
                         rng.getrandbits(32), rng.randrange(2)) for _ in range(300)]
        elif name == "ZipAXIL":
            # Real transactions: address/data wait independently, then stay stable
            # through the handshake. Exercise zero/partial/full strobes and stalls.
            idle = (1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1)
            samples = [(0,) * 12, idle]
            for _ in range(100):
                address, data, mask = rng.randrange(16), rng.getrandbits(32), rng.randrange(16)
                write = (1, 1, address, 0, 1, data, mask, 0, 0, 0, 0, 0)
                samples += [write[:4] + (0,) + write[5:], write, write, idle]
                read = (1, 0, 0, 0, 0, 0, 0, 1, 1, address, 0, 0)
                samples += [read, idle[:11] + (0,), idle[:11] + (0,), idle]
                if _ % 17 == 0:
                    samples += [write, write[:8] + (1, address, 0, 0), idle, (0,) * 12, idle]
        elif name in ("Prefix32", "Ripple32"):
            edges = [0, 1, 0xffffffff, 0x80000000, 0x7fffffff, 0x55555555, 0xaaaaaaaa]
            samples = [(a, b, c) for a in edges for b in edges for c in (0, 1)]
            samples += [(rng.getrandbits(32), rng.getrandbits(32), rng.randrange(2))
                        for _ in range(300)]
        elif name == "CrcSerial":
            samples = [(0, 0, 0)] + [(int(rng.randrange(19) != 0), rng.randrange(2),
                                      rng.randrange(2)) for _ in range(800)]
        elif name == "CrcByte":
            samples = [(0, 0, 0)] + [(int(rng.randrange(19) != 0), rng.randrange(2),
                                      rng.randrange(256)) for _ in range(400)]
        else:
            samples = [(1, 0, 0, 0), (0, 1, 0, 3), (0, 1, 0, 7), (0, 0, 0, 111),
                       (0, 1, 1, 9), (0, 0, 1, 0), (0, 1, 0, 65535), (1, 1, 1, 4)]
            samples += [(int(rng.randrange(37) == 0), rng.randrange(2), rng.randrange(2),
                         rng.randrange(65536)) for _ in range(1000)]
        total += len(samples)
        csv = args.work / (name + ".csv")
        csv.write_text("\n".join(",".join(map(str, row)) for row in samples) + "\n")
        values = ", ".join(f"{f} := BitVec.ofNat {w} n[{i}]!" for i, (f, w) in enumerate(ins))
        observations = [("o", f) for f, _ in outs] + [("next", f) for f, _ in states]
        display = ",".join("{" + obj + "." + f + ".toNat}" for obj, f in observations)
        runner = args.work / ("Run" + name + ".lean")
        runner.write_text(f"import {name}\nopen v_{name}\n"
            + "def main (args : List String) : IO Unit := do\n"
            + "  let lines ← IO.FS.lines args[0]!\n  let mut state : State := default\n"
            + "  for line in lines do\n    let n := (line.splitOn \",\").map String.toNat!\n"
            + f"    let (o, next) := eval {{ {values} }} state\n"
            + f'    IO.println s!"{display}"\n    state := next\n')
        run([args.lake, "env", "lean", "-o", args.work / (name + ".olean"), model], env=env)
        actual = run([args.lake, "env", "lean", "--run", runner, csv], env=env).stdout.splitlines()
        rtl = lambda kind, field: provenance[kind, field]
        declarations = " ".join(f"reg [{w-1}:0] {rtl('Inputs', f)};" for f, w in ins)
        declarations += " " + " ".join(f"wire [{w-1}:0] {rtl('Outputs', f)};" for f, w in outs)
        ports = [f".{rtl(k, f)}({rtl(k, f)})" for k in ("Inputs", "Outputs") for f, _ in fields[k]]
        if states:
            clock = re.search(r"-- Clock port omitted from Inputs: (\w+);", model.read_text())[1]
            ports.append(f".{clock}(clk)")
        initialize = " ".join(f"dut.{rtl('State', f)}=0;" for f, _ in states)
        if name.startswith("Zip"):
            initialize = ""  # These pinned configurations initialize all physical registers.
        names = [rtl("Outputs", f) for f, _ in outs]
        state_names = ["dut." + rtl("State", f) for f, _ in states]
        readfmt = ",".join(["%d"] * len(ins)) + "\\n"
        ofmt = ",".join(["%0d"] * len(outs))
        sfmt = ",".join(["%0d"] * len(states))
        sampling = f'$display("{ofmt}",{",".join(names)});'
        if states:
            sampling = f'$write("{ofmt},",{",".join(names)}); clk=1; #1; '
            sampling += f'$display("{sfmt}",{",".join(state_names)});'
        tb = args.work / (name + "_tb.v")
        tb.write_text(f"module tb; reg clk; {declarations}\n{top} dut({','.join(ports)});\n"
            + "integer fd,status; initial begin clk=0; #1; " + initialize
            + f' fd=$fopen("{csv}","r"); while(!$feof(fd)) begin\n'
            + f'status=$fscanf(fd,"{readfmt}",{",".join(rtl("Inputs", f) for f, _ in ins)});\n'
            + f"if(status=={len(ins)}) begin clk=0; #1; {sampling} end end\n"
            + "$finish; end endmodule\n")
        binary = args.work / (name + ".vvp")
        run([args.iverilog, "-g2012", "-s", "tb", "-o", binary, root / source, tb])
        expected = [line for line in run([args.vvp, binary]).stdout.splitlines()
                    if re.match(r"^\d+,", line)]
        assert len(actual) == len(expected) == len(samples)
        crc, queue = 0, []
        registers = [0] * 4
        awready = bvalid = rvalid = rdata = 0

        def bit_step(r, b):
            return ((r << 1) & 255) ^ (7 if ((r >> 7) ^ b) else 0)

        for n, (sample, a, e) in enumerate(zip(samples, actual, expected)):
            assert a == e, (name, n, sample, a, e)
            nums = list(map(int, a.split(",")))
            o = dict(zip((f for f, _ in outs), nums))
            s = dict(zip((f for f, _ in states), nums[len(outs):]))
            if name == "IbexALU":
                op, a, b, *_ = sample
                assert o['v_result_o'] == ((a + b, a - b, a ^ b, a | b, a & b)[op] & 0xffffffff)
            elif name == "ZipSkid":
                reset, valid, data, ready = sample
                assert o['v_o_ready'] == int(not queue)
                assert o['v_o_valid'] == int(not reset and (valid or bool(queue)))
                if reset:
                    queue.clear()
                else:
                    if o['v_o_ready'] and valid:
                        queue.append(data)
                    if o['v_o_valid'] and ready:
                        assert queue.pop(0) == o['v_o_data']
                assert len(queue) <= 1
                assert s['v_LOGIC_r_valid'] == int(bool(queue))
                if queue:
                    assert s['v_LOGIC_r_data'] == queue[0]
            elif name == "ZipAXIL":
                resetn, awv, awa, _, wv, data, mask, br, arv, ara, _, rr = sample
                assert [o[f'v_S_AXI_{p}'] for p in
                        ('AWREADY', 'WREADY', 'BVALID', 'RVALID', 'RDATA', 'BRESP', 'RRESP')] == [
                            awready, awready, bvalid, rvalid, rdata, 0, 0]
                old_registers = registers.copy()
                if not resetn:
                    registers = [0] * 4
                elif awready:
                    old = registers[awa >> 2]
                    enables = sum(255 << (8 * k) for k in range(4) if (mask >> k) & 1)
                    registers[awa >> 2] = (old & ~enables) | (data & enables)
                if not rvalid or rr:
                    rdata = old_registers[ara >> 2]
                next_ready = int(bool(resetn and not awready and awv and wv and (not bvalid or br)))
                bvalid = int(bool(resetn and (awready or (bvalid and not br))))
                rvalid = int(bool(resetn and ((arv and not rvalid) or (rvalid and not rr))))
                awready = next_ready
                assert [s[f'v_r{k}'] for k in range(4)] == registers
                assert s['v_S_AXI_RDATA'] == rdata
                assert s['v_SIMPLE_WRITES_axil_awready'] == awready
                assert s['v_S_AXI_BVALID'] == bvalid and s['v_S_AXI_RVALID'] == rvalid
            elif name in ("Prefix32", "Ripple32"):
                assert ((o["v_cout"] << 32) | o["v_sum"]) == sum(sample)
            elif name == "CrcSerial":
                reset_n, b, valid = sample
                assert o["v_crc"] == crc
                crc = 255 if not reset_n else bit_step(crc, b) if valid else crc
                assert s["v_crc"] == crc
            elif name == "CrcByte":
                reset_n, valid, byte = sample
                assert o["v_crc"] == crc
                if not reset_n:
                    crc = 255
                elif valid:
                    for k in range(7, -1, -1):
                        crc = bit_step(crc, (byte >> k) & 1)
                assert s["v_crc"] == crc
            else:
                reset, valid, ready, x = sample
                assert o["v_out_valid"] == int(not reset and bool(queue))
                assert o["v_in_ready"] == int(not reset and (not queue or ready))
                if reset:
                    queue.clear()
                else:
                    if o["v_out_valid"] and ready:
                        assert o["v_out_data"] == queue.pop(0)
                    if o["v_in_ready"] and valid:
                        queue.append((5 * x + 1) & 65535)
                assert len(queue) <= 1 and s["v_full"] == len(queue)
                if queue:
                    assert s["v_data"] == queue[0]
        print(f"PASS: {name}, {len(samples)} Lean/RTL samples and independent reference", flush=True)
    print(f"PASS: {total} Lean/RTL samples across {len(circuits)} circuits", flush=True)
