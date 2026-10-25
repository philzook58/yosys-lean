"""Five intentional NERV faults and one shared, unmodified RTL control."""
import argparse
from pathlib import Path
import subprocess
from export import ROOT, cpu_lowering, quote

# Each recipe must match exactly once in the pinned source. No upstream file is edited.
FAULTS = {
    'Operand': (
        'wire [31:0] rs1_value = !insn_rs1 ? 0 : regfile[insn_rs1];',
        'wire [31:0] rs1_value = !insn_rs1 ? 0 : regfile[insn_rs2];'),
    'Alias': (
        'if (mem_rd_enable_q || next_wr)',
        'if (mem_rd_enable_q || (next_wr && (insn_rd == 0 || insn_rd != insn_rs1)))'),
    'Stall': (
        'if (!trapped && !stall && !reset && !reset_q)',
        'if (!trapped && !stall && !reset && !reset_q && !resume_stall_q)'),
    'Load': (
        'wire [31:0] rs1_value = !insn_rs1 ? 0 : regfile[insn_rs1];',
        'wire [31:0] rs1_value = !insn_rs1 ? 0 :\n'
        '\t\tjust_loaded && insn_rs1 == load_dest ? stale_load_value : regfile[insn_rs1];'),
    'Fetch': (
        'assign imem_addr = (stall || trap || mem_rd_enable_q) ? imem_addr_q : npc;',
        "assign imem_addr = (stall || trap || mem_rd_enable_q) ? imem_addr_q :\n"
        "\t\tinsn_opcode == 7'b1101111 ? pc + 4 : npc;"),
}


def fault_sources():
    original = ROOT / 'examples/riscv/upstream/nerv/nerv.sv'
    sources = {'NervFaultControl': original}
    directory = ROOT / 'build/cpu-faults'
    directory.mkdir(parents=True, exist_ok=True)
    for fault, (before, after) in FAULTS.items():
        text = original.read_text()
        assert text.count(before) == 1, fault
        text = text.replace(before, after)
        if fault == 'Stall':
            text = text.replace('\t// every cycle', '''\treg resume_stall_q;
\talways @(posedge clock)
\t\tif (reset) resume_stall_q <= 0;
\t\telse resume_stall_q <= stall;

\t// every cycle''')
        if fault == 'Load':
            text = text.replace('\t// rs1 and rs2', '''\treg just_loaded;
\treg [4:0] load_dest;
\treg [31:0] stale_load_value;
\talways @(posedge clock) begin
\t\tif (reset) just_loaded <= 0;
\t\telse if (!stall) begin
\t\t\tjust_loaded <= mem_rd_enable_q;
\t\t\tload_dest <= mem_rd_reg_q;
\t\t\tstale_load_value <= regfile[mem_rd_reg_q];
\t\tend
\tend

\t// rs1 and rs2''')
        path = directory / (fault.lower() + '.sv')
        path.write_text(text)
        sources['NervFault' + fault] = path
    return sources


def fault_scripts():
    directory = 'examples/riscv/upstream/riscv-formal/'
    return {name: (
        f'read_verilog -formal -sv -I{directory} -D NERV_RVFI '
        '-D RISCV_FORMAL_NRET=1 -D RISCV_FORMAL_XLEN=32 -D RISCV_FORMAL_ILEN=32 '
        '-D RISCV_FORMAL_CHANNEL_IDX=0 -D RISCV_FORMAL_INSN_MODEL=rvfi_insn_add '
        f'{directory}rvfi_macros.vh {quote(source.relative_to(ROOT))} '
        f'{directory}insn_add.v {directory}rvfi_insn_check.sv '
        'examples/riscv/NervFaultHarness.sv; hierarchy -check -top NervFaultHarness; '
        f'rename NervFaultHarness {name}; ')
        for name, source in fault_sources().items()}


def export_faults(yosys, plugin, dest=None):
    dest = dest or ROOT / 'Examples/Generated'
    dest.mkdir(parents=True, exist_ok=True)
    for name, script in fault_scripts().items():
        subprocess.run([str(yosys), '-Q', '-T', '-m', str(plugin), '-p',
                        script + cpu_lowering(name) + f'write_lean {quote(dest / (name + ".lean"))}'],
                       cwd=ROOT, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--yosys', type=Path, default=ROOT / 'build/yosys/yosys')
    parser.add_argument('--plugin', type=Path, default=ROOT / 'build/yosys_lean.so')
    args = parser.parse_args()
    export_faults(args.yosys, args.plugin)
