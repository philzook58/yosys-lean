# Proving a real divider

**Result:** ZipCPU's unchanged 32-bit divider returns the correct signed or unsigned
quotient, with the specified completion timing. This covers arbitrary operands,
wrapped signed overflow, and divide-by-zero error.

**Assumptions:** accept a request in a ready state; do not reset or issue another
request while it runs. Operand buses may change after acceptance. Flags are not
fully proved. [Exact contract and provenance](../examples/zipcpu/README.md).

**Check it:**

```sh
python3 scripts/check_lean.py --deps Examples/DividerSignedProofs.lean
```

## The proof in three steps

1. **Explain one RTL step.** The hardware compares part of its dividend workspace
   with the divisor, conditionally subtracts, then shifts the workspace and appends
   a quotient bit. Local lemmas in [Divider32Proofs.lean](../Examples/Divider32Proofs.lean)
   connect the exported slices and muxes to that arithmetic step.
2. **Preserve a balance equation.** After `n` decisions:

   ```text
   workspace + divisor * 2^32 * partial_quotient = 2^n * numerator
   ```

   Bounds on the workspace and quotient justify truncation and establish the
   final quotient. [DividerArithmetic.lean](../Examples/DividerArithmetic.lean)
   proves this recurrence without enumerating operands.
3. **Connect arithmetic to time.** A relation between the mathematical state and
   the actual registers shows unsigned completion after 32 processing edges.
   [DividerSignedProofs.lean](../Examples/DividerSignedProofs.lean) reuses that loop
   between sign preprocessing and final negation, taking 32–34 edges.

Two RTL details matter. Preprocessing can append an extra quotient bit; the proof
carries it until 32 shifts remove it. The final workspace can wrap; the proof
permits that because the returned quotient remains correct.

## What to copy for another circuit

Prove small signal/update equations first. Then write an invariant in mathematical
terms and relate it to the physical registers. Keep the final theorem about the
exported circuit. Avoid unfolding the entire execution into one large expression.

The [SMTBMC benchmark](../examples/zipcpu/README.md#independent-smtbmc-transaction-benchmark)
checks a matching unsigned harness. At 32 bits, induction passed in 13.25 seconds,
but BMC timed out at 30 seconds, leaving that run inconclusive. This is a measured
result for one configuration, not a claim that other solver strategies cannot succeed.
