import YosysLean.Check
import Examples.Prefix32Proofs
import Examples.Ripple32Proofs
namespace AdderProofs

/-- Equivalence includes both sum and carry, with no restrictions on the operands. -/
theorem implementations_agree (a b : BitVec 32) (cin : BitVec 1) :
    let p := (v_Prefix32.eval ⟨a, b, cin⟩ {}).1
    let r := (v_Ripple32.eval ⟨a, b, cin⟩ {}).1
    BitVec.append p.v_cout p.v_sum = BitVec.append r.v_cout r.v_sum :=
  (prefix32_correct a b cin).trans (ripple32_correct a b cin).symm

#check_claim prefix32_correct, ripple32_correct, implementations_agree
end AdderProofs
