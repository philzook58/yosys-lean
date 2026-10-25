// SPDX-License-Identifier: ISC
// Word-level FunctionalIR exporter. Yosys owns elaboration and circuit lowering.
#include "kernel/yosys.h"
#include "kernel/functional.h"
#include "kernel/ff.h"
#include "kernel/ffinit.h"
#include "kernel/sigtools.h"
#include <fstream>
#include <map>
#include <set>
#include <sstream>

USING_YOSYS_NAMESPACE
PRIVATE_NAMESPACE_BEGIN

using Node = Functional::Node;
using Fn = Functional::Fn;

// Metadata is always printed in single-line comments. Never interpolate HDL into Lean syntax.
std::string comment(std::string s) {
    for (char &c : s)
        if (static_cast<unsigned char>(c) < 32 || static_cast<unsigned char>(c) > 126) c = '?';
    return s;
}

struct Names {
    std::set<std::string> used;
    std::string make(std::string s) {
        s = RTLIL::unescape_id(s);
        for (char &c : s)
            if (!((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') ||
                  (c >= '0' && c <= '9') || c == '_')) c = '_';
        // Prefix every identifier, including keywords and names with leading digits.
        s = "v_" + s;
        auto base = s;
        for (unsigned i = 1; !used.insert(s).second; ++i) s = base + "_" + std::to_string(i);
        return s;
    }
};

std::string literal(const RTLIL::Const &c, bool mask = false, bool initial = false) {
    std::string bits;
    for (int i = c.size(); i-- > 0;) {
        bool known = c[i] == State::S0 || c[i] == State::S1;
        if (!known && !initial)
            log_cmd_error("write_lean: unknown combinational constant bit; refusing concretization.\n");
        bits += mask ? (known ? '1' : '0') : (c[i] == State::S1 ? '1' : '0');
    }
    return "(0b" + bits + " : BitVec " + std::to_string(c.size()) + ")";
}

struct Expressions : Functional::DefaultVisitor<std::string> {
    const std::map<int, std::string> &nodes;
    bool named;
    const std::map<std::pair<IdString, IdString>, std::string> &input_names;
    const std::map<IdString, std::string> &state_names;
    Expressions(const std::map<int, std::string> &nodes,
                const std::map<std::pair<IdString, IdString>, std::string> &input_names,
                const std::map<IdString, std::string> &state_names, bool named)
        : nodes(nodes), named(named), input_names(input_names), state_names(state_names) {}
    std::string n(Node a) {
        auto name = nodes.at(a.id());
        return named ? "(" + name + " inputs state)" : name;
    }
    std::string app(std::string f, Node a) { return "(" + f + " " + n(a) + ")"; }
    std::string app(std::string f, Node a, Node b) {
        return "(" + f + " " + n(a) + " " + n(b) + ")";
    }
    std::string binary(std::string op, Node a, Node b) {
        return "(" + n(a) + " " + op + " " + n(b) + ")";
    }
    std::string boolvec(std::string b) { return "(BitVec.ofBool " + b + ")"; }
    std::string default_handler(Node a) override {
        log_cmd_error("write_lean: unsupported operation %s at %s.\n",
            Functional::fn_to_string(a.fn()), a.name().unescape());
    }
    std::string buf(Node, Node a) override { return n(a); }
    std::string slice(Node, Node a, int start, int width) override {
        return "(BitVec.extractLsb' " + std::to_string(start) + " " + std::to_string(width) + " " + n(a) + ")";
    }
    std::string zero_extend(Node, Node a, int width) override {
        return "(BitVec.setWidth " + std::to_string(width) + " " + n(a) + ")";
    }
    std::string sign_extend(Node, Node a, int width) override {
        return "(BitVec.signExtend " + std::to_string(width) + " " + n(a) + ")";
    }
    std::string concat(Node, Node a, Node b) override { return app("BitVec.append", b, a); }
    std::string add(Node, Node a, Node b) override { return binary("+", a, b); }
    std::string sub(Node, Node a, Node b) override { return binary("-", a, b); }
    std::string mul(Node, Node a, Node b) override { return binary("*", a, b); }
    std::string unsigned_div(Node, Node a, Node b) override { return app("YosysLean.udiv", a, b); }
    std::string unsigned_mod(Node, Node a, Node b) override { return binary("%", a, b); }
    std::string bitwise_and(Node, Node a, Node b) override { return binary("&&&", a, b); }
    std::string bitwise_or(Node, Node a, Node b) override { return binary("|||", a, b); }
    std::string bitwise_xor(Node, Node a, Node b) override { return binary("^^^", a, b); }
    std::string bitwise_not(Node, Node a) override { return "(~~~" + n(a) + ")"; }
    std::string unary_minus(Node, Node a) override { return "(-" + n(a) + ")"; }
    std::string reduce_and(Node, Node a) override {
        return boolvec("(" + n(a) + " == ~~~(0 : BitVec " + std::to_string(a.width()) + "))");
    }
    std::string reduce_or(Node, Node a) override { return boolvec("(" + n(a) + " != 0)"); }
    std::string reduce_xor(Node, Node a) override { return boolvec(app("YosysLean.parity", a)); }
    std::string equal(Node, Node a, Node b) override { return boolvec(binary("==", a, b)); }
    std::string not_equal(Node, Node a, Node b) override { return boolvec(binary("!=", a, b)); }
    std::string signed_greater_than(Node, Node a, Node b) override { return boolvec(app("BitVec.slt", b, a)); }
    std::string signed_greater_equal(Node, Node a, Node b) override { return boolvec(app("BitVec.sle", b, a)); }
    std::string unsigned_greater_than(Node, Node a, Node b) override { return boolvec(app("BitVec.ult", b, a)); }
    std::string unsigned_greater_equal(Node, Node a, Node b) override { return boolvec(app("BitVec.ule", b, a)); }
    std::string logical_shift_left(Node, Node a, Node b) override {
        return "(" + n(a) + " <<< " + n(b) + ".toNat)";
    }
    std::string logical_shift_right(Node, Node a, Node b) override {
        return "(" + n(a) + " >>> " + n(b) + ".toNat)";
    }
    std::string arithmetic_shift_right(Node, Node a, Node b) override {
        return "(BitVec.sshiftRight " + n(a) + " " + n(b) + ".toNat)";
    }
    std::string mux(Node, Node a, Node b, Node s) override {
        return "(if " + n(s) + " == 1 then " + n(b) + " else " + n(a) + ")";
    }
    std::string constant(Node, const RTLIL::Const &value) override { return literal(value); }
    std::string input(Node, IdString name, IdString kind) override {
        auto it = input_names.find({name, kind});
        if (it == input_names.end())
            log_cmd_error("write_lean: omitted clock is used as data; rerun lean_prepare.\n");
        return "inputs." + it->second;
    }
    std::string state(Node, IdString name, IdString) override { return "state." + state_names.at(name); }

};

struct Printer {
    Functional::IR &ir;
    RTLIL::Module *module;
    Names locals, inputs, states, outputs;
    std::map<int, std::string> nodes;
    std::map<std::pair<IdString, IdString>, std::string> input_names;
    std::map<IdString, std::string> state_names, output_names;
    std::map<IdString, std::string> aliases;
    std::ostringstream out;

