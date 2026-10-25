import Examples.Generated.Prefix32

-- Generated proof instrumentation; do not edit.
namespace v_Prefix32Wires

structure Carries where
  c0 : BitVec 1
  c1 : BitVec 1
  c2 : BitVec 1
  c3 : BitVec 1
  c4 : BitVec 1
  c5 : BitVec 1
  c6 : BitVec 1
  c7 : BitVec 1
  c8 : BitVec 1
  c9 : BitVec 1
  c10 : BitVec 1
  c11 : BitVec 1
  c12 : BitVec 1
  c13 : BitVec 1
  c14 : BitVec 1
  c15 : BitVec 1
  c16 : BitVec 1
  c17 : BitVec 1
  c18 : BitVec 1
  c19 : BitVec 1
  c20 : BitVec 1
  c21 : BitVec 1
  c22 : BitVec 1
  c23 : BitVec 1
  c24 : BitVec 1
  c25 : BitVec 1
  c26 : BitVec 1
  c27 : BitVec 1
  c28 : BitVec 1
  c29 : BitVec 1
  c30 : BitVec 1
  c31 : BitVec 1
  c32 : BitVec 1

def eval (inputs : v_Prefix32.Inputs) (state : v_Prefix32.State) :
    (v_Prefix32.Outputs × v_Prefix32.State) × Carries :=
  -- a : input; src: examples/bird/upstream/sklansky_adder_32.v:6.22-6.23
  let v_a : BitVec 32 := inputs.v_a
  -- n1 : slice
  let v_n1 : BitVec 1 := (BitVec.extractLsb' 0 1 v_a)
  -- b : input; src: examples/bird/upstream/sklansky_adder_32.v:7.22-7.23
  let v_b : BitVec 32 := inputs.v_b
  -- n3 : slice
  let v_n3 : BitVec 1 := (BitVec.extractLsb' 0 1 v_b)
  -- w0 : bitwise_xor; src: examples/bird/upstream/sklansky_adder_32.v:12.8-12.10
  let v_w0 : BitVec 1 := (v_n1 ^^^ v_n3)
  -- cin : input; src: examples/bird/upstream/sklansky_adder_32.v:8.22-8.25
  let v_cin : BitVec 1 := inputs.v_cin
  -- $examples/bird/upstream/sklansky_adder_32.v:13$xor$2$\Y : bitwise_xor
  let v_n6 : BitVec 1 := (v_w0 ^^^ v_cin)
  -- n7 : slice
  let v_n7 : BitVec 1 := (BitVec.extractLsb' 1 1 v_a)
  -- n8 : slice
  let v_n8 : BitVec 1 := (BitVec.extractLsb' 1 1 v_b)
  -- w2 : bitwise_xor; src: examples/bird/upstream/sklansky_adder_32.v:14.8-14.10
  let v_w2 : BitVec 1 := (v_n7 ^^^ v_n8)
  -- w3 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:15.8-15.10
  let v_w3 : BitVec 1 := (v_n1 &&& v_n3)
  -- w4 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:16.8-16.10
  let v_w4 : BitVec 1 := (v_w0 &&& v_cin)
  -- w5 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:17.8-17.10
  let v_w5 : BitVec 1 := (v_w3 ||| v_w4)
  -- $examples/bird/upstream/sklansky_adder_32.v:18$xor$7$\Y : bitwise_xor
  let v_n13 : BitVec 1 := (v_w2 ^^^ v_w5)
  -- n14 : concat
  let v_n14 : BitVec 2 := (BitVec.append v_n13 v_n6)
  -- n15 : slice
  let v_n15 : BitVec 1 := (BitVec.extractLsb' 2 1 v_a)
  -- n16 : slice
  let v_n16 : BitVec 1 := (BitVec.extractLsb' 2 1 v_b)
  -- w7 : bitwise_xor; src: examples/bird/upstream/sklansky_adder_32.v:19.8-19.10
  let v_w7 : BitVec 1 := (v_n15 ^^^ v_n16)
  -- w8 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:20.8-20.10
  let v_w8 : BitVec 1 := (v_n7 &&& v_n8)
  -- w9 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:21.8-21.10
  let v_w9 : BitVec 1 := (v_w2 &&& v_w5)
  -- w10 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:22.8-22.11
  let v_w10 : BitVec 1 := (v_w8 ||| v_w9)
  -- $examples/bird/upstream/sklansky_adder_32.v:23$xor$12$\Y : bitwise_xor
  let v_n21 : BitVec 1 := (v_w7 ^^^ v_w10)
  -- n22 : concat
  let v_n22 : BitVec 3 := (BitVec.append v_n21 v_n14)
  -- n23 : slice
  let v_n23 : BitVec 1 := (BitVec.extractLsb' 3 1 v_a)
  -- n24 : slice
  let v_n24 : BitVec 1 := (BitVec.extractLsb' 3 1 v_b)
  -- w12 : bitwise_xor; src: examples/bird/upstream/sklansky_adder_32.v:24.8-24.11
  let v_w12 : BitVec 1 := (v_n23 ^^^ v_n24)
  -- w13 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:25.8-25.11
  let v_w13 : BitVec 1 := (v_n15 &&& v_n16)
  -- w14 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:26.8-26.11
  let v_w14 : BitVec 1 := (v_w7 &&& v_w8)
  -- w15 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:27.8-27.11
  let v_w15 : BitVec 1 := (v_w13 ||| v_w14)
  -- w16 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:28.8-28.11
  let v_w16 : BitVec 1 := (v_w2 &&& v_w7)
  -- w17 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:29.8-29.11
  let v_w17 : BitVec 1 := (v_w16 &&& v_w5)
  -- w18 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:30.8-30.11
  let v_w18 : BitVec 1 := (v_w15 ||| v_w17)
  -- $examples/bird/upstream/sklansky_adder_32.v:31$xor$20$\Y : bitwise_xor
  let v_n32 : BitVec 1 := (v_w12 ^^^ v_w18)
  -- n33 : concat
  let v_n33 : BitVec 4 := (BitVec.append v_n32 v_n22)
  -- n34 : slice
  let v_n34 : BitVec 1 := (BitVec.extractLsb' 4 1 v_a)
  -- n35 : slice
  let v_n35 : BitVec 1 := (BitVec.extractLsb' 4 1 v_b)
  -- w20 : bitwise_xor; src: examples/bird/upstream/sklansky_adder_32.v:32.8-32.11
  let v_w20 : BitVec 1 := (v_n34 ^^^ v_n35)
  -- w21 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:33.8-33.11
  let v_w21 : BitVec 1 := (v_n23 &&& v_n24)
  -- w22 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:34.8-34.11
  let v_w22 : BitVec 1 := (v_w12 &&& v_w18)
  -- w23 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:35.8-35.11
  let v_w23 : BitVec 1 := (v_w21 ||| v_w22)
  -- $examples/bird/upstream/sklansky_adder_32.v:36$xor$25$\Y : bitwise_xor
  let v_n40 : BitVec 1 := (v_w20 ^^^ v_w23)
  -- n41 : concat
  let v_n41 : BitVec 5 := (BitVec.append v_n40 v_n33)
  -- n42 : slice
  let v_n42 : BitVec 1 := (BitVec.extractLsb' 5 1 v_a)
  -- n43 : slice
  let v_n43 : BitVec 1 := (BitVec.extractLsb' 5 1 v_b)
  -- w25 : bitwise_xor; src: examples/bird/upstream/sklansky_adder_32.v:37.8-37.11
  let v_w25 : BitVec 1 := (v_n42 ^^^ v_n43)
  -- w26 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:38.8-38.11
  let v_w26 : BitVec 1 := (v_n34 &&& v_n35)
  -- w27 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:39.8-39.11
  let v_w27 : BitVec 1 := (v_w20 &&& v_w21)
  -- w28 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:40.8-40.11
  let v_w28 : BitVec 1 := (v_w26 ||| v_w27)
  -- w29 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:41.8-41.11
  let v_w29 : BitVec 1 := (v_w12 &&& v_w20)
  -- w30 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:42.8-42.11
  let v_w30 : BitVec 1 := (v_w29 &&& v_w18)
  -- w31 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:43.8-43.11
  let v_w31 : BitVec 1 := (v_w28 ||| v_w30)
  -- $examples/bird/upstream/sklansky_adder_32.v:44$xor$33$\Y : bitwise_xor
  let v_n51 : BitVec 1 := (v_w25 ^^^ v_w31)
  -- n52 : concat
  let v_n52 : BitVec 6 := (BitVec.append v_n51 v_n41)
  -- n53 : slice
  let v_n53 : BitVec 1 := (BitVec.extractLsb' 6 1 v_a)
  -- n54 : slice
  let v_n54 : BitVec 1 := (BitVec.extractLsb' 6 1 v_b)
  -- w33 : bitwise_xor; src: examples/bird/upstream/sklansky_adder_32.v:45.8-45.11
  let v_w33 : BitVec 1 := (v_n53 ^^^ v_n54)
  -- w34 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:46.8-46.11
  let v_w34 : BitVec 1 := (v_n42 &&& v_n43)
  -- w35 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:47.8-47.11
  let v_w35 : BitVec 1 := (v_w25 &&& v_w28)
  -- w36 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:48.8-48.11
  let v_w36 : BitVec 1 := (v_w34 ||| v_w35)
  -- w37 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:49.8-49.11
  let v_w37 : BitVec 1 := (v_w29 &&& v_w25)
  -- w38 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:50.8-50.11
  let v_w38 : BitVec 1 := (v_w37 &&& v_w18)
  -- w39 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:51.8-51.11
  let v_w39 : BitVec 1 := (v_w36 ||| v_w38)
  -- $examples/bird/upstream/sklansky_adder_32.v:52$xor$41$\Y : bitwise_xor
  let v_n62 : BitVec 1 := (v_w33 ^^^ v_w39)
  -- n63 : concat
  let v_n63 : BitVec 7 := (BitVec.append v_n62 v_n52)
  -- n64 : slice
  let v_n64 : BitVec 1 := (BitVec.extractLsb' 7 1 v_a)
  -- n65 : slice
  let v_n65 : BitVec 1 := (BitVec.extractLsb' 7 1 v_b)
  -- w41 : bitwise_xor; src: examples/bird/upstream/sklansky_adder_32.v:53.8-53.11
  let v_w41 : BitVec 1 := (v_n64 ^^^ v_n65)
  -- w42 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:54.8-54.11
  let v_w42 : BitVec 1 := (v_n53 &&& v_n54)
  -- w43 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:55.8-55.11
  let v_w43 : BitVec 1 := (v_w33 &&& v_w34)
  -- w44 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:56.8-56.11
  let v_w44 : BitVec 1 := (v_w42 ||| v_w43)
  -- w45 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:57.8-57.11
  let v_w45 : BitVec 1 := (v_w25 &&& v_w33)
  -- w46 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:58.8-58.11
  let v_w46 : BitVec 1 := (v_w45 &&& v_w28)
  -- w47 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:59.8-59.11
  let v_w47 : BitVec 1 := (v_w44 ||| v_w46)
  -- w48 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:60.8-60.11
  let v_w48 : BitVec 1 := (v_w29 &&& v_w45)
  -- w49 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:61.8-61.11
  let v_w49 : BitVec 1 := (v_w48 &&& v_w18)
  -- w50 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:62.8-62.11
  let v_w50 : BitVec 1 := (v_w47 ||| v_w49)
  -- $examples/bird/upstream/sklansky_adder_32.v:63$xor$52$\Y : bitwise_xor
  let v_n76 : BitVec 1 := (v_w41 ^^^ v_w50)
  -- n77 : concat
  let v_n77 : BitVec 8 := (BitVec.append v_n76 v_n63)
  -- n78 : slice
  let v_n78 : BitVec 1 := (BitVec.extractLsb' 8 1 v_a)
  -- n79 : slice
  let v_n79 : BitVec 1 := (BitVec.extractLsb' 8 1 v_b)
  -- w52 : bitwise_xor; src: examples/bird/upstream/sklansky_adder_32.v:64.8-64.11
  let v_w52 : BitVec 1 := (v_n78 ^^^ v_n79)
  -- w53 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:65.8-65.11
  let v_w53 : BitVec 1 := (v_n64 &&& v_n65)
  -- w54 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:66.8-66.11
  let v_w54 : BitVec 1 := (v_w41 &&& v_w50)
  -- w55 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:67.8-67.11
  let v_w55 : BitVec 1 := (v_w53 ||| v_w54)
  -- $examples/bird/upstream/sklansky_adder_32.v:68$xor$57$\Y : bitwise_xor
  let v_n84 : BitVec 1 := (v_w52 ^^^ v_w55)
  -- n85 : concat
  let v_n85 : BitVec 9 := (BitVec.append v_n84 v_n77)
  -- n86 : slice
  let v_n86 : BitVec 1 := (BitVec.extractLsb' 9 1 v_a)
  -- n87 : slice
  let v_n87 : BitVec 1 := (BitVec.extractLsb' 9 1 v_b)
  -- w57 : bitwise_xor; src: examples/bird/upstream/sklansky_adder_32.v:69.8-69.11
  let v_w57 : BitVec 1 := (v_n86 ^^^ v_n87)
  -- w58 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:70.8-70.11
  let v_w58 : BitVec 1 := (v_n78 &&& v_n79)
  -- w59 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:71.8-71.11
  let v_w59 : BitVec 1 := (v_w52 &&& v_w53)
  -- w60 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:72.8-72.11
  let v_w60 : BitVec 1 := (v_w58 ||| v_w59)
  -- w61 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:73.8-73.11
  let v_w61 : BitVec 1 := (v_w41 &&& v_w52)
  -- w62 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:74.8-74.11
  let v_w62 : BitVec 1 := (v_w61 &&& v_w50)
  -- w63 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:75.8-75.11
  let v_w63 : BitVec 1 := (v_w60 ||| v_w62)
  -- $examples/bird/upstream/sklansky_adder_32.v:76$xor$65$\Y : bitwise_xor
  let v_n95 : BitVec 1 := (v_w57 ^^^ v_w63)
  -- n96 : concat
  let v_n96 : BitVec 10 := (BitVec.append v_n95 v_n85)
  -- n97 : slice
  let v_n97 : BitVec 1 := (BitVec.extractLsb' 10 1 v_a)
  -- n98 : slice
  let v_n98 : BitVec 1 := (BitVec.extractLsb' 10 1 v_b)
  -- w65 : bitwise_xor; src: examples/bird/upstream/sklansky_adder_32.v:77.8-77.11
  let v_w65 : BitVec 1 := (v_n97 ^^^ v_n98)
  -- w66 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:78.8-78.11
  let v_w66 : BitVec 1 := (v_n86 &&& v_n87)
  -- w67 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:79.8-79.11
  let v_w67 : BitVec 1 := (v_w57 &&& v_w60)
  -- w68 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:80.8-80.11
  let v_w68 : BitVec 1 := (v_w66 ||| v_w67)
  -- w69 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:81.8-81.11
  let v_w69 : BitVec 1 := (v_w61 &&& v_w57)
  -- w70 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:82.8-82.11
  let v_w70 : BitVec 1 := (v_w69 &&& v_w50)
  -- w71 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:83.8-83.11
  let v_w71 : BitVec 1 := (v_w68 ||| v_w70)
  -- $examples/bird/upstream/sklansky_adder_32.v:84$xor$73$\Y : bitwise_xor
  let v_n106 : BitVec 1 := (v_w65 ^^^ v_w71)
  -- n107 : concat
  let v_n107 : BitVec 11 := (BitVec.append v_n106 v_n96)
  -- n108 : slice
  let v_n108 : BitVec 1 := (BitVec.extractLsb' 11 1 v_a)
  -- n109 : slice
  let v_n109 : BitVec 1 := (BitVec.extractLsb' 11 1 v_b)
  -- w73 : bitwise_xor; src: examples/bird/upstream/sklansky_adder_32.v:85.8-85.11
  let v_w73 : BitVec 1 := (v_n108 ^^^ v_n109)
  -- w74 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:86.8-86.11
  let v_w74 : BitVec 1 := (v_n97 &&& v_n98)
  -- w75 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:87.8-87.11
  let v_w75 : BitVec 1 := (v_w65 &&& v_w66)
  -- w76 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:88.8-88.11
  let v_w76 : BitVec 1 := (v_w74 ||| v_w75)
  -- w77 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:89.8-89.11
  let v_w77 : BitVec 1 := (v_w57 &&& v_w65)
  -- w78 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:90.8-90.11
  let v_w78 : BitVec 1 := (v_w77 &&& v_w60)
  -- w79 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:91.8-91.11
  let v_w79 : BitVec 1 := (v_w76 ||| v_w78)
  -- w80 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:92.8-92.11
  let v_w80 : BitVec 1 := (v_w61 &&& v_w77)
  -- w81 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:93.8-93.11
  let v_w81 : BitVec 1 := (v_w80 &&& v_w50)
  -- w82 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:94.8-94.11
  let v_w82 : BitVec 1 := (v_w79 ||| v_w81)
  -- $examples/bird/upstream/sklansky_adder_32.v:95$xor$84$\Y : bitwise_xor
  let v_n120 : BitVec 1 := (v_w73 ^^^ v_w82)
  -- n121 : concat
  let v_n121 : BitVec 12 := (BitVec.append v_n120 v_n107)
  -- n122 : slice
  let v_n122 : BitVec 1 := (BitVec.extractLsb' 12 1 v_a)
  -- n123 : slice
  let v_n123 : BitVec 1 := (BitVec.extractLsb' 12 1 v_b)
  -- w84 : bitwise_xor; src: examples/bird/upstream/sklansky_adder_32.v:96.8-96.11
  let v_w84 : BitVec 1 := (v_n122 ^^^ v_n123)
  -- w85 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:97.8-97.11
  let v_w85 : BitVec 1 := (v_n108 &&& v_n109)
  -- w86 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:98.8-98.11
  let v_w86 : BitVec 1 := (v_w73 &&& v_w79)
  -- w87 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:99.8-99.11
  let v_w87 : BitVec 1 := (v_w85 ||| v_w86)
  -- w88 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:100.8-100.11
  let v_w88 : BitVec 1 := (v_w80 &&& v_w73)
  -- w89 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:101.8-101.11
  let v_w89 : BitVec 1 := (v_w88 &&& v_w50)
  -- w90 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:102.8-102.11
  let v_w90 : BitVec 1 := (v_w87 ||| v_w89)
  -- $examples/bird/upstream/sklansky_adder_32.v:103$xor$92$\Y : bitwise_xor
  let v_n131 : BitVec 1 := (v_w84 ^^^ v_w90)
  -- n132 : concat
  let v_n132 : BitVec 13 := (BitVec.append v_n131 v_n121)
  -- n133 : slice
  let v_n133 : BitVec 1 := (BitVec.extractLsb' 13 1 v_a)
  -- n134 : slice
  let v_n134 : BitVec 1 := (BitVec.extractLsb' 13 1 v_b)
  -- w92 : bitwise_xor; src: examples/bird/upstream/sklansky_adder_32.v:104.8-104.11
  let v_w92 : BitVec 1 := (v_n133 ^^^ v_n134)
  -- w93 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:105.8-105.11
  let v_w93 : BitVec 1 := (v_n122 &&& v_n123)
  -- w94 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:106.8-106.11
  let v_w94 : BitVec 1 := (v_w84 &&& v_w85)
  -- w95 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:107.8-107.11
  let v_w95 : BitVec 1 := (v_w93 ||| v_w94)
  -- w96 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:108.8-108.11
  let v_w96 : BitVec 1 := (v_w73 &&& v_w84)
  -- w97 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:109.8-109.11
  let v_w97 : BitVec 1 := (v_w96 &&& v_w79)
  -- w98 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:110.8-110.11
  let v_w98 : BitVec 1 := (v_w95 ||| v_w97)
  -- w99 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:111.8-111.11
  let v_w99 : BitVec 1 := (v_w80 &&& v_w96)
  -- w100 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:112.8-112.12
  let v_w100 : BitVec 1 := (v_w99 &&& v_w50)
  -- w101 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:113.8-113.12
  let v_w101 : BitVec 1 := (v_w98 ||| v_w100)
  -- $examples/bird/upstream/sklansky_adder_32.v:114$xor$103$\Y : bitwise_xor
  let v_n145 : BitVec 1 := (v_w92 ^^^ v_w101)
  -- n146 : concat
  let v_n146 : BitVec 14 := (BitVec.append v_n145 v_n132)
  -- n147 : slice
  let v_n147 : BitVec 1 := (BitVec.extractLsb' 14 1 v_a)
  -- n148 : slice
  let v_n148 : BitVec 1 := (BitVec.extractLsb' 14 1 v_b)
  -- w103 : bitwise_xor; src: examples/bird/upstream/sklansky_adder_32.v:115.8-115.12
  let v_w103 : BitVec 1 := (v_n147 ^^^ v_n148)
  -- w104 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:116.8-116.12
  let v_w104 : BitVec 1 := (v_n133 &&& v_n134)
  -- w105 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:117.8-117.12
  let v_w105 : BitVec 1 := (v_w92 &&& v_w95)
  -- w106 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:118.8-118.12
  let v_w106 : BitVec 1 := (v_w104 ||| v_w105)
  -- w107 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:119.8-119.12
  let v_w107 : BitVec 1 := (v_w96 &&& v_w92)
  -- w108 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:120.8-120.12
  let v_w108 : BitVec 1 := (v_w107 &&& v_w79)
  -- w109 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:121.8-121.12
  let v_w109 : BitVec 1 := (v_w106 ||| v_w108)
  -- w110 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:122.8-122.12
  let v_w110 : BitVec 1 := (v_w80 &&& v_w107)
  -- w111 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:123.8-123.12
  let v_w111 : BitVec 1 := (v_w110 &&& v_w50)
  -- w112 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:124.8-124.12
  let v_w112 : BitVec 1 := (v_w109 ||| v_w111)
  -- $examples/bird/upstream/sklansky_adder_32.v:125$xor$114$\Y : bitwise_xor
  let v_n159 : BitVec 1 := (v_w103 ^^^ v_w112)
  -- n160 : concat
  let v_n160 : BitVec 15 := (BitVec.append v_n159 v_n146)
  -- n161 : slice
  let v_n161 : BitVec 1 := (BitVec.extractLsb' 15 1 v_a)
  -- n162 : slice
  let v_n162 : BitVec 1 := (BitVec.extractLsb' 15 1 v_b)
  -- w114 : bitwise_xor; src: examples/bird/upstream/sklansky_adder_32.v:126.8-126.12
  let v_w114 : BitVec 1 := (v_n161 ^^^ v_n162)
  -- w115 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:127.8-127.12
  let v_w115 : BitVec 1 := (v_n147 &&& v_n148)
  -- w116 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:128.8-128.12
  let v_w116 : BitVec 1 := (v_w103 &&& v_w104)
  -- w117 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:129.8-129.12
  let v_w117 : BitVec 1 := (v_w115 ||| v_w116)
  -- w118 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:130.8-130.12
  let v_w118 : BitVec 1 := (v_w92 &&& v_w103)
  -- w119 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:131.8-131.12
  let v_w119 : BitVec 1 := (v_w118 &&& v_w95)
  -- w120 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:132.8-132.12
  let v_w120 : BitVec 1 := (v_w117 ||| v_w119)
  -- w121 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:133.8-133.12
  let v_w121 : BitVec 1 := (v_w96 &&& v_w118)
  -- w122 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:134.8-134.12
  let v_w122 : BitVec 1 := (v_w121 &&& v_w79)
  -- w123 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:135.8-135.12
  let v_w123 : BitVec 1 := (v_w120 ||| v_w122)
  -- w124 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:136.8-136.12
  let v_w124 : BitVec 1 := (v_w80 &&& v_w121)
  -- w125 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:137.8-137.12
  let v_w125 : BitVec 1 := (v_w124 &&& v_w50)
  -- w126 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:138.8-138.12
  let v_w126 : BitVec 1 := (v_w123 ||| v_w125)
  -- $examples/bird/upstream/sklansky_adder_32.v:139$xor$128$\Y : bitwise_xor
  let v_n176 : BitVec 1 := (v_w114 ^^^ v_w126)
  -- n177 : concat
  let v_n177 : BitVec 16 := (BitVec.append v_n176 v_n160)
  -- n178 : slice
  let v_n178 : BitVec 1 := (BitVec.extractLsb' 16 1 v_a)
  -- n179 : slice
  let v_n179 : BitVec 1 := (BitVec.extractLsb' 16 1 v_b)
  -- w128 : bitwise_xor; src: examples/bird/upstream/sklansky_adder_32.v:140.8-140.12
  let v_w128 : BitVec 1 := (v_n178 ^^^ v_n179)
  -- w129 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:141.8-141.12
  let v_w129 : BitVec 1 := (v_n161 &&& v_n162)
  -- w130 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:142.8-142.12
  let v_w130 : BitVec 1 := (v_w114 &&& v_w126)
  -- w131 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:143.8-143.12
  let v_w131 : BitVec 1 := (v_w129 ||| v_w130)
  -- $examples/bird/upstream/sklansky_adder_32.v:144$xor$133$\Y : bitwise_xor
  let v_n184 : BitVec 1 := (v_w128 ^^^ v_w131)
  -- n185 : concat
  let v_n185 : BitVec 17 := (BitVec.append v_n184 v_n177)
  -- n186 : slice
  let v_n186 : BitVec 1 := (BitVec.extractLsb' 17 1 v_a)
  -- n187 : slice
  let v_n187 : BitVec 1 := (BitVec.extractLsb' 17 1 v_b)
  -- w133 : bitwise_xor; src: examples/bird/upstream/sklansky_adder_32.v:145.8-145.12
  let v_w133 : BitVec 1 := (v_n186 ^^^ v_n187)
  -- w134 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:146.8-146.12
  let v_w134 : BitVec 1 := (v_n178 &&& v_n179)
  -- w135 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:147.8-147.12
  let v_w135 : BitVec 1 := (v_w128 &&& v_w129)
  -- w136 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:148.8-148.12
  let v_w136 : BitVec 1 := (v_w134 ||| v_w135)
  -- w137 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:149.8-149.12
  let v_w137 : BitVec 1 := (v_w114 &&& v_w128)
  -- w138 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:150.8-150.12
  let v_w138 : BitVec 1 := (v_w137 &&& v_w126)
  -- w139 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:151.8-151.12
  let v_w139 : BitVec 1 := (v_w136 ||| v_w138)
  -- $examples/bird/upstream/sklansky_adder_32.v:152$xor$141$\Y : bitwise_xor
  let v_n195 : BitVec 1 := (v_w133 ^^^ v_w139)
  -- n196 : concat
  let v_n196 : BitVec 18 := (BitVec.append v_n195 v_n185)
  -- n197 : slice
  let v_n197 : BitVec 1 := (BitVec.extractLsb' 18 1 v_a)
  -- n198 : slice
  let v_n198 : BitVec 1 := (BitVec.extractLsb' 18 1 v_b)
  -- w141 : bitwise_xor; src: examples/bird/upstream/sklansky_adder_32.v:153.8-153.12
  let v_w141 : BitVec 1 := (v_n197 ^^^ v_n198)
  -- w142 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:154.8-154.12
  let v_w142 : BitVec 1 := (v_n186 &&& v_n187)
  -- w143 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:155.8-155.12
  let v_w143 : BitVec 1 := (v_w133 &&& v_w136)
  -- w144 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:156.8-156.12
  let v_w144 : BitVec 1 := (v_w142 ||| v_w143)
  -- w145 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:157.8-157.12
  let v_w145 : BitVec 1 := (v_w137 &&& v_w133)
  -- w146 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:158.8-158.12
  let v_w146 : BitVec 1 := (v_w145 &&& v_w126)
  -- w147 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:159.8-159.12
  let v_w147 : BitVec 1 := (v_w144 ||| v_w146)
  -- $examples/bird/upstream/sklansky_adder_32.v:160$xor$149$\Y : bitwise_xor
  let v_n206 : BitVec 1 := (v_w141 ^^^ v_w147)
  -- n207 : concat
  let v_n207 : BitVec 19 := (BitVec.append v_n206 v_n196)
  -- n208 : slice
  let v_n208 : BitVec 1 := (BitVec.extractLsb' 19 1 v_a)
  -- n209 : slice
  let v_n209 : BitVec 1 := (BitVec.extractLsb' 19 1 v_b)
  -- w149 : bitwise_xor; src: examples/bird/upstream/sklansky_adder_32.v:161.8-161.12
  let v_w149 : BitVec 1 := (v_n208 ^^^ v_n209)
  -- w150 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:162.8-162.12
  let v_w150 : BitVec 1 := (v_n197 &&& v_n198)
  -- w151 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:163.8-163.12
  let v_w151 : BitVec 1 := (v_w141 &&& v_w142)
  -- w152 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:164.8-164.12
  let v_w152 : BitVec 1 := (v_w150 ||| v_w151)
  -- w153 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:165.8-165.12
  let v_w153 : BitVec 1 := (v_w133 &&& v_w141)
  -- w154 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:166.8-166.12
  let v_w154 : BitVec 1 := (v_w153 &&& v_w136)
  -- w155 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:167.8-167.12
  let v_w155 : BitVec 1 := (v_w152 ||| v_w154)
  -- w156 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:168.8-168.12
  let v_w156 : BitVec 1 := (v_w137 &&& v_w153)
  -- w157 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:169.8-169.12
  let v_w157 : BitVec 1 := (v_w156 &&& v_w126)
  -- w158 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:170.8-170.12
  let v_w158 : BitVec 1 := (v_w155 ||| v_w157)
  -- $examples/bird/upstream/sklansky_adder_32.v:171$xor$160$\Y : bitwise_xor
  let v_n220 : BitVec 1 := (v_w149 ^^^ v_w158)
  -- n221 : concat
  let v_n221 : BitVec 20 := (BitVec.append v_n220 v_n207)
  -- n222 : slice
  let v_n222 : BitVec 1 := (BitVec.extractLsb' 20 1 v_a)
  -- n223 : slice
  let v_n223 : BitVec 1 := (BitVec.extractLsb' 20 1 v_b)
  -- w160 : bitwise_xor; src: examples/bird/upstream/sklansky_adder_32.v:172.8-172.12
  let v_w160 : BitVec 1 := (v_n222 ^^^ v_n223)
  -- w161 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:173.8-173.12
  let v_w161 : BitVec 1 := (v_n208 &&& v_n209)
  -- w162 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:174.8-174.12
  let v_w162 : BitVec 1 := (v_w149 &&& v_w155)
  -- w163 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:175.8-175.12
  let v_w163 : BitVec 1 := (v_w161 ||| v_w162)
  -- w164 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:176.8-176.12
  let v_w164 : BitVec 1 := (v_w156 &&& v_w149)
  -- w165 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:177.8-177.12
  let v_w165 : BitVec 1 := (v_w164 &&& v_w126)
  -- w166 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:178.8-178.12
  let v_w166 : BitVec 1 := (v_w163 ||| v_w165)
  -- $examples/bird/upstream/sklansky_adder_32.v:179$xor$168$\Y : bitwise_xor
  let v_n231 : BitVec 1 := (v_w160 ^^^ v_w166)
  -- n232 : concat
  let v_n232 : BitVec 21 := (BitVec.append v_n231 v_n221)
  -- n233 : slice
  let v_n233 : BitVec 1 := (BitVec.extractLsb' 21 1 v_a)
  -- n234 : slice
  let v_n234 : BitVec 1 := (BitVec.extractLsb' 21 1 v_b)
  -- w168 : bitwise_xor; src: examples/bird/upstream/sklansky_adder_32.v:180.8-180.12
  let v_w168 : BitVec 1 := (v_n233 ^^^ v_n234)
  -- w169 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:181.8-181.12
  let v_w169 : BitVec 1 := (v_n222 &&& v_n223)
  -- w170 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:182.8-182.12
  let v_w170 : BitVec 1 := (v_w160 &&& v_w161)
  -- w171 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:183.8-183.12
  let v_w171 : BitVec 1 := (v_w169 ||| v_w170)
  -- w172 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:184.8-184.12
  let v_w172 : BitVec 1 := (v_w149 &&& v_w160)
  -- w173 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:185.8-185.12
  let v_w173 : BitVec 1 := (v_w172 &&& v_w155)
  -- w174 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:186.8-186.12
  let v_w174 : BitVec 1 := (v_w171 ||| v_w173)
  -- w175 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:187.8-187.12
  let v_w175 : BitVec 1 := (v_w156 &&& v_w172)
  -- w176 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:188.8-188.12
  let v_w176 : BitVec 1 := (v_w175 &&& v_w126)
  -- w177 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:189.8-189.12
  let v_w177 : BitVec 1 := (v_w174 ||| v_w176)
  -- $examples/bird/upstream/sklansky_adder_32.v:190$xor$179$\Y : bitwise_xor
  let v_n245 : BitVec 1 := (v_w168 ^^^ v_w177)
  -- n246 : concat
  let v_n246 : BitVec 22 := (BitVec.append v_n245 v_n232)
  -- n247 : slice
  let v_n247 : BitVec 1 := (BitVec.extractLsb' 22 1 v_a)
  -- n248 : slice
  let v_n248 : BitVec 1 := (BitVec.extractLsb' 22 1 v_b)
  -- w179 : bitwise_xor; src: examples/bird/upstream/sklansky_adder_32.v:191.8-191.12
  let v_w179 : BitVec 1 := (v_n247 ^^^ v_n248)
  -- w180 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:192.8-192.12
  let v_w180 : BitVec 1 := (v_n233 &&& v_n234)
  -- w181 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:193.8-193.12
  let v_w181 : BitVec 1 := (v_w168 &&& v_w171)
  -- w182 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:194.8-194.12
  let v_w182 : BitVec 1 := (v_w180 ||| v_w181)
  -- w183 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:195.8-195.12
  let v_w183 : BitVec 1 := (v_w172 &&& v_w168)
  -- w184 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:196.8-196.12
  let v_w184 : BitVec 1 := (v_w183 &&& v_w155)
  -- w185 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:197.8-197.12
  let v_w185 : BitVec 1 := (v_w182 ||| v_w184)
  -- w186 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:198.8-198.12
  let v_w186 : BitVec 1 := (v_w156 &&& v_w183)
  -- w187 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:199.8-199.12
  let v_w187 : BitVec 1 := (v_w186 &&& v_w126)
  -- w188 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:200.8-200.12
  let v_w188 : BitVec 1 := (v_w185 ||| v_w187)
  -- $examples/bird/upstream/sklansky_adder_32.v:201$xor$190$\Y : bitwise_xor
  let v_n259 : BitVec 1 := (v_w179 ^^^ v_w188)
  -- n260 : concat
  let v_n260 : BitVec 23 := (BitVec.append v_n259 v_n246)
  -- n261 : slice
  let v_n261 : BitVec 1 := (BitVec.extractLsb' 23 1 v_a)
  -- n262 : slice
  let v_n262 : BitVec 1 := (BitVec.extractLsb' 23 1 v_b)
  -- w190 : bitwise_xor; src: examples/bird/upstream/sklansky_adder_32.v:202.8-202.12
  let v_w190 : BitVec 1 := (v_n261 ^^^ v_n262)
  -- w191 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:203.8-203.12
  let v_w191 : BitVec 1 := (v_n247 &&& v_n248)
  -- w192 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:204.8-204.12
  let v_w192 : BitVec 1 := (v_w179 &&& v_w180)
  -- w193 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:205.8-205.12
  let v_w193 : BitVec 1 := (v_w191 ||| v_w192)
  -- w194 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:206.8-206.12
  let v_w194 : BitVec 1 := (v_w168 &&& v_w179)
  -- w195 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:207.8-207.12
  let v_w195 : BitVec 1 := (v_w194 &&& v_w171)
  -- w196 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:208.8-208.12
  let v_w196 : BitVec 1 := (v_w193 ||| v_w195)
  -- w197 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:209.8-209.12
  let v_w197 : BitVec 1 := (v_w172 &&& v_w194)
  -- w198 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:210.8-210.12
  let v_w198 : BitVec 1 := (v_w197 &&& v_w155)
  -- w199 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:211.8-211.12
  let v_w199 : BitVec 1 := (v_w196 ||| v_w198)
  -- w200 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:212.8-212.12
  let v_w200 : BitVec 1 := (v_w156 &&& v_w197)
  -- w201 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:213.8-213.12
  let v_w201 : BitVec 1 := (v_w200 &&& v_w126)
  -- w202 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:214.8-214.12
  let v_w202 : BitVec 1 := (v_w199 ||| v_w201)
  -- $examples/bird/upstream/sklansky_adder_32.v:215$xor$204$\Y : bitwise_xor
  let v_n276 : BitVec 1 := (v_w190 ^^^ v_w202)
  -- n277 : concat
  let v_n277 : BitVec 24 := (BitVec.append v_n276 v_n260)
  -- n278 : slice
  let v_n278 : BitVec 1 := (BitVec.extractLsb' 24 1 v_a)
  -- n279 : slice
  let v_n279 : BitVec 1 := (BitVec.extractLsb' 24 1 v_b)
  -- w204 : bitwise_xor; src: examples/bird/upstream/sklansky_adder_32.v:216.8-216.12
  let v_w204 : BitVec 1 := (v_n278 ^^^ v_n279)
  -- w205 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:217.8-217.12
  let v_w205 : BitVec 1 := (v_n261 &&& v_n262)
  -- w206 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:218.8-218.12
  let v_w206 : BitVec 1 := (v_w190 &&& v_w199)
  -- w207 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:219.8-219.12
  let v_w207 : BitVec 1 := (v_w205 ||| v_w206)
  -- w208 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:220.8-220.12
  let v_w208 : BitVec 1 := (v_w200 &&& v_w190)
  -- w209 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:221.8-221.12
  let v_w209 : BitVec 1 := (v_w208 &&& v_w126)
  -- w210 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:222.8-222.12
  let v_w210 : BitVec 1 := (v_w207 ||| v_w209)
  -- $examples/bird/upstream/sklansky_adder_32.v:223$xor$212$\Y : bitwise_xor
  let v_n287 : BitVec 1 := (v_w204 ^^^ v_w210)
  -- n288 : concat
  let v_n288 : BitVec 25 := (BitVec.append v_n287 v_n277)
  -- n289 : slice
  let v_n289 : BitVec 1 := (BitVec.extractLsb' 25 1 v_a)
  -- n290 : slice
  let v_n290 : BitVec 1 := (BitVec.extractLsb' 25 1 v_b)
  -- w212 : bitwise_xor; src: examples/bird/upstream/sklansky_adder_32.v:224.8-224.12
  let v_w212 : BitVec 1 := (v_n289 ^^^ v_n290)
  -- w213 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:225.8-225.12
  let v_w213 : BitVec 1 := (v_n278 &&& v_n279)
  -- w214 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:226.8-226.12
  let v_w214 : BitVec 1 := (v_w204 &&& v_w205)
  -- w215 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:227.8-227.12
  let v_w215 : BitVec 1 := (v_w213 ||| v_w214)
  -- w216 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:228.8-228.12
  let v_w216 : BitVec 1 := (v_w190 &&& v_w204)
  -- w217 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:229.8-229.12
  let v_w217 : BitVec 1 := (v_w216 &&& v_w199)
  -- w218 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:230.8-230.12
  let v_w218 : BitVec 1 := (v_w215 ||| v_w217)
  -- w219 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:231.8-231.12
  let v_w219 : BitVec 1 := (v_w200 &&& v_w216)
  -- w220 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:232.8-232.12
  let v_w220 : BitVec 1 := (v_w219 &&& v_w126)
  -- w221 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:233.8-233.12
  let v_w221 : BitVec 1 := (v_w218 ||| v_w220)
  -- $examples/bird/upstream/sklansky_adder_32.v:234$xor$223$\Y : bitwise_xor
  let v_n301 : BitVec 1 := (v_w212 ^^^ v_w221)
  -- n302 : concat
  let v_n302 : BitVec 26 := (BitVec.append v_n301 v_n288)
  -- n303 : slice
  let v_n303 : BitVec 1 := (BitVec.extractLsb' 26 1 v_a)
  -- n304 : slice
  let v_n304 : BitVec 1 := (BitVec.extractLsb' 26 1 v_b)
  -- w223 : bitwise_xor; src: examples/bird/upstream/sklansky_adder_32.v:235.8-235.12
  let v_w223 : BitVec 1 := (v_n303 ^^^ v_n304)
  -- w224 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:236.8-236.12
  let v_w224 : BitVec 1 := (v_n289 &&& v_n290)
  -- w225 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:237.8-237.12
  let v_w225 : BitVec 1 := (v_w212 &&& v_w215)
  -- w226 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:238.8-238.12
  let v_w226 : BitVec 1 := (v_w224 ||| v_w225)
  -- w227 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:239.8-239.12
  let v_w227 : BitVec 1 := (v_w216 &&& v_w212)
  -- w228 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:240.8-240.12
  let v_w228 : BitVec 1 := (v_w227 &&& v_w199)
  -- w229 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:241.8-241.12
  let v_w229 : BitVec 1 := (v_w226 ||| v_w228)
  -- w230 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:242.8-242.12
  let v_w230 : BitVec 1 := (v_w200 &&& v_w227)
  -- w231 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:243.8-243.12
  let v_w231 : BitVec 1 := (v_w230 &&& v_w126)
  -- w232 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:244.8-244.12
  let v_w232 : BitVec 1 := (v_w229 ||| v_w231)
  -- $examples/bird/upstream/sklansky_adder_32.v:245$xor$234$\Y : bitwise_xor
  let v_n315 : BitVec 1 := (v_w223 ^^^ v_w232)
  -- n316 : concat
  let v_n316 : BitVec 27 := (BitVec.append v_n315 v_n302)
  -- n317 : slice
  let v_n317 : BitVec 1 := (BitVec.extractLsb' 27 1 v_a)
  -- n318 : slice
  let v_n318 : BitVec 1 := (BitVec.extractLsb' 27 1 v_b)
  -- w234 : bitwise_xor; src: examples/bird/upstream/sklansky_adder_32.v:246.8-246.12
  let v_w234 : BitVec 1 := (v_n317 ^^^ v_n318)
  -- w235 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:247.8-247.12
  let v_w235 : BitVec 1 := (v_n303 &&& v_n304)
  -- w236 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:248.8-248.12
  let v_w236 : BitVec 1 := (v_w223 &&& v_w224)
  -- w237 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:249.8-249.12
  let v_w237 : BitVec 1 := (v_w235 ||| v_w236)
  -- w238 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:250.8-250.12
  let v_w238 : BitVec 1 := (v_w212 &&& v_w223)
  -- w239 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:251.8-251.12
  let v_w239 : BitVec 1 := (v_w238 &&& v_w215)
  -- w240 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:252.8-252.12
  let v_w240 : BitVec 1 := (v_w237 ||| v_w239)
  -- w241 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:253.8-253.12
  let v_w241 : BitVec 1 := (v_w216 &&& v_w238)
  -- w242 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:254.8-254.12
  let v_w242 : BitVec 1 := (v_w241 &&& v_w199)
  -- w243 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:255.8-255.12
  let v_w243 : BitVec 1 := (v_w240 ||| v_w242)
  -- w244 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:256.8-256.12
  let v_w244 : BitVec 1 := (v_w200 &&& v_w241)
  -- w245 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:257.8-257.12
  let v_w245 : BitVec 1 := (v_w244 &&& v_w126)
  -- w246 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:258.8-258.12
  let v_w246 : BitVec 1 := (v_w243 ||| v_w245)
  -- $examples/bird/upstream/sklansky_adder_32.v:259$xor$248$\Y : bitwise_xor
  let v_n332 : BitVec 1 := (v_w234 ^^^ v_w246)
  -- n333 : concat
  let v_n333 : BitVec 28 := (BitVec.append v_n332 v_n316)
  -- n334 : slice
  let v_n334 : BitVec 1 := (BitVec.extractLsb' 28 1 v_a)
  -- n335 : slice
  let v_n335 : BitVec 1 := (BitVec.extractLsb' 28 1 v_b)
  -- w248 : bitwise_xor; src: examples/bird/upstream/sklansky_adder_32.v:260.8-260.12
  let v_w248 : BitVec 1 := (v_n334 ^^^ v_n335)
  -- w249 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:261.8-261.12
  let v_w249 : BitVec 1 := (v_n317 &&& v_n318)
  -- w250 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:262.8-262.12
  let v_w250 : BitVec 1 := (v_w234 &&& v_w240)
  -- w251 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:263.8-263.12
  let v_w251 : BitVec 1 := (v_w249 ||| v_w250)
  -- w252 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:264.8-264.12
  let v_w252 : BitVec 1 := (v_w241 &&& v_w234)
  -- w253 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:265.8-265.12
  let v_w253 : BitVec 1 := (v_w252 &&& v_w199)
  -- w254 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:266.8-266.12
  let v_w254 : BitVec 1 := (v_w251 ||| v_w253)
  -- w255 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:267.8-267.12
  let v_w255 : BitVec 1 := (v_w200 &&& v_w252)
  -- w256 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:268.8-268.12
  let v_w256 : BitVec 1 := (v_w255 &&& v_w126)
  -- w257 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:269.8-269.12
  let v_w257 : BitVec 1 := (v_w254 ||| v_w256)
  -- $examples/bird/upstream/sklansky_adder_32.v:270$xor$259$\Y : bitwise_xor
  let v_n346 : BitVec 1 := (v_w248 ^^^ v_w257)
  -- n347 : concat
  let v_n347 : BitVec 29 := (BitVec.append v_n346 v_n333)
  -- n348 : slice
  let v_n348 : BitVec 1 := (BitVec.extractLsb' 29 1 v_a)
  -- n349 : slice
  let v_n349 : BitVec 1 := (BitVec.extractLsb' 29 1 v_b)
  -- w259 : bitwise_xor; src: examples/bird/upstream/sklansky_adder_32.v:271.8-271.12
  let v_w259 : BitVec 1 := (v_n348 ^^^ v_n349)
  -- w260 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:272.8-272.12
  let v_w260 : BitVec 1 := (v_n334 &&& v_n335)
  -- w261 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:273.8-273.12
  let v_w261 : BitVec 1 := (v_w248 &&& v_w249)
  -- w262 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:274.8-274.12
  let v_w262 : BitVec 1 := (v_w260 ||| v_w261)
  -- w263 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:275.8-275.12
  let v_w263 : BitVec 1 := (v_w234 &&& v_w248)
  -- w264 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:276.8-276.12
  let v_w264 : BitVec 1 := (v_w263 &&& v_w240)
  -- w265 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:277.8-277.12
  let v_w265 : BitVec 1 := (v_w262 ||| v_w264)
  -- w266 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:278.8-278.12
  let v_w266 : BitVec 1 := (v_w241 &&& v_w263)
  -- w267 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:279.8-279.12
  let v_w267 : BitVec 1 := (v_w266 &&& v_w199)
  -- w268 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:280.8-280.12
  let v_w268 : BitVec 1 := (v_w265 ||| v_w267)
  -- w269 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:281.8-281.12
  let v_w269 : BitVec 1 := (v_w200 &&& v_w266)
  -- w270 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:282.8-282.12
  let v_w270 : BitVec 1 := (v_w269 &&& v_w126)
  -- w271 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:283.8-283.12
  let v_w271 : BitVec 1 := (v_w268 ||| v_w270)
  -- $examples/bird/upstream/sklansky_adder_32.v:284$xor$273$\Y : bitwise_xor
  let v_n363 : BitVec 1 := (v_w259 ^^^ v_w271)
  -- n364 : concat
  let v_n364 : BitVec 30 := (BitVec.append v_n363 v_n347)
  -- n365 : slice
  let v_n365 : BitVec 1 := (BitVec.extractLsb' 30 1 v_a)
  -- n366 : slice
  let v_n366 : BitVec 1 := (BitVec.extractLsb' 30 1 v_b)
  -- w273 : bitwise_xor; src: examples/bird/upstream/sklansky_adder_32.v:285.8-285.12
  let v_w273 : BitVec 1 := (v_n365 ^^^ v_n366)
  -- w274 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:286.8-286.12
  let v_w274 : BitVec 1 := (v_n348 &&& v_n349)
  -- w275 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:287.8-287.12
  let v_w275 : BitVec 1 := (v_w259 &&& v_w262)
  -- w276 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:288.8-288.12
  let v_w276 : BitVec 1 := (v_w274 ||| v_w275)
  -- w277 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:289.8-289.12
  let v_w277 : BitVec 1 := (v_w263 &&& v_w259)
  -- w278 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:290.8-290.12
  let v_w278 : BitVec 1 := (v_w277 &&& v_w240)
  -- w279 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:291.8-291.12
  let v_w279 : BitVec 1 := (v_w276 ||| v_w278)
  -- w280 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:292.8-292.12
  let v_w280 : BitVec 1 := (v_w241 &&& v_w277)
  -- w281 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:293.8-293.12
  let v_w281 : BitVec 1 := (v_w280 &&& v_w199)
  -- w282 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:294.8-294.12
  let v_w282 : BitVec 1 := (v_w279 ||| v_w281)
  -- w283 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:295.8-295.12
  let v_w283 : BitVec 1 := (v_w200 &&& v_w280)
  -- w284 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:296.8-296.12
  let v_w284 : BitVec 1 := (v_w283 &&& v_w126)
  -- w285 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:297.8-297.12
  let v_w285 : BitVec 1 := (v_w282 ||| v_w284)
  -- $examples/bird/upstream/sklansky_adder_32.v:298$xor$287$\Y : bitwise_xor
  let v_n380 : BitVec 1 := (v_w273 ^^^ v_w285)
  -- n381 : concat
  let v_n381 : BitVec 31 := (BitVec.append v_n380 v_n364)
  -- n382 : slice
  let v_n382 : BitVec 1 := (BitVec.extractLsb' 31 1 v_a)
  -- n383 : slice
  let v_n383 : BitVec 1 := (BitVec.extractLsb' 31 1 v_b)
  -- w287 : bitwise_xor; src: examples/bird/upstream/sklansky_adder_32.v:299.8-299.12
  let v_w287 : BitVec 1 := (v_n382 ^^^ v_n383)
  -- w288 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:300.8-300.12
  let v_w288 : BitVec 1 := (v_n365 &&& v_n366)
  -- w289 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:301.8-301.12
  let v_w289 : BitVec 1 := (v_w273 &&& v_w274)
  -- w290 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:302.8-302.12
  let v_w290 : BitVec 1 := (v_w288 ||| v_w289)
  -- w291 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:303.8-303.12
  let v_w291 : BitVec 1 := (v_w259 &&& v_w273)
  -- w292 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:304.8-304.12
  let v_w292 : BitVec 1 := (v_w291 &&& v_w262)
  -- w293 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:305.8-305.12
  let v_w293 : BitVec 1 := (v_w290 ||| v_w292)
  -- w294 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:306.8-306.12
  let v_w294 : BitVec 1 := (v_w263 &&& v_w291)
  -- w295 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:307.8-307.12
  let v_w295 : BitVec 1 := (v_w294 &&& v_w240)
  -- w296 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:308.8-308.12
  let v_w296 : BitVec 1 := (v_w293 ||| v_w295)
  -- w297 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:309.8-309.12
  let v_w297 : BitVec 1 := (v_w241 &&& v_w294)
  -- w298 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:310.8-310.12
  let v_w298 : BitVec 1 := (v_w297 &&& v_w199)
  -- w299 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:311.8-311.12
  let v_w299 : BitVec 1 := (v_w296 ||| v_w298)
  -- w300 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:312.8-312.12
  let v_w300 : BitVec 1 := (v_w200 &&& v_w297)
  -- w301 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:313.8-313.12
  let v_w301 : BitVec 1 := (v_w300 &&& v_w126)
  -- w302 : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:314.8-314.12
  let v_w302 : BitVec 1 := (v_w299 ||| v_w301)
  -- $examples/bird/upstream/sklansky_adder_32.v:315$xor$304$\Y : bitwise_xor
  let v_n400 : BitVec 1 := (v_w287 ^^^ v_w302)
  -- sum : concat; src: examples/bird/upstream/sklansky_adder_32.v:9.22-9.25
  let v_sum : BitVec 32 := (BitVec.append v_n400 v_n381)
  -- w304 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:316.8-316.12
  let v_w304 : BitVec 1 := (v_n382 &&& v_n383)
  -- w305 : bitwise_and; src: examples/bird/upstream/sklansky_adder_32.v:317.8-317.12
  let v_w305 : BitVec 1 := (v_w287 &&& v_w302)
  -- cout : bitwise_or; src: examples/bird/upstream/sklansky_adder_32.v:10.22-10.26
  let v_cout : BitVec 1 := (v_w304 ||| v_w305)
  (({
     v_sum := v_sum,
     v_cout := v_cout
   }, {

   }), {
     c0 := v_cin,
     c1 := v_w5,
     c2 := v_w10,
     c3 := v_w18,
     c4 := v_w23,
     c5 := v_w31,
     c6 := v_w39,
     c7 := v_w50,
     c8 := v_w55,
     c9 := v_w63,
     c10 := v_w71,
     c11 := v_w82,
     c12 := v_w90,
     c13 := v_w101,
     c14 := v_w112,
     c15 := v_w126,
     c16 := v_w131,
     c17 := v_w139,
     c18 := v_w147,
     c19 := v_w158,
     c20 := v_w166,
     c21 := v_w177,
     c22 := v_w188,
     c23 := v_w202,
     c24 := v_w210,
     c25 := v_w221,
     c26 := v_w232,
     c27 := v_w246,
     c28 := v_w257,
     c29 := v_w271,
     c30 := v_w285,
     c31 := v_w302,
     c32 := v_cout
   })

theorem projection (i : v_Prefix32.Inputs) (s : v_Prefix32.State) :
    (eval i s).1 = v_Prefix32.eval i s := by rfl

end v_Prefix32Wires
