"""Independent interpretation of the deliberately small emitted Lean expression grammar.

This is a test oracle, not a Lean parser or a production translation path. Symbolic
queries compare the emitted expressions with ordinary write_smt2; concrete tests
also execute the real Lean definitions to check this oracle's interpretation.
"""
from dataclasses import dataclass
import re


@dataclass
class Expr:
    text: str
    width: int | str | None


def resize(x, width, signed=False):
    if x.width is None:
        return Expr(f"(_ bv{x.text} {width})", width)
    if x.width == width:
        return x
    if x.width < width:
        op = "sign_extend" if signed else "zero_extend"
        return Expr(f"((_ {op} {width - x.width}) {x.text})", width)
    return Expr(f"((_ extract {width - 1} 0) {x.text})", width)


def call(op, *args, width=None):
    return Expr(f"({op} {' '.join(a.text for a in args)})", width or args[0].width)


class Parser:
    def __init__(self, text, env):
        self.tokens = re.findall(
            r"0b[01]+|==|!=|&&&|\|\|\||\^\^\^|<<<|>>>|~~~|[A-Za-z_][\w.']*|\d+|[():+*%<\-]", text)
        self.i = 0
        self.env = env

    def pop(self):
        value = self.tokens[self.i]
        self.i += 1
        return value

    def expect(self, token):
        actual = self.pop()
        assert actual == token, (token, actual, self.tokens)

    def expr(self):
        t = self.pop()
        if t == "(":
            head = self.tokens[self.i]
            if head == "if":
                self.pop()
                cond = self.expr()
                self.expect("==")
                one = resize(self.expr(), cond.width)
                self.expect("then")
                yes = self.expr()
                self.expect("else")
                no = self.expr()
                result = Expr(f"(ite (= {cond.text} {one.text}) {yes.text} {no.text})", yes.width)
            elif head.startswith("BitVec.") or head.startswith("YosysLean."):
                self.pop()
                result = self.function(head)
            else:
                result = self.expr()
                op = self.pop()
                if op == ")":
                    return result
                if op == ":":
                    self.expect("BitVec")
                    result = resize(result, int(self.pop()))
                else:
                    rhs = self.expr()
                    if rhs.width is None:
                        rhs = resize(rhs, result.width)
                    if result.width is None:
                        result = resize(result, rhs.width)
                    if op in ("==", "!="):
                        result = call("=" if op == "==" else "distinct", result, rhs, width="Bool")
                    elif op in ("<<<", ">>>"):
                        # Lean shifts use Nat counts; FunctionalIR bounds their width.
                        result = call("bvshl" if op == "<<<" else "bvlshr", result,
                                      resize(rhs, result.width))
                    else:
                        result = call({"+": "bvadd", "-": "bvsub", "*": "bvmul", "%": "bvurem",
                                       "&&&": "bvand", "|||": "bvor", "^^^": "bvxor"}[op], result, rhs)
            self.expect(")")
            return result
        if t in ("~~~", "-"):
            return call("bvnot" if t == "~~~" else "bvneg", self.expr())
        if t.startswith("0b"):
            return Expr("#b" + t[2:], len(t) - 2)
        if t.isdigit():
            return Expr(t, None)
        return self.env[t.removesuffix(".toNat")]

    def function(self, name):
        if name == "BitVec.ofBool":
            b = self.expr()
            assert b.width == "Bool"
            return Expr(f"(ite {b.text} #b1 #b0)", 1)
        if name == "BitVec.extractLsb'":
            start, width = int(self.pop()), int(self.pop())
            x = self.expr()
            return call(f"(_ extract {start + width - 1} {start})", x, width=width)
        if name in ("BitVec.setWidth", "BitVec.signExtend"):
            width = int(self.pop())
            return resize(self.expr(), width, name == "BitVec.signExtend")
        a = self.expr()
        if name == "YosysLean.parity":
            bits = [Expr(f"(= ((_ extract {i} {i}) {a.text}) #b1)", "Bool")
                    for i in range(a.width)]
            result = Expr("false", "Bool")
            for bit in bits:
                result = call("xor", result, bit, width="Bool")
            return result
        b = self.expr()
        if name == "BitVec.append":
            return call("concat", a, b, width=a.width + b.width)
        if name == "YosysLean.udiv":
            return call("bvudiv", a, b)
        if name == "BitVec.sshiftRight":
            return call("bvashr", a, resize(b, a.width))
        return call({"BitVec.slt": "bvslt", "BitVec.sle": "bvsle", "BitVec.ult": "bvult",
                     "BitVec.ule": "bvule"}[name], a, b, width="Bool")

    def parse(self):
        result = self.expr()
        assert self.i == len(self.tokens), self.tokens[self.i:]
        return result