    bool is_clock(IdString name) const {
        auto wire = module->wire(name);
        return wire && wire->get_bool_attribute(module->design->twines().add("\\yosys_lean_clock"));
    }

    Printer(Functional::IR &ir, RTLIL::Module *module) : ir(ir), module(module) {
        SigMap sigmap(module);
        // Prefer user register names to synthesized $procdff identifiers.
        for (auto s : ir.states()) {
            if (s->kind != ID($state) || !s->sort.is_signal())
                log_cmd_error("write_lean: unsupported state kind or memory.\n");
            std::string suggestion = s->name.unescape();
            auto cell = module->cell(s->name);
            if (cell && cell->hasPort(ID::Q)) {
                auto q = sigmap(cell->getPort(ID::Q));
                std::vector<std::string> candidates;
                for (auto w : module->wires())
                    if (w->width == q.size() && sigmap(SigSpec(w)) == q && w->name.isPublic())
                        candidates.push_back(w->name.unescape());
                std::sort(candidates.begin(), candidates.end());
                if (!candidates.empty()) suggestion = candidates.front();
                for (auto &name : candidates) aliases[s->name] += " " + comment(name);
            }
            state_names[s->name] = states.make(suggestion);
        }
        for (auto i : ir.all_inputs()) {
            if (!i->kind.in(ID($input), ID($anyseq)) || !i->sort.is_signal())
                log_cmd_error("write_lean: only ordinary inputs and $anyseq choice inputs are supported.\n");
            if (i->kind != ID($input) || !is_clock(i->name))
                input_names[{i->name, i->kind}] = inputs.make(i->name.unescape());
        }
        for (auto o : ir.all_outputs()) {
            if (!o->kind.in(ID($output), ID($assert), ID($assume), ID($cover)) || !o->sort.is_signal())
                log_cmd_error("write_lean: formal property output kinds are unsupported.\n");
            output_names[o->name] = outputs.make(o->name.unescape());
        }
        for (auto n : ir) {
            auto name = n.name().unescape();
            if (name.empty() || name.front() == '$') name = "n" + std::to_string(n.id());
            nodes[n.id()] = locals.make(name);
        }
    }

