import Examples.AdderSupport
import Examples.Generated.Ripple32Wires
/-! One declaration per observed carry. Separate declarations and modules bound
kernel checking memory; each uses an already proved carry as its boundary. -/

namespace AdderProofs
set_option maxRecDepth 4096
set_option maxHeartbeats 500000

theorem ripple32_carry_0 (a b : BitVec 32) (cin : BitVec 1) :
    (v_Ripple32Wires.eval ⟨a,b,cin⟩ {}).2.c0.getLsbD 0 =
      BitVec.carry 0 (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := by
  generalize h : v_Ripple32Wires.eval ⟨a,b,cin⟩ {} = result
  delta v_Ripple32Wires.eval at h
  extract_lets at h
  expose_names
  subst result
  simp only [v_cin, BitVec.carry_zero]

theorem ripple32_carry_1 (a b : BitVec 32) (cin : BitVec 1) :
    (v_Ripple32Wires.eval ⟨a,b,cin⟩ {}).2.c1.getLsbD 0 =
      BitVec.carry 1 (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := by
  generalize h : v_Ripple32Wires.eval ⟨a,b,cin⟩ {} = result
  delta v_Ripple32Wires.eval at h
  extract_lets at h
  expose_names
  subst result
  have previous : v_cin.getLsbD 0 = BitVec.carry 0
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := ripple32_carry_0 a b cin
  carry_step 1 from 0 at v_column_1__carry_in using previous cut v_cin as answer
  exact answer

theorem ripple32_carry_2 (a b : BitVec 32) (cin : BitVec 1) :
    (v_Ripple32Wires.eval ⟨a,b,cin⟩ {}).2.c2.getLsbD 0 =
      BitVec.carry 2 (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := by
  generalize h : v_Ripple32Wires.eval ⟨a,b,cin⟩ {} = result
  delta v_Ripple32Wires.eval at h
  extract_lets at h
  expose_names
  subst result
  have previous : v_column_1__carry_in.getLsbD 0 = BitVec.carry 1
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := ripple32_carry_1 a b cin
  carry_step 2 from 1 at v_column_2__carry_in using previous cut v_column_1__carry_in as answer
  exact answer

theorem ripple32_carry_3 (a b : BitVec 32) (cin : BitVec 1) :
    (v_Ripple32Wires.eval ⟨a,b,cin⟩ {}).2.c3.getLsbD 0 =
      BitVec.carry 3 (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := by
  generalize h : v_Ripple32Wires.eval ⟨a,b,cin⟩ {} = result
  delta v_Ripple32Wires.eval at h
  extract_lets at h
  expose_names
  subst result
  have previous : v_column_2__carry_in.getLsbD 0 = BitVec.carry 2
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := ripple32_carry_2 a b cin
  carry_step 3 from 2 at v_column_3__carry_in using previous cut v_column_2__carry_in as answer
  exact answer

theorem ripple32_carry_4 (a b : BitVec 32) (cin : BitVec 1) :
    (v_Ripple32Wires.eval ⟨a,b,cin⟩ {}).2.c4.getLsbD 0 =
      BitVec.carry 4 (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := by
  generalize h : v_Ripple32Wires.eval ⟨a,b,cin⟩ {} = result
  delta v_Ripple32Wires.eval at h
  extract_lets at h
  expose_names
  subst result
  have previous : v_column_3__carry_in.getLsbD 0 = BitVec.carry 3
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := ripple32_carry_3 a b cin
  carry_step 4 from 3 at v_column_4__carry_in using previous cut v_column_3__carry_in as answer
  exact answer

theorem ripple32_carry_5 (a b : BitVec 32) (cin : BitVec 1) :
    (v_Ripple32Wires.eval ⟨a,b,cin⟩ {}).2.c5.getLsbD 0 =
      BitVec.carry 5 (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := by
  generalize h : v_Ripple32Wires.eval ⟨a,b,cin⟩ {} = result
  delta v_Ripple32Wires.eval at h
  extract_lets at h
  expose_names
  subst result
  have previous : v_column_4__carry_in.getLsbD 0 = BitVec.carry 4
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := ripple32_carry_4 a b cin
  carry_step 5 from 4 at v_column_5__carry_in using previous cut v_column_4__carry_in as answer
  exact answer

theorem ripple32_carry_6 (a b : BitVec 32) (cin : BitVec 1) :
    (v_Ripple32Wires.eval ⟨a,b,cin⟩ {}).2.c6.getLsbD 0 =
      BitVec.carry 6 (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := by
  generalize h : v_Ripple32Wires.eval ⟨a,b,cin⟩ {} = result
  delta v_Ripple32Wires.eval at h
  extract_lets at h
  expose_names
  subst result
  have previous : v_column_5__carry_in.getLsbD 0 = BitVec.carry 5
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := ripple32_carry_5 a b cin
  carry_step 6 from 5 at v_column_6__carry_in using previous cut v_column_5__carry_in as answer
  exact answer

theorem ripple32_carry_7 (a b : BitVec 32) (cin : BitVec 1) :
    (v_Ripple32Wires.eval ⟨a,b,cin⟩ {}).2.c7.getLsbD 0 =
      BitVec.carry 7 (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := by
  generalize h : v_Ripple32Wires.eval ⟨a,b,cin⟩ {} = result
  delta v_Ripple32Wires.eval at h
  extract_lets at h
  expose_names
  subst result
  have previous : v_column_6__carry_in.getLsbD 0 = BitVec.carry 6
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := ripple32_carry_6 a b cin
  carry_step 7 from 6 at v_column_7__carry_in using previous cut v_column_6__carry_in as answer
  exact answer

theorem ripple32_carry_8 (a b : BitVec 32) (cin : BitVec 1) :
    (v_Ripple32Wires.eval ⟨a,b,cin⟩ {}).2.c8.getLsbD 0 =
      BitVec.carry 8 (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := by
  generalize h : v_Ripple32Wires.eval ⟨a,b,cin⟩ {} = result
  delta v_Ripple32Wires.eval at h
  extract_lets at h
  expose_names
  subst result
  have previous : v_column_7__carry_in.getLsbD 0 = BitVec.carry 7
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := ripple32_carry_7 a b cin
  carry_step 8 from 7 at v_column_8__carry_in using previous cut v_column_7__carry_in as answer
  exact answer

theorem ripple32_carry_9 (a b : BitVec 32) (cin : BitVec 1) :
    (v_Ripple32Wires.eval ⟨a,b,cin⟩ {}).2.c9.getLsbD 0 =
      BitVec.carry 9 (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := by
  generalize h : v_Ripple32Wires.eval ⟨a,b,cin⟩ {} = result
  delta v_Ripple32Wires.eval at h
  extract_lets at h
  expose_names
  subst result
  have previous : v_column_8__carry_in.getLsbD 0 = BitVec.carry 8
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := ripple32_carry_8 a b cin
  carry_step 9 from 8 at v_column_9__carry_in using previous cut v_column_8__carry_in as answer
  exact answer

theorem ripple32_carry_10 (a b : BitVec 32) (cin : BitVec 1) :
    (v_Ripple32Wires.eval ⟨a,b,cin⟩ {}).2.c10.getLsbD 0 =
      BitVec.carry 10 (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := by
  generalize h : v_Ripple32Wires.eval ⟨a,b,cin⟩ {} = result
  delta v_Ripple32Wires.eval at h
  extract_lets at h
  expose_names
  subst result
  have previous : v_column_9__carry_in.getLsbD 0 = BitVec.carry 9
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := ripple32_carry_9 a b cin
  carry_step 10 from 9 at v_column_10__carry_in using previous cut v_column_9__carry_in as answer
  exact answer

theorem ripple32_carry_11 (a b : BitVec 32) (cin : BitVec 1) :
    (v_Ripple32Wires.eval ⟨a,b,cin⟩ {}).2.c11.getLsbD 0 =
      BitVec.carry 11 (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := by
  generalize h : v_Ripple32Wires.eval ⟨a,b,cin⟩ {} = result
  delta v_Ripple32Wires.eval at h
  extract_lets at h
  expose_names
  subst result
  have previous : v_column_10__carry_in.getLsbD 0 = BitVec.carry 10
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := ripple32_carry_10 a b cin
  carry_step 11 from 10 at v_column_11__carry_in using previous cut v_column_10__carry_in as answer
  exact answer

theorem ripple32_carry_12 (a b : BitVec 32) (cin : BitVec 1) :
    (v_Ripple32Wires.eval ⟨a,b,cin⟩ {}).2.c12.getLsbD 0 =
      BitVec.carry 12 (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := by
  generalize h : v_Ripple32Wires.eval ⟨a,b,cin⟩ {} = result
  delta v_Ripple32Wires.eval at h
  extract_lets at h
  expose_names
  subst result
  have previous : v_column_11__carry_in.getLsbD 0 = BitVec.carry 11
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := ripple32_carry_11 a b cin
  carry_step 12 from 11 at v_column_12__carry_in using previous cut v_column_11__carry_in as answer
  exact answer

theorem ripple32_carry_13 (a b : BitVec 32) (cin : BitVec 1) :
    (v_Ripple32Wires.eval ⟨a,b,cin⟩ {}).2.c13.getLsbD 0 =
      BitVec.carry 13 (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := by
  generalize h : v_Ripple32Wires.eval ⟨a,b,cin⟩ {} = result
  delta v_Ripple32Wires.eval at h
  extract_lets at h
  expose_names
  subst result
  have previous : v_column_12__carry_in.getLsbD 0 = BitVec.carry 12
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := ripple32_carry_12 a b cin
  carry_step 13 from 12 at v_column_13__carry_in using previous cut v_column_12__carry_in as answer
  exact answer

theorem ripple32_carry_14 (a b : BitVec 32) (cin : BitVec 1) :
    (v_Ripple32Wires.eval ⟨a,b,cin⟩ {}).2.c14.getLsbD 0 =
      BitVec.carry 14 (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := by
  generalize h : v_Ripple32Wires.eval ⟨a,b,cin⟩ {} = result
  delta v_Ripple32Wires.eval at h
  extract_lets at h
  expose_names
  subst result
  have previous : v_column_13__carry_in.getLsbD 0 = BitVec.carry 13
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := ripple32_carry_13 a b cin
  carry_step 14 from 13 at v_column_14__carry_in using previous cut v_column_13__carry_in as answer
  exact answer

theorem ripple32_carry_15 (a b : BitVec 32) (cin : BitVec 1) :
    (v_Ripple32Wires.eval ⟨a,b,cin⟩ {}).2.c15.getLsbD 0 =
      BitVec.carry 15 (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := by
  generalize h : v_Ripple32Wires.eval ⟨a,b,cin⟩ {} = result
  delta v_Ripple32Wires.eval at h
  extract_lets at h
  expose_names
  subst result
  have previous : v_column_14__carry_in.getLsbD 0 = BitVec.carry 14
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := ripple32_carry_14 a b cin
  carry_step 15 from 14 at v_column_15__carry_in using previous cut v_column_14__carry_in as answer
  exact answer

theorem ripple32_carry_16 (a b : BitVec 32) (cin : BitVec 1) :
    (v_Ripple32Wires.eval ⟨a,b,cin⟩ {}).2.c16.getLsbD 0 =
      BitVec.carry 16 (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := by
  generalize h : v_Ripple32Wires.eval ⟨a,b,cin⟩ {} = result
  delta v_Ripple32Wires.eval at h
  extract_lets at h
  expose_names
  subst result
  have previous : v_column_15__carry_in.getLsbD 0 = BitVec.carry 15
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := ripple32_carry_15 a b cin
  carry_step 16 from 15 at v_column_16__carry_in using previous cut v_column_15__carry_in as answer
  exact answer

theorem ripple32_carry_17 (a b : BitVec 32) (cin : BitVec 1) :
    (v_Ripple32Wires.eval ⟨a,b,cin⟩ {}).2.c17.getLsbD 0 =
      BitVec.carry 17 (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := by
  generalize h : v_Ripple32Wires.eval ⟨a,b,cin⟩ {} = result
  delta v_Ripple32Wires.eval at h
  extract_lets at h
  expose_names
  subst result
  have previous : v_column_16__carry_in.getLsbD 0 = BitVec.carry 16
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := ripple32_carry_16 a b cin
  carry_step 17 from 16 at v_column_17__carry_in using previous cut v_column_16__carry_in as answer
  exact answer

theorem ripple32_carry_18 (a b : BitVec 32) (cin : BitVec 1) :
    (v_Ripple32Wires.eval ⟨a,b,cin⟩ {}).2.c18.getLsbD 0 =
      BitVec.carry 18 (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := by
  generalize h : v_Ripple32Wires.eval ⟨a,b,cin⟩ {} = result
  delta v_Ripple32Wires.eval at h
  extract_lets at h
  expose_names
  subst result
  have previous : v_column_17__carry_in.getLsbD 0 = BitVec.carry 17
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := ripple32_carry_17 a b cin
  carry_step 18 from 17 at v_column_18__carry_in using previous cut v_column_17__carry_in as answer
  exact answer

theorem ripple32_carry_19 (a b : BitVec 32) (cin : BitVec 1) :
    (v_Ripple32Wires.eval ⟨a,b,cin⟩ {}).2.c19.getLsbD 0 =
      BitVec.carry 19 (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := by
  generalize h : v_Ripple32Wires.eval ⟨a,b,cin⟩ {} = result
  delta v_Ripple32Wires.eval at h
  extract_lets at h
  expose_names
  subst result
  have previous : v_column_18__carry_in.getLsbD 0 = BitVec.carry 18
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := ripple32_carry_18 a b cin
  carry_step 19 from 18 at v_column_19__carry_in using previous cut v_column_18__carry_in as answer
  exact answer

theorem ripple32_carry_20 (a b : BitVec 32) (cin : BitVec 1) :
    (v_Ripple32Wires.eval ⟨a,b,cin⟩ {}).2.c20.getLsbD 0 =
      BitVec.carry 20 (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := by
  generalize h : v_Ripple32Wires.eval ⟨a,b,cin⟩ {} = result
  delta v_Ripple32Wires.eval at h
  extract_lets at h
  expose_names
  subst result
  have previous : v_column_19__carry_in.getLsbD 0 = BitVec.carry 19
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := ripple32_carry_19 a b cin
  carry_step 20 from 19 at v_column_20__carry_in using previous cut v_column_19__carry_in as answer
  exact answer

theorem ripple32_carry_21 (a b : BitVec 32) (cin : BitVec 1) :
    (v_Ripple32Wires.eval ⟨a,b,cin⟩ {}).2.c21.getLsbD 0 =
      BitVec.carry 21 (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := by
  generalize h : v_Ripple32Wires.eval ⟨a,b,cin⟩ {} = result
  delta v_Ripple32Wires.eval at h
  extract_lets at h
  expose_names
  subst result
  have previous : v_column_20__carry_in.getLsbD 0 = BitVec.carry 20
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := ripple32_carry_20 a b cin
  carry_step 21 from 20 at v_column_21__carry_in using previous cut v_column_20__carry_in as answer
  exact answer

theorem ripple32_carry_22 (a b : BitVec 32) (cin : BitVec 1) :
    (v_Ripple32Wires.eval ⟨a,b,cin⟩ {}).2.c22.getLsbD 0 =
      BitVec.carry 22 (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := by
  generalize h : v_Ripple32Wires.eval ⟨a,b,cin⟩ {} = result
  delta v_Ripple32Wires.eval at h
  extract_lets at h
  expose_names
  subst result
  have previous : v_column_21__carry_in.getLsbD 0 = BitVec.carry 21
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := ripple32_carry_21 a b cin
  carry_step 22 from 21 at v_column_22__carry_in using previous cut v_column_21__carry_in as answer
  exact answer

theorem ripple32_carry_23 (a b : BitVec 32) (cin : BitVec 1) :
    (v_Ripple32Wires.eval ⟨a,b,cin⟩ {}).2.c23.getLsbD 0 =
      BitVec.carry 23 (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := by
  generalize h : v_Ripple32Wires.eval ⟨a,b,cin⟩ {} = result
  delta v_Ripple32Wires.eval at h
  extract_lets at h
  expose_names
  subst result
  have previous : v_column_22__carry_in.getLsbD 0 = BitVec.carry 22
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := ripple32_carry_22 a b cin
  carry_step 23 from 22 at v_column_23__carry_in using previous cut v_column_22__carry_in as answer
  exact answer

theorem ripple32_carry_24 (a b : BitVec 32) (cin : BitVec 1) :
    (v_Ripple32Wires.eval ⟨a,b,cin⟩ {}).2.c24.getLsbD 0 =
      BitVec.carry 24 (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := by
  generalize h : v_Ripple32Wires.eval ⟨a,b,cin⟩ {} = result
  delta v_Ripple32Wires.eval at h
  extract_lets at h
  expose_names
  subst result
  have previous : v_column_23__carry_in.getLsbD 0 = BitVec.carry 23
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := ripple32_carry_23 a b cin
  carry_step 24 from 23 at v_column_24__carry_in using previous cut v_column_23__carry_in as answer
  exact answer

theorem ripple32_carry_25 (a b : BitVec 32) (cin : BitVec 1) :
    (v_Ripple32Wires.eval ⟨a,b,cin⟩ {}).2.c25.getLsbD 0 =
      BitVec.carry 25 (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := by
  generalize h : v_Ripple32Wires.eval ⟨a,b,cin⟩ {} = result
  delta v_Ripple32Wires.eval at h
  extract_lets at h
  expose_names
  subst result
  have previous : v_column_24__carry_in.getLsbD 0 = BitVec.carry 24
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := ripple32_carry_24 a b cin
  carry_step 25 from 24 at v_column_25__carry_in using previous cut v_column_24__carry_in as answer
  exact answer

theorem ripple32_carry_26 (a b : BitVec 32) (cin : BitVec 1) :
    (v_Ripple32Wires.eval ⟨a,b,cin⟩ {}).2.c26.getLsbD 0 =
      BitVec.carry 26 (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := by
  generalize h : v_Ripple32Wires.eval ⟨a,b,cin⟩ {} = result
  delta v_Ripple32Wires.eval at h
  extract_lets at h
  expose_names
  subst result
  have previous : v_column_25__carry_in.getLsbD 0 = BitVec.carry 25
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := ripple32_carry_25 a b cin
  carry_step 26 from 25 at v_column_26__carry_in using previous cut v_column_25__carry_in as answer
  exact answer

theorem ripple32_carry_27 (a b : BitVec 32) (cin : BitVec 1) :
    (v_Ripple32Wires.eval ⟨a,b,cin⟩ {}).2.c27.getLsbD 0 =
      BitVec.carry 27 (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := by
  generalize h : v_Ripple32Wires.eval ⟨a,b,cin⟩ {} = result
  delta v_Ripple32Wires.eval at h
  extract_lets at h
  expose_names
  subst result
  have previous : v_column_26__carry_in.getLsbD 0 = BitVec.carry 26
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := ripple32_carry_26 a b cin
  carry_step 27 from 26 at v_column_27__carry_in using previous cut v_column_26__carry_in as answer
  exact answer

theorem ripple32_carry_28 (a b : BitVec 32) (cin : BitVec 1) :
    (v_Ripple32Wires.eval ⟨a,b,cin⟩ {}).2.c28.getLsbD 0 =
      BitVec.carry 28 (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := by
  generalize h : v_Ripple32Wires.eval ⟨a,b,cin⟩ {} = result
  delta v_Ripple32Wires.eval at h
  extract_lets at h
  expose_names
  subst result
  have previous : v_column_27__carry_in.getLsbD 0 = BitVec.carry 27
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := ripple32_carry_27 a b cin
  carry_step 28 from 27 at v_column_28__carry_in using previous cut v_column_27__carry_in as answer
  exact answer

theorem ripple32_carry_29 (a b : BitVec 32) (cin : BitVec 1) :
    (v_Ripple32Wires.eval ⟨a,b,cin⟩ {}).2.c29.getLsbD 0 =
      BitVec.carry 29 (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := by
  generalize h : v_Ripple32Wires.eval ⟨a,b,cin⟩ {} = result
  delta v_Ripple32Wires.eval at h
  extract_lets at h
  expose_names
  subst result
  have previous : v_column_28__carry_in.getLsbD 0 = BitVec.carry 28
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := ripple32_carry_28 a b cin
  carry_step 29 from 28 at v_column_29__carry_in using previous cut v_column_28__carry_in as answer
  exact answer

theorem ripple32_carry_30 (a b : BitVec 32) (cin : BitVec 1) :
    (v_Ripple32Wires.eval ⟨a,b,cin⟩ {}).2.c30.getLsbD 0 =
      BitVec.carry 30 (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := by
  generalize h : v_Ripple32Wires.eval ⟨a,b,cin⟩ {} = result
  delta v_Ripple32Wires.eval at h
  extract_lets at h
  expose_names
  subst result
  have previous : v_column_29__carry_in.getLsbD 0 = BitVec.carry 29
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := ripple32_carry_29 a b cin
  carry_step 30 from 29 at v_column_30__carry_in using previous cut v_column_29__carry_in as answer
  exact answer

theorem ripple32_carry_31 (a b : BitVec 32) (cin : BitVec 1) :
    (v_Ripple32Wires.eval ⟨a,b,cin⟩ {}).2.c31.getLsbD 0 =
      BitVec.carry 31 (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := by
  generalize h : v_Ripple32Wires.eval ⟨a,b,cin⟩ {} = result
  delta v_Ripple32Wires.eval at h
  extract_lets at h
  expose_names
  subst result
  have previous : v_column_30__carry_in.getLsbD 0 = BitVec.carry 30
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := ripple32_carry_30 a b cin
  carry_step 31 from 30 at v_column_31__carry_in using previous cut v_column_30__carry_in as answer
  exact answer

theorem ripple32_carry_32 (a b : BitVec 32) (cin : BitVec 1) :
    (v_Ripple32Wires.eval ⟨a,b,cin⟩ {}).2.c32.getLsbD 0 =
      BitVec.carry 32 (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := by
  generalize h : v_Ripple32Wires.eval ⟨a,b,cin⟩ {} = result
  delta v_Ripple32Wires.eval at h
  extract_lets at h
  expose_names
  subst result
  have previous : v_column_31__carry_in.getLsbD 0 = BitVec.carry 31
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := ripple32_carry_31 a b cin
  carry_step 32 from 31 at v_cout using previous cut v_column_31__carry_in as answer
  exact answer

end AdderProofs
