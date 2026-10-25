"""Generate a kernel-checked structural connection for the fetch-port wrapper."""
import re


def fields(text, name):
    body = text.split('structure '+name+' where\n', 1)[1].split('  deriving ', 1)[0]
    return re.findall(r'^  (\w+) : BitVec (\d+)$',body, re.M)


def export_bridge(dest):
    old = (dest/'NervAdd.lean').read_text()
    new = (dest/'NervFetch.lean').read_text()
    body = '''import Examples.Generated.NervAdd
import Examples.Generated.NervFetch

-- Generated structural connection; do not edit. Every correspondence is checked by rfl.
-- Arbitrary choices are renamed, never fixed. The additional fetch state stays in NervFetch.
namespace NervFetchBridge
'''
    for kind, fn in [('Inputs','inputs'),('State','state'),('Outputs','outputs')]:
        a = fields(old, kind)
        b = fields(new, kind)
        if kind == 'Inputs':
            def leaves(name):
                view = (dest/f'{name}View.lean').read_text()
                return re.findall(r'def \w+ \(inputs : Inputs\) \(state : State\) : BitVec (\d+) := inputs\.(\w+)',view)
            # Suggest a correspondence by input-leaf order. The generated rfl theorem
            # checks it; this heuristic cannot establish an unchecked equivalence.
            x, y = leaves('NervAdd'), leaves('NervFetch')
            assert [t for t, _ in x] == [t for t, _ in y]
            mapping = {old_name: new_name for (_, old_name), (_, new_name) in zip(x, y)}
            assert set(mapping) == {n for n, _ in a}
            pairs = [(field, (mapping[field[0]], field[1])) for field in a]
        else:
            bmap = dict(b)
            missing = [x for x in b if x[0] not in dict(a)
                       and x[0] not in ('v_imem_addr', 'v_cpu_imem_addr_q')]
            pairs = []
            for x in a:
                y = x if x[0] in bmap else missing.pop(0)
                assert x[1] == y[1]
                pairs.append((x, y))
            assert not missing
        body += f'\ndef {fn} (s : v_NervFetch.{kind}) : v_NervAdd.{kind} :=\n  {{\n'
        body += ',\n'.join(f'    {x[0]} := s.{y[0]}' for x, y in pairs)+'\n  }\n'
    body += '''
set_option maxRecDepth 4096
set_option maxHeartbeats 800000

theorem agrees (i : v_NervFetch.Inputs) (s : v_NervFetch.State) :
    (outputs (v_NervFetch.eval i s).1, state (v_NervFetch.eval i s).2) =
      v_NervAdd.eval (inputs i) (state s) := by rfl

theorem next_agrees (i : v_NervFetch.Inputs) (s : v_NervFetch.State) :
    state (v_NervFetch.eval i s).2 = (v_NervAdd.eval (inputs i) (state s)).2 :=
  congrArg Prod.snd (agrees i s)

end NervFetchBridge
'''
    (dest/'NervFetchBridge.lean').write_text(body)