def read_model(text):
    """Return structure fields, provenance, typed node bindings, and result assignments."""
    # Named output differs only in node declarations and explicit dependency calls.
    # Normalize that small generated grammar for this independent SMT test oracle.
    named = bool(re.search(r"^namespace Signals$", text, re.M))
    if named:
        text = re.sub(r"\((?:Signals\.)?(v_\w+) inputs state\)", r"\1", text)
    fields, provenance = {}, {}
    for name, body in re.findall(r"structure (\w+) where\n(.*?)  deriving", text, re.S):
        fields[name] = re.findall(r"^  (\w+) : BitVec (\d+)$", body, re.M)
        fields[name] = [(f, int(w)) for f, w in fields[name]]
        source = None
        for line in body.splitlines():
            if line.startswith("  -- register "):
                aliases = line.split("; aliases:")[1].split("; src:")[0].split()
                # Lowered $past monitors can have only a synthesized register name.
                source = aliases[0] if aliases else line.split()[2].removesuffix(";")
            elif line.startswith("  -- arbitrary per-edge choice "):
                source = line.split("choice ", 1)[1].split("; src:", 1)[0]
            elif line.startswith(("  -- input ", "  -- output ", "  -- $assert ", "  -- $assume ", "  -- $cover ")):
                source = line.split()[2].removesuffix(";")
            elif re.match(r"  \w+ : BitVec", line):
                provenance[name, line.split()[0]] = source
    lets = re.findall(r"^  let (\w+) : BitVec (\d+) := (.*)$", text, re.M)
    if named:
        signal_body = text.split("namespace Signals\n", 1)[1].split("end Signals", 1)[0]
        lets = re.findall(
            r"^def (\w+) \(inputs : Inputs\) \(state : State\) : BitVec (\d+) := (.*)$",
            signal_body, re.M)
    pairs = re.search(r"^  \(\{\n(.*?)\n   \}, \{\n(.*?)\n   \}\)$", text, re.M | re.S)
    assert pairs
    result = [dict(re.findall(r"(\w+) := (\w+)", group)) for group in pairs.groups()]
    return fields, provenance, lets, result


def comparison(lean_text, smt_text, top, corrupt=False):
    fields, provenance, lets, result = read_model(lean_text)
    lines = [smt_text, f"(declare-const curr |{top}_s|)", f"(declare-const next |{top}_s|)",
             f"(assert (|{top}_h| curr))", f"(assert (|{top}_h| next))",
             f"(assert (|{top}_t| curr next))"]
    env = {}

    def signal(name, width, when):
        expr = f"(|{top}_n {name}| {when})"
        # write_smt2 represents scalar named nets using Bool, buses using BitVec.
        declaration = re.search(r"\(define-fun \|" + re.escape(top + "_n " + name) +
                                r"\| .*?\) (Bool|\(_ BitVec \d+\))", smt_text)
        if not declaration:
            for kind, suffix in (("assert", "a"), ("assume", "u"), ("cover", "c")):
                properties = re.findall(r"^; yosys-smt2-" + kind + r" (\d+) (\S+) .*", smt_text, re.M)
                matches = [index for index, cell in properties if cell == name.replace("\\", "/")]
                if matches:
                    assert len(matches) == 1 and width == 1
                    return Expr(f"(ite (|{top}_{suffix} {matches[0]}| {when}) #b1 #b0)", 1)
            # Packed/split registers may have no full-width named wire. The SMT
            # transition records their exact cell identity beside the next selector.
            registers = re.findall(r"\(\|([^|]+)\| next_state\)\) ; "
                                   + re.escape(name) + r"(?:\s|$)", smt_text, re.M)
            if registers:
                assert len(registers) == 1, (name, registers)
                selector = registers[0]
                declaration = re.search(r"\(\|" + re.escape(selector)
                                        + r"\| (Bool|\(_ BitVec \d+\))\)", smt_text)
                assert declaration, (name, selector)
                sort = declaration[1]
                assert (sort == "Bool" and width == 1) or sort == f"(_ BitVec {width})"
                value = f"(|{selector}| {when})"
                return Expr(f"(ite {value} #b1 #b0)" if sort == "Bool" else value, width)
            # Formal generators have no normal input port. Match cell identity,
            # or the unique source location retained independently by write_smt2.
            source = re.search(r"  -- arbitrary per-edge choice " + re.escape(name) + r"; src: (.*)", lean_text)
            choices = re.findall(r"^; yosys-smt2-anyseq (\S+) (\d+) (.*)$", smt_text, re.M)
            matches = [identifier for identifier, bits, info in choices
                       if int(bits) == width and (info == name or (source and info == source[1]))]
            assert len(matches) == 1, (name, top, matches)
            return Expr(f"(|{matches[0]}| {when})", width)
        if declaration[1] == "Bool":
            expr = f"(ite {expr} #b1 #b0)"
        return Expr(expr, width)

    for kind, prefix in (("Inputs", "inputs"), ("State", "state")):
        for f, width in fields[kind]:
            env[prefix + "." + f] = signal(provenance[kind, f], width, "curr")
    for name, width, expr in lets:
        parsed = Parser(expr, env).parse()
        assert parsed.width == int(width), (name, parsed)
        env[name] = Expr(name, int(width))
        lines.append(f"(define-fun {name} () (_ BitVec {width}) {parsed.text})")
    equalities = []
    for kind, when, mapping in (("Outputs", "curr", result[0]), ("State", "next", result[1])):
        for f, width in fields[kind]:
            reference = signal(provenance[kind, f], width, when)
            value = env[mapping[f]].text
            if corrupt:
                value = f"(bvnot {value})"
                corrupt = False
            equalities.append(f"(= {value} {reference.text})")
    lines += ["(assert (not (and " + " ".join(equalities) + ")))", "(check-sat)"]
    return "\n".join(lines)