    std::string source(IdString id, bool cell) {
        auto obj = cell ? static_cast<RTLIL::AttrObject *>(module->cell(id)) :
                          static_cast<RTLIL::AttrObject *>(module->wire(id));
        if (obj && obj->has_attribute(ID::src)) return comment(obj->get_string_attribute(ID::src));
        return "unavailable after lowering";
    }
    void write(bool named) {
        Expressions expressions(nodes, input_names, state_names, named);
        auto n = [&](Node node) {
            auto name = nodes.at(node.id());
            return named ? "(Signals." + name + " inputs state)" : name;
        };
        Names ns;
        const auto namespace_name = ns.make(module->name.unescape());
        out << "import YosysLean\n\n-- Generated by yosys-lean; do not edit.\n"
            << "-- Yosys: " << comment(yosys_version_str) << "\n"
            << "-- Module: " << comment(module->name.unescape()) << "; source: "
            << comment(module->get_string_attribute(ID::src)) << "\n"
            << (state_names.empty() ? "-- Combinational evaluation.\n" :
                "-- One eval = one rising edge; outputs observe the pre-edge state.\n");
        for (auto i : ir.all_inputs())
            if (i->kind == ID($input) && is_clock(i->name))
                out << "-- Clock port omitted from Inputs: " << comment(i->name.unescape())
                    << "; src: " << source(i->name, false) << "\n";
        out << "namespace " << namespace_name << "\n\n";
        out << "structure Inputs where\n";
        for (auto i : ir.all_inputs()) {
            if (i->kind == ID($input) && is_clock(i->name)) continue;
            out << "  -- " << (i->kind == ID($anyseq) ? "arbitrary per-edge choice " : "input ")
                << comment(i->name.unescape()) << "; src: " << source(i->name, i->kind == ID($anyseq))
                << "\n  " << input_names.at({i->name, i->kind}) << " : BitVec " << i->sort.width() << "\n";
        }
        out << "  deriving DecidableEq, Repr, Inhabited\n\nstructure State where\n";
        for (auto s : ir.states())
            out << "  -- register " << comment(s->name.unescape()) << "; aliases:" << aliases[s->name]
                << "; src: " << source(s->name, true) << "\n  " << state_names.at(s->name)
                << " : BitVec " << s->sort.width() << "\n";
        out << "  deriving DecidableEq, Repr, Inhabited\n\nstructure Outputs where\n";
        for (auto o : ir.all_outputs())
            out << "  -- " << (o->kind == ID($output) ? "output" : comment(o->kind.unescape()))
                << " " << comment(o->name.unescape())
                << "; src: " << source(o->name, o->kind != ID($output))
                << "\n  " << output_names.at(o->name) << " : BitVec " << o->sort.width() << "\n";
        out << "  deriving DecidableEq, Repr, Inhabited\n\n";
        if (named)
            out << "-- Named intermediate expressions for local proof lemmas.\n"
                << "namespace Signals\nset_option linter.unusedVariables false\n\n";
        else
            out << "def eval (inputs : Inputs) (state : State) : Outputs × State :=\n";
        for (auto node : ir) {
            if (!node.sort().is_signal()) log_cmd_error("write_lean: memories unsupported.\n");
            out << (named ? "-- " : "  -- ") << comment(node.name().unescape())
                << " : " << Functional::fn_to_string(node.fn());
            auto src = source(node.name(), module->cell(node.name()) != nullptr);
            if (src != "unavailable after lowering") out << "; src: " << src;
            out << "\n" << (named ? "def " : "  let ") << nodes.at(node.id());
            if (named) out << " (inputs : Inputs) (state : State)";
            out << " : BitVec " << node.width() << " := " << node.visit(expressions)
                << (named ? "\n\n" : "\n");
        }
        if (named) {
            out << "end Signals\n\nnamespace Next\n";
            for (auto s : ir.states())
                out << "-- Next register value; aliases:" << aliases[s->name]
                    << "; src: " << source(s->name, true) << "\n"
                    << "def " << state_names.at(s->name)
                    << " (inputs : Inputs) (state : State) : BitVec " << s->sort.width()
                    << " := " << n(s->next_value()) << "\n\n";
            out << "end Next\n\ndef eval (inputs : Inputs) (state : State) : Outputs × State :=\n";
        }
        out << "  ({\n";
        bool sep = false;
        for (auto o : ir.all_outputs()) {
            if (sep) out << ",\n";
            sep = true;
            out << "     " << output_names.at(o->name) << " := " << n(o->value());
        }
        out << "\n   }, {\n"; sep = false;
        for (auto s : ir.states()) {
            if (sep) out << ",\n";
            sep = true;
            out << "     " << state_names.at(s->name) << " := " << n(s->next_value());
        }
        out << "\n   })\n";
        if (named)
            for (auto s : ir.states()) {
                auto field = state_names.at(s->name);
                out << "\ntheorem eval_next_" << field << " (inputs : Inputs) (state : State) :\n"
                    << "    (eval inputs state).2." << field << " = Next." << field
                    << " inputs state := by rfl\n";
            }
        out << "\n-- Only specified initial bits constrain the initial state.\n"
            << "def initial (state : State) : Prop :=\n  True";
        for (auto s : ir.states()) {
            const auto &v = s->initial_value_signal();
            out << " ∧\n  (state." << state_names.at(s->name) << " &&& " << literal(v, true, true)
                << ") = " << literal(v, false, true);
        }
        out << "\n";
        for (auto kind : {ID($assert), ID($assume), ID($cover)}) {
            if (ir.outputs(kind).empty()) continue;
            std::string label = kind == ID($assert) ? "assertions" :
                                kind == ID($assume) ? "assumptions" : "covers";
            out << "\n-- Formal " << label << "; these do not restrict eval or initial.\n"
                << "def " << label << " (outputs : Outputs) : Prop :=\n  "
                << (kind == ID($cover) ? "False" : "True");
            for (auto o : ir.outputs(kind))
                out << (kind == ID($cover) ? " ∨\n  " : " ∧\n  ")
                    << "outputs." << output_names.at(o->name) << " = 1";
            out << "\n";
        }
        out << "\nend " << namespace_name << "\n";
    }
};

// Validate the actual clocks before formalff removes them. Never use async2sync here.
struct Prepare : Pass {
    Prepare() : Pass("lean_prepare", "validate and lower a single-clock design for write_lean") {}
    void help() override {
        log("lean_prepare\n  Run after hierarchy -top; flattens and lowers synchronous RTL.\n");
    }
    void execute(std::vector<std::string> args, RTLIL::Design *design) override {
        extra_args(args, 1, design);
        if (!design->full_selection() || !design->top_module())
            log_cmd_error("lean_prepare: select the complete design and set a top module.\n");
        Pass::call(design, "proc");
        Pass::call(design, "flatten");
        Pass::call(design, "opt_clean");
        auto m = design->top_module();
        SigMap map(m);
        FfInitVals init(&map, m);
        auto clock_attribute = design->twines().add("\\yosys_lean_clock");
        for (auto w : m->wires()) w->attributes.erase(clock_attribute);
        SigSpec clock;
        for (auto c : m->cells()) {
            if (c->is_builtin_ff()) {
                FfData ff(&init, c);
                if (!ff.has_clk || !ff.pol_clk || ff.has_arst || ff.has_aload || ff.has_sr)
                    log_cmd_error("lean_prepare: %s is not a synchronous rising-edge register.\n", c);
                auto clk = map(ff.sig_clk);
                if (clock.empty()) clock = clk;
                if (clock != clk) log_cmd_error("lean_prepare: multiple clocks unsupported.\n");
            }
            if (c->type == ID($check) && c->getParam(ID(TRG_ENABLE)).as_bool()
                    && c->getParam(ID(TRG_WIDTH)).as_int() != 0) {
                auto clk = map(c->getPort(ID(TRG)));
                if (clk.size() != 1 || c->getParam(ID(TRG_POLARITY)).as_int() != 1)
                    log_cmd_error("lean_prepare: property requires one rising-edge clock.\n");
                if (clock.empty()) clock = clk;
                if (clock != clk) log_cmd_error("lean_prepare: multiple clocks unsupported.\n");
            }
            if (design->module(c->type))
                log_cmd_error("lean_prepare: unresolved or black-box module %s.\n", c);
            if (c->type.in(ID($live), ID($fair), ID($anyconst),
                           ID($allconst), ID($allseq)))
                log_cmd_error("lean_prepare: fixed/universal formal generators and temporal formal cells unsupported.\n");
        }
        // Every eval already samples the validated rising edge. A triggered
        // check therefore observes A/EN in exactly the same pre-edge state.
        for (auto c : m->cells().to_vector())
            if (c->type == ID($check)) {
                if (!c->getPort(ID(ARGS)).empty())
                    log_cmd_error("lean_prepare: formatted property messages unsupported.\n");
                if (c->getParam(ID(TRG_ENABLE)).as_bool()
                        && c->getParam(ID(TRG_WIDTH)).as_int() == 0) {
                    auto first = m->Initstate(m->uniquify(design->twines().add("$yosys_lean_initstate")));
                    c->setPort(ID::EN, m->And(m->uniquify(design->twines().add("$yosys_lean_initial_enable")),
                                             c->getPort(ID::EN), first));
                }
                c->setPort(ID(TRG), SigSpec());
                c->setParam(ID(TRG_ENABLE), false);
                c->setParam(ID(TRG_WIDTH), 0);
                c->setParam(ID(TRG_POLARITY), false);
            }
        Pass::call(design, "chformal -lower");
        if (!clock.empty()) {
            bool direct = false;
            for (auto w : m->wires())
                if (w->port_input && w->width == 1 && map(SigSpec(w)) == clock) direct = true;
            if (!direct) log_cmd_error("lean_prepare: clock must be a direct one-bit input.\n");
            // The abstract edge replaces the clock input. Reject data uses, which
            // could sample a different value at the actual edge.
            for (auto c : m->cells())
                for (const auto &connection : c->connections()) {
                    if (c->is_builtin_ff() && connection.first == ID::CLK) continue;
                    for (auto bit : map(connection.second))
                        if (bit == clock.as_bit())
                            log_cmd_error("lean_prepare: clock used as data at %s.%s.\n",
                                c, PooledName(m, connection.first).unescape());
                }
            for (auto w : m->wires())
                if (w->port_output)
                    for (auto bit : map(SigSpec(w)))
                        if (bit == clock.as_bit())
                            log_cmd_error("lean_prepare: clock exposed as data output %s.\n", w);
        }
        if (!m->memories.empty()) log_cmd_error("lean_prepare: memories unsupported.\n");
        for (auto c : m->cells())
            if (c->type.in(ID($mem), ID($mem_v2), ID($memrd), ID($memwr), ID($meminit),
                           ID($memrd_v2), ID($memwr_v2), ID($meminit_v2)))
                log_cmd_error("lean_prepare: memories unsupported.\n");
        Pass::call(design, "check -assert");
        // FunctionalIR uses EN -> A for every property kind. Cover instead asks
        // whether EN AND A is reached, so give it an always-enabled conjunction.
        for (auto c : m->cells().to_vector())
            if (c->type == ID($cover)) {
                auto enabled = m->And(m->uniquify(design->twines().add("$yosys_lean_cover_enabled")),
                                      c->getPort(ID::EN), c->getPort(ID::A));
                c->setPort(ID::A, enabled);
                c->setPort(ID::EN, State::S1);
            }
        if (!clock.empty())
            for (auto w : m->wires())
                if (w->port_input && w->width == 1 && map(SigSpec(w)) == clock)
                    w->set_bool_attribute(clock_attribute);
        Pass::call(design, "dffunmap");
        Pass::call(design, "formalff -clk2ff");
        Pass::call(design, "opt_clean");
        m->set_bool_attribute(design->twines().add("\\yosys_lean_prepared"));
    }
} Prepare;

struct LeanBackend : Backend {
    LeanBackend() : Backend("lean", "emit native Lean from FunctionalIR") {}
    void help() override {
        log("write_lean [-named] [filename]\n"
            "  Emit the top module after lean_prepare.\n"
            "  -named: expose Signals, Next register updates, and eval projection lemmas.\n");
    }
    void execute(std::ostream *&f, std::string filename, std::vector<std::string> args,
                 RTLIL::Design *design) override {
        size_t argidx = 1;
        bool named = argidx < args.size() && args[argidx] == "-named";
        if (named) ++argidx;
        if (argidx < args.size() && !args[argidx].empty() && args[argidx][0] == '-')
            log_cmd_error("write_lean: unknown option %s.\n", args[argidx].c_str());
        if (args.size() > argidx + 1)
            log_cmd_error("write_lean: expected at most one filename.\n");
        auto m = design->top_module();
        if (!design->full_selection() || !m || !m->get_bool_attribute(design->twines().add("\\yosys_lean_prepared")))
            log_cmd_error("write_lean: run lean_prepare on the complete design first.\n");
        auto ir = Functional::IR::from_module(m);
        Printer printer(ir, m);
        printer.write(named); // Validate before opening/truncating the requested destination.
        extra_args(f, filename, args, argidx, design);
        *f << printer.out.str();
    }
} LeanBackend;

PRIVATE_NAMESPACE_END
