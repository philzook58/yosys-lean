import Examples.Prefix32Carries
namespace AdderProofs
set_option maxRecDepth 4096
set_option maxHeartbeats 500000

/-- The exact exported sum and carry equal widened addition for all inputs. -/
theorem prefix32_correct (a b : BitVec 32) (cin : BitVec 1) :
    let o := (v_Prefix32.eval ⟨a,b,cin⟩ {}).1
    BitVec.append o.v_cout o.v_sum = sum33 a b cin := by
  rw [← v_Prefix32Wires.projection]
  generalize h : v_Prefix32Wires.eval ⟨a,b,cin⟩ {} = result
  delta v_Prefix32Wires.eval at h
  extract_lets at h
  expose_names
  subst result
  have h0 : v_cin.getLsbD 0 = BitVec.carry 0
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := prefix32_carry_0 a b cin
  have h1 : v_w5.getLsbD 0 = BitVec.carry 1
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := prefix32_carry_1 a b cin
  have h2 : v_w10.getLsbD 0 = BitVec.carry 2
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := prefix32_carry_2 a b cin
  have h3 : v_w18.getLsbD 0 = BitVec.carry 3
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := prefix32_carry_3 a b cin
  have h4 : v_w23.getLsbD 0 = BitVec.carry 4
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := prefix32_carry_4 a b cin
  have h5 : v_w31.getLsbD 0 = BitVec.carry 5
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := prefix32_carry_5 a b cin
  have h6 : v_w39.getLsbD 0 = BitVec.carry 6
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := prefix32_carry_6 a b cin
  have h7 : v_w50.getLsbD 0 = BitVec.carry 7
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := prefix32_carry_7 a b cin
  have h8 : v_w55.getLsbD 0 = BitVec.carry 8
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := prefix32_carry_8 a b cin
  have h9 : v_w63.getLsbD 0 = BitVec.carry 9
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := prefix32_carry_9 a b cin
  have h10 : v_w71.getLsbD 0 = BitVec.carry 10
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := prefix32_carry_10 a b cin
  have h11 : v_w82.getLsbD 0 = BitVec.carry 11
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := prefix32_carry_11 a b cin
  have h12 : v_w90.getLsbD 0 = BitVec.carry 12
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := prefix32_carry_12 a b cin
  have h13 : v_w101.getLsbD 0 = BitVec.carry 13
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := prefix32_carry_13 a b cin
  have h14 : v_w112.getLsbD 0 = BitVec.carry 14
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := prefix32_carry_14 a b cin
  have h15 : v_w126.getLsbD 0 = BitVec.carry 15
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := prefix32_carry_15 a b cin
  have h16 : v_w131.getLsbD 0 = BitVec.carry 16
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := prefix32_carry_16 a b cin
  have h17 : v_w139.getLsbD 0 = BitVec.carry 17
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := prefix32_carry_17 a b cin
  have h18 : v_w147.getLsbD 0 = BitVec.carry 18
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := prefix32_carry_18 a b cin
  have h19 : v_w158.getLsbD 0 = BitVec.carry 19
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := prefix32_carry_19 a b cin
  have h20 : v_w166.getLsbD 0 = BitVec.carry 20
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := prefix32_carry_20 a b cin
  have h21 : v_w177.getLsbD 0 = BitVec.carry 21
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := prefix32_carry_21 a b cin
  have h22 : v_w188.getLsbD 0 = BitVec.carry 22
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := prefix32_carry_22 a b cin
  have h23 : v_w202.getLsbD 0 = BitVec.carry 23
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := prefix32_carry_23 a b cin
  have h24 : v_w210.getLsbD 0 = BitVec.carry 24
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := prefix32_carry_24 a b cin
  have h25 : v_w221.getLsbD 0 = BitVec.carry 25
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := prefix32_carry_25 a b cin
  have h26 : v_w232.getLsbD 0 = BitVec.carry 26
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := prefix32_carry_26 a b cin
  have h27 : v_w246.getLsbD 0 = BitVec.carry 27
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := prefix32_carry_27 a b cin
  have h28 : v_w257.getLsbD 0 = BitVec.carry 28
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := prefix32_carry_28 a b cin
  have h29 : v_w271.getLsbD 0 = BitVec.carry 29
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := prefix32_carry_29 a b cin
  have h30 : v_w285.getLsbD 0 = BitVec.carry 30
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := prefix32_carry_30 a b cin
  have h31 : v_w302.getLsbD 0 = BitVec.carry 31
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := prefix32_carry_31 a b cin
  have h32 : v_cout.getLsbD 0 = BitVec.carry 32
      (a.setWidth 33) (b.setWidth 33) (cin.getLsbD 0) := prefix32_carry_32 a b cin
  finish_bit 0 as bit0
  finish_bit 1 as bit1
  finish_bit 2 as bit2
  finish_bit 3 as bit3
  finish_bit 4 as bit4
  finish_bit 5 as bit5
  finish_bit 6 as bit6
  finish_bit 7 as bit7
  finish_bit 8 as bit8
  finish_bit 9 as bit9
  finish_bit 10 as bit10
  finish_bit 11 as bit11
  finish_bit 12 as bit12
  finish_bit 13 as bit13
  finish_bit 14 as bit14
  finish_bit 15 as bit15
  finish_bit 16 as bit16
  finish_bit 17 as bit17
  finish_bit 18 as bit18
  finish_bit 19 as bit19
  finish_bit 20 as bit20
  finish_bit 21 as bit21
  finish_bit 22 as bit22
  finish_bit 23 as bit23
  finish_bit 24 as bit24
  finish_bit 25 as bit25
  finish_bit 26 as bit26
  finish_bit 27 as bit27
  finish_bit 28 as bit28
  finish_bit 29 as bit29
  finish_bit 30 as bit30
  finish_bit 31 as bit31
  finish_bit 32 as bit32
  exact equal_bits33 _ _ bit0 bit1 bit2 bit3 bit4 bit5 bit6 bit7 bit8 bit9 bit10 bit11 bit12 bit13 bit14 bit15 bit16 bit17 bit18 bit19 bit20 bit21 bit22 bit23 bit24 bit25 bit26 bit27 bit28 bit29 bit30 bit31 bit32

end AdderProofs
