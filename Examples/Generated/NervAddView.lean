import Examples.Generated.NervAdd

-- Generated named view; do not edit. Types come from the original export.
namespace v_NervAdd.Named
namespace Signals
set_option linter.unusedVariables false

-- cpu.regfile[31] : state
def v_cpu_regfile_31_ (inputs : Inputs) (state : State) : BitVec 32 := state.v_cpu_regfile_31_

-- $auto$setundef.cc:552:execute$2382$\Y : input
def v_n1 (inputs : Inputs) (state : State) : BitVec 32 := inputs.v__auto_setundef_cc_552_execute_2382

-- $auto$setundef.cc:552:execute$2388$\Y : input
def v_n2 (inputs : Inputs) (state : State) : BitVec 32 := inputs.v__auto_setundef_cc_552_execute_2388

-- $const32b00000000000000000000000000000000 : constant
def v_n3 (inputs : Inputs) (state : State) : BitVec 32 := (0b00000000000000000000000000000000 : BitVec 32)

-- $auto$ff.cc:337:slice$1987$\Q : state
def v_n4 (inputs : Inputs) (state : State) : BitVec 32 := state.v_cpu_regfile_0_

-- $auto$ff.cc:337:slice$1988$\Q : state
def v_n5 (inputs : Inputs) (state : State) : BitVec 32 := state.v_cpu_regfile_1_

-- imem_data : input; src: examples/riscv/NervHarness.sv:5.16-5.25
def v_imem_data (inputs : Inputs) (state : State) : BitVec 32 := inputs.v_imem_data

-- n7 : slice
def v_n7 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 15 1 (v_imem_data inputs state))

-- $memory\cpu.regfile$rdmux[1][4][0]$1695$\Y : mux
def v_n8 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n7 inputs state) == 1 then (v_n5 inputs state) else (v_n4 inputs state))

-- $auto$ff.cc:337:slice$1989$\Q : state
def v_n9 (inputs : Inputs) (state : State) : BitVec 32 := state.v_cpu_regfile_2_

-- $auto$ff.cc:337:slice$1990$\Q : state
def v_n10 (inputs : Inputs) (state : State) : BitVec 32 := state.v_cpu_regfile_3_

-- $memory\cpu.regfile$rdmux[1][4][1]$1698$\Y : mux
def v_n11 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n7 inputs state) == 1 then (v_n10 inputs state) else (v_n9 inputs state))

-- n12 : slice
def v_n12 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 16 1 (v_imem_data inputs state))

-- $memory\cpu.regfile$rdmux[1][3][0]$1671$\Y : mux
def v_n13 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n12 inputs state) == 1 then (v_n11 inputs state) else (v_n8 inputs state))

-- $auto$ff.cc:337:slice$1991$\Q : state
def v_n14 (inputs : Inputs) (state : State) : BitVec 32 := state.v_cpu_regfile_4_

-- $auto$ff.cc:337:slice$1992$\Q : state
def v_n15 (inputs : Inputs) (state : State) : BitVec 32 := state.v_cpu_regfile_5_

-- $memory\cpu.regfile$rdmux[1][4][2]$1701$\Y : mux
def v_n16 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n7 inputs state) == 1 then (v_n15 inputs state) else (v_n14 inputs state))

-- $auto$ff.cc:337:slice$1993$\Q : state
def v_n17 (inputs : Inputs) (state : State) : BitVec 32 := state.v_cpu_regfile_6_

-- $auto$ff.cc:337:slice$1994$\Q : state
def v_n18 (inputs : Inputs) (state : State) : BitVec 32 := state.v_cpu_regfile_7_

-- $memory\cpu.regfile$rdmux[1][4][3]$1704$\Y : mux
def v_n19 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n7 inputs state) == 1 then (v_n18 inputs state) else (v_n17 inputs state))

-- $memory\cpu.regfile$rdmux[1][3][1]$1674$\Y : mux
def v_n20 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n12 inputs state) == 1 then (v_n19 inputs state) else (v_n16 inputs state))

-- n21 : slice
def v_n21 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 17 1 (v_imem_data inputs state))

-- $memory\cpu.regfile$rdmux[1][2][0]$1659$\Y : mux
def v_n22 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n21 inputs state) == 1 then (v_n20 inputs state) else (v_n13 inputs state))

-- $auto$ff.cc:337:slice$1995$\Q : state
def v_n23 (inputs : Inputs) (state : State) : BitVec 32 := state.v_cpu_regfile_8_

-- $auto$ff.cc:337:slice$1996$\Q : state
def v_n24 (inputs : Inputs) (state : State) : BitVec 32 := state.v_cpu_regfile_9_

-- $memory\cpu.regfile$rdmux[1][4][4]$1707$\Y : mux
def v_n25 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n7 inputs state) == 1 then (v_n24 inputs state) else (v_n23 inputs state))

-- $auto$ff.cc:337:slice$1997$\Q : state
def v_n26 (inputs : Inputs) (state : State) : BitVec 32 := state.v_cpu_regfile_10_

-- $auto$ff.cc:337:slice$1998$\Q : state
def v_n27 (inputs : Inputs) (state : State) : BitVec 32 := state.v_cpu_regfile_11_

-- $memory\cpu.regfile$rdmux[1][4][5]$1710$\Y : mux
def v_n28 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n7 inputs state) == 1 then (v_n27 inputs state) else (v_n26 inputs state))

-- $memory\cpu.regfile$rdmux[1][3][2]$1677$\Y : mux
def v_n29 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n12 inputs state) == 1 then (v_n28 inputs state) else (v_n25 inputs state))

-- $auto$ff.cc:337:slice$1999$\Q : state
def v_n30 (inputs : Inputs) (state : State) : BitVec 32 := state.v_cpu_regfile_12_

-- $auto$ff.cc:337:slice$2000$\Q : state
def v_n31 (inputs : Inputs) (state : State) : BitVec 32 := state.v_cpu_regfile_13_

-- $memory\cpu.regfile$rdmux[1][4][6]$1713$\Y : mux
def v_n32 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n7 inputs state) == 1 then (v_n31 inputs state) else (v_n30 inputs state))

-- $auto$ff.cc:337:slice$2001$\Q : state
def v_n33 (inputs : Inputs) (state : State) : BitVec 32 := state.v_cpu_regfile_14_

-- $auto$ff.cc:337:slice$2002$\Q : state
def v_n34 (inputs : Inputs) (state : State) : BitVec 32 := state.v_cpu_regfile_15_

-- $memory\cpu.regfile$rdmux[1][4][7]$1716$\Y : mux
def v_n35 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n7 inputs state) == 1 then (v_n34 inputs state) else (v_n33 inputs state))

-- $memory\cpu.regfile$rdmux[1][3][3]$1680$\Y : mux
def v_n36 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n12 inputs state) == 1 then (v_n35 inputs state) else (v_n32 inputs state))

-- $memory\cpu.regfile$rdmux[1][2][1]$1662$\Y : mux
def v_n37 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n21 inputs state) == 1 then (v_n36 inputs state) else (v_n29 inputs state))

-- n38 : slice
def v_n38 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 18 1 (v_imem_data inputs state))

-- $memory\cpu.regfile$rdmux[1][1][0]$1653$\Y : mux
def v_n39 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n38 inputs state) == 1 then (v_n37 inputs state) else (v_n22 inputs state))

-- $auto$ff.cc:337:slice$2003$\Q : state
def v_n40 (inputs : Inputs) (state : State) : BitVec 32 := state.v_cpu_regfile_16_

-- $auto$ff.cc:337:slice$2004$\Q : state
def v_n41 (inputs : Inputs) (state : State) : BitVec 32 := state.v_cpu_regfile_17_

-- $memory\cpu.regfile$rdmux[1][4][8]$1719$\Y : mux
def v_n42 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n7 inputs state) == 1 then (v_n41 inputs state) else (v_n40 inputs state))

-- $auto$ff.cc:337:slice$2005$\Q : state
def v_n43 (inputs : Inputs) (state : State) : BitVec 32 := state.v_cpu_regfile_18_

-- $auto$ff.cc:337:slice$2006$\Q : state
def v_n44 (inputs : Inputs) (state : State) : BitVec 32 := state.v_cpu_regfile_19_

-- $memory\cpu.regfile$rdmux[1][4][9]$1722$\Y : mux
def v_n45 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n7 inputs state) == 1 then (v_n44 inputs state) else (v_n43 inputs state))

-- $memory\cpu.regfile$rdmux[1][3][4]$1683$\Y : mux
def v_n46 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n12 inputs state) == 1 then (v_n45 inputs state) else (v_n42 inputs state))

-- $auto$ff.cc:337:slice$2007$\Q : state
def v_n47 (inputs : Inputs) (state : State) : BitVec 32 := state.v_cpu_regfile_20_

-- $auto$ff.cc:337:slice$2008$\Q : state
def v_n48 (inputs : Inputs) (state : State) : BitVec 32 := state.v_cpu_regfile_21_

-- $memory\cpu.regfile$rdmux[1][4][10]$1725$\Y : mux
def v_n49 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n7 inputs state) == 1 then (v_n48 inputs state) else (v_n47 inputs state))

-- $auto$ff.cc:337:slice$2009$\Q : state
def v_n50 (inputs : Inputs) (state : State) : BitVec 32 := state.v_cpu_regfile_22_

-- $auto$ff.cc:337:slice$2010$\Q : state
def v_n51 (inputs : Inputs) (state : State) : BitVec 32 := state.v_cpu_regfile_23_

-- $memory\cpu.regfile$rdmux[1][4][11]$1728$\Y : mux
def v_n52 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n7 inputs state) == 1 then (v_n51 inputs state) else (v_n50 inputs state))

-- $memory\cpu.regfile$rdmux[1][3][5]$1686$\Y : mux
def v_n53 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n12 inputs state) == 1 then (v_n52 inputs state) else (v_n49 inputs state))

-- $memory\cpu.regfile$rdmux[1][2][2]$1665$\Y : mux
def v_n54 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n21 inputs state) == 1 then (v_n53 inputs state) else (v_n46 inputs state))

-- $auto$ff.cc:337:slice$2011$\Q : state
def v_n55 (inputs : Inputs) (state : State) : BitVec 32 := state.v_cpu_regfile_24_

-- $auto$ff.cc:337:slice$2012$\Q : state
def v_n56 (inputs : Inputs) (state : State) : BitVec 32 := state.v_cpu_regfile_25_

-- $memory\cpu.regfile$rdmux[1][4][12]$1731$\Y : mux
def v_n57 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n7 inputs state) == 1 then (v_n56 inputs state) else (v_n55 inputs state))

-- $auto$ff.cc:337:slice$2013$\Q : state
def v_n58 (inputs : Inputs) (state : State) : BitVec 32 := state.v_cpu_regfile_26_

-- $auto$ff.cc:337:slice$2014$\Q : state
def v_n59 (inputs : Inputs) (state : State) : BitVec 32 := state.v_cpu_regfile_27_

-- $memory\cpu.regfile$rdmux[1][4][13]$1734$\Y : mux
def v_n60 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n7 inputs state) == 1 then (v_n59 inputs state) else (v_n58 inputs state))

-- $memory\cpu.regfile$rdmux[1][3][6]$1689$\Y : mux
def v_n61 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n12 inputs state) == 1 then (v_n60 inputs state) else (v_n57 inputs state))

-- $auto$ff.cc:337:slice$2015$\Q : state
def v_n62 (inputs : Inputs) (state : State) : BitVec 32 := state.v_cpu_regfile_28_

-- $auto$ff.cc:337:slice$2016$\Q : state
def v_n63 (inputs : Inputs) (state : State) : BitVec 32 := state.v_cpu_regfile_29_

-- $memory\cpu.regfile$rdmux[1][4][14]$1737$\Y : mux
def v_n64 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n7 inputs state) == 1 then (v_n63 inputs state) else (v_n62 inputs state))

-- $auto$ff.cc:337:slice$2017$\Q : state
def v_n65 (inputs : Inputs) (state : State) : BitVec 32 := state.v_cpu_regfile_30_

-- $memory\cpu.regfile$rdmux[1][4][15]$1740$\Y : mux
def v_n66 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n7 inputs state) == 1 then (v_cpu_regfile_31_ inputs state) else (v_n65 inputs state))

-- $memory\cpu.regfile$rdmux[1][3][7]$1692$\Y : mux
def v_n67 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n12 inputs state) == 1 then (v_n66 inputs state) else (v_n64 inputs state))

-- $memory\cpu.regfile$rdmux[1][2][3]$1668$\Y : mux
def v_n68 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n21 inputs state) == 1 then (v_n67 inputs state) else (v_n61 inputs state))

-- $memory\cpu.regfile$rdmux[1][1][1]$1656$\Y : mux
def v_n69 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n38 inputs state) == 1 then (v_n68 inputs state) else (v_n54 inputs state))

-- n70 : slice
def v_n70 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 19 1 (v_imem_data inputs state))

-- $memory\cpu.regfile$rdmux[1][0][0]$1650$\Y : mux
def v_n71 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n70 inputs state) == 1 then (v_n69 inputs state) else (v_n39 inputs state))

-- n72 : slice
def v_n72 (inputs : Inputs) (state : State) : BitVec 5 := (BitVec.extractLsb' 15 5 (v_imem_data inputs state))

-- n73 : reduce_or
def v_n73 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n72 inputs state) != 0))

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:114$logic_not$14$\Y : bitwise_not
def v_n74 (inputs : Inputs) (state : State) : BitVec 1 := (~~~(v_n73 inputs state))

-- cpu.rs1_value : mux; src: examples/riscv/upstream/nerv/nerv.sv:114.14-114.23
def v_cpu_rs1_value (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n74 inputs state) == 1 then (v_n3 inputs state) else (v_n71 inputs state))

-- n76 : slice
def v_n76 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 20 1 (v_imem_data inputs state))

-- $memory\cpu.regfile$rdmux[0][4][0]$1602$\Y : mux
def v_n77 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n76 inputs state) == 1 then (v_n5 inputs state) else (v_n4 inputs state))

-- $memory\cpu.regfile$rdmux[0][4][1]$1605$\Y : mux
def v_n78 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n76 inputs state) == 1 then (v_n10 inputs state) else (v_n9 inputs state))

-- n79 : slice
def v_n79 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 21 1 (v_imem_data inputs state))

-- $memory\cpu.regfile$rdmux[0][3][0]$1578$\Y : mux
def v_n80 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n79 inputs state) == 1 then (v_n78 inputs state) else (v_n77 inputs state))

-- $memory\cpu.regfile$rdmux[0][4][2]$1608$\Y : mux
def v_n81 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n76 inputs state) == 1 then (v_n15 inputs state) else (v_n14 inputs state))

-- $memory\cpu.regfile$rdmux[0][4][3]$1611$\Y : mux
def v_n82 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n76 inputs state) == 1 then (v_n18 inputs state) else (v_n17 inputs state))

-- $memory\cpu.regfile$rdmux[0][3][1]$1581$\Y : mux
def v_n83 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n79 inputs state) == 1 then (v_n82 inputs state) else (v_n81 inputs state))

-- n84 : slice
def v_n84 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 22 1 (v_imem_data inputs state))

-- $memory\cpu.regfile$rdmux[0][2][0]$1566$\Y : mux
def v_n85 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n84 inputs state) == 1 then (v_n83 inputs state) else (v_n80 inputs state))

-- $memory\cpu.regfile$rdmux[0][4][4]$1614$\Y : mux
def v_n86 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n76 inputs state) == 1 then (v_n24 inputs state) else (v_n23 inputs state))

-- $memory\cpu.regfile$rdmux[0][4][5]$1617$\Y : mux
def v_n87 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n76 inputs state) == 1 then (v_n27 inputs state) else (v_n26 inputs state))

-- $memory\cpu.regfile$rdmux[0][3][2]$1584$\Y : mux
def v_n88 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n79 inputs state) == 1 then (v_n87 inputs state) else (v_n86 inputs state))

-- $memory\cpu.regfile$rdmux[0][4][6]$1620$\Y : mux
def v_n89 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n76 inputs state) == 1 then (v_n31 inputs state) else (v_n30 inputs state))

-- $memory\cpu.regfile$rdmux[0][4][7]$1623$\Y : mux
def v_n90 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n76 inputs state) == 1 then (v_n34 inputs state) else (v_n33 inputs state))

-- $memory\cpu.regfile$rdmux[0][3][3]$1587$\Y : mux
def v_n91 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n79 inputs state) == 1 then (v_n90 inputs state) else (v_n89 inputs state))

-- $memory\cpu.regfile$rdmux[0][2][1]$1569$\Y : mux
def v_n92 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n84 inputs state) == 1 then (v_n91 inputs state) else (v_n88 inputs state))

-- n93 : slice
def v_n93 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 23 1 (v_imem_data inputs state))

-- $memory\cpu.regfile$rdmux[0][1][0]$1560$\Y : mux
def v_n94 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n93 inputs state) == 1 then (v_n92 inputs state) else (v_n85 inputs state))

-- $memory\cpu.regfile$rdmux[0][4][8]$1626$\Y : mux
def v_n95 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n76 inputs state) == 1 then (v_n41 inputs state) else (v_n40 inputs state))

-- $memory\cpu.regfile$rdmux[0][4][9]$1629$\Y : mux
def v_n96 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n76 inputs state) == 1 then (v_n44 inputs state) else (v_n43 inputs state))

-- $memory\cpu.regfile$rdmux[0][3][4]$1590$\Y : mux
def v_n97 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n79 inputs state) == 1 then (v_n96 inputs state) else (v_n95 inputs state))

-- $memory\cpu.regfile$rdmux[0][4][10]$1632$\Y : mux
def v_n98 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n76 inputs state) == 1 then (v_n48 inputs state) else (v_n47 inputs state))

-- $memory\cpu.regfile$rdmux[0][4][11]$1635$\Y : mux
def v_n99 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n76 inputs state) == 1 then (v_n51 inputs state) else (v_n50 inputs state))

-- $memory\cpu.regfile$rdmux[0][3][5]$1593$\Y : mux
def v_n100 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n79 inputs state) == 1 then (v_n99 inputs state) else (v_n98 inputs state))

-- $memory\cpu.regfile$rdmux[0][2][2]$1572$\Y : mux
def v_n101 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n84 inputs state) == 1 then (v_n100 inputs state) else (v_n97 inputs state))

-- $memory\cpu.regfile$rdmux[0][4][12]$1638$\Y : mux
def v_n102 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n76 inputs state) == 1 then (v_n56 inputs state) else (v_n55 inputs state))

-- $memory\cpu.regfile$rdmux[0][4][13]$1641$\Y : mux
def v_n103 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n76 inputs state) == 1 then (v_n59 inputs state) else (v_n58 inputs state))

-- $memory\cpu.regfile$rdmux[0][3][6]$1596$\Y : mux
def v_n104 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n79 inputs state) == 1 then (v_n103 inputs state) else (v_n102 inputs state))

-- $memory\cpu.regfile$rdmux[0][4][14]$1644$\Y : mux
def v_n105 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n76 inputs state) == 1 then (v_n63 inputs state) else (v_n62 inputs state))

-- $memory\cpu.regfile$rdmux[0][4][15]$1647$\Y : mux
def v_n106 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n76 inputs state) == 1 then (v_cpu_regfile_31_ inputs state) else (v_n65 inputs state))

-- $memory\cpu.regfile$rdmux[0][3][7]$1599$\Y : mux
def v_n107 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n79 inputs state) == 1 then (v_n106 inputs state) else (v_n105 inputs state))

-- $memory\cpu.regfile$rdmux[0][2][3]$1575$\Y : mux
def v_n108 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n84 inputs state) == 1 then (v_n107 inputs state) else (v_n104 inputs state))

-- $memory\cpu.regfile$rdmux[0][1][1]$1563$\Y : mux
def v_n109 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n93 inputs state) == 1 then (v_n108 inputs state) else (v_n101 inputs state))

-- n110 : slice
def v_n110 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 24 1 (v_imem_data inputs state))

-- $memory\cpu.regfile$rdmux[0][0][0]$1557$\Y : mux
def v_n111 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n110 inputs state) == 1 then (v_n109 inputs state) else (v_n94 inputs state))

-- n112 : slice
def v_n112 (inputs : Inputs) (state : State) : BitVec 5 := (BitVec.extractLsb' 20 5 (v_imem_data inputs state))

-- n113 : reduce_or
def v_n113 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n112 inputs state) != 0))

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:115$logic_not$17$\Y : bitwise_not
def v_n114 (inputs : Inputs) (state : State) : BitVec 1 := (~~~(v_n113 inputs state))

-- cpu.rs2_value : mux; src: examples/riscv/upstream/nerv/nerv.sv:115.14-115.23
def v_cpu_rs2_value (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n114 inputs state) == 1 then (v_n3 inputs state) else (v_n111 inputs state))

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:326$add$63_Y : add; src: examples/riscv/upstream/nerv/nerv.sv:326.64-326.85
def v_n116 (inputs : Inputs) (state : State) : BitVec 32 := ((v_cpu_rs1_value inputs state) + (v_cpu_rs2_value inputs state))

-- n117 : slice
def v_n117 (inputs : Inputs) (state : State) : BitVec 5 := (BitVec.extractLsb' 0 5 (v_cpu_rs2_value inputs state))

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:328$shl$65_Y : logical_shift_left; src: examples/riscv/upstream/nerv/nerv.sv:328.64-328.91
def v_n118 (inputs : Inputs) (state : State) : BitVec 32 := ((v_cpu_rs1_value inputs state) <<< (v_n117 inputs state).toNat)

-- n119 : concat
def v_n119 (inputs : Inputs) (state : State) : BitVec 64 := (BitVec.append (v_n118 inputs state) (v_n116 inputs state))

-- n120 : signed_greater_than
def v_n120 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool (BitVec.slt (v_cpu_rs1_value inputs state) (v_cpu_rs2_value inputs state)))

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:329$lt$66_Y : zero_extend; src: examples/riscv/upstream/nerv/nerv.sv:329.64-329.103
def v_n121 (inputs : Inputs) (state : State) : BitVec 32 := (BitVec.setWidth 32 (v_n120 inputs state))

-- n122 : concat
def v_n122 (inputs : Inputs) (state : State) : BitVec 96 := (BitVec.append (v_n121 inputs state) (v_n119 inputs state))

-- n123 : unsigned_greater_than
def v_n123 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool (BitVec.ult (v_cpu_rs1_value inputs state) (v_cpu_rs2_value inputs state)))

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:330$lt$67_Y : zero_extend; src: examples/riscv/upstream/nerv/nerv.sv:330.64-330.85
def v_n124 (inputs : Inputs) (state : State) : BitVec 32 := (BitVec.setWidth 32 (v_n123 inputs state))

-- n125 : concat
def v_n125 (inputs : Inputs) (state : State) : BitVec 128 := (BitVec.append (v_n124 inputs state) (v_n122 inputs state))

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:331$xor$68_Y : bitwise_xor; src: examples/riscv/upstream/nerv/nerv.sv:331.64-331.85
def v_n126 (inputs : Inputs) (state : State) : BitVec 32 := ((v_cpu_rs1_value inputs state) ^^^ (v_cpu_rs2_value inputs state))

-- n127 : concat
def v_n127 (inputs : Inputs) (state : State) : BitVec 160 := (BitVec.append (v_n126 inputs state) (v_n125 inputs state))

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:332$shr$69_Y : logical_shift_right; src: examples/riscv/upstream/nerv/nerv.sv:332.64-332.91
def v_n128 (inputs : Inputs) (state : State) : BitVec 32 := ((v_cpu_rs1_value inputs state) >>> (v_n117 inputs state).toNat)

-- n129 : concat
def v_n129 (inputs : Inputs) (state : State) : BitVec 192 := (BitVec.append (v_n128 inputs state) (v_n127 inputs state))

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:334$or$71_Y : bitwise_or; src: examples/riscv/upstream/nerv/nerv.sv:334.64-334.85
def v_n130 (inputs : Inputs) (state : State) : BitVec 32 := ((v_cpu_rs1_value inputs state) ||| (v_cpu_rs2_value inputs state))

-- n131 : concat
def v_n131 (inputs : Inputs) (state : State) : BitVec 224 := (BitVec.append (v_n130 inputs state) (v_n129 inputs state))

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:335$and$72_Y : bitwise_and; src: examples/riscv/upstream/nerv/nerv.sv:335.64-335.85
def v_n132 (inputs : Inputs) (state : State) : BitVec 32 := ((v_cpu_rs1_value inputs state) &&& (v_cpu_rs2_value inputs state))

-- n133 : concat
def v_n133 (inputs : Inputs) (state : State) : BitVec 256 := (BitVec.append (v_n132 inputs state) (v_n131 inputs state))

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:327$sub$64_Y : sub; src: examples/riscv/upstream/nerv/nerv.sv:327.64-327.85
def v_n134 (inputs : Inputs) (state : State) : BitVec 32 := ((v_cpu_rs1_value inputs state) - (v_cpu_rs2_value inputs state))

-- n135 : concat
def v_n135 (inputs : Inputs) (state : State) : BitVec 288 := (BitVec.append (v_n134 inputs state) (v_n133 inputs state))

-- $auto$setundef.cc:552:execute$2374$\Y : input
def v_n136 (inputs : Inputs) (state : State) : BitVec 128 := inputs.v__auto_setundef_cc_552_execute_2374

-- n137 : concat
def v_n137 (inputs : Inputs) (state : State) : BitVec 416 := (BitVec.append (v_n136 inputs state) (v_n135 inputs state))

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:333$sshr$70_Y : arithmetic_shift_right; src: examples/riscv/upstream/nerv/nerv.sv:333.64-333.101
def v_n138 (inputs : Inputs) (state : State) : BitVec 32 := (BitVec.sshiftRight (v_cpu_rs1_value inputs state) (v_n117 inputs state).toNat)

-- n139 : concat
def v_n139 (inputs : Inputs) (state : State) : BitVec 448 := (BitVec.append (v_n138 inputs state) (v_n137 inputs state))

-- $const5b00000 : constant
def v_n140 (inputs : Inputs) (state : State) : BitVec 5 := (0b00000 : BitVec 5)

-- n141 : slice
def v_n141 (inputs : Inputs) (state : State) : BitVec 3 := (BitVec.extractLsb' 12 3 (v_imem_data inputs state))

-- n142 : concat
def v_n142 (inputs : Inputs) (state : State) : BitVec 8 := (BitVec.append (v_n141 inputs state) (v_n140 inputs state))

-- n143 : slice
def v_n143 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 30 1 (v_imem_data inputs state))

-- n144 : concat
def v_n144 (inputs : Inputs) (state : State) : BitVec 9 := (BitVec.append (v_n143 inputs state) (v_n142 inputs state))

-- n145 : slice
def v_n145 (inputs : Inputs) (state : State) : BitVec 5 := (BitVec.extractLsb' 25 5 (v_imem_data inputs state))

-- n146 : concat
def v_n146 (inputs : Inputs) (state : State) : BitVec 14 := (BitVec.append (v_n145 inputs state) (v_n144 inputs state))

-- n147 : slice
def v_n147 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 31 1 (v_imem_data inputs state))

-- n148 : concat
def v_n148 (inputs : Inputs) (state : State) : BitVec 15 := (BitVec.append (v_n147 inputs state) (v_n146 inputs state))

-- n149 : slice
def v_n149 (inputs : Inputs) (state : State) : BitVec 9 := (BitVec.extractLsb' 0 9 (v_n148 inputs state))

-- n150 : logical_shift_right
def v_n150 (inputs : Inputs) (state : State) : BitVec 448 := ((v_n139 inputs state) >>> (v_n149 inputs state).toNat)

-- n151 : constant
def v_n151 (inputs : Inputs) (state : State) : BitVec 448 := (0b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000 : BitVec 448)

-- n152 : constant
def v_n152 (inputs : Inputs) (state : State) : BitVec 15 := (0b000000111000000 : BitVec 15)

-- n153 : unsigned_greater_equal
def v_n153 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool (BitVec.ule (v_n152 inputs state) (v_n148 inputs state)))

-- n154 : mux
def v_n154 (inputs : Inputs) (state : State) : BitVec 448 := (if (v_n153 inputs state) == 1 then (v_n151 inputs state) else (v_n150 inputs state))

-- $auto$pmux2shiftx.cc:714:execute$2347$\Y : slice
def v_n155 (inputs : Inputs) (state : State) : BitVec 32 := (BitVec.extractLsb' 0 32 (v_n154 inputs state))

-- $const14b10000111111111 : constant
def v_n156 (inputs : Inputs) (state : State) : BitVec 14 := (0b10000111111111 : BitVec 14)

-- n157 : concat
def v_n157 (inputs : Inputs) (state : State) : BitVec 4 := (BitVec.append (v_n143 inputs state) (v_n141 inputs state))

-- n158 : concat
def v_n158 (inputs : Inputs) (state : State) : BitVec 9 := (BitVec.append (v_n145 inputs state) (v_n157 inputs state))

-- n159 : concat
def v_n159 (inputs : Inputs) (state : State) : BitVec 10 := (BitVec.append (v_n147 inputs state) (v_n158 inputs state))

-- n160 : slice
def v_n160 (inputs : Inputs) (state : State) : BitVec 4 := (BitVec.extractLsb' 0 4 (v_n159 inputs state))

-- n161 : logical_shift_right
def v_n161 (inputs : Inputs) (state : State) : BitVec 14 := ((v_n156 inputs state) >>> (v_n160 inputs state).toNat)

-- n162 : constant
def v_n162 (inputs : Inputs) (state : State) : BitVec 14 := (0b00000000000000 : BitVec 14)

-- n163 : constant
def v_n163 (inputs : Inputs) (state : State) : BitVec 10 := (0b0000001110 : BitVec 10)

-- n164 : unsigned_greater_equal
def v_n164 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool (BitVec.ule (v_n163 inputs state) (v_n159 inputs state)))

-- n165 : mux
def v_n165 (inputs : Inputs) (state : State) : BitVec 14 := (if (v_n164 inputs state) == 1 then (v_n162 inputs state) else (v_n161 inputs state))

-- $auto$pmux2shiftx.cc:694:execute$2345$\Y : slice
def v_n166 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 0 1 (v_n165 inputs state))

-- $flatten\cpu.$procmux$811$\Y : mux
def v_n167 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n166 inputs state) == 1 then (v_n155 inputs state) else (v_n3 inputs state))

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:316$shl$60_Y : logical_shift_left; src: examples/riscv/upstream/nerv/nerv.sv:316.65-316.89
def v_n168 (inputs : Inputs) (state : State) : BitVec 32 := ((v_cpu_rs1_value inputs state) <<< (v_n112 inputs state).toNat)

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:317$shr$61_Y : logical_shift_right; src: examples/riscv/upstream/nerv/nerv.sv:317.65-317.89
def v_n169 (inputs : Inputs) (state : State) : BitVec 32 := ((v_cpu_rs1_value inputs state) >>> (v_n112 inputs state).toNat)

-- n170 : concat
def v_n170 (inputs : Inputs) (state : State) : BitVec 64 := (BitVec.append (v_n169 inputs state) (v_n168 inputs state))

-- $auto$setundef.cc:552:execute$2372$\Y : input
def v_n171 (inputs : Inputs) (state : State) : BitVec 32 := inputs.v__auto_setundef_cc_552_execute_2372

-- n172 : concat
def v_n172 (inputs : Inputs) (state : State) : BitVec 96 := (BitVec.append (v_n171 inputs state) (v_n170 inputs state))

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:318$sshr$62_Y : arithmetic_shift_right; src: examples/riscv/upstream/nerv/nerv.sv:318.65-318.99
def v_n173 (inputs : Inputs) (state : State) : BitVec 32 := (BitVec.sshiftRight (v_cpu_rs1_value inputs state) (v_n112 inputs state).toNat)

-- n174 : concat
def v_n174 (inputs : Inputs) (state : State) : BitVec 128 := (BitVec.append (v_n173 inputs state) (v_n172 inputs state))

-- n175 : slice
def v_n175 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 14 1 (v_imem_data inputs state))

-- n176 : concat
def v_n176 (inputs : Inputs) (state : State) : BitVec 6 := (BitVec.append (v_n175 inputs state) (v_n140 inputs state))

-- n177 : concat
def v_n177 (inputs : Inputs) (state : State) : BitVec 7 := (BitVec.append (v_n143 inputs state) (v_n176 inputs state))

-- n178 : slice
def v_n178 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 12 1 (v_imem_data inputs state))

-- $auto$rtlil.cc:3203:Not$2369 : bitwise_not
def v_n179 (inputs : Inputs) (state : State) : BitVec 1 := (~~~(v_n178 inputs state))

-- n180 : concat
def v_n180 (inputs : Inputs) (state : State) : BitVec 8 := (BitVec.append (v_n179 inputs state) (v_n177 inputs state))

-- n181 : slice
def v_n181 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 13 1 (v_imem_data inputs state))

-- n182 : concat
def v_n182 (inputs : Inputs) (state : State) : BitVec 9 := (BitVec.append (v_n181 inputs state) (v_n180 inputs state))

-- n183 : concat
def v_n183 (inputs : Inputs) (state : State) : BitVec 14 := (BitVec.append (v_n145 inputs state) (v_n182 inputs state))

-- n184 : concat
def v_n184 (inputs : Inputs) (state : State) : BitVec 15 := (BitVec.append (v_n147 inputs state) (v_n183 inputs state))

-- n185 : slice
def v_n185 (inputs : Inputs) (state : State) : BitVec 7 := (BitVec.extractLsb' 0 7 (v_n184 inputs state))

-- n186 : logical_shift_right
def v_n186 (inputs : Inputs) (state : State) : BitVec 128 := ((v_n174 inputs state) >>> (v_n185 inputs state).toNat)

-- n187 : constant
def v_n187 (inputs : Inputs) (state : State) : BitVec 128 := (0b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000 : BitVec 128)

-- n188 : constant
def v_n188 (inputs : Inputs) (state : State) : BitVec 15 := (0b000000010000000 : BitVec 15)

-- n189 : unsigned_greater_equal
def v_n189 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool (BitVec.ule (v_n188 inputs state) (v_n184 inputs state)))

-- n190 : mux
def v_n190 (inputs : Inputs) (state : State) : BitVec 128 := (if (v_n189 inputs state) == 1 then (v_n187 inputs state) else (v_n186 inputs state))

-- $auto$pmux2shiftx.cc:714:execute$2353$\Y : slice
def v_n191 (inputs : Inputs) (state : State) : BitVec 32 := (BitVec.extractLsb' 0 32 (v_n190 inputs state))

-- n192 : slice
def v_n192 (inputs : Inputs) (state : State) : BitVec 12 := (BitVec.extractLsb' 20 12 (v_imem_data inputs state))

-- n193 : concat
def v_n193 (inputs : Inputs) (state : State) : BitVec 13 := (BitVec.append (v_n147 inputs state) (v_n192 inputs state))

-- n194 : concat
def v_n194 (inputs : Inputs) (state : State) : BitVec 14 := (BitVec.append (v_n147 inputs state) (v_n193 inputs state))

-- n195 : concat
def v_n195 (inputs : Inputs) (state : State) : BitVec 15 := (BitVec.append (v_n147 inputs state) (v_n194 inputs state))

-- n196 : concat
def v_n196 (inputs : Inputs) (state : State) : BitVec 16 := (BitVec.append (v_n147 inputs state) (v_n195 inputs state))

-- n197 : concat
def v_n197 (inputs : Inputs) (state : State) : BitVec 17 := (BitVec.append (v_n147 inputs state) (v_n196 inputs state))

-- n198 : concat
def v_n198 (inputs : Inputs) (state : State) : BitVec 18 := (BitVec.append (v_n147 inputs state) (v_n197 inputs state))

-- n199 : concat
def v_n199 (inputs : Inputs) (state : State) : BitVec 19 := (BitVec.append (v_n147 inputs state) (v_n198 inputs state))

-- n200 : concat
def v_n200 (inputs : Inputs) (state : State) : BitVec 20 := (BitVec.append (v_n147 inputs state) (v_n199 inputs state))

-- n201 : concat
def v_n201 (inputs : Inputs) (state : State) : BitVec 21 := (BitVec.append (v_n147 inputs state) (v_n200 inputs state))

-- n202 : concat
def v_n202 (inputs : Inputs) (state : State) : BitVec 22 := (BitVec.append (v_n147 inputs state) (v_n201 inputs state))

-- n203 : concat
def v_n203 (inputs : Inputs) (state : State) : BitVec 23 := (BitVec.append (v_n147 inputs state) (v_n202 inputs state))

-- n204 : concat
def v_n204 (inputs : Inputs) (state : State) : BitVec 24 := (BitVec.append (v_n147 inputs state) (v_n203 inputs state))

-- n205 : concat
def v_n205 (inputs : Inputs) (state : State) : BitVec 25 := (BitVec.append (v_n147 inputs state) (v_n204 inputs state))

-- n206 : concat
def v_n206 (inputs : Inputs) (state : State) : BitVec 26 := (BitVec.append (v_n147 inputs state) (v_n205 inputs state))

-- n207 : concat
def v_n207 (inputs : Inputs) (state : State) : BitVec 27 := (BitVec.append (v_n147 inputs state) (v_n206 inputs state))

-- n208 : concat
def v_n208 (inputs : Inputs) (state : State) : BitVec 28 := (BitVec.append (v_n147 inputs state) (v_n207 inputs state))

-- n209 : concat
def v_n209 (inputs : Inputs) (state : State) : BitVec 29 := (BitVec.append (v_n147 inputs state) (v_n208 inputs state))

-- n210 : concat
def v_n210 (inputs : Inputs) (state : State) : BitVec 30 := (BitVec.append (v_n147 inputs state) (v_n209 inputs state))

-- n211 : concat
def v_n211 (inputs : Inputs) (state : State) : BitVec 31 := (BitVec.append (v_n147 inputs state) (v_n210 inputs state))

-- n212 : concat
def v_n212 (inputs : Inputs) (state : State) : BitVec 32 := (BitVec.append (v_n147 inputs state) (v_n211 inputs state))

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:242$add$29_Y : add; src: examples/riscv/upstream/nerv/nerv.sv:242.14-242.36
def v_n213 (inputs : Inputs) (state : State) : BitVec 32 := ((v_cpu_rs1_value inputs state) + (v_n212 inputs state))

-- $auto$setundef.cc:552:execute$2406$\Y : input
def v_n214 (inputs : Inputs) (state : State) : BitVec 32 := inputs.v__auto_setundef_cc_552_execute_2406

-- n215 : concat
def v_n215 (inputs : Inputs) (state : State) : BitVec 64 := (BitVec.append (v_n214 inputs state) (v_n213 inputs state))

-- n216 : signed_greater_than
def v_n216 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool (BitVec.slt (v_cpu_rs1_value inputs state) (v_n212 inputs state)))

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:311$lt$55_Y : zero_extend; src: examples/riscv/upstream/nerv/nerv.sv:311.65-311.105
def v_n217 (inputs : Inputs) (state : State) : BitVec 32 := (BitVec.setWidth 32 (v_n216 inputs state))

-- n218 : concat
def v_n218 (inputs : Inputs) (state : State) : BitVec 96 := (BitVec.append (v_n217 inputs state) (v_n215 inputs state))

-- n219 : unsigned_greater_than
def v_n219 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool (BitVec.ult (v_cpu_rs1_value inputs state) (v_n212 inputs state)))

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:312$lt$56_Y : zero_extend; src: examples/riscv/upstream/nerv/nerv.sv:312.65-312.87
def v_n220 (inputs : Inputs) (state : State) : BitVec 32 := (BitVec.setWidth 32 (v_n219 inputs state))

-- n221 : concat
def v_n221 (inputs : Inputs) (state : State) : BitVec 128 := (BitVec.append (v_n220 inputs state) (v_n218 inputs state))

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:313$xor$57_Y : bitwise_xor; src: examples/riscv/upstream/nerv/nerv.sv:313.65-313.87
def v_n222 (inputs : Inputs) (state : State) : BitVec 32 := ((v_cpu_rs1_value inputs state) ^^^ (v_n212 inputs state))

-- n223 : concat
def v_n223 (inputs : Inputs) (state : State) : BitVec 160 := (BitVec.append (v_n222 inputs state) (v_n221 inputs state))

-- $auto$setundef.cc:552:execute$2408$\Y : input
def v_n224 (inputs : Inputs) (state : State) : BitVec 32 := inputs.v__auto_setundef_cc_552_execute_2408

-- n225 : concat
def v_n225 (inputs : Inputs) (state : State) : BitVec 192 := (BitVec.append (v_n224 inputs state) (v_n223 inputs state))

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:314$or$58_Y : bitwise_or; src: examples/riscv/upstream/nerv/nerv.sv:314.65-314.87
def v_n226 (inputs : Inputs) (state : State) : BitVec 32 := ((v_cpu_rs1_value inputs state) ||| (v_n212 inputs state))

-- n227 : concat
def v_n227 (inputs : Inputs) (state : State) : BitVec 224 := (BitVec.append (v_n226 inputs state) (v_n225 inputs state))

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:315$and$59_Y : bitwise_and; src: examples/riscv/upstream/nerv/nerv.sv:315.65-315.87
def v_n228 (inputs : Inputs) (state : State) : BitVec 32 := ((v_cpu_rs1_value inputs state) &&& (v_n212 inputs state))

-- n229 : concat
def v_n229 (inputs : Inputs) (state : State) : BitVec 256 := (BitVec.append (v_n228 inputs state) (v_n227 inputs state))

-- n230 : concat
def v_n230 (inputs : Inputs) (state : State) : BitVec 8 := (BitVec.append (v_n141 inputs state) (v_n140 inputs state))

-- n231 : logical_shift_right
def v_n231 (inputs : Inputs) (state : State) : BitVec 256 := ((v_n229 inputs state) >>> (v_n230 inputs state).toNat)

-- $auto$pmux2shiftx.cc:713:execute$2356 : slice
def v_n232 (inputs : Inputs) (state : State) : BitVec 32 := (BitVec.extractLsb' 0 32 (v_n231 inputs state))

-- n233 : concat
def v_n233 (inputs : Inputs) (state : State) : BitVec 64 := (BitVec.append (v_n232 inputs state) (v_n191 inputs state))

-- n234 : slice
def v_n234 (inputs : Inputs) (state : State) : BitVec 32 := (BitVec.extractLsb' 0 32 (v_n233 inputs state))

-- $const4b1011 : constant
def v_n235 (inputs : Inputs) (state : State) : BitVec 4 := (0b1011 : BitVec 4)

-- n236 : concat
def v_n236 (inputs : Inputs) (state : State) : BitVec 2 := (BitVec.append (v_n143 inputs state) (v_n175 inputs state))

-- n237 : concat
def v_n237 (inputs : Inputs) (state : State) : BitVec 3 := (BitVec.append (v_n179 inputs state) (v_n236 inputs state))

-- n238 : concat
def v_n238 (inputs : Inputs) (state : State) : BitVec 4 := (BitVec.append (v_n181 inputs state) (v_n237 inputs state))

-- n239 : concat
def v_n239 (inputs : Inputs) (state : State) : BitVec 9 := (BitVec.append (v_n145 inputs state) (v_n238 inputs state))

-- n240 : concat
def v_n240 (inputs : Inputs) (state : State) : BitVec 10 := (BitVec.append (v_n147 inputs state) (v_n239 inputs state))

-- n241 : slice
def v_n241 (inputs : Inputs) (state : State) : BitVec 2 := (BitVec.extractLsb' 0 2 (v_n240 inputs state))

-- n242 : logical_shift_right
def v_n242 (inputs : Inputs) (state : State) : BitVec 4 := ((v_n235 inputs state) >>> (v_n241 inputs state).toNat)

-- n243 : constant
def v_n243 (inputs : Inputs) (state : State) : BitVec 4 := (0b0000 : BitVec 4)

-- n244 : constant
def v_n244 (inputs : Inputs) (state : State) : BitVec 10 := (0b0000000100 : BitVec 10)

-- n245 : unsigned_greater_equal
def v_n245 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool (BitVec.ule (v_n244 inputs state) (v_n240 inputs state)))

-- n246 : mux
def v_n246 (inputs : Inputs) (state : State) : BitVec 4 := (if (v_n245 inputs state) == 1 then (v_n243 inputs state) else (v_n242 inputs state))

-- $auto$pmux2shiftx.cc:694:execute$2351$\Y : slice
def v_n247 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 0 1 (v_n246 inputs state))

-- $const8b11011101 : constant
def v_n248 (inputs : Inputs) (state : State) : BitVec 8 := (0b11011101 : BitVec 8)

-- n249 : logical_shift_right
def v_n249 (inputs : Inputs) (state : State) : BitVec 8 := ((v_n248 inputs state) >>> (v_n141 inputs state).toNat)

-- $auto$pmux2shiftx.cc:694:execute$2355$\Y : slice
def v_n250 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 0 1 (v_n249 inputs state))

-- n251 : concat
def v_n251 (inputs : Inputs) (state : State) : BitVec 2 := (BitVec.append (v_n250 inputs state) (v_n247 inputs state))

-- n252 : slice
def v_n252 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 0 1 (v_n251 inputs state))

-- n253 : mux
def v_n253 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n252 inputs state) == 1 then (v_n234 inputs state) else (v_n3 inputs state))

-- n254 : slice
def v_n254 (inputs : Inputs) (state : State) : BitVec 32 := (BitVec.extractLsb' 32 32 (v_n233 inputs state))

-- n255 : slice
def v_n255 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 1 1 (v_n251 inputs state))

-- $flatten\cpu.$procmux$857$\Y : mux
def v_n256 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n255 inputs state) == 1 then (v_n254 inputs state) else (v_n253 inputs state))

-- n257 : concat
def v_n257 (inputs : Inputs) (state : State) : BitVec 64 := (BitVec.append (v_n256 inputs state) (v_n167 inputs state))

-- $auto$ff.cc:337:slice$1461$\Q : state
def v_n258 (inputs : Inputs) (state : State) : BitVec 32 := state.v_cpu_pc

-- $const32b00000000000000000000000000000100 : constant
def v_n259 (inputs : Inputs) (state : State) : BitVec 32 := (0b00000000000000000000000000000100 : BitVec 32)

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:197$add$21_Y : add; src: examples/riscv/upstream/nerv/nerv.sv:197.9-197.15
def v_n260 (inputs : Inputs) (state : State) : BitVec 32 := ((v_n258 inputs state) + (v_n259 inputs state))

-- n261 : reduce_or
def v_n261 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n141 inputs state) != 0))

-- $flatten\cpu.$procmux$1107_CMP : bitwise_not
def v_n262 (inputs : Inputs) (state : State) : BitVec 1 := (~~~(v_n261 inputs state))

-- $flatten\cpu.$procmux$1180$\Y : mux
def v_n263 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n262 inputs state) == 1 then (v_n260 inputs state) else (v_n3 inputs state))

-- n264 : concat
def v_n264 (inputs : Inputs) (state : State) : BitVec 96 := (BitVec.append (v_n263 inputs state) (v_n257 inputs state))

-- n265 : concat
def v_n265 (inputs : Inputs) (state : State) : BitVec 128 := (BitVec.append (v_n260 inputs state) (v_n264 inputs state))

-- $const12b000000000000 : constant
def v_n266 (inputs : Inputs) (state : State) : BitVec 12 := (0b000000000000 : BitVec 12)

-- n267 : slice
def v_n267 (inputs : Inputs) (state : State) : BitVec 20 := (BitVec.extractLsb' 12 20 (v_imem_data inputs state))

-- n268 : concat
def v_n268 (inputs : Inputs) (state : State) : BitVec 32 := (BitVec.append (v_n267 inputs state) (v_n266 inputs state))

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:224$add$24$\Y : add
def v_n269 (inputs : Inputs) (state : State) : BitVec 32 := ((v_n268 inputs state) + (v_n258 inputs state))

-- n270 : concat
def v_n270 (inputs : Inputs) (state : State) : BitVec 160 := (BitVec.append (v_n269 inputs state) (v_n265 inputs state))

-- n271 : concat
def v_n271 (inputs : Inputs) (state : State) : BitVec 172 := (BitVec.append (v_n266 inputs state) (v_n270 inputs state))

-- n272 : concat
def v_n272 (inputs : Inputs) (state : State) : BitVec 192 := (BitVec.append (v_n267 inputs state) (v_n271 inputs state))

-- n273 : slice
def v_n273 (inputs : Inputs) (state : State) : BitVec 32 := (BitVec.extractLsb' 0 32 (v_n272 inputs state))

-- n274 : slice
def v_n274 (inputs : Inputs) (state : State) : BitVec 7 := (BitVec.extractLsb' 0 7 (v_imem_data inputs state))

-- $const7b0110011 : constant
def v_n275 (inputs : Inputs) (state : State) : BitVec 7 := (0b0110011 : BitVec 7)

-- $flatten\cpu.$procmux$823_CMP0$\Y : equal
def v_n276 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n274 inputs state) == (v_n275 inputs state)))

-- $const7b0010011 : constant
def v_n277 (inputs : Inputs) (state : State) : BitVec 7 := (0b0010011 : BitVec 7)

-- $flatten\cpu.$procmux$868_CMP0$\Y : equal
def v_n278 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n274 inputs state) == (v_n277 inputs state)))

-- n279 : concat
def v_n279 (inputs : Inputs) (state : State) : BitVec 2 := (BitVec.append (v_n278 inputs state) (v_n276 inputs state))

-- $const7b1100111 : constant
def v_n280 (inputs : Inputs) (state : State) : BitVec 7 := (0b1100111 : BitVec 7)

-- $flatten\cpu.$procmux$1150_CMP0$\Y : equal
def v_n281 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n274 inputs state) == (v_n280 inputs state)))

-- n282 : concat
def v_n282 (inputs : Inputs) (state : State) : BitVec 3 := (BitVec.append (v_n281 inputs state) (v_n279 inputs state))

-- $const7b1101111 : constant
def v_n283 (inputs : Inputs) (state : State) : BitVec 7 := (0b1101111 : BitVec 7)

-- $flatten\cpu.$procmux$1217_CMP : equal
def v_n284 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n274 inputs state) == (v_n283 inputs state)))

-- n285 : concat
def v_n285 (inputs : Inputs) (state : State) : BitVec 4 := (BitVec.append (v_n284 inputs state) (v_n282 inputs state))

-- $const7b0010111 : constant
def v_n286 (inputs : Inputs) (state : State) : BitVec 7 := (0b0010111 : BitVec 7)

-- $flatten\cpu.$procmux$1236_CMP : equal
def v_n287 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n274 inputs state) == (v_n286 inputs state)))

-- n288 : concat
def v_n288 (inputs : Inputs) (state : State) : BitVec 5 := (BitVec.append (v_n287 inputs state) (v_n285 inputs state))

-- $const7b0110111 : constant
def v_n289 (inputs : Inputs) (state : State) : BitVec 7 := (0b0110111 : BitVec 7)

-- $flatten\cpu.$procmux$1237_CMP : equal
def v_n290 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n274 inputs state) == (v_n289 inputs state)))

-- n291 : concat
def v_n291 (inputs : Inputs) (state : State) : BitVec 6 := (BitVec.append (v_n290 inputs state) (v_n288 inputs state))

-- n292 : slice
def v_n292 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 0 1 (v_n291 inputs state))

-- n293 : mux
def v_n293 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n292 inputs state) == 1 then (v_n273 inputs state) else (v_n3 inputs state))

-- n294 : slice
def v_n294 (inputs : Inputs) (state : State) : BitVec 32 := (BitVec.extractLsb' 32 32 (v_n272 inputs state))

-- n295 : slice
def v_n295 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 1 1 (v_n291 inputs state))

-- n296 : mux
def v_n296 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n295 inputs state) == 1 then (v_n294 inputs state) else (v_n293 inputs state))

-- n297 : slice
def v_n297 (inputs : Inputs) (state : State) : BitVec 32 := (BitVec.extractLsb' 64 32 (v_n272 inputs state))

-- n298 : slice
def v_n298 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 2 1 (v_n291 inputs state))

-- n299 : mux
def v_n299 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n298 inputs state) == 1 then (v_n297 inputs state) else (v_n296 inputs state))

-- n300 : slice
def v_n300 (inputs : Inputs) (state : State) : BitVec 32 := (BitVec.extractLsb' 96 32 (v_n272 inputs state))

-- n301 : slice
def v_n301 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 3 1 (v_n291 inputs state))

-- n302 : mux
def v_n302 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n301 inputs state) == 1 then (v_n300 inputs state) else (v_n299 inputs state))

-- n303 : slice
def v_n303 (inputs : Inputs) (state : State) : BitVec 32 := (BitVec.extractLsb' 128 32 (v_n272 inputs state))

-- n304 : slice
def v_n304 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 4 1 (v_n291 inputs state))

-- n305 : mux
def v_n305 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n304 inputs state) == 1 then (v_n303 inputs state) else (v_n302 inputs state))

-- n306 : slice
def v_n306 (inputs : Inputs) (state : State) : BitVec 32 := (BitVec.extractLsb' 160 32 (v_n272 inputs state))

-- n307 : slice
def v_n307 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 5 1 (v_n291 inputs state))

-- cpu.next_rd : mux; src: examples/riscv/upstream/nerv/nerv.sv:188.13-188.20
def v_cpu_next_rd (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n307 inputs state) == 1 then (v_n306 inputs state) else (v_n305 inputs state))

-- rvfi_mem_rdata : input; src: examples/riscv/NervHarness.sv:6.1047-6.1061
def v_rvfi_mem_rdata (inputs : Inputs) (state : State) : BitVec 32 := inputs.v_dmem_rdata

-- $const32b00000000000000000000000000001000 : constant
def v_n310 (inputs : Inputs) (state : State) : BitVec 32 := (0b00000000000000000000000000001000 : BitVec 32)

-- $auto$ff.cc:337:slice$1486$\Q : state
def v_n311 (inputs : Inputs) (state : State) : BitVec 5 := state.v_cpu_mem_rd_func_q

-- n312 : slice
def v_n312 (inputs : Inputs) (state : State) : BitVec 2 := (BitVec.extractLsb' 3 2 (v_n311 inputs state))

-- n313 : zero_extend
def v_n313 (inputs : Inputs) (state : State) : BitVec 32 := (BitVec.setWidth 32 (v_n312 inputs state))

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:371$mul$75_Y : mul; src: examples/riscv/upstream/nerv/nerv.sv:371.30-371.50
def v_n314 (inputs : Inputs) (state : State) : BitVec 32 := ((v_n310 inputs state) * (v_n313 inputs state))

-- n315 : slice
def v_n315 (inputs : Inputs) (state : State) : BitVec 5 := (BitVec.extractLsb' 0 5 (v_n314 inputs state))

-- n316 : logical_shift_right
def v_n316 (inputs : Inputs) (state : State) : BitVec 32 := ((v_rvfi_mem_rdata inputs state) >>> (v_n315 inputs state).toNat)

-- n317 : constant
def v_n317 (inputs : Inputs) (state : State) : BitVec 32 := (0b00000000000000000000000000000000 : BitVec 32)

-- n318 : constant
def v_n318 (inputs : Inputs) (state : State) : BitVec 32 := (0b00000000000000000000000000100000 : BitVec 32)

-- n319 : unsigned_greater_equal
def v_n319 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool (BitVec.ule (v_n318 inputs state) (v_n314 inputs state)))

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:371$shr$76$\Y : mux
def v_n320 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n319 inputs state) == 1 then (v_n317 inputs state) else (v_n316 inputs state))

-- n321 : slice
def v_n321 (inputs : Inputs) (state : State) : BitVec 8 := (BitVec.extractLsb' 0 8 (v_n320 inputs state))

-- n322 : slice
def v_n322 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 7 1 (v_n320 inputs state))

-- n323 : concat
def v_n323 (inputs : Inputs) (state : State) : BitVec 9 := (BitVec.append (v_n322 inputs state) (v_n321 inputs state))

-- n324 : concat
def v_n324 (inputs : Inputs) (state : State) : BitVec 10 := (BitVec.append (v_n322 inputs state) (v_n323 inputs state))

-- n325 : concat
def v_n325 (inputs : Inputs) (state : State) : BitVec 11 := (BitVec.append (v_n322 inputs state) (v_n324 inputs state))

-- n326 : concat
def v_n326 (inputs : Inputs) (state : State) : BitVec 12 := (BitVec.append (v_n322 inputs state) (v_n325 inputs state))

-- n327 : concat
def v_n327 (inputs : Inputs) (state : State) : BitVec 13 := (BitVec.append (v_n322 inputs state) (v_n326 inputs state))

-- n328 : concat
def v_n328 (inputs : Inputs) (state : State) : BitVec 14 := (BitVec.append (v_n322 inputs state) (v_n327 inputs state))

-- n329 : concat
def v_n329 (inputs : Inputs) (state : State) : BitVec 15 := (BitVec.append (v_n322 inputs state) (v_n328 inputs state))

-- n330 : concat
def v_n330 (inputs : Inputs) (state : State) : BitVec 16 := (BitVec.append (v_n322 inputs state) (v_n329 inputs state))

-- n331 : concat
def v_n331 (inputs : Inputs) (state : State) : BitVec 17 := (BitVec.append (v_n322 inputs state) (v_n330 inputs state))

-- n332 : concat
def v_n332 (inputs : Inputs) (state : State) : BitVec 18 := (BitVec.append (v_n322 inputs state) (v_n331 inputs state))

-- n333 : concat
def v_n333 (inputs : Inputs) (state : State) : BitVec 19 := (BitVec.append (v_n322 inputs state) (v_n332 inputs state))

-- n334 : concat
def v_n334 (inputs : Inputs) (state : State) : BitVec 20 := (BitVec.append (v_n322 inputs state) (v_n333 inputs state))

-- n335 : concat
def v_n335 (inputs : Inputs) (state : State) : BitVec 21 := (BitVec.append (v_n322 inputs state) (v_n334 inputs state))

-- n336 : concat
def v_n336 (inputs : Inputs) (state : State) : BitVec 22 := (BitVec.append (v_n322 inputs state) (v_n335 inputs state))

-- n337 : concat
def v_n337 (inputs : Inputs) (state : State) : BitVec 23 := (BitVec.append (v_n322 inputs state) (v_n336 inputs state))

-- n338 : concat
def v_n338 (inputs : Inputs) (state : State) : BitVec 24 := (BitVec.append (v_n322 inputs state) (v_n337 inputs state))

-- n339 : concat
def v_n339 (inputs : Inputs) (state : State) : BitVec 25 := (BitVec.append (v_n322 inputs state) (v_n338 inputs state))

-- n340 : concat
def v_n340 (inputs : Inputs) (state : State) : BitVec 26 := (BitVec.append (v_n322 inputs state) (v_n339 inputs state))

-- n341 : concat
def v_n341 (inputs : Inputs) (state : State) : BitVec 27 := (BitVec.append (v_n322 inputs state) (v_n340 inputs state))

-- n342 : concat
def v_n342 (inputs : Inputs) (state : State) : BitVec 28 := (BitVec.append (v_n322 inputs state) (v_n341 inputs state))

-- n343 : concat
def v_n343 (inputs : Inputs) (state : State) : BitVec 29 := (BitVec.append (v_n322 inputs state) (v_n342 inputs state))

-- n344 : concat
def v_n344 (inputs : Inputs) (state : State) : BitVec 30 := (BitVec.append (v_n322 inputs state) (v_n343 inputs state))

-- n345 : concat
def v_n345 (inputs : Inputs) (state : State) : BitVec 31 := (BitVec.append (v_n322 inputs state) (v_n344 inputs state))

-- n346 : concat
def v_n346 (inputs : Inputs) (state : State) : BitVec 32 := (BitVec.append (v_n322 inputs state) (v_n345 inputs state))

-- n347 : slice
def v_n347 (inputs : Inputs) (state : State) : BitVec 16 := (BitVec.extractLsb' 0 16 (v_n320 inputs state))

-- n348 : concat
def v_n348 (inputs : Inputs) (state : State) : BitVec 48 := (BitVec.append (v_n347 inputs state) (v_n346 inputs state))

-- n349 : slice
def v_n349 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 15 1 (v_n320 inputs state))

-- n350 : concat
def v_n350 (inputs : Inputs) (state : State) : BitVec 49 := (BitVec.append (v_n349 inputs state) (v_n348 inputs state))

-- n351 : concat
def v_n351 (inputs : Inputs) (state : State) : BitVec 50 := (BitVec.append (v_n349 inputs state) (v_n350 inputs state))

-- n352 : concat
def v_n352 (inputs : Inputs) (state : State) : BitVec 51 := (BitVec.append (v_n349 inputs state) (v_n351 inputs state))

-- n353 : concat
def v_n353 (inputs : Inputs) (state : State) : BitVec 52 := (BitVec.append (v_n349 inputs state) (v_n352 inputs state))

-- n354 : concat
def v_n354 (inputs : Inputs) (state : State) : BitVec 53 := (BitVec.append (v_n349 inputs state) (v_n353 inputs state))

-- n355 : concat
def v_n355 (inputs : Inputs) (state : State) : BitVec 54 := (BitVec.append (v_n349 inputs state) (v_n354 inputs state))

-- n356 : concat
def v_n356 (inputs : Inputs) (state : State) : BitVec 55 := (BitVec.append (v_n349 inputs state) (v_n355 inputs state))

-- n357 : concat
def v_n357 (inputs : Inputs) (state : State) : BitVec 56 := (BitVec.append (v_n349 inputs state) (v_n356 inputs state))

-- n358 : concat
def v_n358 (inputs : Inputs) (state : State) : BitVec 57 := (BitVec.append (v_n349 inputs state) (v_n357 inputs state))

-- n359 : concat
def v_n359 (inputs : Inputs) (state : State) : BitVec 58 := (BitVec.append (v_n349 inputs state) (v_n358 inputs state))

-- n360 : concat
def v_n360 (inputs : Inputs) (state : State) : BitVec 59 := (BitVec.append (v_n349 inputs state) (v_n359 inputs state))

-- n361 : concat
def v_n361 (inputs : Inputs) (state : State) : BitVec 60 := (BitVec.append (v_n349 inputs state) (v_n360 inputs state))

-- n362 : concat
def v_n362 (inputs : Inputs) (state : State) : BitVec 61 := (BitVec.append (v_n349 inputs state) (v_n361 inputs state))

-- n363 : concat
def v_n363 (inputs : Inputs) (state : State) : BitVec 62 := (BitVec.append (v_n349 inputs state) (v_n362 inputs state))

-- n364 : concat
def v_n364 (inputs : Inputs) (state : State) : BitVec 63 := (BitVec.append (v_n349 inputs state) (v_n363 inputs state))

-- n365 : concat
def v_n365 (inputs : Inputs) (state : State) : BitVec 64 := (BitVec.append (v_n349 inputs state) (v_n364 inputs state))

-- n366 : concat
def v_n366 (inputs : Inputs) (state : State) : BitVec 72 := (BitVec.append (v_n321 inputs state) (v_n365 inputs state))

-- $const24b000000000000000000000000 : constant
def v_n367 (inputs : Inputs) (state : State) : BitVec 24 := (0b000000000000000000000000 : BitVec 24)

-- n368 : concat
def v_n368 (inputs : Inputs) (state : State) : BitVec 96 := (BitVec.append (v_n367 inputs state) (v_n366 inputs state))

-- n369 : concat
def v_n369 (inputs : Inputs) (state : State) : BitVec 112 := (BitVec.append (v_n347 inputs state) (v_n368 inputs state))

-- $const16b0000000000000000 : constant
def v_n370 (inputs : Inputs) (state : State) : BitVec 16 := (0b0000000000000000 : BitVec 16)

-- n371 : concat
def v_n371 (inputs : Inputs) (state : State) : BitVec 128 := (BitVec.append (v_n370 inputs state) (v_n369 inputs state))

-- n372 : concat
def v_n372 (inputs : Inputs) (state : State) : BitVec 160 := (BitVec.append (v_n320 inputs state) (v_n371 inputs state))

-- n373 : concat
def v_n373 (inputs : Inputs) (state : State) : BitVec 192 := (BitVec.append (v_n320 inputs state) (v_n372 inputs state))

-- n374 : concat
def v_n374 (inputs : Inputs) (state : State) : BitVec 224 := (BitVec.append (v_n320 inputs state) (v_n373 inputs state))

-- n375 : concat
def v_n375 (inputs : Inputs) (state : State) : BitVec 256 := (BitVec.append (v_n320 inputs state) (v_n374 inputs state))

-- n376 : slice
def v_n376 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 0 1 (v_n311 inputs state))

-- n377 : concat
def v_n377 (inputs : Inputs) (state : State) : BitVec 6 := (BitVec.append (v_n376 inputs state) (v_n140 inputs state))

-- n378 : slice
def v_n378 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 2 1 (v_n311 inputs state))

-- n379 : concat
def v_n379 (inputs : Inputs) (state : State) : BitVec 7 := (BitVec.append (v_n378 inputs state) (v_n377 inputs state))

-- n380 : slice
def v_n380 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 1 1 (v_n311 inputs state))

-- n381 : concat
def v_n381 (inputs : Inputs) (state : State) : BitVec 8 := (BitVec.append (v_n380 inputs state) (v_n379 inputs state))

-- n382 : logical_shift_right
def v_n382 (inputs : Inputs) (state : State) : BitVec 256 := ((v_n375 inputs state) >>> (v_n381 inputs state).toNat)

-- cpu.mem_rdata : slice; src: examples/riscv/upstream/nerv/nerv.sv:362.13-362.22
def v_cpu_mem_rdata (inputs : Inputs) (state : State) : BitVec 32 := (BitVec.extractLsb' 0 32 (v_n382 inputs state))

-- $auto$ff.cc:337:slice$1489$\Q : state
def v_n384 (inputs : Inputs) (state : State) : BitVec 1 := state.v_cpu_mem_rd_enable_q

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:428$ternary$107_Y : mux; src: examples/riscv/upstream/nerv/nerv.sv:428.58-428.95
def v_n385 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n384 inputs state) == 1 then (v_cpu_mem_rdata inputs state) else (v_cpu_next_rd inputs state))

-- $const1b0 : constant
def v_n386 (inputs : Inputs) (state : State) : BitVec 1 := (0b0 : BitVec 1)

-- $const1b1 : constant
def v_n387 (inputs : Inputs) (state : State) : BitVec 1 := (0b1 : BitVec 1)

-- $flatten\cpu.$procmux$1191$\Y : mux
def v_n388 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n262 inputs state) == 1 then (v_n387 inputs state) else (v_n386 inputs state))

-- n389 : concat
def v_n389 (inputs : Inputs) (state : State) : BitVec 2 := (BitVec.append (v_n388 inputs state) (v_n387 inputs state))

-- $const3b100 : constant
def v_n390 (inputs : Inputs) (state : State) : BitVec 3 := (0b100 : BitVec 3)

-- $flatten\cpu.$procmux$1072_CMP : equal
def v_n391 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n141 inputs state) == (v_n390 inputs state)))

-- n392 : concat
def v_n392 (inputs : Inputs) (state : State) : BitVec 2 := (BitVec.append (v_n391 inputs state) (v_n262 inputs state))

-- $const3b110 : constant
def v_n393 (inputs : Inputs) (state : State) : BitVec 3 := (0b110 : BitVec 3)

-- $flatten\cpu.$procmux$1041_CMP : equal
def v_n394 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n141 inputs state) == (v_n393 inputs state)))

-- n395 : concat
def v_n395 (inputs : Inputs) (state : State) : BitVec 3 := (BitVec.append (v_n394 inputs state) (v_n392 inputs state))

-- $const3b111 : constant
def v_n396 (inputs : Inputs) (state : State) : BitVec 3 := (0b111 : BitVec 3)

-- $flatten\cpu.$procmux$1027_CMP : equal
def v_n397 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n141 inputs state) == (v_n396 inputs state)))

-- n398 : concat
def v_n398 (inputs : Inputs) (state : State) : BitVec 4 := (BitVec.append (v_n397 inputs state) (v_n395 inputs state))

-- $const3b010 : constant
def v_n399 (inputs : Inputs) (state : State) : BitVec 3 := (0b010 : BitVec 3)

-- $flatten\cpu.$procmux$865_CMP0$\Y : equal
def v_n400 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n141 inputs state) == (v_n399 inputs state)))

-- n401 : concat
def v_n401 (inputs : Inputs) (state : State) : BitVec 5 := (BitVec.append (v_n400 inputs state) (v_n398 inputs state))

-- $const3b011 : constant
def v_n402 (inputs : Inputs) (state : State) : BitVec 3 := (0b011 : BitVec 3)

-- $flatten\cpu.$procmux$864_CMP0$\Y : equal
def v_n403 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n141 inputs state) == (v_n402 inputs state)))

-- n404 : concat
def v_n404 (inputs : Inputs) (state : State) : BitVec 6 := (BitVec.append (v_n403 inputs state) (v_n401 inputs state))

-- n405 : slice
def v_n405 (inputs : Inputs) (state : State) : BitVec 7 := (BitVec.extractLsb' 25 7 (v_imem_data inputs state))

-- n406 : concat
def v_n406 (inputs : Inputs) (state : State) : BitVec 10 := (BitVec.append (v_n405 inputs state) (v_n141 inputs state))

-- $const10b0000000001 : constant
def v_n407 (inputs : Inputs) (state : State) : BitVec 10 := (0b0000000001 : BitVec 10)

-- $flatten\cpu.$procmux$819_CMP0$\Y : equal
def v_n408 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n406 inputs state) == (v_n407 inputs state)))

-- n409 : concat
def v_n409 (inputs : Inputs) (state : State) : BitVec 7 := (BitVec.append (v_n408 inputs state) (v_n404 inputs state))

-- $const10b0000000101 : constant
def v_n410 (inputs : Inputs) (state : State) : BitVec 10 := (0b0000000101 : BitVec 10)

-- $flatten\cpu.$procmux$815_CMP0$\Y : equal
def v_n411 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n406 inputs state) == (v_n410 inputs state)))

-- n412 : concat
def v_n412 (inputs : Inputs) (state : State) : BitVec 8 := (BitVec.append (v_n411 inputs state) (v_n409 inputs state))

-- $const10b0100000101 : constant
def v_n413 (inputs : Inputs) (state : State) : BitVec 10 := (0b0100000101 : BitVec 10)

-- $flatten\cpu.$procmux$814_CMP0$\Y : equal
def v_n414 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n406 inputs state) == (v_n413 inputs state)))

-- n415 : concat
def v_n415 (inputs : Inputs) (state : State) : BitVec 9 := (BitVec.append (v_n414 inputs state) (v_n412 inputs state))

-- $auto$opt_reduce.cc:137:opt_pmux$1444 : reduce_or
def v_n416 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n415 inputs state) != 0))

-- $flatten\cpu.$procmux$872$\Y : mux
def v_n417 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n416 inputs state) == 1 then (v_n387 inputs state) else (v_n386 inputs state))

-- n418 : concat
def v_n418 (inputs : Inputs) (state : State) : BitVec 3 := (BitVec.append (v_n417 inputs state) (v_n389 inputs state))

-- n419 : reduce_or
def v_n419 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n406 inputs state) != 0))

-- $flatten\cpu.$procmux$821_CMP0$\Y : bitwise_not
def v_n420 (inputs : Inputs) (state : State) : BitVec 1 := (~~~(v_n419 inputs state))

-- $const10b0100000000 : constant
def v_n421 (inputs : Inputs) (state : State) : BitVec 10 := (0b0100000000 : BitVec 10)

-- $flatten\cpu.$procmux$820_CMP0$\Y : equal
def v_n422 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n406 inputs state) == (v_n421 inputs state)))

-- n423 : concat
def v_n423 (inputs : Inputs) (state : State) : BitVec 2 := (BitVec.append (v_n422 inputs state) (v_n420 inputs state))

-- n424 : concat
def v_n424 (inputs : Inputs) (state : State) : BitVec 3 := (BitVec.append (v_n408 inputs state) (v_n423 inputs state))

-- $const10b0000000010 : constant
def v_n425 (inputs : Inputs) (state : State) : BitVec 10 := (0b0000000010 : BitVec 10)

-- $flatten\cpu.$procmux$818_CMP0$\Y : equal
def v_n426 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n406 inputs state) == (v_n425 inputs state)))

-- n427 : concat
def v_n427 (inputs : Inputs) (state : State) : BitVec 4 := (BitVec.append (v_n426 inputs state) (v_n424 inputs state))

-- $const10b0000000011 : constant
def v_n428 (inputs : Inputs) (state : State) : BitVec 10 := (0b0000000011 : BitVec 10)

-- $flatten\cpu.$procmux$817_CMP0$\Y : equal
def v_n429 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n406 inputs state) == (v_n428 inputs state)))

-- n430 : concat
def v_n430 (inputs : Inputs) (state : State) : BitVec 5 := (BitVec.append (v_n429 inputs state) (v_n427 inputs state))

-- $const10b0000000100 : constant
def v_n431 (inputs : Inputs) (state : State) : BitVec 10 := (0b0000000100 : BitVec 10)

-- $flatten\cpu.$procmux$816_CMP0$\Y : equal
def v_n432 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n406 inputs state) == (v_n431 inputs state)))

-- n433 : concat
def v_n433 (inputs : Inputs) (state : State) : BitVec 6 := (BitVec.append (v_n432 inputs state) (v_n430 inputs state))

-- n434 : concat
def v_n434 (inputs : Inputs) (state : State) : BitVec 7 := (BitVec.append (v_n411 inputs state) (v_n433 inputs state))

-- n435 : concat
def v_n435 (inputs : Inputs) (state : State) : BitVec 8 := (BitVec.append (v_n414 inputs state) (v_n434 inputs state))

-- $const10b0000000110 : constant
def v_n436 (inputs : Inputs) (state : State) : BitVec 10 := (0b0000000110 : BitVec 10)

-- $flatten\cpu.$procmux$813_CMP0$\Y : equal
def v_n437 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n406 inputs state) == (v_n436 inputs state)))

-- n438 : concat
def v_n438 (inputs : Inputs) (state : State) : BitVec 9 := (BitVec.append (v_n437 inputs state) (v_n435 inputs state))

-- $const10b0000000111 : constant
def v_n439 (inputs : Inputs) (state : State) : BitVec 10 := (0b0000000111 : BitVec 10)

-- $flatten\cpu.$procmux$812_CMP0$\Y : equal
def v_n440 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n406 inputs state) == (v_n439 inputs state)))

-- n441 : concat
def v_n441 (inputs : Inputs) (state : State) : BitVec 10 := (BitVec.append (v_n440 inputs state) (v_n438 inputs state))

-- $auto$opt_reduce.cc:137:opt_pmux$1440 : reduce_or
def v_n442 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n441 inputs state) != 0))

-- $flatten\cpu.$procmux$826$\Y : mux
def v_n443 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n442 inputs state) == 1 then (v_n387 inputs state) else (v_n386 inputs state))

-- n444 : concat
def v_n444 (inputs : Inputs) (state : State) : BitVec 4 := (BitVec.append (v_n443 inputs state) (v_n418 inputs state))

-- n445 : slice
def v_n445 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 0 1 (v_n444 inputs state))

-- n446 : concat
def v_n446 (inputs : Inputs) (state : State) : BitVec 2 := (BitVec.append (v_n287 inputs state) (v_n290 inputs state))

-- n447 : concat
def v_n447 (inputs : Inputs) (state : State) : BitVec 3 := (BitVec.append (v_n284 inputs state) (v_n446 inputs state))

-- $auto$opt_reduce.cc:131:opt_pmux$1449$\Y : reduce_or
def v_n448 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n447 inputs state) != 0))

-- n449 : concat
def v_n449 (inputs : Inputs) (state : State) : BitVec 2 := (BitVec.append (v_n281 inputs state) (v_n448 inputs state))

-- n450 : concat
def v_n450 (inputs : Inputs) (state : State) : BitVec 3 := (BitVec.append (v_n278 inputs state) (v_n449 inputs state))

-- n451 : concat
def v_n451 (inputs : Inputs) (state : State) : BitVec 4 := (BitVec.append (v_n276 inputs state) (v_n450 inputs state))

-- n452 : slice
def v_n452 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 0 1 (v_n451 inputs state))

-- n453 : mux
def v_n453 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n452 inputs state) == 1 then (v_n445 inputs state) else (v_n386 inputs state))

-- n454 : slice
def v_n454 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 1 1 (v_n444 inputs state))

-- n455 : slice
def v_n455 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 1 1 (v_n451 inputs state))

-- n456 : mux
def v_n456 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n455 inputs state) == 1 then (v_n454 inputs state) else (v_n453 inputs state))

-- n457 : slice
def v_n457 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 2 1 (v_n444 inputs state))

-- n458 : slice
def v_n458 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 2 1 (v_n451 inputs state))

-- n459 : mux
def v_n459 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n458 inputs state) == 1 then (v_n457 inputs state) else (v_n456 inputs state))

-- n460 : slice
def v_n460 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 3 1 (v_n444 inputs state))

-- n461 : slice
def v_n461 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 3 1 (v_n451 inputs state))

-- $flatten\cpu.$1\next_wr[0:0] : mux; src: examples/riscv/upstream/nerv/nerv.sv:195.2-359.5
def v_n462 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n461 inputs state) == 1 then (v_n460 inputs state) else (v_n459 inputs state))

-- $flatten\cpu.$procmux$804$\Y : mux
def v_n463 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n384 inputs state) == 1 then (v_n386 inputs state) else (v_n462 inputs state))

-- reset : input; src: examples/riscv/NervHarness.sv:4.16-4.21
def v_reset (inputs : Inputs) (state : State) : BitVec 1 := inputs.v_reset

-- cpu.reset_q : state; src: examples/riscv/upstream/nerv/nerv.sv:361.6-361.13
def v_cpu_reset_q (inputs : Inputs) (state : State) : BitVec 1 := state.v_cpu_reset_q

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:352$logic_or$73_Y : bitwise_or; src: examples/riscv/upstream/nerv/nerv.sv:352.7-352.23
def v_n466 (inputs : Inputs) (state : State) : BitVec 1 := ((v_reset inputs state) ||| (v_cpu_reset_q inputs state))

-- cpu.next_wr : mux; src: examples/riscv/upstream/nerv/nerv.sv:187.6-187.13
def v_cpu_next_wr (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n466 inputs state) == 1 then (v_n386 inputs state) else (v_n463 inputs state))

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:427$logic_or$102_Y : bitwise_or; src: examples/riscv/upstream/nerv/nerv.sv:427.8-427.34
def v_n468 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n384 inputs state) ||| (v_cpu_next_wr inputs state))

-- $flatten\cpu.$2$memwr$\regfile$examples/riscv/upstream/nerv/nerv.sv:428$1_DATA[31:0]$104 : mux; src: examples/riscv/upstream/nerv/nerv.sv:381.2-440.5
def v_n469 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n468 inputs state) == 1 then (v_n385 inputs state) else (v_n2 inputs state))

-- cpu.trapped : state; src: examples/riscv/upstream/nerv/nerv.sv:191.6-191.13
def v_cpu_trapped (inputs : Inputs) (state : State) : BitVec 1 := state.v_cpu_trap

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:386$logic_not$81$\Y : bitwise_not
def v_n471 (inputs : Inputs) (state : State) : BitVec 1 := (~~~(v_cpu_trapped inputs state))

-- stall : input; src: examples/riscv/NervHarness.sv:4.23-4.28
def v_stall (inputs : Inputs) (state : State) : BitVec 1 := inputs.v_stall

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:386$logic_not$82$\Y : bitwise_not
def v_n473 (inputs : Inputs) (state : State) : BitVec 1 := (~~~(v_stall inputs state))

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:386$logic_and$83$\Y : bitwise_and
def v_n474 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n471 inputs state) &&& (v_n473 inputs state))

-- $flatten\check_insn.$examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:134$logic_not$165_Y : bitwise_not; src: examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:134.8-134.14
def v_n475 (inputs : Inputs) (state : State) : BitVec 1 := (~~~(v_reset inputs state))

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:386$logic_and$85$\Y : bitwise_and
def v_n476 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n474 inputs state) &&& (v_n475 inputs state))

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:386$logic_not$86$\Y : bitwise_not
def v_n477 (inputs : Inputs) (state : State) : BitVec 1 := (~~~(v_cpu_reset_q inputs state))

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:386$logic_and$87_Y : bitwise_and; src: examples/riscv/upstream/nerv/nerv.sv:386.7-386.47
def v_n478 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n476 inputs state) &&& (v_n477 inputs state))

-- $flatten\cpu.$0$memwr$\regfile$examples/riscv/upstream/nerv/nerv.sv:428$1_DATA[31:0]$79 : mux; src: examples/riscv/upstream/nerv/nerv.sv:381.2-440.5
def v_n479 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n478 inputs state) == 1 then (v_n469 inputs state) else (v_n1 inputs state))

-- $auto$setundef.cc:552:execute$2412$\Y : input
def v_n480 (inputs : Inputs) (state : State) : BitVec 5 := inputs.v__auto_setundef_cc_552_execute_2412

-- $auto$setundef.cc:552:execute$2410$\Y : input
def v_n481 (inputs : Inputs) (state : State) : BitVec 5 := inputs.v__auto_setundef_cc_552_execute_2410

-- n482 : slice
def v_n482 (inputs : Inputs) (state : State) : BitVec 5 := (BitVec.extractLsb' 7 5 (v_imem_data inputs state))

-- $auto$ff.cc:337:slice$1490$\Q : state
def v_n483 (inputs : Inputs) (state : State) : BitVec 5 := state.v_cpu_mem_rd_reg_q

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:428$ternary$106$\Y : mux
def v_n484 (inputs : Inputs) (state : State) : BitVec 5 := (if (v_n384 inputs state) == 1 then (v_n483 inputs state) else (v_n482 inputs state))

-- $flatten\cpu.$procmux$665$\Y : mux
def v_n485 (inputs : Inputs) (state : State) : BitVec 5 := (if (v_n468 inputs state) == 1 then (v_n484 inputs state) else (v_n481 inputs state))

-- $flatten\cpu.$procmux$676$\Y : mux
def v_n486 (inputs : Inputs) (state : State) : BitVec 5 := (if (v_n478 inputs state) == 1 then (v_n485 inputs state) else (v_n480 inputs state))

-- $auto$rtlil.cc:3258:Eq$1766 : slice
def v_n487 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 0 1 (v_n486 inputs state))

-- $auto$rtlil.cc:3258:Eq$1776 : slice
def v_n488 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 1 1 (v_n486 inputs state))

-- $auto$rtlil.cc:3251:And$1786 : bitwise_and
def v_n489 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n487 inputs state) &&& (v_n488 inputs state))

-- $auto$rtlil.cc:3258:Eq$1794 : slice
def v_n490 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 2 1 (v_n486 inputs state))

-- $auto$rtlil.cc:3258:Eq$1822 : slice
def v_n491 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 3 1 (v_n486 inputs state))

-- $auto$rtlil.cc:3258:Eq$1878 : slice
def v_n492 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 4 1 (v_n486 inputs state))

-- $auto$memory_map.cc:100:addr_decode$1933$\Y : bitwise_and
def v_n493 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n491 inputs state) &&& (v_n492 inputs state))

-- $auto$memory_map.cc:100:addr_decode$1961$\Y : bitwise_and
def v_n494 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n490 inputs state) &&& (v_n493 inputs state))

-- $auto$rtlil.cc:3251:And$1982 : bitwise_and
def v_n495 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n489 inputs state) &&& (v_n494 inputs state))

-- $flatten\cpu.$procmux$653$\Y : mux
def v_n496 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n468 inputs state) == 1 then (v_n387 inputs state) else (v_n386 inputs state))

-- n497 : concat
def v_n497 (inputs : Inputs) (state : State) : BitVec 2 := (BitVec.append (v_n496 inputs state) (v_n496 inputs state))

-- n498 : concat
def v_n498 (inputs : Inputs) (state : State) : BitVec 3 := (BitVec.append (v_n496 inputs state) (v_n497 inputs state))

-- n499 : concat
def v_n499 (inputs : Inputs) (state : State) : BitVec 4 := (BitVec.append (v_n496 inputs state) (v_n498 inputs state))

-- n500 : concat
def v_n500 (inputs : Inputs) (state : State) : BitVec 5 := (BitVec.append (v_n496 inputs state) (v_n499 inputs state))

-- n501 : concat
def v_n501 (inputs : Inputs) (state : State) : BitVec 6 := (BitVec.append (v_n496 inputs state) (v_n500 inputs state))

-- n502 : concat
def v_n502 (inputs : Inputs) (state : State) : BitVec 7 := (BitVec.append (v_n496 inputs state) (v_n501 inputs state))

-- n503 : concat
def v_n503 (inputs : Inputs) (state : State) : BitVec 8 := (BitVec.append (v_n496 inputs state) (v_n502 inputs state))

-- n504 : concat
def v_n504 (inputs : Inputs) (state : State) : BitVec 9 := (BitVec.append (v_n496 inputs state) (v_n503 inputs state))

-- n505 : concat
def v_n505 (inputs : Inputs) (state : State) : BitVec 10 := (BitVec.append (v_n496 inputs state) (v_n504 inputs state))

-- n506 : concat
def v_n506 (inputs : Inputs) (state : State) : BitVec 11 := (BitVec.append (v_n496 inputs state) (v_n505 inputs state))

-- n507 : concat
def v_n507 (inputs : Inputs) (state : State) : BitVec 12 := (BitVec.append (v_n496 inputs state) (v_n506 inputs state))

-- n508 : concat
def v_n508 (inputs : Inputs) (state : State) : BitVec 13 := (BitVec.append (v_n496 inputs state) (v_n507 inputs state))

-- n509 : concat
def v_n509 (inputs : Inputs) (state : State) : BitVec 14 := (BitVec.append (v_n496 inputs state) (v_n508 inputs state))

-- n510 : concat
def v_n510 (inputs : Inputs) (state : State) : BitVec 15 := (BitVec.append (v_n496 inputs state) (v_n509 inputs state))

-- n511 : concat
def v_n511 (inputs : Inputs) (state : State) : BitVec 16 := (BitVec.append (v_n496 inputs state) (v_n510 inputs state))

-- n512 : concat
def v_n512 (inputs : Inputs) (state : State) : BitVec 17 := (BitVec.append (v_n496 inputs state) (v_n511 inputs state))

-- n513 : concat
def v_n513 (inputs : Inputs) (state : State) : BitVec 18 := (BitVec.append (v_n496 inputs state) (v_n512 inputs state))

-- n514 : concat
def v_n514 (inputs : Inputs) (state : State) : BitVec 19 := (BitVec.append (v_n496 inputs state) (v_n513 inputs state))

-- n515 : concat
def v_n515 (inputs : Inputs) (state : State) : BitVec 20 := (BitVec.append (v_n496 inputs state) (v_n514 inputs state))

-- n516 : concat
def v_n516 (inputs : Inputs) (state : State) : BitVec 21 := (BitVec.append (v_n496 inputs state) (v_n515 inputs state))

-- n517 : concat
def v_n517 (inputs : Inputs) (state : State) : BitVec 22 := (BitVec.append (v_n496 inputs state) (v_n516 inputs state))

-- n518 : concat
def v_n518 (inputs : Inputs) (state : State) : BitVec 23 := (BitVec.append (v_n496 inputs state) (v_n517 inputs state))

-- n519 : concat
def v_n519 (inputs : Inputs) (state : State) : BitVec 24 := (BitVec.append (v_n496 inputs state) (v_n518 inputs state))

-- n520 : concat
def v_n520 (inputs : Inputs) (state : State) : BitVec 25 := (BitVec.append (v_n496 inputs state) (v_n519 inputs state))

-- n521 : concat
def v_n521 (inputs : Inputs) (state : State) : BitVec 26 := (BitVec.append (v_n496 inputs state) (v_n520 inputs state))

-- n522 : concat
def v_n522 (inputs : Inputs) (state : State) : BitVec 27 := (BitVec.append (v_n496 inputs state) (v_n521 inputs state))

-- n523 : concat
def v_n523 (inputs : Inputs) (state : State) : BitVec 28 := (BitVec.append (v_n496 inputs state) (v_n522 inputs state))

-- n524 : concat
def v_n524 (inputs : Inputs) (state : State) : BitVec 29 := (BitVec.append (v_n496 inputs state) (v_n523 inputs state))

-- n525 : concat
def v_n525 (inputs : Inputs) (state : State) : BitVec 30 := (BitVec.append (v_n496 inputs state) (v_n524 inputs state))

-- n526 : concat
def v_n526 (inputs : Inputs) (state : State) : BitVec 31 := (BitVec.append (v_n496 inputs state) (v_n525 inputs state))

-- $flatten\cpu.$2$memwr$\regfile$examples/riscv/upstream/nerv/nerv.sv:428$1_EN[31:0]$105 : concat; src: examples/riscv/upstream/nerv/nerv.sv:381.2-440.5
def v_n527 (inputs : Inputs) (state : State) : BitVec 32 := (BitVec.append (v_n496 inputs state) (v_n526 inputs state))

-- n528 : slice
def v_n528 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 0 1 (v_n527 inputs state))

-- $flatten\cpu.$procmux$670$\Y : mux
def v_n529 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n478 inputs state) == 1 then (v_n528 inputs state) else (v_n386 inputs state))

-- $memory\cpu.regfile$wren[31][0][0]$y$1984 : bitwise_and
def v_n530 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n495 inputs state) &&& (v_n529 inputs state))

-- $auto$rtlil.cc:3339:Mux$2211 : mux
def v_n531 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n530 inputs state) == 1 then (v_n479 inputs state) else (v_cpu_regfile_31_ inputs state))

-- $auto$rtlil.cc:3258:Eq$1744 : bitwise_not
def v_n532 (inputs : Inputs) (state : State) : BitVec 1 := (~~~(v_n487 inputs state))

-- $auto$rtlil.cc:3258:Eq$1746 : bitwise_not
def v_n533 (inputs : Inputs) (state : State) : BitVec 1 := (~~~(v_n488 inputs state))

-- $auto$rtlil.cc:3251:And$1748 : bitwise_and
def v_n534 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n532 inputs state) &&& (v_n533 inputs state))

-- $auto$rtlil.cc:3258:Eq$1750 : bitwise_not
def v_n535 (inputs : Inputs) (state : State) : BitVec 1 := (~~~(v_n490 inputs state))

-- $auto$rtlil.cc:3258:Eq$1752 : bitwise_not
def v_n536 (inputs : Inputs) (state : State) : BitVec 1 := (~~~(v_n491 inputs state))

-- $auto$rtlil.cc:3258:Eq$1754 : bitwise_not
def v_n537 (inputs : Inputs) (state : State) : BitVec 1 := (~~~(v_n492 inputs state))

-- $auto$rtlil.cc:3251:And$1756 : bitwise_and
def v_n538 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n536 inputs state) &&& (v_n537 inputs state))

-- $auto$rtlil.cc:3251:And$1758 : bitwise_and
def v_n539 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n535 inputs state) &&& (v_n538 inputs state))

-- $auto$rtlil.cc:3251:And$1760 : bitwise_and
def v_n540 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n534 inputs state) &&& (v_n539 inputs state))

-- n541 : concat
def v_n541 (inputs : Inputs) (state : State) : BitVec 2 := (BitVec.append (v_n529 inputs state) (v_n529 inputs state))

-- n542 : concat
def v_n542 (inputs : Inputs) (state : State) : BitVec 3 := (BitVec.append (v_n529 inputs state) (v_n541 inputs state))

-- n543 : concat
def v_n543 (inputs : Inputs) (state : State) : BitVec 4 := (BitVec.append (v_n529 inputs state) (v_n542 inputs state))

-- n544 : concat
def v_n544 (inputs : Inputs) (state : State) : BitVec 5 := (BitVec.append (v_n529 inputs state) (v_n543 inputs state))

-- n545 : concat
def v_n545 (inputs : Inputs) (state : State) : BitVec 6 := (BitVec.append (v_n529 inputs state) (v_n544 inputs state))

-- n546 : concat
def v_n546 (inputs : Inputs) (state : State) : BitVec 7 := (BitVec.append (v_n529 inputs state) (v_n545 inputs state))

-- n547 : concat
def v_n547 (inputs : Inputs) (state : State) : BitVec 8 := (BitVec.append (v_n529 inputs state) (v_n546 inputs state))

-- n548 : concat
def v_n548 (inputs : Inputs) (state : State) : BitVec 9 := (BitVec.append (v_n529 inputs state) (v_n547 inputs state))

-- n549 : concat
def v_n549 (inputs : Inputs) (state : State) : BitVec 10 := (BitVec.append (v_n529 inputs state) (v_n548 inputs state))

-- n550 : concat
def v_n550 (inputs : Inputs) (state : State) : BitVec 11 := (BitVec.append (v_n529 inputs state) (v_n549 inputs state))

-- n551 : concat
def v_n551 (inputs : Inputs) (state : State) : BitVec 12 := (BitVec.append (v_n529 inputs state) (v_n550 inputs state))

-- n552 : concat
def v_n552 (inputs : Inputs) (state : State) : BitVec 13 := (BitVec.append (v_n529 inputs state) (v_n551 inputs state))

-- n553 : concat
def v_n553 (inputs : Inputs) (state : State) : BitVec 14 := (BitVec.append (v_n529 inputs state) (v_n552 inputs state))

-- n554 : concat
def v_n554 (inputs : Inputs) (state : State) : BitVec 15 := (BitVec.append (v_n529 inputs state) (v_n553 inputs state))

-- n555 : concat
def v_n555 (inputs : Inputs) (state : State) : BitVec 16 := (BitVec.append (v_n529 inputs state) (v_n554 inputs state))

-- n556 : concat
def v_n556 (inputs : Inputs) (state : State) : BitVec 17 := (BitVec.append (v_n529 inputs state) (v_n555 inputs state))

-- n557 : concat
def v_n557 (inputs : Inputs) (state : State) : BitVec 18 := (BitVec.append (v_n529 inputs state) (v_n556 inputs state))

-- n558 : concat
def v_n558 (inputs : Inputs) (state : State) : BitVec 19 := (BitVec.append (v_n529 inputs state) (v_n557 inputs state))

-- n559 : concat
def v_n559 (inputs : Inputs) (state : State) : BitVec 20 := (BitVec.append (v_n529 inputs state) (v_n558 inputs state))

-- n560 : concat
def v_n560 (inputs : Inputs) (state : State) : BitVec 21 := (BitVec.append (v_n529 inputs state) (v_n559 inputs state))

-- n561 : concat
def v_n561 (inputs : Inputs) (state : State) : BitVec 22 := (BitVec.append (v_n529 inputs state) (v_n560 inputs state))

-- n562 : concat
def v_n562 (inputs : Inputs) (state : State) : BitVec 23 := (BitVec.append (v_n529 inputs state) (v_n561 inputs state))

-- n563 : concat
def v_n563 (inputs : Inputs) (state : State) : BitVec 24 := (BitVec.append (v_n529 inputs state) (v_n562 inputs state))

-- n564 : concat
def v_n564 (inputs : Inputs) (state : State) : BitVec 25 := (BitVec.append (v_n529 inputs state) (v_n563 inputs state))

-- n565 : concat
def v_n565 (inputs : Inputs) (state : State) : BitVec 26 := (BitVec.append (v_n529 inputs state) (v_n564 inputs state))

-- n566 : concat
def v_n566 (inputs : Inputs) (state : State) : BitVec 27 := (BitVec.append (v_n529 inputs state) (v_n565 inputs state))

-- n567 : concat
def v_n567 (inputs : Inputs) (state : State) : BitVec 28 := (BitVec.append (v_n529 inputs state) (v_n566 inputs state))

-- n568 : concat
def v_n568 (inputs : Inputs) (state : State) : BitVec 29 := (BitVec.append (v_n529 inputs state) (v_n567 inputs state))

-- n569 : concat
def v_n569 (inputs : Inputs) (state : State) : BitVec 30 := (BitVec.append (v_n529 inputs state) (v_n568 inputs state))

-- n570 : concat
def v_n570 (inputs : Inputs) (state : State) : BitVec 31 := (BitVec.append (v_n529 inputs state) (v_n569 inputs state))

-- $flatten\cpu.$0$memwr$\regfile$examples/riscv/upstream/nerv/nerv.sv:428$1_EN[31:0]$80 : concat; src: examples/riscv/upstream/nerv/nerv.sv:381.2-440.5
def v_n571 (inputs : Inputs) (state : State) : BitVec 32 := (BitVec.append (v_n529 inputs state) (v_n570 inputs state))

-- n572 : slice
def v_n572 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 0 1 (v_n571 inputs state))

-- $memory\cpu.regfile$wren[0][0][0]$1761$\Y : bitwise_and
def v_n573 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n540 inputs state) &&& (v_n572 inputs state))

-- $auto$rtlil.cc:3339:Mux$2273 : mux
def v_n574 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n573 inputs state) == 1 then (v_n479 inputs state) else (v_n4 inputs state))

-- $auto$rtlil.cc:3251:And$1768 : bitwise_and
def v_n575 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n487 inputs state) &&& (v_n533 inputs state))

-- $auto$rtlil.cc:3251:And$1770 : bitwise_and
def v_n576 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n575 inputs state) &&& (v_n539 inputs state))

-- $memory\cpu.regfile$wren[1][0][0]$1771$\Y : bitwise_and
def v_n577 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n576 inputs state) &&& (v_n572 inputs state))

-- $auto$rtlil.cc:3339:Mux$2271 : mux
def v_n578 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n577 inputs state) == 1 then (v_n479 inputs state) else (v_n5 inputs state))

-- $auto$rtlil.cc:3251:And$1778 : bitwise_and
def v_n579 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n532 inputs state) &&& (v_n488 inputs state))

-- $auto$rtlil.cc:3251:And$1780 : bitwise_and
def v_n580 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n579 inputs state) &&& (v_n539 inputs state))

-- $memory\cpu.regfile$wren[2][0][0]$1781$\Y : bitwise_and
def v_n581 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n580 inputs state) &&& (v_n572 inputs state))

-- $auto$rtlil.cc:3339:Mux$2269 : mux
def v_n582 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n581 inputs state) == 1 then (v_n479 inputs state) else (v_n9 inputs state))

-- $auto$rtlil.cc:3251:And$1788 : bitwise_and
def v_n583 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n489 inputs state) &&& (v_n539 inputs state))

-- $memory\cpu.regfile$wren[3][0][0]$1789$\Y : bitwise_and
def v_n584 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n583 inputs state) &&& (v_n572 inputs state))

-- $auto$rtlil.cc:3339:Mux$2267 : mux
def v_n585 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n584 inputs state) == 1 then (v_n479 inputs state) else (v_n10 inputs state))

-- $auto$rtlil.cc:3251:And$1796 : bitwise_and
def v_n586 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n490 inputs state) &&& (v_n538 inputs state))

-- $auto$rtlil.cc:3251:And$1798 : bitwise_and
def v_n587 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n534 inputs state) &&& (v_n586 inputs state))

-- $memory\cpu.regfile$wren[4][0][0]$1799$\Y : bitwise_and
def v_n588 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n587 inputs state) &&& (v_n572 inputs state))

-- $auto$rtlil.cc:3339:Mux$2265 : mux
def v_n589 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n588 inputs state) == 1 then (v_n479 inputs state) else (v_n14 inputs state))

-- $auto$rtlil.cc:3251:And$1804 : bitwise_and
def v_n590 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n575 inputs state) &&& (v_n586 inputs state))

-- $memory\cpu.regfile$wren[5][0][0]$1805$\Y : bitwise_and
def v_n591 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n590 inputs state) &&& (v_n572 inputs state))

-- $auto$rtlil.cc:3339:Mux$2263 : mux
def v_n592 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n591 inputs state) == 1 then (v_n479 inputs state) else (v_n15 inputs state))

-- $auto$rtlil.cc:3251:And$1810 : bitwise_and
def v_n593 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n579 inputs state) &&& (v_n586 inputs state))

-- $memory\cpu.regfile$wren[6][0][0]$1811$\Y : bitwise_and
def v_n594 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n593 inputs state) &&& (v_n572 inputs state))

-- $auto$rtlil.cc:3339:Mux$2261 : mux
def v_n595 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n594 inputs state) == 1 then (v_n479 inputs state) else (v_n17 inputs state))

-- $auto$rtlil.cc:3251:And$1816 : bitwise_and
def v_n596 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n489 inputs state) &&& (v_n586 inputs state))

-- $memory\cpu.regfile$wren[7][0][0]$1817$\Y : bitwise_and
def v_n597 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n596 inputs state) &&& (v_n572 inputs state))

-- $auto$rtlil.cc:3339:Mux$2259 : mux
def v_n598 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n597 inputs state) == 1 then (v_n479 inputs state) else (v_n18 inputs state))

-- $auto$rtlil.cc:3251:And$1824 : bitwise_and
def v_n599 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n491 inputs state) &&& (v_n537 inputs state))

-- $auto$rtlil.cc:3251:And$1826 : bitwise_and
def v_n600 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n535 inputs state) &&& (v_n599 inputs state))

-- $auto$rtlil.cc:3251:And$1828 : bitwise_and
def v_n601 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n534 inputs state) &&& (v_n600 inputs state))

-- $memory\cpu.regfile$wren[8][0][0]$1829$\Y : bitwise_and
def v_n602 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n601 inputs state) &&& (v_n572 inputs state))

-- $auto$rtlil.cc:3339:Mux$2257 : mux
def v_n603 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n602 inputs state) == 1 then (v_n479 inputs state) else (v_n23 inputs state))

-- $auto$rtlil.cc:3251:And$1834 : bitwise_and
def v_n604 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n575 inputs state) &&& (v_n600 inputs state))

-- $memory\cpu.regfile$wren[9][0][0]$1835$\Y : bitwise_and
def v_n605 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n604 inputs state) &&& (v_n572 inputs state))

-- $auto$rtlil.cc:3339:Mux$2255 : mux
def v_n606 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n605 inputs state) == 1 then (v_n479 inputs state) else (v_n24 inputs state))

-- $auto$rtlil.cc:3251:And$1840 : bitwise_and
def v_n607 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n579 inputs state) &&& (v_n600 inputs state))

-- $memory\cpu.regfile$wren[10][0][0]$1841$\Y : bitwise_and
def v_n608 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n607 inputs state) &&& (v_n572 inputs state))

-- $auto$rtlil.cc:3339:Mux$2253 : mux
def v_n609 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n608 inputs state) == 1 then (v_n479 inputs state) else (v_n26 inputs state))

-- $auto$rtlil.cc:3251:And$1846 : bitwise_and
def v_n610 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n489 inputs state) &&& (v_n600 inputs state))

-- $memory\cpu.regfile$wren[11][0][0]$1847$\Y : bitwise_and
def v_n611 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n610 inputs state) &&& (v_n572 inputs state))

-- $auto$rtlil.cc:3339:Mux$2251 : mux
def v_n612 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n611 inputs state) == 1 then (v_n479 inputs state) else (v_n27 inputs state))

-- $auto$rtlil.cc:3251:And$1852 : bitwise_and
def v_n613 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n490 inputs state) &&& (v_n599 inputs state))

-- $auto$rtlil.cc:3251:And$1854 : bitwise_and
def v_n614 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n534 inputs state) &&& (v_n613 inputs state))

-- $memory\cpu.regfile$wren[12][0][0]$1855$\Y : bitwise_and
def v_n615 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n614 inputs state) &&& (v_n572 inputs state))

-- $auto$rtlil.cc:3339:Mux$2249 : mux
def v_n616 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n615 inputs state) == 1 then (v_n479 inputs state) else (v_n30 inputs state))

-- $auto$rtlil.cc:3251:And$1860 : bitwise_and
def v_n617 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n575 inputs state) &&& (v_n613 inputs state))

-- $memory\cpu.regfile$wren[13][0][0]$1861$\Y : bitwise_and
def v_n618 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n617 inputs state) &&& (v_n572 inputs state))

-- $auto$rtlil.cc:3339:Mux$2247 : mux
def v_n619 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n618 inputs state) == 1 then (v_n479 inputs state) else (v_n31 inputs state))

-- $auto$rtlil.cc:3251:And$1866 : bitwise_and
def v_n620 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n579 inputs state) &&& (v_n613 inputs state))

-- $memory\cpu.regfile$wren[14][0][0]$1867$\Y : bitwise_and
def v_n621 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n620 inputs state) &&& (v_n572 inputs state))

-- $auto$rtlil.cc:3339:Mux$2245 : mux
def v_n622 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n621 inputs state) == 1 then (v_n479 inputs state) else (v_n33 inputs state))

-- $auto$rtlil.cc:3251:And$1872 : bitwise_and
def v_n623 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n489 inputs state) &&& (v_n613 inputs state))

-- $memory\cpu.regfile$wren[15][0][0]$1873$\Y : bitwise_and
def v_n624 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n623 inputs state) &&& (v_n572 inputs state))

-- $auto$rtlil.cc:3339:Mux$2243 : mux
def v_n625 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n624 inputs state) == 1 then (v_n479 inputs state) else (v_n34 inputs state))

-- $auto$rtlil.cc:3251:And$1880 : bitwise_and
def v_n626 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n536 inputs state) &&& (v_n492 inputs state))

-- $auto$rtlil.cc:3251:And$1882 : bitwise_and
def v_n627 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n535 inputs state) &&& (v_n626 inputs state))

-- $auto$rtlil.cc:3251:And$1884 : bitwise_and
def v_n628 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n534 inputs state) &&& (v_n627 inputs state))

-- $memory\cpu.regfile$wren[16][0][0]$1885$\Y : bitwise_and
def v_n629 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n628 inputs state) &&& (v_n572 inputs state))

-- $auto$rtlil.cc:3339:Mux$2241 : mux
def v_n630 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n629 inputs state) == 1 then (v_n479 inputs state) else (v_n40 inputs state))

-- $auto$rtlil.cc:3251:And$1890 : bitwise_and
def v_n631 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n575 inputs state) &&& (v_n627 inputs state))

-- $memory\cpu.regfile$wren[17][0][0]$1891$\Y : bitwise_and
def v_n632 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n631 inputs state) &&& (v_n572 inputs state))

-- $auto$rtlil.cc:3339:Mux$2239 : mux
def v_n633 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n632 inputs state) == 1 then (v_n479 inputs state) else (v_n41 inputs state))

-- $auto$rtlil.cc:3251:And$1896 : bitwise_and
def v_n634 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n579 inputs state) &&& (v_n627 inputs state))

-- $memory\cpu.regfile$wren[18][0][0]$1897$\Y : bitwise_and
def v_n635 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n634 inputs state) &&& (v_n572 inputs state))

-- $auto$rtlil.cc:3339:Mux$2237 : mux
def v_n636 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n635 inputs state) == 1 then (v_n479 inputs state) else (v_n43 inputs state))

-- $auto$rtlil.cc:3251:And$1902 : bitwise_and
def v_n637 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n489 inputs state) &&& (v_n627 inputs state))

-- $memory\cpu.regfile$wren[19][0][0]$1903$\Y : bitwise_and
def v_n638 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n637 inputs state) &&& (v_n572 inputs state))

-- $auto$rtlil.cc:3339:Mux$2235 : mux
def v_n639 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n638 inputs state) == 1 then (v_n479 inputs state) else (v_n44 inputs state))

-- $auto$rtlil.cc:3251:And$1908 : bitwise_and
def v_n640 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n490 inputs state) &&& (v_n626 inputs state))

-- $auto$rtlil.cc:3251:And$1910 : bitwise_and
def v_n641 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n534 inputs state) &&& (v_n640 inputs state))

-- $memory\cpu.regfile$wren[20][0][0]$1911$\Y : bitwise_and
def v_n642 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n641 inputs state) &&& (v_n572 inputs state))

-- $auto$rtlil.cc:3339:Mux$2233 : mux
def v_n643 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n642 inputs state) == 1 then (v_n479 inputs state) else (v_n47 inputs state))

-- $auto$rtlil.cc:3251:And$1916 : bitwise_and
def v_n644 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n575 inputs state) &&& (v_n640 inputs state))

-- $memory\cpu.regfile$wren[21][0][0]$1917$\Y : bitwise_and
def v_n645 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n644 inputs state) &&& (v_n572 inputs state))

-- $auto$rtlil.cc:3339:Mux$2231 : mux
def v_n646 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n645 inputs state) == 1 then (v_n479 inputs state) else (v_n48 inputs state))

-- $auto$rtlil.cc:3251:And$1922 : bitwise_and
def v_n647 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n579 inputs state) &&& (v_n640 inputs state))

-- $memory\cpu.regfile$wren[22][0][0]$1923$\Y : bitwise_and
def v_n648 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n647 inputs state) &&& (v_n572 inputs state))

-- $auto$rtlil.cc:3339:Mux$2229 : mux
def v_n649 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n648 inputs state) == 1 then (v_n479 inputs state) else (v_n50 inputs state))

-- $auto$memory_map.cc:100:addr_decode$1927$\Y : bitwise_and
def v_n650 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n489 inputs state) &&& (v_n640 inputs state))

-- $memory\cpu.regfile$wren[23][0][0]$1929$\Y : bitwise_and
def v_n651 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n650 inputs state) &&& (v_n572 inputs state))

-- $auto$rtlil.cc:3339:Mux$2227 : mux
def v_n652 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n651 inputs state) == 1 then (v_n479 inputs state) else (v_n51 inputs state))

-- $auto$memory_map.cc:100:addr_decode$1935$\Y : bitwise_and
def v_n653 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n535 inputs state) &&& (v_n493 inputs state))

-- $auto$memory_map.cc:100:addr_decode$1937$\Y : bitwise_and
def v_n654 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n534 inputs state) &&& (v_n653 inputs state))

-- $memory\cpu.regfile$wren[24][0][0]$1939$\Y : bitwise_and
def v_n655 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n654 inputs state) &&& (v_n572 inputs state))

-- $auto$rtlil.cc:3339:Mux$2225 : mux
def v_n656 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n655 inputs state) == 1 then (v_n479 inputs state) else (v_n55 inputs state))

-- $auto$memory_map.cc:100:addr_decode$1943$\Y : bitwise_and
def v_n657 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n575 inputs state) &&& (v_n653 inputs state))

-- $memory\cpu.regfile$wren[25][0][0]$1945$\Y : bitwise_and
def v_n658 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n657 inputs state) &&& (v_n572 inputs state))

-- $auto$rtlil.cc:3339:Mux$2223 : mux
def v_n659 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n658 inputs state) == 1 then (v_n479 inputs state) else (v_n56 inputs state))

-- $auto$memory_map.cc:100:addr_decode$1949$\Y : bitwise_and
def v_n660 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n579 inputs state) &&& (v_n653 inputs state))

-- $memory\cpu.regfile$wren[26][0][0]$1951$\Y : bitwise_and
def v_n661 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n660 inputs state) &&& (v_n572 inputs state))

-- $auto$rtlil.cc:3339:Mux$2221 : mux
def v_n662 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n661 inputs state) == 1 then (v_n479 inputs state) else (v_n58 inputs state))

-- $auto$memory_map.cc:100:addr_decode$1955$\Y : bitwise_and
def v_n663 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n489 inputs state) &&& (v_n653 inputs state))

-- $memory\cpu.regfile$wren[27][0][0]$1957$\Y : bitwise_and
def v_n664 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n663 inputs state) &&& (v_n572 inputs state))

-- $auto$rtlil.cc:3339:Mux$2219 : mux
def v_n665 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n664 inputs state) == 1 then (v_n479 inputs state) else (v_n59 inputs state))

-- $auto$memory_map.cc:100:addr_decode$1963$\Y : bitwise_and
def v_n666 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n534 inputs state) &&& (v_n494 inputs state))

-- $memory\cpu.regfile$wren[28][0][0]$1965$\Y : bitwise_and
def v_n667 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n666 inputs state) &&& (v_n572 inputs state))

-- $auto$rtlil.cc:3339:Mux$2217 : mux
def v_n668 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n667 inputs state) == 1 then (v_n479 inputs state) else (v_n62 inputs state))

-- $auto$rtlil.cc:3251:And$1970 : bitwise_and
def v_n669 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n575 inputs state) &&& (v_n494 inputs state))

-- $memory\cpu.regfile$wren[29][0][0]$1971$\Y : bitwise_and
def v_n670 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n669 inputs state) &&& (v_n572 inputs state))

-- $auto$rtlil.cc:3339:Mux$2215 : mux
def v_n671 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n670 inputs state) == 1 then (v_n479 inputs state) else (v_n63 inputs state))

-- $auto$memory_map.cc:100:addr_decode$1975$\Y : bitwise_and
def v_n672 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n579 inputs state) &&& (v_n494 inputs state))

-- $memory\cpu.regfile$wren[30][0][0]$1977$\Y : bitwise_and
def v_n673 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n672 inputs state) &&& (v_n572 inputs state))

-- $auto$rtlil.cc:3339:Mux$2213 : mux
def v_n674 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n673 inputs state) == 1 then (v_n479 inputs state) else (v_n65 inputs state))

-- $auto$setundef.cc:552:execute$2414$\Y : input
def v_n675 (inputs : Inputs) (state : State) : BitVec 5 := inputs.v__auto_setundef_cc_552_execute_2414

-- $auto$setundef.cc:552:execute$2386$\Y : input
def v_n676 (inputs : Inputs) (state : State) : BitVec 5 := inputs.v__auto_setundef_cc_552_execute_2386

-- n677 : slice
def v_n677 (inputs : Inputs) (state : State) : BitVec 2 := (BitVec.extractLsb' 0 2 (v_n213 inputs state))

-- n678 : concat
def v_n678 (inputs : Inputs) (state : State) : BitVec 5 := (BitVec.append (v_n677 inputs state) (v_n141 inputs state))

-- n679 : concat
def v_n679 (inputs : Inputs) (state : State) : BitVec 2 := (BitVec.append (v_n391 inputs state) (v_n262 inputs state))

-- n680 : slice
def v_n680 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 0 1 (v_n213 inputs state))

-- n681 : concat
def v_n681 (inputs : Inputs) (state : State) : BitVec 4 := (BitVec.append (v_n141 inputs state) (v_n680 inputs state))

-- $const4b0010 : constant
def v_n682 (inputs : Inputs) (state : State) : BitVec 4 := (0b0010 : BitVec 4)

-- $flatten\cpu.$procmux$958_CMP1$\Y : equal
def v_n683 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n681 inputs state) == (v_n682 inputs state)))

-- n684 : concat
def v_n684 (inputs : Inputs) (state : State) : BitVec 3 := (BitVec.append (v_n683 inputs state) (v_n679 inputs state))

-- n685 : concat
def v_n685 (inputs : Inputs) (state : State) : BitVec 5 := (BitVec.append (v_n141 inputs state) (v_n677 inputs state))

-- $const5b01000 : constant
def v_n686 (inputs : Inputs) (state : State) : BitVec 5 := (0b01000 : BitVec 5)

-- $flatten\cpu.$procmux$958_CMP2$\Y : equal
def v_n687 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n685 inputs state) == (v_n686 inputs state)))

-- n688 : concat
def v_n688 (inputs : Inputs) (state : State) : BitVec 4 := (BitVec.append (v_n687 inputs state) (v_n684 inputs state))

-- $const4b1010 : constant
def v_n689 (inputs : Inputs) (state : State) : BitVec 4 := (0b1010 : BitVec 4)

-- $flatten\cpu.$procmux$958_CMP4$\Y : equal
def v_n690 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n681 inputs state) == (v_n689 inputs state)))

-- n691 : concat
def v_n691 (inputs : Inputs) (state : State) : BitVec 5 := (BitVec.append (v_n690 inputs state) (v_n688 inputs state))

-- $flatten\cpu.$procmux$958_ANY$\Y : reduce_or
def v_n692 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n691 inputs state) != 0))

-- $flatten\cpu.$procmux$966$\Y : mux
def v_n693 (inputs : Inputs) (state : State) : BitVec 5 := (if (v_n692 inputs state) == 1 then (v_n678 inputs state) else (v_n676 inputs state))

-- $const7b0000011 : constant
def v_n694 (inputs : Inputs) (state : State) : BitVec 7 := (0b0000011 : BitVec 7)

-- $flatten\cpu.$procmux$960_CMP0$\Y : equal
def v_n695 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n274 inputs state) == (v_n694 inputs state)))

-- cpu.mem_rd_func : mux; src: examples/riscv/upstream/nerv/nerv.sv:73.12-73.23
def v_cpu_mem_rd_func (inputs : Inputs) (state : State) : BitVec 5 := (if (v_n695 inputs state) == 1 then (v_n693 inputs state) else (v_n675 inputs state))

-- $auto$rtlil.cc:3339:Mux$2285 : mux
def v_n697 (inputs : Inputs) (state : State) : BitVec 5 := (if (v_stall inputs state) == 1 then (v_n311 inputs state) else (v_cpu_mem_rd_func inputs state))

-- $auto$ff.cc:337:slice$1456$\Q : state
def v_n698 (inputs : Inputs) (state : State) : BitVec 1 := state.v_cpu_rvfi_pre_valid

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:391$logic_not$91_Y : bitwise_not; src: examples/riscv/upstream/nerv/nerv.sv:391.22-391.38
def v_n699 (inputs : Inputs) (state : State) : BitVec 1 := (~~~(v_n384 inputs state))

-- $auto$ff.cc:592:unmap_ce$2336$\Y : mux
def v_n700 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n478 inputs state) == 1 then (v_n699 inputs state) else (v_n698 inputs state))

-- $auto$rtlil.cc:3339:Mux$2339 : mux
def v_n701 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n466 inputs state) == 1 then (v_n386 inputs state) else (v_n700 inputs state))

-- n702 : slice
def v_n702 (inputs : Inputs) (state : State) : BitVec 10 := (BitVec.extractLsb' 21 10 (v_imem_data inputs state))

-- n703 : concat
def v_n703 (inputs : Inputs) (state : State) : BitVec 11 := (BitVec.append (v_n702 inputs state) (v_n386 inputs state))

-- n704 : concat
def v_n704 (inputs : Inputs) (state : State) : BitVec 12 := (BitVec.append (v_n76 inputs state) (v_n703 inputs state))

-- n705 : slice
def v_n705 (inputs : Inputs) (state : State) : BitVec 8 := (BitVec.extractLsb' 12 8 (v_imem_data inputs state))

-- n706 : concat
def v_n706 (inputs : Inputs) (state : State) : BitVec 20 := (BitVec.append (v_n705 inputs state) (v_n704 inputs state))

-- n707 : concat
def v_n707 (inputs : Inputs) (state : State) : BitVec 21 := (BitVec.append (v_n147 inputs state) (v_n706 inputs state))

-- n708 : concat
def v_n708 (inputs : Inputs) (state : State) : BitVec 22 := (BitVec.append (v_n147 inputs state) (v_n707 inputs state))

-- n709 : concat
def v_n709 (inputs : Inputs) (state : State) : BitVec 23 := (BitVec.append (v_n147 inputs state) (v_n708 inputs state))

-- n710 : concat
def v_n710 (inputs : Inputs) (state : State) : BitVec 24 := (BitVec.append (v_n147 inputs state) (v_n709 inputs state))

-- n711 : concat
def v_n711 (inputs : Inputs) (state : State) : BitVec 25 := (BitVec.append (v_n147 inputs state) (v_n710 inputs state))

-- n712 : concat
def v_n712 (inputs : Inputs) (state : State) : BitVec 26 := (BitVec.append (v_n147 inputs state) (v_n711 inputs state))

-- n713 : concat
def v_n713 (inputs : Inputs) (state : State) : BitVec 27 := (BitVec.append (v_n147 inputs state) (v_n712 inputs state))

-- n714 : concat
def v_n714 (inputs : Inputs) (state : State) : BitVec 28 := (BitVec.append (v_n147 inputs state) (v_n713 inputs state))

-- n715 : concat
def v_n715 (inputs : Inputs) (state : State) : BitVec 29 := (BitVec.append (v_n147 inputs state) (v_n714 inputs state))

-- n716 : concat
def v_n716 (inputs : Inputs) (state : State) : BitVec 30 := (BitVec.append (v_n147 inputs state) (v_n715 inputs state))

-- n717 : concat
def v_n717 (inputs : Inputs) (state : State) : BitVec 31 := (BitVec.append (v_n147 inputs state) (v_n716 inputs state))

-- n718 : concat
def v_n718 (inputs : Inputs) (state : State) : BitVec 32 := (BitVec.append (v_n147 inputs state) (v_n717 inputs state))

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:230$add$25$\Y : add
def v_n719 (inputs : Inputs) (state : State) : BitVec 32 := ((v_n258 inputs state) + (v_n718 inputs state))

-- n720 : slice
def v_n720 (inputs : Inputs) (state : State) : BitVec 2 := (BitVec.extractLsb' 0 2 (v_n719 inputs state))

-- $const30b000000000000000000000000000000 : constant
def v_n721 (inputs : Inputs) (state : State) : BitVec 30 := (0b000000000000000000000000000000 : BitVec 30)

-- n722 : concat
def v_n722 (inputs : Inputs) (state : State) : BitVec 32 := (BitVec.append (v_n721 inputs state) (v_n720 inputs state))

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:231$reduce_bool$27_Y : reduce_or; src: examples/riscv/upstream/nerv/nerv.sv:231.23-231.23
def v_n723 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n722 inputs state) != 0))

-- $flatten\cpu.$procmux$1226$\Y : mux
def v_n724 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n723 inputs state) == 1 then (v_n387 inputs state) else (v_n386 inputs state))

-- n725 : concat
def v_n725 (inputs : Inputs) (state : State) : BitVec 2 := (BitVec.append (v_n724 inputs state) (v_n386 inputs state))

-- $flatten\cpu.$3\illinsn[0:0] : mux; src: examples/riscv/upstream/nerv/nerv.sv:195.2-359.5
def v_n726 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n262 inputs state) == 1 then (v_n386 inputs state) else (v_n387 inputs state))

-- $auto$setundef.cc:552:execute$2404$\Y : input
def v_n727 (inputs : Inputs) (state : State) : BitVec 32 := inputs.v__auto_setundef_cc_552_execute_2404

-- n728 : slice
def v_n728 (inputs : Inputs) (state : State) : BitVec 31 := (BitVec.extractLsb' 1 31 (v_n213 inputs state))

-- n729 : concat
def v_n729 (inputs : Inputs) (state : State) : BitVec 32 := (BitVec.append (v_n728 inputs state) (v_n386 inputs state))

-- $flatten\cpu.$procmux$1169$\Y : mux
def v_n730 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n262 inputs state) == 1 then (v_n729 inputs state) else (v_n260 inputs state))

-- $flatten\cpu.$3\npc[31:0] : mux; src: examples/riscv/upstream/nerv/nerv.sv:195.2-359.5
def v_n731 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n281 inputs state) == 1 then (v_n730 inputs state) else (v_n727 inputs state))

-- n732 : slice
def v_n732 (inputs : Inputs) (state : State) : BitVec 2 := (BitVec.extractLsb' 0 2 (v_n731 inputs state))

-- n733 : concat
def v_n733 (inputs : Inputs) (state : State) : BitVec 32 := (BitVec.append (v_n721 inputs state) (v_n732 inputs state))

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:246$reduce_bool$32_Y : reduce_or; src: examples/riscv/upstream/nerv/nerv.sv:246.23-246.23
def v_n734 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n733 inputs state) != 0))

-- $flatten\cpu.$procmux$1158$\Y : mux
def v_n735 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n734 inputs state) == 1 then (v_n387 inputs state) else (v_n726 inputs state))

-- n736 : concat
def v_n736 (inputs : Inputs) (state : State) : BitVec 3 := (BitVec.append (v_n735 inputs state) (v_n725 inputs state))

-- $const3b001 : constant
def v_n737 (inputs : Inputs) (state : State) : BitVec 3 := (0b001 : BitVec 3)

-- $flatten\cpu.$procmux$1089_CMP : equal
def v_n738 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n141 inputs state) == (v_n737 inputs state)))

-- n739 : concat
def v_n739 (inputs : Inputs) (state : State) : BitVec 2 := (BitVec.append (v_n738 inputs state) (v_n262 inputs state))

-- n740 : concat
def v_n740 (inputs : Inputs) (state : State) : BitVec 3 := (BitVec.append (v_n391 inputs state) (v_n739 inputs state))

-- $const3b101 : constant
def v_n741 (inputs : Inputs) (state : State) : BitVec 3 := (0b101 : BitVec 3)

-- $flatten\cpu.$procmux$1056_CMP : equal
def v_n742 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n141 inputs state) == (v_n741 inputs state)))

-- n743 : concat
def v_n743 (inputs : Inputs) (state : State) : BitVec 4 := (BitVec.append (v_n742 inputs state) (v_n740 inputs state))

-- n744 : concat
def v_n744 (inputs : Inputs) (state : State) : BitVec 5 := (BitVec.append (v_n394 inputs state) (v_n743 inputs state))

-- n745 : concat
def v_n745 (inputs : Inputs) (state : State) : BitVec 6 := (BitVec.append (v_n397 inputs state) (v_n744 inputs state))

-- $auto$opt_reduce.cc:131:opt_pmux$1447$\Y : reduce_or
def v_n746 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n745 inputs state) != 0))

-- $flatten\cpu.$5\illinsn[0:0] : mux; src: examples/riscv/upstream/nerv/nerv.sv:195.2-359.5
def v_n747 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n746 inputs state) == 1 then (v_n386 inputs state) else (v_n387 inputs state))

-- $auto$setundef.cc:552:execute$2400$\Y : input
def v_n748 (inputs : Inputs) (state : State) : BitVec 32 := inputs.v__auto_setundef_cc_552_execute_2400

-- n749 : slice
def v_n749 (inputs : Inputs) (state : State) : BitVec 4 := (BitVec.extractLsb' 8 4 (v_imem_data inputs state))

-- n750 : concat
def v_n750 (inputs : Inputs) (state : State) : BitVec 5 := (BitVec.append (v_n749 inputs state) (v_n386 inputs state))

-- n751 : slice
def v_n751 (inputs : Inputs) (state : State) : BitVec 6 := (BitVec.extractLsb' 25 6 (v_imem_data inputs state))

-- n752 : concat
def v_n752 (inputs : Inputs) (state : State) : BitVec 11 := (BitVec.append (v_n751 inputs state) (v_n750 inputs state))

-- n753 : slice
def v_n753 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 7 1 (v_imem_data inputs state))

-- n754 : concat
def v_n754 (inputs : Inputs) (state : State) : BitVec 12 := (BitVec.append (v_n753 inputs state) (v_n752 inputs state))

-- n755 : concat
def v_n755 (inputs : Inputs) (state : State) : BitVec 13 := (BitVec.append (v_n147 inputs state) (v_n754 inputs state))

-- n756 : concat
def v_n756 (inputs : Inputs) (state : State) : BitVec 14 := (BitVec.append (v_n147 inputs state) (v_n755 inputs state))

-- n757 : concat
def v_n757 (inputs : Inputs) (state : State) : BitVec 15 := (BitVec.append (v_n147 inputs state) (v_n756 inputs state))

-- n758 : concat
def v_n758 (inputs : Inputs) (state : State) : BitVec 16 := (BitVec.append (v_n147 inputs state) (v_n757 inputs state))

-- n759 : concat
def v_n759 (inputs : Inputs) (state : State) : BitVec 17 := (BitVec.append (v_n147 inputs state) (v_n758 inputs state))

-- n760 : concat
def v_n760 (inputs : Inputs) (state : State) : BitVec 18 := (BitVec.append (v_n147 inputs state) (v_n759 inputs state))

-- n761 : concat
def v_n761 (inputs : Inputs) (state : State) : BitVec 19 := (BitVec.append (v_n147 inputs state) (v_n760 inputs state))

-- n762 : concat
def v_n762 (inputs : Inputs) (state : State) : BitVec 20 := (BitVec.append (v_n147 inputs state) (v_n761 inputs state))

-- n763 : concat
def v_n763 (inputs : Inputs) (state : State) : BitVec 21 := (BitVec.append (v_n147 inputs state) (v_n762 inputs state))

-- n764 : concat
def v_n764 (inputs : Inputs) (state : State) : BitVec 22 := (BitVec.append (v_n147 inputs state) (v_n763 inputs state))

-- n765 : concat
def v_n765 (inputs : Inputs) (state : State) : BitVec 23 := (BitVec.append (v_n147 inputs state) (v_n764 inputs state))

-- n766 : concat
def v_n766 (inputs : Inputs) (state : State) : BitVec 24 := (BitVec.append (v_n147 inputs state) (v_n765 inputs state))

-- n767 : concat
def v_n767 (inputs : Inputs) (state : State) : BitVec 25 := (BitVec.append (v_n147 inputs state) (v_n766 inputs state))

-- n768 : concat
def v_n768 (inputs : Inputs) (state : State) : BitVec 26 := (BitVec.append (v_n147 inputs state) (v_n767 inputs state))

-- n769 : concat
def v_n769 (inputs : Inputs) (state : State) : BitVec 27 := (BitVec.append (v_n147 inputs state) (v_n768 inputs state))

-- n770 : concat
def v_n770 (inputs : Inputs) (state : State) : BitVec 28 := (BitVec.append (v_n147 inputs state) (v_n769 inputs state))

-- n771 : concat
def v_n771 (inputs : Inputs) (state : State) : BitVec 29 := (BitVec.append (v_n147 inputs state) (v_n770 inputs state))

-- n772 : concat
def v_n772 (inputs : Inputs) (state : State) : BitVec 30 := (BitVec.append (v_n147 inputs state) (v_n771 inputs state))

-- n773 : concat
def v_n773 (inputs : Inputs) (state : State) : BitVec 31 := (BitVec.append (v_n147 inputs state) (v_n772 inputs state))

-- n774 : concat
def v_n774 (inputs : Inputs) (state : State) : BitVec 32 := (BitVec.append (v_n147 inputs state) (v_n773 inputs state))

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:254$add$35_Y : add; src: examples/riscv/upstream/nerv/nerv.sv:254.66-254.81
def v_n775 (inputs : Inputs) (state : State) : BitVec 32 := ((v_n258 inputs state) + (v_n774 inputs state))

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:254$eq$34_Y : equal; src: examples/riscv/upstream/nerv/nerv.sv:254.36-254.58
def v_n776 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_cpu_rs1_value inputs state) == (v_cpu_rs2_value inputs state)))

-- $flatten\cpu.$procmux$1104$\Y : mux
def v_n777 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n776 inputs state) == 1 then (v_n775 inputs state) else (v_n260 inputs state))

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:255$ne$36_Y : not_equal; src: examples/riscv/upstream/nerv/nerv.sv:255.36-255.58
def v_n778 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_cpu_rs1_value inputs state) != (v_cpu_rs2_value inputs state)))

-- $flatten\cpu.$procmux$1086$\Y : mux
def v_n779 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n778 inputs state) == 1 then (v_n775 inputs state) else (v_n260 inputs state))

-- n780 : concat
def v_n780 (inputs : Inputs) (state : State) : BitVec 64 := (BitVec.append (v_n779 inputs state) (v_n777 inputs state))

-- n781 : concat
def v_n781 (inputs : Inputs) (state : State) : BitVec 96 := (BitVec.append (v_n260 inputs state) (v_n780 inputs state))

-- n782 : concat
def v_n782 (inputs : Inputs) (state : State) : BitVec 128 := (BitVec.append (v_n260 inputs state) (v_n781 inputs state))

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:256$lt$38_Y : signed_greater_than; src: examples/riscv/upstream/nerv/nerv.sv:256.36-256.75
def v_n783 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool (BitVec.slt (v_cpu_rs1_value inputs state) (v_cpu_rs2_value inputs state)))

-- $flatten\cpu.$procmux$1069$\Y : mux
def v_n784 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n783 inputs state) == 1 then (v_n775 inputs state) else (v_n260 inputs state))

-- n785 : concat
def v_n785 (inputs : Inputs) (state : State) : BitVec 160 := (BitVec.append (v_n784 inputs state) (v_n782 inputs state))

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:257$ge$40_Y : signed_greater_equal; src: examples/riscv/upstream/nerv/nerv.sv:257.36-257.76
def v_n786 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool (BitVec.sle (v_cpu_rs2_value inputs state) (v_cpu_rs1_value inputs state)))

-- $flatten\cpu.$procmux$1053$\Y : mux
def v_n787 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n786 inputs state) == 1 then (v_n775 inputs state) else (v_n260 inputs state))

-- n788 : concat
def v_n788 (inputs : Inputs) (state : State) : BitVec 192 := (BitVec.append (v_n787 inputs state) (v_n785 inputs state))

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:258$lt$42_Y : unsigned_greater_than; src: examples/riscv/upstream/nerv/nerv.sv:258.36-258.57
def v_n789 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool (BitVec.ult (v_cpu_rs1_value inputs state) (v_cpu_rs2_value inputs state)))

-- $flatten\cpu.$procmux$1038$\Y : mux
def v_n790 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n789 inputs state) == 1 then (v_n775 inputs state) else (v_n260 inputs state))

-- n791 : concat
def v_n791 (inputs : Inputs) (state : State) : BitVec 224 := (BitVec.append (v_n790 inputs state) (v_n788 inputs state))

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:259$ge$44_Y : unsigned_greater_equal; src: examples/riscv/upstream/nerv/nerv.sv:259.36-259.58
def v_n792 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool (BitVec.ule (v_cpu_rs2_value inputs state) (v_cpu_rs1_value inputs state)))

-- $flatten\cpu.$procmux$1024$\Y : mux
def v_n793 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n792 inputs state) == 1 then (v_n775 inputs state) else (v_n260 inputs state))

-- n794 : concat
def v_n794 (inputs : Inputs) (state : State) : BitVec 256 := (BitVec.append (v_n793 inputs state) (v_n791 inputs state))

-- n795 : logical_shift_right
def v_n795 (inputs : Inputs) (state : State) : BitVec 256 := ((v_n794 inputs state) >>> (v_n230 inputs state).toNat)

-- $auto$pmux2shiftx.cc:713:execute$2358 : slice
def v_n796 (inputs : Inputs) (state : State) : BitVec 32 := (BitVec.extractLsb' 0 32 (v_n795 inputs state))

-- $const7b1100011 : constant
def v_n797 (inputs : Inputs) (state : State) : BitVec 7 := (0b1100011 : BitVec 7)

-- $flatten\cpu.$procmux$1006_CMP0$\Y : equal
def v_n798 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n274 inputs state) == (v_n797 inputs state)))

-- $flatten\cpu.$5\npc[31:0] : mux; src: examples/riscv/upstream/nerv/nerv.sv:195.2-359.5
def v_n799 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n798 inputs state) == 1 then (v_n796 inputs state) else (v_n748 inputs state))

-- n800 : slice
def v_n800 (inputs : Inputs) (state : State) : BitVec 2 := (BitVec.extractLsb' 0 2 (v_n799 inputs state))

-- n801 : concat
def v_n801 (inputs : Inputs) (state : State) : BitVec 32 := (BitVec.append (v_n721 inputs state) (v_n800 inputs state))

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:262$reduce_bool$47_Y : reduce_or; src: examples/riscv/upstream/nerv/nerv.sv:262.23-262.23
def v_n802 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n801 inputs state) != 0))

-- $flatten\cpu.$procmux$1013$\Y : mux
def v_n803 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n802 inputs state) == 1 then (v_n387 inputs state) else (v_n747 inputs state))

-- n804 : concat
def v_n804 (inputs : Inputs) (state : State) : BitVec 4 := (BitVec.append (v_n803 inputs state) (v_n736 inputs state))

-- $flatten\cpu.$procmux$993$\Y : mux
def v_n805 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n692 inputs state) == 1 then (v_n386 inputs state) else (v_n387 inputs state))

-- n806 : concat
def v_n806 (inputs : Inputs) (state : State) : BitVec 5 := (BitVec.append (v_n805 inputs state) (v_n804 inputs state))

-- n807 : concat
def v_n807 (inputs : Inputs) (state : State) : BitVec 12 := (BitVec.append (v_n405 inputs state) (v_n482 inputs state))

-- n808 : concat
def v_n808 (inputs : Inputs) (state : State) : BitVec 13 := (BitVec.append (v_n147 inputs state) (v_n807 inputs state))

-- n809 : concat
def v_n809 (inputs : Inputs) (state : State) : BitVec 14 := (BitVec.append (v_n147 inputs state) (v_n808 inputs state))

-- n810 : concat
def v_n810 (inputs : Inputs) (state : State) : BitVec 15 := (BitVec.append (v_n147 inputs state) (v_n809 inputs state))

-- n811 : concat
def v_n811 (inputs : Inputs) (state : State) : BitVec 16 := (BitVec.append (v_n147 inputs state) (v_n810 inputs state))

-- n812 : concat
def v_n812 (inputs : Inputs) (state : State) : BitVec 17 := (BitVec.append (v_n147 inputs state) (v_n811 inputs state))

-- n813 : concat
def v_n813 (inputs : Inputs) (state : State) : BitVec 18 := (BitVec.append (v_n147 inputs state) (v_n812 inputs state))

-- n814 : concat
def v_n814 (inputs : Inputs) (state : State) : BitVec 19 := (BitVec.append (v_n147 inputs state) (v_n813 inputs state))

-- n815 : concat
def v_n815 (inputs : Inputs) (state : State) : BitVec 20 := (BitVec.append (v_n147 inputs state) (v_n814 inputs state))

-- n816 : concat
def v_n816 (inputs : Inputs) (state : State) : BitVec 21 := (BitVec.append (v_n147 inputs state) (v_n815 inputs state))

-- n817 : concat
def v_n817 (inputs : Inputs) (state : State) : BitVec 22 := (BitVec.append (v_n147 inputs state) (v_n816 inputs state))

-- n818 : concat
def v_n818 (inputs : Inputs) (state : State) : BitVec 23 := (BitVec.append (v_n147 inputs state) (v_n817 inputs state))

-- n819 : concat
def v_n819 (inputs : Inputs) (state : State) : BitVec 24 := (BitVec.append (v_n147 inputs state) (v_n818 inputs state))

-- n820 : concat
def v_n820 (inputs : Inputs) (state : State) : BitVec 25 := (BitVec.append (v_n147 inputs state) (v_n819 inputs state))

-- n821 : concat
def v_n821 (inputs : Inputs) (state : State) : BitVec 26 := (BitVec.append (v_n147 inputs state) (v_n820 inputs state))

-- n822 : concat
def v_n822 (inputs : Inputs) (state : State) : BitVec 27 := (BitVec.append (v_n147 inputs state) (v_n821 inputs state))

-- n823 : concat
def v_n823 (inputs : Inputs) (state : State) : BitVec 28 := (BitVec.append (v_n147 inputs state) (v_n822 inputs state))

-- n824 : concat
def v_n824 (inputs : Inputs) (state : State) : BitVec 29 := (BitVec.append (v_n147 inputs state) (v_n823 inputs state))

-- n825 : concat
def v_n825 (inputs : Inputs) (state : State) : BitVec 30 := (BitVec.append (v_n147 inputs state) (v_n824 inputs state))

-- n826 : concat
def v_n826 (inputs : Inputs) (state : State) : BitVec 31 := (BitVec.append (v_n147 inputs state) (v_n825 inputs state))

-- n827 : concat
def v_n827 (inputs : Inputs) (state : State) : BitVec 32 := (BitVec.append (v_n147 inputs state) (v_n826 inputs state))

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:286$add$50_Y : add; src: examples/riscv/upstream/nerv/nerv.sv:286.19-286.41
def v_n828 (inputs : Inputs) (state : State) : BitVec 32 := ((v_cpu_rs1_value inputs state) + (v_n827 inputs state))

-- n829 : slice
def v_n829 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 0 1 (v_n828 inputs state))

-- n830 : concat
def v_n830 (inputs : Inputs) (state : State) : BitVec 4 := (BitVec.append (v_n141 inputs state) (v_n829 inputs state))

-- $flatten\cpu.$procmux$909_CMP1$\Y : equal
def v_n831 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n830 inputs state) == (v_n682 inputs state)))

-- n832 : concat
def v_n832 (inputs : Inputs) (state : State) : BitVec 2 := (BitVec.append (v_n831 inputs state) (v_n262 inputs state))

-- n833 : slice
def v_n833 (inputs : Inputs) (state : State) : BitVec 2 := (BitVec.extractLsb' 0 2 (v_n828 inputs state))

-- n834 : concat
def v_n834 (inputs : Inputs) (state : State) : BitVec 5 := (BitVec.append (v_n141 inputs state) (v_n833 inputs state))

-- $flatten\cpu.$procmux$909_CMP2$\Y : equal
def v_n835 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n834 inputs state) == (v_n686 inputs state)))

-- n836 : concat
def v_n836 (inputs : Inputs) (state : State) : BitVec 3 := (BitVec.append (v_n835 inputs state) (v_n832 inputs state))

-- $flatten\cpu.$procmux$909_ANY$\Y : reduce_or
def v_n837 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n836 inputs state) != 0))

-- $flatten\cpu.$procmux$948$\Y : mux
def v_n838 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n837 inputs state) == 1 then (v_n386 inputs state) else (v_n387 inputs state))

-- n839 : concat
def v_n839 (inputs : Inputs) (state : State) : BitVec 6 := (BitVec.append (v_n838 inputs state) (v_n806 inputs state))

-- $flatten\cpu.$procmux$887$\Y : mux
def v_n840 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n416 inputs state) == 1 then (v_n386 inputs state) else (v_n387 inputs state))

-- n841 : concat
def v_n841 (inputs : Inputs) (state : State) : BitVec 7 := (BitVec.append (v_n840 inputs state) (v_n839 inputs state))

-- $flatten\cpu.$procmux$841$\Y : mux
def v_n842 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n442 inputs state) == 1 then (v_n386 inputs state) else (v_n387 inputs state))

-- n843 : concat
def v_n843 (inputs : Inputs) (state : State) : BitVec 8 := (BitVec.append (v_n842 inputs state) (v_n841 inputs state))

-- n844 : slice
def v_n844 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 0 1 (v_n843 inputs state))

-- n845 : concat
def v_n845 (inputs : Inputs) (state : State) : BitVec 2 := (BitVec.append (v_n287 inputs state) (v_n290 inputs state))

-- $auto$opt_reduce.cc:131:opt_pmux$1451$\Y : reduce_or
def v_n846 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n845 inputs state) != 0))

-- n847 : concat
def v_n847 (inputs : Inputs) (state : State) : BitVec 2 := (BitVec.append (v_n284 inputs state) (v_n846 inputs state))

-- n848 : concat
def v_n848 (inputs : Inputs) (state : State) : BitVec 3 := (BitVec.append (v_n281 inputs state) (v_n847 inputs state))

-- n849 : concat
def v_n849 (inputs : Inputs) (state : State) : BitVec 4 := (BitVec.append (v_n798 inputs state) (v_n848 inputs state))

-- n850 : concat
def v_n850 (inputs : Inputs) (state : State) : BitVec 5 := (BitVec.append (v_n695 inputs state) (v_n849 inputs state))

-- $const7b0100011 : constant
def v_n851 (inputs : Inputs) (state : State) : BitVec 7 := (0b0100011 : BitVec 7)

-- $flatten\cpu.$procmux$911_CMP0$\Y : equal
def v_n852 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n274 inputs state) == (v_n851 inputs state)))

-- n853 : concat
def v_n853 (inputs : Inputs) (state : State) : BitVec 6 := (BitVec.append (v_n852 inputs state) (v_n850 inputs state))

-- n854 : concat
def v_n854 (inputs : Inputs) (state : State) : BitVec 7 := (BitVec.append (v_n278 inputs state) (v_n853 inputs state))

-- n855 : concat
def v_n855 (inputs : Inputs) (state : State) : BitVec 8 := (BitVec.append (v_n276 inputs state) (v_n854 inputs state))

-- n856 : slice
def v_n856 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 0 1 (v_n855 inputs state))

-- n857 : mux
def v_n857 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n856 inputs state) == 1 then (v_n844 inputs state) else (v_n387 inputs state))

-- n858 : slice
def v_n858 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 1 1 (v_n843 inputs state))

-- n859 : slice
def v_n859 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 1 1 (v_n855 inputs state))

-- n860 : mux
def v_n860 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n859 inputs state) == 1 then (v_n858 inputs state) else (v_n857 inputs state))

-- n861 : slice
def v_n861 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 2 1 (v_n843 inputs state))

-- n862 : slice
def v_n862 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 2 1 (v_n855 inputs state))

-- n863 : mux
def v_n863 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n862 inputs state) == 1 then (v_n861 inputs state) else (v_n860 inputs state))

-- n864 : slice
def v_n864 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 3 1 (v_n843 inputs state))

-- n865 : slice
def v_n865 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 3 1 (v_n855 inputs state))

-- n866 : mux
def v_n866 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n865 inputs state) == 1 then (v_n864 inputs state) else (v_n863 inputs state))

-- n867 : slice
def v_n867 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 4 1 (v_n843 inputs state))

-- n868 : slice
def v_n868 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 4 1 (v_n855 inputs state))

-- n869 : mux
def v_n869 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n868 inputs state) == 1 then (v_n867 inputs state) else (v_n866 inputs state))

-- n870 : slice
def v_n870 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 5 1 (v_n843 inputs state))

-- n871 : slice
def v_n871 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 5 1 (v_n855 inputs state))

-- n872 : mux
def v_n872 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n871 inputs state) == 1 then (v_n870 inputs state) else (v_n869 inputs state))

-- n873 : slice
def v_n873 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 6 1 (v_n843 inputs state))

-- n874 : slice
def v_n874 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 6 1 (v_n855 inputs state))

-- n875 : mux
def v_n875 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n874 inputs state) == 1 then (v_n873 inputs state) else (v_n872 inputs state))

-- n876 : slice
def v_n876 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 7 1 (v_n843 inputs state))

-- n877 : slice
def v_n877 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 7 1 (v_n855 inputs state))

-- $flatten\cpu.$1\illinsn[0:0] : mux; src: examples/riscv/upstream/nerv/nerv.sv:195.2-359.5
def v_n878 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n877 inputs state) == 1 then (v_n876 inputs state) else (v_n875 inputs state))

-- $flatten\cpu.$procmux$801$\Y : mux
def v_n879 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n384 inputs state) == 1 then (v_n386 inputs state) else (v_n878 inputs state))

-- $flatten\cpu.$procmux$786$\Y : mux
def v_n880 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n466 inputs state) == 1 then (v_n386 inputs state) else (v_n879 inputs state))

-- n881 : concat
def v_n881 (inputs : Inputs) (state : State) : BitVec 2 := (BitVec.append (v_n880 inputs state) (v_n478 inputs state))

-- $auto$simple.cc:216:make_patterns_logic$1459 : reduce_and
def v_n882 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n881 inputs state) == ~~~(0 : BitVec 2)))

-- $auto$ff.cc:592:unmap_ce$2332$\Y : mux
def v_n883 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n882 inputs state) == 1 then (v_n387 inputs state) else (v_cpu_trapped inputs state))

-- $auto$rtlil.cc:3339:Mux$2335 : mux
def v_n884 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n466 inputs state) == 1 then (v_n386 inputs state) else (v_n883 inputs state))

-- $auto$setundef.cc:552:execute$2392$\Y : input
def v_n885 (inputs : Inputs) (state : State) : BitVec 32 := inputs.v__auto_setundef_cc_552_execute_2392

-- $const2b00 : constant
def v_n886 (inputs : Inputs) (state : State) : BitVec 2 := (0b00 : BitVec 2)

-- n887 : slice
def v_n887 (inputs : Inputs) (state : State) : BitVec 30 := (BitVec.extractLsb' 2 30 (v_n799 inputs state))

-- n888 : concat
def v_n888 (inputs : Inputs) (state : State) : BitVec 32 := (BitVec.append (v_n887 inputs state) (v_n886 inputs state))

-- $flatten\cpu.$procmux$1003$\Y : mux
def v_n889 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n802 inputs state) == 1 then (v_n888 inputs state) else (v_n799 inputs state))

-- n890 : slice
def v_n890 (inputs : Inputs) (state : State) : BitVec 30 := (BitVec.extractLsb' 2 30 (v_n731 inputs state))

-- n891 : concat
def v_n891 (inputs : Inputs) (state : State) : BitVec 32 := (BitVec.append (v_n890 inputs state) (v_n886 inputs state))

-- $flatten\cpu.$4\npc[31:0] : mux; src: examples/riscv/upstream/nerv/nerv.sv:195.2-359.5
def v_n892 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n734 inputs state) == 1 then (v_n891 inputs state) else (v_n731 inputs state))

-- n893 : concat
def v_n893 (inputs : Inputs) (state : State) : BitVec 64 := (BitVec.append (v_n892 inputs state) (v_n889 inputs state))

-- $auto$setundef.cc:552:execute$2394$\Y : input
def v_n894 (inputs : Inputs) (state : State) : BitVec 32 := inputs.v__auto_setundef_cc_552_execute_2394

-- n895 : concat
def v_n895 (inputs : Inputs) (state : State) : BitVec 96 := (BitVec.append (v_n894 inputs state) (v_n893 inputs state))

-- n896 : slice
def v_n896 (inputs : Inputs) (state : State) : BitVec 30 := (BitVec.extractLsb' 2 30 (v_n719 inputs state))

-- n897 : concat
def v_n897 (inputs : Inputs) (state : State) : BitVec 32 := (BitVec.append (v_n896 inputs state) (v_n886 inputs state))

-- $flatten\cpu.$2\npc[31:0] : mux; src: examples/riscv/upstream/nerv/nerv.sv:195.2-359.5
def v_n898 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n723 inputs state) == 1 then (v_n897 inputs state) else (v_n719 inputs state))

-- n899 : concat
def v_n899 (inputs : Inputs) (state : State) : BitVec 128 := (BitVec.append (v_n898 inputs state) (v_n895 inputs state))

-- n900 : slice
def v_n900 (inputs : Inputs) (state : State) : BitVec 2 := (BitVec.extractLsb' 2 2 (v_imem_data inputs state))

-- n901 : concat
def v_n901 (inputs : Inputs) (state : State) : BitVec 7 := (BitVec.append (v_n900 inputs state) (v_n140 inputs state))

-- n902 : slice
def v_n902 (inputs : Inputs) (state : State) : BitVec 2 := (BitVec.extractLsb' 0 2 (v_imem_data inputs state))

-- n903 : slice
def v_n903 (inputs : Inputs) (state : State) : BitVec 2 := (BitVec.extractLsb' 5 2 (v_imem_data inputs state))

-- n904 : concat
def v_n904 (inputs : Inputs) (state : State) : BitVec 4 := (BitVec.append (v_n903 inputs state) (v_n902 inputs state))

-- $auto$opt_expr.cc:702:replace_const_cells$2370$\Y : bitwise_not
def v_n905 (inputs : Inputs) (state : State) : BitVec 4 := (~~~(v_n904 inputs state))

-- n906 : slice
def v_n906 (inputs : Inputs) (state : State) : BitVec 2 := (BitVec.extractLsb' 0 2 (v_n905 inputs state))

-- n907 : concat
def v_n907 (inputs : Inputs) (state : State) : BitVec 9 := (BitVec.append (v_n906 inputs state) (v_n901 inputs state))

-- n908 : slice
def v_n908 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 4 1 (v_imem_data inputs state))

-- n909 : concat
def v_n909 (inputs : Inputs) (state : State) : BitVec 10 := (BitVec.append (v_n908 inputs state) (v_n907 inputs state))

-- n910 : slice
def v_n910 (inputs : Inputs) (state : State) : BitVec 2 := (BitVec.extractLsb' 2 2 (v_n905 inputs state))

-- n911 : concat
def v_n911 (inputs : Inputs) (state : State) : BitVec 12 := (BitVec.append (v_n910 inputs state) (v_n909 inputs state))

-- n912 : slice
def v_n912 (inputs : Inputs) (state : State) : BitVec 7 := (BitVec.extractLsb' 0 7 (v_n911 inputs state))

-- n913 : logical_shift_right
def v_n913 (inputs : Inputs) (state : State) : BitVec 128 := ((v_n899 inputs state) >>> (v_n912 inputs state).toNat)

-- n914 : constant
def v_n914 (inputs : Inputs) (state : State) : BitVec 128 := (0b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000 : BitVec 128)

-- n915 : constant
def v_n915 (inputs : Inputs) (state : State) : BitVec 12 := (0b000010000000 : BitVec 12)

-- n916 : unsigned_greater_equal
def v_n916 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool (BitVec.ule (v_n915 inputs state) (v_n911 inputs state)))

-- n917 : mux
def v_n917 (inputs : Inputs) (state : State) : BitVec 128 := (if (v_n916 inputs state) == 1 then (v_n914 inputs state) else (v_n913 inputs state))

-- $auto$pmux2shiftx.cc:714:execute$2367$\Y : slice
def v_n918 (inputs : Inputs) (state : State) : BitVec 32 := (BitVec.extractLsb' 0 32 (v_n917 inputs state))

-- n919 : concat
def v_n919 (inputs : Inputs) (state : State) : BitVec 4 := (BitVec.append (v_n906 inputs state) (v_n900 inputs state))

-- n920 : concat
def v_n920 (inputs : Inputs) (state : State) : BitVec 5 := (BitVec.append (v_n908 inputs state) (v_n919 inputs state))

-- n921 : concat
def v_n921 (inputs : Inputs) (state : State) : BitVec 7 := (BitVec.append (v_n910 inputs state) (v_n920 inputs state))

-- n922 : slice
def v_n922 (inputs : Inputs) (state : State) : BitVec 2 := (BitVec.extractLsb' 0 2 (v_n921 inputs state))

-- n923 : logical_shift_right
def v_n923 (inputs : Inputs) (state : State) : BitVec 4 := ((v_n235 inputs state) >>> (v_n922 inputs state).toNat)

-- n924 : constant
def v_n924 (inputs : Inputs) (state : State) : BitVec 4 := (0b0000 : BitVec 4)

-- n925 : constant
def v_n925 (inputs : Inputs) (state : State) : BitVec 7 := (0b0000100 : BitVec 7)

-- n926 : unsigned_greater_equal
def v_n926 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool (BitVec.ule (v_n925 inputs state) (v_n921 inputs state)))

-- n927 : mux
def v_n927 (inputs : Inputs) (state : State) : BitVec 4 := (if (v_n926 inputs state) == 1 then (v_n924 inputs state) else (v_n923 inputs state))

-- $auto$pmux2shiftx.cc:694:execute$2365$\Y : slice
def v_n928 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 0 1 (v_n927 inputs state))

-- $flatten\cpu.$1\npc[31:0] : mux; src: examples/riscv/upstream/nerv/nerv.sv:195.2-359.5
def v_n929 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n928 inputs state) == 1 then (v_n918 inputs state) else (v_n260 inputs state))

-- $flatten\cpu.$13\npc[31:0] : mux; src: examples/riscv/upstream/nerv/nerv.sv:195.2-359.5
def v_n930 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n384 inputs state) == 1 then (v_n258 inputs state) else (v_n929 inputs state))

-- $flatten\cpu.$procmux$792$\Y : mux
def v_n931 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n466 inputs state) == 1 then (v_n3 inputs state) else (v_n930 inputs state))

-- $flatten\cpu.$procmux$697$\Y : mux
def v_n932 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n478 inputs state) == 1 then (v_n931 inputs state) else (v_n885 inputs state))

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:433$ternary$109$\Y : mux
def v_n933 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_reset inputs state) == 1 then (v_n259 inputs state) else (v_n3 inputs state))

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:433$sub$110$\Y : sub
def v_n934 (inputs : Inputs) (state : State) : BitVec 32 := ((v_n3 inputs state) - (v_n933 inputs state))

-- $flatten\cpu.$procmux$699$\Y : mux
def v_n935 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n466 inputs state) == 1 then (v_n934 inputs state) else (v_n932 inputs state))

-- n936 : concat
def v_n936 (inputs : Inputs) (state : State) : BitVec 2 := (BitVec.append (v_n466 inputs state) (v_n478 inputs state))

-- $auto$simple.cc:200:make_patterns_logic$1463$\Y : reduce_or
def v_n937 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n936 inputs state) != 0))

-- $auto$rtlil.cc:3339:Mux$2331 : mux
def v_n938 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n937 inputs state) == 1 then (v_n935 inputs state) else (v_n258 inputs state))

-- $auto$ff.cc:337:slice$1454$\Q : state
def v_n939 (inputs : Inputs) (state : State) : BitVec 5 := state.v_cpu_rvfi_pre_rd_addr

-- $auto$ff.cc:614:unmap_srst$2340$\Y : mux
def v_n940 (inputs : Inputs) (state : State) : BitVec 5 := (if (v_cpu_next_wr inputs state) == 1 then (v_n482 inputs state) else (v_n140 inputs state))

-- $auto$rtlil.cc:3339:Mux$2343 : mux
def v_n941 (inputs : Inputs) (state : State) : BitVec 5 := (if (v_n478 inputs state) == 1 then (v_n940 inputs state) else (v_n939 inputs state))

-- $auto$setundef.cc:552:execute$2416$\Y : input
def v_n942 (inputs : Inputs) (state : State) : BitVec 5 := inputs.v__auto_setundef_cc_552_execute_2416

-- $auto$setundef.cc:552:execute$2390$\Y : input
def v_n943 (inputs : Inputs) (state : State) : BitVec 5 := inputs.v__auto_setundef_cc_552_execute_2390

-- $flatten\cpu.$procmux$975$\Y : mux
def v_n944 (inputs : Inputs) (state : State) : BitVec 5 := (if (v_n692 inputs state) == 1 then (v_n482 inputs state) else (v_n943 inputs state))

-- cpu.mem_rd_reg : mux; src: examples/riscv/upstream/nerv/nerv.sv:72.12-72.22
def v_cpu_mem_rd_reg (inputs : Inputs) (state : State) : BitVec 5 := (if (v_n695 inputs state) == 1 then (v_n944 inputs state) else (v_n942 inputs state))

-- $auto$rtlil.cc:3339:Mux$2279 : mux
def v_n946 (inputs : Inputs) (state : State) : BitVec 5 := (if (v_stall inputs state) == 1 then (v_n483 inputs state) else (v_cpu_mem_rd_reg inputs state))

-- $auto$ff.cc:337:slice$1492$\Q : state
def v_n947 (inputs : Inputs) (state : State) : BitVec 32 := state.v_cpu_rvfi_pre_rd_wdata

-- n948 : reduce_or
def v_n948 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n482 inputs state) != 0))

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:404$logic_and$95_Y : bitwise_and; src: examples/riscv/upstream/nerv/nerv.sv:404.25-404.43
def v_n949 (inputs : Inputs) (state : State) : BitVec 1 := ((v_cpu_next_wr inputs state) &&& (v_n948 inputs state))

-- $auto$ff.cc:614:unmap_srst$2274$\Y : mux
def v_n950 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n949 inputs state) == 1 then (v_cpu_next_rd inputs state) else (v_n3 inputs state))

-- $auto$rtlil.cc:3339:Mux$2277 : mux
def v_n951 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n478 inputs state) == 1 then (v_n950 inputs state) else (v_n947 inputs state))

-- $flatten\cpu.$procmux$984$\Y : mux
def v_n952 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n692 inputs state) == 1 then (v_n387 inputs state) else (v_n386 inputs state))

-- $flatten\cpu.$1\mem_rd_enable[0:0] : mux; src: examples/riscv/upstream/nerv/nerv.sv:195.2-359.5
def v_n953 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n695 inputs state) == 1 then (v_n952 inputs state) else (v_n386 inputs state))

-- $flatten\cpu.$procmux$798$\Y : mux
def v_n954 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n384 inputs state) == 1 then (v_n386 inputs state) else (v_n953 inputs state))

-- cpu.mem_rd_enable : mux; src: examples/riscv/upstream/nerv/nerv.sv:70.6-70.19
def v_cpu_mem_rd_enable (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n466 inputs state) == 1 then (v_n386 inputs state) else (v_n954 inputs state))

-- $auto$ff.cc:594:unmap_ce$2280$\Y : mux
def v_n956 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_stall inputs state) == 1 then (v_n384 inputs state) else (v_cpu_mem_rd_enable inputs state))

-- $auto$rtlil.cc:3339:Mux$2283 : mux
def v_n957 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_reset inputs state) == 1 then (v_n386 inputs state) else (v_n956 inputs state))

-- $auto$ff.cc:337:slice$1483$\Q : state
def v_n958 (inputs : Inputs) (state : State) : BitVec 32 := state.v_check_insn_insn

-- n959 : slice
def v_n959 (inputs : Inputs) (state : State) : BitVec 7 := (BitVec.extractLsb' 0 7 (v_n958 inputs state))

-- check_insn.spec_rd_addr : slice; src: examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:60.50-60.62
def v_check_insn_spec_rd_addr (inputs : Inputs) (state : State) : BitVec 5 := (BitVec.extractLsb' 7 5 (v_n958 inputs state))

-- n961 : concat
def v_n961 (inputs : Inputs) (state : State) : BitVec 12 := (BitVec.append (v_check_insn_spec_rd_addr inputs state) (v_n959 inputs state))

-- n962 : slice
def v_n962 (inputs : Inputs) (state : State) : BitVec 3 := (BitVec.extractLsb' 12 3 (v_n958 inputs state))

-- n963 : concat
def v_n963 (inputs : Inputs) (state : State) : BitVec 15 := (BitVec.append (v_n962 inputs state) (v_n961 inputs state))

-- check_insn.spec_rs1_addr : slice; src: examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:58.50-58.63
def v_check_insn_spec_rs1_addr (inputs : Inputs) (state : State) : BitVec 5 := (BitVec.extractLsb' 15 5 (v_n958 inputs state))

-- n965 : concat
def v_n965 (inputs : Inputs) (state : State) : BitVec 20 := (BitVec.append (v_check_insn_spec_rs1_addr inputs state) (v_n963 inputs state))

-- check_insn.spec_rs2_addr : slice; src: examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:59.50-59.63
def v_check_insn_spec_rs2_addr (inputs : Inputs) (state : State) : BitVec 5 := (BitVec.extractLsb' 20 5 (v_n958 inputs state))

-- n967 : concat
def v_n967 (inputs : Inputs) (state : State) : BitVec 25 := (BitVec.append (v_check_insn_spec_rs2_addr inputs state) (v_n965 inputs state))

-- n968 : slice
def v_n968 (inputs : Inputs) (state : State) : BitVec 7 := (BitVec.extractLsb' 25 7 (v_n958 inputs state))

-- check_insn.insn : concat; src: examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:26.34-26.38
def v_check_insn_insn (inputs : Inputs) (state : State) : BitVec 32 := (BitVec.append (v_n968 inputs state) (v_n967 inputs state))

-- n970 : slice
def v_n970 (inputs : Inputs) (state : State) : BitVec 7 := (BitVec.extractLsb' 0 7 (v_check_insn_insn inputs state))

-- n971 : concat
def v_n971 (inputs : Inputs) (state : State) : BitVec 12 := (BitVec.append (v_check_insn_spec_rd_addr inputs state) (v_n970 inputs state))

-- n972 : slice
def v_n972 (inputs : Inputs) (state : State) : BitVec 3 := (BitVec.extractLsb' 12 3 (v_check_insn_insn inputs state))

-- n973 : concat
def v_n973 (inputs : Inputs) (state : State) : BitVec 15 := (BitVec.append (v_n972 inputs state) (v_n971 inputs state))

-- n974 : concat
def v_n974 (inputs : Inputs) (state : State) : BitVec 20 := (BitVec.append (v_check_insn_spec_rs1_addr inputs state) (v_n973 inputs state))

-- n975 : concat
def v_n975 (inputs : Inputs) (state : State) : BitVec 25 := (BitVec.append (v_check_insn_spec_rs2_addr inputs state) (v_n974 inputs state))

-- n976 : slice
def v_n976 (inputs : Inputs) (state : State) : BitVec 7 := (BitVec.extractLsb' 25 7 (v_check_insn_insn inputs state))

-- rvfi_insn : concat; src: examples/riscv/NervHarness.sv:6.154-6.163
def v_rvfi_insn (inputs : Inputs) (state : State) : BitVec 32 := (BitVec.append (v_n976 inputs state) (v_n975 inputs state))

-- $auto$rtlil.cc:3339:Mux$2291 : mux
def v_n978 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n478 inputs state) == 1 then (v_imem_data inputs state) else (v_rvfi_insn inputs state))

-- rvfi_trap : state; src: examples/riscv/NervHarness.sv:6.215-6.224
def v_rvfi_trap (inputs : Inputs) (state : State) : BitVec 1 := state.v_check_insn_rvfi_trap

-- $auto$rtlil.cc:3339:Mux$2293 : mux
def v_n980 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n478 inputs state) == 1 then (v_n880 inputs state) else (v_rvfi_trap inputs state))

-- rvfi_halt : state; src: examples/riscv/NervHarness.sv:6.276-6.285
def v_rvfi_halt (inputs : Inputs) (state : State) : BitVec 1 := state.v_check_insn_halt

-- $auto$rtlil.cc:3339:Mux$2295 : mux
def v_n982 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n478 inputs state) == 1 then (v_n880 inputs state) else (v_rvfi_halt inputs state))

-- rvfi_intr : state; src: examples/riscv/NervHarness.sv:6.337-6.346
def v_rvfi_intr (inputs : Inputs) (state : State) : BitVec 1 := state.v_check_insn_intr

-- $auto$rtlil.cc:3339:Mux$2297 : mux
def v_n984 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n478 inputs state) == 1 then (v_n386 inputs state) else (v_rvfi_intr inputs state))

-- rvfi_rs1_addr : state; src: examples/riscv/NervHarness.sv:6.520-6.533
def v_rvfi_rs1_addr (inputs : Inputs) (state : State) : BitVec 5 := state.v_check_insn_rs1_addr

-- $auto$rtlil.cc:3339:Mux$2303 : mux
def v_n986 (inputs : Inputs) (state : State) : BitVec 5 := (if (v_n478 inputs state) == 1 then (v_n72 inputs state) else (v_rvfi_rs1_addr inputs state))

-- rvfi_rs2_addr : state; src: examples/riscv/NervHarness.sv:6.581-6.594
def v_rvfi_rs2_addr (inputs : Inputs) (state : State) : BitVec 5 := state.v_check_insn_rs2_addr

-- $auto$rtlil.cc:3339:Mux$2305 : mux
def v_n988 (inputs : Inputs) (state : State) : BitVec 5 := (if (v_n478 inputs state) == 1 then (v_n112 inputs state) else (v_rvfi_rs2_addr inputs state))

-- rvfi_rs1_rdata : state; src: examples/riscv/NervHarness.sv:6.626-6.640
def v_rvfi_rs1_rdata (inputs : Inputs) (state : State) : BitVec 32 := state.v_check_insn_rs1_rdata

-- $auto$rtlil.cc:3339:Mux$2307 : mux
def v_n990 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n478 inputs state) == 1 then (v_cpu_rs1_value inputs state) else (v_rvfi_rs1_rdata inputs state))

-- rvfi_rs2_rdata : state; src: examples/riscv/NervHarness.sv:6.671-6.685
def v_rvfi_rs2_rdata (inputs : Inputs) (state : State) : BitVec 32 := state.v_check_insn_rs2_rdata

-- $auto$rtlil.cc:3339:Mux$2309 : mux
def v_n992 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n478 inputs state) == 1 then (v_cpu_rs2_value inputs state) else (v_rvfi_rs2_rdata inputs state))

-- rvfi_pc_rdata : state; src: examples/riscv/NervHarness.sv:6.822-6.835
def v_rvfi_pc_rdata (inputs : Inputs) (state : State) : BitVec 32 := state.v_check_insn_insn_spec_rvfi_pc_rdata

-- $auto$rtlil.cc:3339:Mux$2311 : mux
def v_n994 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n478 inputs state) == 1 then (v_n258 inputs state) else (v_rvfi_pc_rdata inputs state))

-- rvfi_pc_wdata : state; src: examples/riscv/NervHarness.sv:6.867-6.880
def v_rvfi_pc_wdata (inputs : Inputs) (state : State) : BitVec 32 := state.v_check_insn_pc_wdata

-- $auto$rtlil.cc:3339:Mux$2313 : mux
def v_n996 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n478 inputs state) == 1 then (v_n931 inputs state) else (v_rvfi_pc_wdata inputs state))

-- rvfi_mem_addr : state; src: examples/riscv/NervHarness.sv:6.912-6.925
def v_rvfi_mem_addr (inputs : Inputs) (state : State) : BitVec 32 := state.v_check_insn_mem_addr

-- $auto$setundef.cc:552:execute$2396$\Y : input
def v_n998 (inputs : Inputs) (state : State) : BitVec 32 := inputs.v__auto_setundef_cc_552_execute_2396

-- $auto$setundef.cc:552:execute$2418$\Y : input
def v_n999 (inputs : Inputs) (state : State) : BitVec 32 := inputs.v__auto_setundef_cc_552_execute_2418

-- n1000 : slice
def v_n1000 (inputs : Inputs) (state : State) : BitVec 30 := (BitVec.extractLsb' 2 30 (v_n213 inputs state))

-- n1001 : concat
def v_n1001 (inputs : Inputs) (state : State) : BitVec 32 := (BitVec.append (v_n1000 inputs state) (v_n886 inputs state))

-- $flatten\cpu.$procmux$957$\Y : mux
def v_n1002 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n692 inputs state) == 1 then (v_n1001 inputs state) else (v_n213 inputs state))

-- cpu.mem_rd_addr : mux; src: examples/riscv/upstream/nerv/nerv.sv:71.13-71.24
def v_cpu_mem_rd_addr (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n695 inputs state) == 1 then (v_n1002 inputs state) else (v_n999 inputs state))

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:93$ternary$5$\Y : mux
def v_n1004 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_cpu_mem_rd_enable inputs state) == 1 then (v_cpu_mem_rd_addr inputs state) else (v_n998 inputs state))

-- $auto$setundef.cc:552:execute$2424$\Y : input
def v_n1005 (inputs : Inputs) (state : State) : BitVec 32 := inputs.v__auto_setundef_cc_552_execute_2424

-- n1006 : slice
def v_n1006 (inputs : Inputs) (state : State) : BitVec 30 := (BitVec.extractLsb' 2 30 (v_n828 inputs state))

-- n1007 : concat
def v_n1007 (inputs : Inputs) (state : State) : BitVec 32 := (BitVec.append (v_n1006 inputs state) (v_n886 inputs state))

-- $flatten\cpu.$procmux$916$\Y : mux
def v_n1008 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n837 inputs state) == 1 then (v_n1007 inputs state) else (v_n828 inputs state))

-- cpu.mem_wr_addr : mux; src: examples/riscv/upstream/nerv/nerv.sv:66.13-66.24
def v_cpu_mem_wr_addr (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n852 inputs state) == 1 then (v_n1008 inputs state) else (v_n1005 inputs state))

-- $flatten\cpu.$procmux$940$\Y : mux
def v_n1010 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n837 inputs state) == 1 then (v_n387 inputs state) else (v_n386 inputs state))

-- $flatten\cpu.$1\mem_wr_enable[0:0] : mux; src: examples/riscv/upstream/nerv/nerv.sv:195.2-359.5
def v_n1011 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n852 inputs state) == 1 then (v_n1010 inputs state) else (v_n386 inputs state))

-- $flatten\cpu.$procmux$795$\Y : mux
def v_n1012 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n384 inputs state) == 1 then (v_n386 inputs state) else (v_n1011 inputs state))

-- $flatten\cpu.$procmux$780$\Y : mux
def v_n1013 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n466 inputs state) == 1 then (v_n386 inputs state) else (v_n1012 inputs state))

-- cpu.dmem_addr : mux; src: examples/riscv/upstream/nerv/nerv.sv:60.16-60.25
def v_cpu_dmem_addr (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n1013 inputs state) == 1 then (v_cpu_mem_wr_addr inputs state) else (v_n1004 inputs state))

-- cpu.dmem_valid : bitwise_or; src: examples/riscv/upstream/nerv/nerv.sv:59.16-59.26
def v_cpu_dmem_valid (inputs : Inputs) (state : State) : BitVec 1 := ((v_n1013 inputs state) ||| (v_cpu_mem_rd_enable inputs state))

-- $auto$ff.cc:614:unmap_srst$2314$\Y : mux
def v_n1016 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_cpu_dmem_valid inputs state) == 1 then (v_cpu_dmem_addr inputs state) else (v_n3 inputs state))

-- $auto$rtlil.cc:3339:Mux$2317 : mux
def v_n1017 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n478 inputs state) == 1 then (v_n1016 inputs state) else (v_rvfi_mem_addr inputs state))

-- rvfi_mem_rmask : state; src: examples/riscv/NervHarness.sv:6.957-6.971
def v_rvfi_mem_rmask (inputs : Inputs) (state : State) : BitVec 4 := state.v_check_insn_mem_rmask

-- $const4b0000 : constant
def v_n1019 (inputs : Inputs) (state : State) : BitVec 4 := (0b0000 : BitVec 4)

-- $const4b1111 : constant
def v_n1020 (inputs : Inputs) (state : State) : BitVec 4 := (0b1111 : BitVec 4)

-- n1021 : slice
def v_n1021 (inputs : Inputs) (state : State) : BitVec 2 := (BitVec.extractLsb' 3 2 (v_cpu_mem_rd_func inputs state))

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:412$shl$99_Y : logical_shift_left; src: examples/riscv/upstream/nerv/nerv.sv:412.51-412.79
def v_n1022 (inputs : Inputs) (state : State) : BitVec 4 := ((v_n1020 inputs state) <<< (v_n1021 inputs state).toNat)

-- $const4b0001 : constant
def v_n1023 (inputs : Inputs) (state : State) : BitVec 4 := (0b0001 : BitVec 4)

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:410$shl$97_Y : logical_shift_left; src: examples/riscv/upstream/nerv/nerv.sv:410.51-410.79
def v_n1024 (inputs : Inputs) (state : State) : BitVec 4 := ((v_n1023 inputs state) <<< (v_n1021 inputs state).toNat)

-- n1025 : concat
def v_n1025 (inputs : Inputs) (state : State) : BitVec 8 := (BitVec.append (v_n1024 inputs state) (v_n1022 inputs state))

-- $const4b0011 : constant
def v_n1026 (inputs : Inputs) (state : State) : BitVec 4 := (0b0011 : BitVec 4)

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:411$shl$98_Y : logical_shift_left; src: examples/riscv/upstream/nerv/nerv.sv:411.51-411.79
def v_n1027 (inputs : Inputs) (state : State) : BitVec 4 := ((v_n1026 inputs state) <<< (v_n1021 inputs state).toNat)

-- n1028 : concat
def v_n1028 (inputs : Inputs) (state : State) : BitVec 12 := (BitVec.append (v_n1027 inputs state) (v_n1025 inputs state))

-- n1029 : slice
def v_n1029 (inputs : Inputs) (state : State) : BitVec 4 := (BitVec.extractLsb' 0 4 (v_n1028 inputs state))

-- n1030 : concat
def v_n1030 (inputs : Inputs) (state : State) : BitVec 4 := (BitVec.append (v_cpu_mem_rd_enable inputs state) (v_n141 inputs state))

-- $flatten\cpu.$procmux$719_CMP : equal
def v_n1031 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n1030 inputs state) == (v_n689 inputs state)))

-- $const4b1000 : constant
def v_n1032 (inputs : Inputs) (state : State) : BitVec 4 := (0b1000 : BitVec 4)

-- $flatten\cpu.$procmux$721_CMP : equal
def v_n1033 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n1030 inputs state) == (v_n1032 inputs state)))

-- $const4b1100 : constant
def v_n1034 (inputs : Inputs) (state : State) : BitVec 4 := (0b1100 : BitVec 4)

-- $flatten\cpu.$procmux$718_CMP : equal
def v_n1035 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n1030 inputs state) == (v_n1034 inputs state)))

-- n1036 : concat
def v_n1036 (inputs : Inputs) (state : State) : BitVec 2 := (BitVec.append (v_n1035 inputs state) (v_n1033 inputs state))

-- $auto$opt_reduce.cc:137:opt_pmux$1436 : reduce_or
def v_n1037 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n1036 inputs state) != 0))

-- n1038 : concat
def v_n1038 (inputs : Inputs) (state : State) : BitVec 2 := (BitVec.append (v_n1037 inputs state) (v_n1031 inputs state))

-- $const4b1001 : constant
def v_n1039 (inputs : Inputs) (state : State) : BitVec 4 := (0b1001 : BitVec 4)

-- $flatten\cpu.$procmux$720_CMP : equal
def v_n1040 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n1030 inputs state) == (v_n1039 inputs state)))

-- $const4b1101 : constant
def v_n1041 (inputs : Inputs) (state : State) : BitVec 4 := (0b1101 : BitVec 4)

-- $flatten\cpu.$procmux$717_CMP : equal
def v_n1042 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n1030 inputs state) == (v_n1041 inputs state)))

-- n1043 : concat
def v_n1043 (inputs : Inputs) (state : State) : BitVec 2 := (BitVec.append (v_n1042 inputs state) (v_n1040 inputs state))

-- $auto$opt_reduce.cc:137:opt_pmux$1438 : reduce_or
def v_n1044 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n1043 inputs state) != 0))

-- n1045 : concat
def v_n1045 (inputs : Inputs) (state : State) : BitVec 3 := (BitVec.append (v_n1044 inputs state) (v_n1038 inputs state))

-- n1046 : slice
def v_n1046 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 0 1 (v_n1045 inputs state))

-- n1047 : mux
def v_n1047 (inputs : Inputs) (state : State) : BitVec 4 := (if (v_n1046 inputs state) == 1 then (v_n1029 inputs state) else (v_n1019 inputs state))

-- n1048 : slice
def v_n1048 (inputs : Inputs) (state : State) : BitVec 4 := (BitVec.extractLsb' 4 4 (v_n1028 inputs state))

-- n1049 : slice
def v_n1049 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 1 1 (v_n1045 inputs state))

-- n1050 : mux
def v_n1050 (inputs : Inputs) (state : State) : BitVec 4 := (if (v_n1049 inputs state) == 1 then (v_n1048 inputs state) else (v_n1047 inputs state))

-- n1051 : slice
def v_n1051 (inputs : Inputs) (state : State) : BitVec 4 := (BitVec.extractLsb' 8 4 (v_n1028 inputs state))

-- n1052 : slice
def v_n1052 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 2 1 (v_n1045 inputs state))

-- $flatten\cpu.$procmux$716_Y : mux
def v_n1053 (inputs : Inputs) (state : State) : BitVec 4 := (if (v_n1052 inputs state) == 1 then (v_n1051 inputs state) else (v_n1050 inputs state))

-- $auto$ff.cc:614:unmap_srst$2318$\Y : mux
def v_n1054 (inputs : Inputs) (state : State) : BitVec 4 := (if (v_cpu_dmem_valid inputs state) == 1 then (v_n1053 inputs state) else (v_n1019 inputs state))

-- $auto$rtlil.cc:3339:Mux$2321 : mux
def v_n1055 (inputs : Inputs) (state : State) : BitVec 4 := (if (v_n478 inputs state) == 1 then (v_n1054 inputs state) else (v_rvfi_mem_rmask inputs state))

-- rvfi_mem_wmask : state; src: examples/riscv/NervHarness.sv:6.1002-6.1016
def v_rvfi_mem_wmask (inputs : Inputs) (state : State) : BitVec 4 := state.v_check_insn_mem_wmask

-- $auto$setundef.cc:552:execute$2398$\Y : input
def v_n1057 (inputs : Inputs) (state : State) : BitVec 4 := inputs.v__auto_setundef_cc_552_execute_2398

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:94$ternary$7$\Y : mux
def v_n1058 (inputs : Inputs) (state : State) : BitVec 4 := (if (v_cpu_mem_rd_enable inputs state) == 1 then (v_n1019 inputs state) else (v_n1057 inputs state))

-- $auto$setundef.cc:552:execute$2420$\Y : input
def v_n1059 (inputs : Inputs) (state : State) : BitVec 4 := inputs.v__auto_setundef_cc_552_execute_2420

-- $auto$setundef.cc:552:execute$2380$\Y : input
def v_n1060 (inputs : Inputs) (state : State) : BitVec 4 := inputs.v__auto_setundef_cc_552_execute_2380

-- $auto$setundef.cc:552:execute$2378$\Y : input
def v_n1061 (inputs : Inputs) (state : State) : BitVec 4 := inputs.v__auto_setundef_cc_552_execute_2378

-- $auto$setundef.cc:552:execute$2376$\Y : input
def v_n1062 (inputs : Inputs) (state : State) : BitVec 4 := inputs.v__auto_setundef_cc_552_execute_2376

-- $const8b00010011 : constant
def v_n1063 (inputs : Inputs) (state : State) : BitVec 8 := (0b00010011 : BitVec 8)

-- n1064 : slice
def v_n1064 (inputs : Inputs) (state : State) : BitVec 4 := (BitVec.extractLsb' 0 4 (v_n1063 inputs state))

-- n1065 : concat
def v_n1065 (inputs : Inputs) (state : State) : BitVec 2 := (BitVec.append (v_n262 inputs state) (v_n738 inputs state))

-- n1066 : slice
def v_n1066 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 0 1 (v_n1065 inputs state))

-- n1067 : mux
def v_n1067 (inputs : Inputs) (state : State) : BitVec 4 := (if (v_n1066 inputs state) == 1 then (v_n1064 inputs state) else (v_n1020 inputs state))

-- n1068 : slice
def v_n1068 (inputs : Inputs) (state : State) : BitVec 4 := (BitVec.extractLsb' 4 4 (v_n1063 inputs state))

-- n1069 : slice
def v_n1069 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 1 1 (v_n1065 inputs state))

-- $flatten\cpu.$procmux$905$\Y : mux
def v_n1070 (inputs : Inputs) (state : State) : BitVec 4 := (if (v_n1069 inputs state) == 1 then (v_n1068 inputs state) else (v_n1067 inputs state))

-- $flatten\cpu.$procmux$908$\Y : mux
def v_n1071 (inputs : Inputs) (state : State) : BitVec 4 := (if (v_n837 inputs state) == 1 then (v_n1070 inputs state) else (v_n1062 inputs state))

-- $flatten\cpu.$procmux$910$\Y : mux
def v_n1072 (inputs : Inputs) (state : State) : BitVec 4 := (if (v_n852 inputs state) == 1 then (v_n1071 inputs state) else (v_n1061 inputs state))

-- n1073 : slice
def v_n1073 (inputs : Inputs) (state : State) : BitVec 2 := (BitVec.extractLsb' 0 2 (v_n828 inputs state))

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:300$shl$53_Y : logical_shift_left; src: examples/riscv/upstream/nerv/nerv.sv:300.21-300.52
def v_n1074 (inputs : Inputs) (state : State) : BitVec 4 := ((v_n1072 inputs state) <<< (v_n1073 inputs state).toNat)

-- $flatten\cpu.$procmux$924$\Y : mux
def v_n1075 (inputs : Inputs) (state : State) : BitVec 4 := (if (v_n837 inputs state) == 1 then (v_n1074 inputs state) else (v_n1060 inputs state))

-- cpu.mem_wr_strb : mux; src: examples/riscv/upstream/nerv/nerv.sv:68.12-68.23
def v_cpu_mem_wr_strb (inputs : Inputs) (state : State) : BitVec 4 := (if (v_n852 inputs state) == 1 then (v_n1075 inputs state) else (v_n1059 inputs state))

-- cpu.dmem_wstrb : mux; src: examples/riscv/upstream/nerv/nerv.sv:61.16-61.26
def v_cpu_dmem_wstrb (inputs : Inputs) (state : State) : BitVec 4 := (if (v_n1013 inputs state) == 1 then (v_cpu_mem_wr_strb inputs state) else (v_n1058 inputs state))

-- $auto$ff.cc:614:unmap_srst$2322$\Y : mux
def v_n1078 (inputs : Inputs) (state : State) : BitVec 4 := (if (v_cpu_dmem_valid inputs state) == 1 then (v_cpu_dmem_wstrb inputs state) else (v_n1019 inputs state))

-- $auto$rtlil.cc:3339:Mux$2325 : mux
def v_n1079 (inputs : Inputs) (state : State) : BitVec 4 := (if (v_n478 inputs state) == 1 then (v_n1078 inputs state) else (v_rvfi_mem_wmask inputs state))

-- rvfi_mem_wdata : state; src: examples/riscv/NervHarness.sv:6.1092-6.1106
def v_rvfi_mem_wdata (inputs : Inputs) (state : State) : BitVec 32 := state.v_check_insn_mem_wdata

-- $auto$setundef.cc:552:execute$2402$\Y : input
def v_n1081 (inputs : Inputs) (state : State) : BitVec 32 := inputs.v__auto_setundef_cc_552_execute_2402

-- $auto$setundef.cc:552:execute$2422$\Y : input
def v_n1082 (inputs : Inputs) (state : State) : BitVec 32 := inputs.v__auto_setundef_cc_552_execute_2422

-- $auto$setundef.cc:552:execute$2384$\Y : input
def v_n1083 (inputs : Inputs) (state : State) : BitVec 32 := inputs.v__auto_setundef_cc_552_execute_2384

-- n1084 : zero_extend
def v_n1084 (inputs : Inputs) (state : State) : BitVec 32 := (BitVec.setWidth 32 (v_n1073 inputs state))

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:299$mul$51$\Y : mul
def v_n1085 (inputs : Inputs) (state : State) : BitVec 32 := ((v_n310 inputs state) * (v_n1084 inputs state))

-- n1086 : slice
def v_n1086 (inputs : Inputs) (state : State) : BitVec 5 := (BitVec.extractLsb' 0 5 (v_n1085 inputs state))

-- n1087 : logical_shift_left
def v_n1087 (inputs : Inputs) (state : State) : BitVec 32 := ((v_cpu_rs2_value inputs state) <<< (v_n1086 inputs state).toNat)

-- n1088 : constant
def v_n1088 (inputs : Inputs) (state : State) : BitVec 32 := (0b00000000000000000000000000000000 : BitVec 32)

-- n1089 : constant
def v_n1089 (inputs : Inputs) (state : State) : BitVec 32 := (0b00000000000000000000000000100000 : BitVec 32)

-- n1090 : unsigned_greater_equal
def v_n1090 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool (BitVec.ule (v_n1089 inputs state) (v_n1085 inputs state)))

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:299$shl$52_Y : mux; src: examples/riscv/upstream/nerv/nerv.sv:299.21-299.56
def v_n1091 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n1090 inputs state) == 1 then (v_n1088 inputs state) else (v_n1087 inputs state))

-- $flatten\cpu.$procmux$932$\Y : mux
def v_n1092 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n837 inputs state) == 1 then (v_n1091 inputs state) else (v_n1083 inputs state))

-- cpu.mem_wr_data : mux; src: examples/riscv/upstream/nerv/nerv.sv:67.13-67.24
def v_cpu_mem_wr_data (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n852 inputs state) == 1 then (v_n1092 inputs state) else (v_n1082 inputs state))

-- cpu.dmem_wdata : mux; src: examples/riscv/upstream/nerv/nerv.sv:62.16-62.26
def v_cpu_dmem_wdata (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n1013 inputs state) == 1 then (v_cpu_mem_wr_data inputs state) else (v_n1081 inputs state))

-- $auto$ff.cc:614:unmap_srst$2326$\Y : mux
def v_n1095 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_cpu_dmem_valid inputs state) == 1 then (v_cpu_dmem_wdata inputs state) else (v_n3 inputs state))

-- $auto$rtlil.cc:3339:Mux$2329 : mux
def v_n1096 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n478 inputs state) == 1 then (v_n1095 inputs state) else (v_rvfi_mem_wdata inputs state))

-- cpu.rvfi_order : state; src: examples/riscv/upstream/nerv/nerv.sv:31.20-31.30
def v_cpu_rvfi_order (inputs : Inputs) (state : State) : BitVec 64 := state.v_check_insn_rvfi_order

-- $const32b00000000000000000000000000000001 : constant
def v_n1098 (inputs : Inputs) (state : State) : BitVec 32 := (0b00000000000000000000000000000001 : BitVec 32)

-- n1099 : zero_extend
def v_n1099 (inputs : Inputs) (state : State) : BitVec 64 := (BitVec.setWidth 64 (v_n1098 inputs state))

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:392$add$92_Y : add; src: examples/riscv/upstream/nerv/nerv.sv:392.18-392.32
def v_n1100 (inputs : Inputs) (state : State) : BitVec 64 := ((v_cpu_rvfi_order inputs state) + (v_n1099 inputs state))

-- $auto$ff.cc:592:unmap_ce$2286$\Y : mux
def v_n1101 (inputs : Inputs) (state : State) : BitVec 64 := (if (v_n478 inputs state) == 1 then (v_n1100 inputs state) else (v_cpu_rvfi_order inputs state))

-- $const64b0000000000000000000000000000000000000000000000000000000000000000 : constant
def v_n1102 (inputs : Inputs) (state : State) : BitVec 64 := (0b0000000000000000000000000000000000000000000000000000000000000000 : BitVec 64)

-- $auto$rtlil.cc:3339:Mux$2289 : mux
def v_n1103 (inputs : Inputs) (state : State) : BitVec 64 := (if (v_n466 inputs state) == 1 then (v_n1102 inputs state) else (v_n1101 inputs state))

-- rvfi_mode : state; src: examples/riscv/NervHarness.sv:6.398-6.407
def v_rvfi_mode (inputs : Inputs) (state : State) : BitVec 2 := state.v_check_insn_rvfi_mode

-- $const2b11 : constant
def v_n1105 (inputs : Inputs) (state : State) : BitVec 2 := (0b11 : BitVec 2)

-- $auto$rtlil.cc:3339:Mux$2299 : mux
def v_n1106 (inputs : Inputs) (state : State) : BitVec 2 := (if (v_n478 inputs state) == 1 then (v_n1105 inputs state) else (v_rvfi_mode inputs state))

-- rvfi_ixl : state; src: examples/riscv/NervHarness.sv:6.459-6.467
def v_rvfi_ixl (inputs : Inputs) (state : State) : BitVec 2 := state.v_check_insn_rvfi_ixl

-- $const2b01 : constant
def v_n1108 (inputs : Inputs) (state : State) : BitVec 2 := (0b01 : BitVec 2)

-- $auto$rtlil.cc:3339:Mux$2301 : mux
def v_n1109 (inputs : Inputs) (state : State) : BitVec 2 := (if (v_n478 inputs state) == 1 then (v_n1108 inputs state) else (v_rvfi_ixl inputs state))

-- n1110 : constant
def v_n1110 (inputs : Inputs) (state : State) : BitVec 1 := (0b1 : BitVec 1)

-- $procdff$1399$\Q : state
def v_n1111 (inputs : Inputs) (state : State) : BitVec 1 := state.v_started

-- $procmux$256$\Y : mux
def v_n1112 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n1111 inputs state) == 1 then (v_n386 inputs state) else (v_n387 inputs state))

-- n1113 : mux
def v_n1113 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n1112 inputs state) == 1 then (v_reset inputs state) else (v_n1110 inputs state))

-- n1114 : constant
def v_n1114 (inputs : Inputs) (state : State) : BitVec 1 := (0b1 : BitVec 1)

-- n1115 : slice
def v_n1115 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 1 1 (v_rvfi_mem_rmask inputs state))

-- n1116 : mux
def v_n1116 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n386 inputs state) == 1 then (v_n1115 inputs state) else (v_n1114 inputs state))

-- n1117 : constant
def v_n1117 (inputs : Inputs) (state : State) : BitVec 1 := (0b1 : BitVec 1)

-- n1118 : slice
def v_n1118 (inputs : Inputs) (state : State) : BitVec 8 := (BitVec.extractLsb' 8 8 (v_rvfi_mem_rdata inputs state))

-- n1119 : slice
def v_n1119 (inputs : Inputs) (state : State) : BitVec 8 := (BitVec.extractLsb' 8 8 (v_rvfi_mem_wdata inputs state))

-- $flatten\check_insn.$examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:190$eq$227$\Y : equal
def v_n1120 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n1118 inputs state) == (v_n1119 inputs state)))

-- n1121 : slice
def v_n1121 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 1 1 (v_rvfi_mem_wmask inputs state))

-- $flatten\check_insn.$procmux$421$\Y : mux
def v_n1122 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n1121 inputs state) == 1 then (v_n387 inputs state) else (v_n386 inputs state))

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:451$logic_and$115$\Y : bitwise_and
def v_n1123 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n698 inputs state) &&& (v_n473 inputs state))

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:451$logic_and$117$\Y : bitwise_and
def v_n1124 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n1123 inputs state) &&& (v_n475 inputs state))

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:451$logic_and$119$\Y : bitwise_and
def v_n1125 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n1124 inputs state) &&& (v_n477 inputs state))

-- cpu.trapped_q : state; src: examples/riscv/upstream/nerv/nerv.sv:192.6-192.15
def v_cpu_trapped_q (inputs : Inputs) (state : State) : BitVec 1 := state.v_cpu_trapped_q

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:451$logic_not$120$\Y : bitwise_not
def v_n1127 (inputs : Inputs) (state : State) : BitVec 1 := (~~~(v_cpu_trapped_q inputs state))

-- rvfi_valid : bitwise_and; src: examples/riscv/NervHarness.sv:6.48-6.58
def v_rvfi_valid (inputs : Inputs) (state : State) : BitVec 1 := ((v_n1125 inputs state) &&& (v_n1127 inputs state))

-- $flatten\check_insn.\insn_spec.$examples/riscv/upstream/riscv-formal/insn_add.v:46$eq$131$\Y : equal
def v_n1129 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n970 inputs state) == (v_n275 inputs state)))

-- n1130 : reduce_or
def v_n1130 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n972 inputs state) != 0))

-- $examples/riscv/NervHarness.sv:11$eq$246_Y : bitwise_not; src: examples/riscv/NervHarness.sv:11.51-11.72
def v_n1131 (inputs : Inputs) (state : State) : BitVec 1 := (~~~(v_n1130 inputs state))

-- $examples/riscv/NervHarness.sv:11$logic_and$247_Y : bitwise_and; src: examples/riscv/NervHarness.sv:11.19-11.72
def v_n1132 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n1129 inputs state) &&& (v_n1131 inputs state))

-- n1133 : reduce_or
def v_n1133 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n976 inputs state) != 0))

-- $examples/riscv/NervHarness.sv:11$eq$248_Y : bitwise_not; src: examples/riscv/NervHarness.sv:11.76-11.97
def v_n1134 (inputs : Inputs) (state : State) : BitVec 1 := (~~~(v_n1133 inputs state))

-- selected : bitwise_and; src: examples/riscv/NervHarness.sv:11.8-11.16
def v_selected (inputs : Inputs) (state : State) : BitVec 1 := ((v_n1132 inputs state) &&& (v_n1134 inputs state))

-- check_insn.check : bitwise_and; src: examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:16.22-16.27
def v_check_insn_check (inputs : Inputs) (state : State) : BitVec 1 := ((v_rvfi_valid inputs state) &&& (v_selected inputs state))

-- $flatten\check_insn.$auto$rtlil.cc:3207:ReduceOr$1373 : bitwise_and
def v_n1137 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n475 inputs state) &&& (v_check_insn_check inputs state))

-- $flatten\check_insn.$procmux$431$\Y : mux
def v_n1138 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n1137 inputs state) == 1 then (v_n1122 inputs state) else (v_n386 inputs state))

-- n1139 : mux
def v_n1139 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n1138 inputs state) == 1 then (v_n1120 inputs state) else (v_n1117 inputs state))

-- n1140 : constant
def v_n1140 (inputs : Inputs) (state : State) : BitVec 1 := (0b1 : BitVec 1)

-- n1141 : slice
def v_n1141 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 2 1 (v_rvfi_mem_rmask inputs state))

-- n1142 : slice
def v_n1142 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 2 1 (v_rvfi_mem_wmask inputs state))

-- $flatten\check_insn.$procmux$358$\Y : mux
def v_n1143 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n1142 inputs state) == 1 then (v_n387 inputs state) else (v_n386 inputs state))

-- $flatten\check_insn.$procmux$368$\Y : mux
def v_n1144 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n1137 inputs state) == 1 then (v_n1143 inputs state) else (v_n386 inputs state))

-- n1145 : mux
def v_n1145 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n1144 inputs state) == 1 then (v_n1141 inputs state) else (v_n1140 inputs state))

-- n1146 : constant
def v_n1146 (inputs : Inputs) (state : State) : BitVec 1 := (0b1 : BitVec 1)

-- n1147 : slice
def v_n1147 (inputs : Inputs) (state : State) : BitVec 8 := (BitVec.extractLsb' 16 8 (v_rvfi_mem_wdata inputs state))

-- n1148 : reduce_or
def v_n1148 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n1147 inputs state) != 0))

-- $flatten\check_insn.$examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:187$eq$231$\Y : bitwise_not
def v_n1149 (inputs : Inputs) (state : State) : BitVec 1 := (~~~(v_n1148 inputs state))

-- n1150 : mux
def v_n1150 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n386 inputs state) == 1 then (v_n1149 inputs state) else (v_n1146 inputs state))

-- n1151 : constant
def v_n1151 (inputs : Inputs) (state : State) : BitVec 1 := (0b1 : BitVec 1)

-- n1152 : mux
def v_n1152 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n1138 inputs state) == 1 then (v_n1115 inputs state) else (v_n1151 inputs state))

-- n1153 : constant
def v_n1153 (inputs : Inputs) (state : State) : BitVec 1 := (0b1 : BitVec 1)

-- n1154 : reduce_or
def v_n1154 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n1119 inputs state) != 0))

-- $flatten\check_insn.$examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:187$eq$224$\Y : bitwise_not
def v_n1155 (inputs : Inputs) (state : State) : BitVec 1 := (~~~(v_n1154 inputs state))

-- n1156 : mux
def v_n1156 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n386 inputs state) == 1 then (v_n1155 inputs state) else (v_n1153 inputs state))

-- n1157 : constant
def v_n1157 (inputs : Inputs) (state : State) : BitVec 1 := (0b1 : BitVec 1)

-- n1158 : slice
def v_n1158 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 3 1 (v_rvfi_mem_rmask inputs state))

-- n1159 : slice
def v_n1159 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 3 1 (v_rvfi_mem_wmask inputs state))

-- $flatten\check_insn.$procmux$295$\Y : mux
def v_n1160 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n1159 inputs state) == 1 then (v_n387 inputs state) else (v_n386 inputs state))

-- $flatten\check_insn.$examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:189$assert$239_EN : mux; src: examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:189.9-189.29
def v_n1161 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n1137 inputs state) == 1 then (v_n1160 inputs state) else (v_n386 inputs state))

-- n1162 : mux
def v_n1162 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n1161 inputs state) == 1 then (v_n1158 inputs state) else (v_n1157 inputs state))

-- n1163 : constant
def v_n1163 (inputs : Inputs) (state : State) : BitVec 1 := (0b1 : BitVec 1)

-- n1164 : slice
def v_n1164 (inputs : Inputs) (state : State) : BitVec 8 := (BitVec.extractLsb' 24 8 (v_rvfi_mem_wdata inputs state))

-- n1165 : reduce_or
def v_n1165 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n1164 inputs state) != 0))

-- $flatten\check_insn.$examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:187$eq$238_Y : bitwise_not; src: examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:187.16-187.63
def v_n1166 (inputs : Inputs) (state : State) : BitVec 1 := (~~~(v_n1165 inputs state))

-- n1167 : mux
def v_n1167 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n386 inputs state) == 1 then (v_n1166 inputs state) else (v_n1163 inputs state))

-- n1168 : constant
def v_n1168 (inputs : Inputs) (state : State) : BitVec 1 := (0b1 : BitVec 1)

-- n1169 : mux
def v_n1169 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n386 inputs state) == 1 then (v_n1159 inputs state) else (v_n1168 inputs state))

-- n1170 : constant
def v_n1170 (inputs : Inputs) (state : State) : BitVec 1 := (0b1 : BitVec 1)

-- n1171 : slice
def v_n1171 (inputs : Inputs) (state : State) : BitVec 8 := (BitVec.extractLsb' 24 8 (v_rvfi_mem_rdata inputs state))

-- $flatten\check_insn.$examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:190$eq$241_Y : equal; src: examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:190.16-190.58
def v_n1172 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n1171 inputs state) == (v_n1164 inputs state)))

-- n1173 : mux
def v_n1173 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n1161 inputs state) == 1 then (v_n1172 inputs state) else (v_n1170 inputs state))

-- n1174 : constant
def v_n1174 (inputs : Inputs) (state : State) : BitVec 1 := (0b1 : BitVec 1)

-- n1175 : mux
def v_n1175 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n386 inputs state) == 1 then (v_n1141 inputs state) else (v_n1174 inputs state))

-- n1176 : constant
def v_n1176 (inputs : Inputs) (state : State) : BitVec 1 := (0b1 : BitVec 1)

-- $flatten\check_insn.$examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:135$cover$166_EN : mux; src: examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:135.5-135.22
def v_n1177 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_reset inputs state) == 1 then (v_n386 inputs state) else (v_n387 inputs state))

-- check_insn.valid : bitwise_and; src: examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:25.19-25.24
def v_check_insn_valid (inputs : Inputs) (state : State) : BitVec 1 := ((v_n475 inputs state) &&& (v_rvfi_valid inputs state))

-- $flatten\check_insn.\insn_spec.$examples/riscv/upstream/riscv-formal/insn_add.v:46$logic_and$128_Y : bitwise_and; src: examples/riscv/upstream/riscv-formal/insn_add.v:46.23-46.80
def v_n1179 (inputs : Inputs) (state : State) : BitVec 1 := ((v_check_insn_valid inputs state) &&& (v_n1134 inputs state))

-- $flatten\check_insn.\insn_spec.$examples/riscv/upstream/riscv-formal/insn_add.v:46$logic_and$130$\Y : bitwise_and
def v_n1180 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n1179 inputs state) &&& (v_n1131 inputs state))

-- check_insn.spec_valid : bitwise_and; src: examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:56.50-56.60
def v_check_insn_spec_valid (inputs : Inputs) (state : State) : BitVec 1 := ((v_n1180 inputs state) &&& (v_n1129 inputs state))

-- $yosys_lean_cover_enabled_3$\Y : bitwise_and
def v_n1182 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n1177 inputs state) &&& (v_check_insn_spec_valid inputs state))

-- n1183 : mux
def v_n1183 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n387 inputs state) == 1 then (v_n1182 inputs state) else (v_n1176 inputs state))

-- n1184 : constant
def v_n1184 (inputs : Inputs) (state : State) : BitVec 1 := (0b1 : BitVec 1)

-- n1185 : slice
def v_n1185 (inputs : Inputs) (state : State) : BitVec 8 := (BitVec.extractLsb' 16 8 (v_rvfi_mem_rdata inputs state))

-- $flatten\check_insn.$examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:190$eq$234_Y : equal; src: examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:190.16-190.58
def v_n1186 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n1185 inputs state) == (v_n1147 inputs state)))

-- n1187 : mux
def v_n1187 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n1144 inputs state) == 1 then (v_n1186 inputs state) else (v_n1184 inputs state))

-- n1188 : constant
def v_n1188 (inputs : Inputs) (state : State) : BitVec 1 := (0b1 : BitVec 1)

-- $flatten\check_insn.$examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:137$logic_and$171_Y : bitwise_and; src: examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:137.11-137.30
def v_n1189 (inputs : Inputs) (state : State) : BitVec 1 := ((v_check_insn_check inputs state) &&& (v_check_insn_spec_valid inputs state))

-- $yosys_lean_cover_enabled_2$\Y : bitwise_and
def v_n1190 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n1177 inputs state) &&& (v_n1189 inputs state))

-- n1191 : mux
def v_n1191 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n387 inputs state) == 1 then (v_n1190 inputs state) else (v_n1188 inputs state))

-- n1192 : constant
def v_n1192 (inputs : Inputs) (state : State) : BitVec 1 := (0b1 : BitVec 1)

-- $flatten\check_insn.$examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:138$logic_not$174$\Y : bitwise_not
def v_n1193 (inputs : Inputs) (state : State) : BitVec 1 := (~~~(v_rvfi_trap inputs state))

-- $flatten\check_insn.$examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:136$logic_and$169_Y : bitwise_and; src: examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:136.11-136.30
def v_n1194 (inputs : Inputs) (state : State) : BitVec 1 := ((v_check_insn_spec_valid inputs state) &&& (v_n1193 inputs state))

-- $yosys_lean_cover_enabled_1$\Y : bitwise_and
def v_n1195 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n1177 inputs state) &&& (v_n1194 inputs state))

-- n1196 : mux
def v_n1196 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n387 inputs state) == 1 then (v_n1195 inputs state) else (v_n1192 inputs state))

-- n1197 : constant
def v_n1197 (inputs : Inputs) (state : State) : BitVec 1 := (0b1 : BitVec 1)

-- $flatten\check_insn.$examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:138$logic_and$175_Y : bitwise_and; src: examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:138.11-138.39
def v_n1198 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n1189 inputs state) &&& (v_n1193 inputs state))

-- $yosys_lean_cover_enabled$\Y : bitwise_and
def v_n1199 (inputs : Inputs) (state : State) : BitVec 1 := ((v_n1177 inputs state) &&& (v_n1198 inputs state))

-- n1200 : mux
def v_n1200 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n387 inputs state) == 1 then (v_n1199 inputs state) else (v_n1197 inputs state))

-- n1201 : constant
def v_n1201 (inputs : Inputs) (state : State) : BitVec 1 := (0b1 : BitVec 1)

-- $flatten\check_insn.$examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:141$assume$178_EN : mux; src: examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:141.5-141.23
def v_n1202 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n1137 inputs state) == 1 then (v_n387 inputs state) else (v_n386 inputs state))

-- n1203 : mux
def v_n1203 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n1202 inputs state) == 1 then (v_check_insn_spec_valid inputs state) else (v_n1201 inputs state))

-- n1204 : constant
def v_n1204 (inputs : Inputs) (state : State) : BitVec 1 := (0b1 : BitVec 1)

-- n1205 : mux
def v_n1205 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n386 inputs state) == 1 then (v_rvfi_trap inputs state) else (v_n1204 inputs state))

-- n1206 : constant
def v_n1206 (inputs : Inputs) (state : State) : BitVec 1 := (0b1 : BitVec 1)

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:446$reduce_bool$112$\Y : reduce_or
def v_n1207 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n483 inputs state) != 0))

-- $flatten\cpu.$examples/riscv/upstream/nerv/nerv.sv:446$ternary$113$\Y : mux
def v_n1208 (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n1207 inputs state) == 1 then (v_cpu_mem_rdata inputs state) else (v_n3 inputs state))

-- rvfi_rd_wdata : mux; src: examples/riscv/NervHarness.sv:6.777-6.790
def v_rvfi_rd_wdata (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n384 inputs state) == 1 then (v_n1208 inputs state) else (v_n947 inputs state))

-- n1210 : reduce_or
def v_n1210 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_rvfi_rd_wdata inputs state) != 0))

-- $flatten\check_insn.$examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:146$eq$186$\Y : bitwise_not
def v_n1211 (inputs : Inputs) (state : State) : BitVec 1 := (~~~(v_n1210 inputs state))

-- n1212 : mux
def v_n1212 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n386 inputs state) == 1 then (v_n1211 inputs state) else (v_n1206 inputs state))

-- n1213 : constant
def v_n1213 (inputs : Inputs) (state : State) : BitVec 1 := (0b1 : BitVec 1)

-- rvfi_rd_addr : mux; src: examples/riscv/NervHarness.sv:6.732-6.744
def v_rvfi_rd_addr (inputs : Inputs) (state : State) : BitVec 5 := (if (v_n384 inputs state) == 1 then (v_n483 inputs state) else (v_n939 inputs state))

-- n1215 : reduce_or
def v_n1215 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_rvfi_rd_addr inputs state) != 0))

-- $flatten\check_insn.$examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:145$eq$184$\Y : bitwise_not
def v_n1216 (inputs : Inputs) (state : State) : BitVec 1 := (~~~(v_n1215 inputs state))

-- n1217 : mux
def v_n1217 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n386 inputs state) == 1 then (v_n1216 inputs state) else (v_n1213 inputs state))

-- n1218 : constant
def v_n1218 (inputs : Inputs) (state : State) : BitVec 1 := (0b1 : BitVec 1)

-- n1219 : reduce_or
def v_n1219 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_rvfi_mem_wmask inputs state) != 0))

-- $flatten\check_insn.$examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:147$eq$188$\Y : bitwise_not
def v_n1220 (inputs : Inputs) (state : State) : BitVec 1 := (~~~(v_n1219 inputs state))

-- n1221 : mux
def v_n1221 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n386 inputs state) == 1 then (v_n1220 inputs state) else (v_n1218 inputs state))

-- n1222 : constant
def v_n1222 (inputs : Inputs) (state : State) : BitVec 1 := (0b1 : BitVec 1)

-- n1223 : reduce_or
def v_n1223 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_rvfi_rs2_rdata inputs state) != 0))

-- $flatten\check_insn.$examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:167$eq$194$\Y : bitwise_not
def v_n1224 (inputs : Inputs) (state : State) : BitVec 1 := (~~~(v_n1223 inputs state))

-- n1225 : reduce_or
def v_n1225 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_rvfi_rs2_addr inputs state) != 0))

-- $flatten\check_insn.$examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:166$eq$192$\Y : bitwise_not
def v_n1226 (inputs : Inputs) (state : State) : BitVec 1 := (~~~(v_n1225 inputs state))

-- $flatten\check_insn.$procmux$595$\Y : mux
def v_n1227 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n1226 inputs state) == 1 then (v_n387 inputs state) else (v_n386 inputs state))

-- $flatten\check_insn.$examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:167$assert$193_EN : mux; src: examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:167.7-167.29
def v_n1228 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n1137 inputs state) == 1 then (v_n1227 inputs state) else (v_n386 inputs state))

-- n1229 : mux
def v_n1229 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n1228 inputs state) == 1 then (v_n1224 inputs state) else (v_n1222 inputs state))

-- n1230 : constant
def v_n1230 (inputs : Inputs) (state : State) : BitVec 1 := (0b1 : BitVec 1)

-- n1231 : reduce_or
def v_n1231 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_rvfi_rs1_rdata inputs state) != 0))

-- $flatten\check_insn.$examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:164$eq$191_Y : bitwise_not; src: examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:164.14-164.28
def v_n1232 (inputs : Inputs) (state : State) : BitVec 1 := (~~~(v_n1231 inputs state))

-- n1233 : reduce_or
def v_n1233 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_rvfi_rs1_addr inputs state) != 0))

-- $flatten\check_insn.$examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:163$eq$189$\Y : bitwise_not
def v_n1234 (inputs : Inputs) (state : State) : BitVec 1 := (~~~(v_n1233 inputs state))

-- $flatten\check_insn.$procmux$603$\Y : mux
def v_n1235 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n1234 inputs state) == 1 then (v_n387 inputs state) else (v_n386 inputs state))

-- $flatten\check_insn.$examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:164$assert$190_EN : mux; src: examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:164.7-164.29
def v_n1236 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n1137 inputs state) == 1 then (v_n1235 inputs state) else (v_n386 inputs state))

-- n1237 : mux
def v_n1237 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n1236 inputs state) == 1 then (v_n1232 inputs state) else (v_n1230 inputs state))

-- n1238 : constant
def v_n1238 (inputs : Inputs) (state : State) : BitVec 1 := (0b1 : BitVec 1)

-- n1239 : mux
def v_n1239 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n386 inputs state) == 1 then (v_n1142 inputs state) else (v_n1238 inputs state))

-- n1240 : constant
def v_n1240 (inputs : Inputs) (state : State) : BitVec 1 := (0b1 : BitVec 1)

-- $flatten\check_insn.$examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:171$eq$198_Y : equal; src: examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:171.15-171.40
def v_n1241 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_check_insn_spec_rs1_addr inputs state) == (v_rvfi_rs1_addr inputs state)))

-- $flatten\check_insn.$examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:170$ne$196$\Y : reduce_or
def v_n1242 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_check_insn_spec_rs1_addr inputs state) != 0))

-- $flatten\check_insn.$procmux$585$\Y : mux
def v_n1243 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n1242 inputs state) == 1 then (v_n387 inputs state) else (v_n386 inputs state))

-- $flatten\check_insn.$examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:171$assert$197_EN : mux; src: examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:171.8-171.41
def v_n1244 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n1137 inputs state) == 1 then (v_n1243 inputs state) else (v_n386 inputs state))

-- n1245 : mux
def v_n1245 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n1244 inputs state) == 1 then (v_n1241 inputs state) else (v_n1240 inputs state))

-- n1246 : constant
def v_n1246 (inputs : Inputs) (state : State) : BitVec 1 := (0b1 : BitVec 1)

-- $flatten\check_insn.$examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:176$eq$203$\Y : equal
def v_n1247 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_check_insn_spec_rd_addr inputs state) == (v_rvfi_rd_addr inputs state)))

-- n1248 : mux
def v_n1248 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n1202 inputs state) == 1 then (v_n1247 inputs state) else (v_n1246 inputs state))

-- n1249 : constant
def v_n1249 (inputs : Inputs) (state : State) : BitVec 1 := (0b1 : BitVec 1)

-- $flatten\check_insn.$examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:174$eq$201_Y : equal; src: examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:174.15-174.40
def v_n1250 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_check_insn_spec_rs2_addr inputs state) == (v_rvfi_rs2_addr inputs state)))

-- $flatten\check_insn.$examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:173$ne$199$\Y : reduce_or
def v_n1251 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_check_insn_spec_rs2_addr inputs state) != 0))

-- $flatten\check_insn.$procmux$574$\Y : mux
def v_n1252 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n1251 inputs state) == 1 then (v_n387 inputs state) else (v_n386 inputs state))

-- $flatten\check_insn.$examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:174$assert$200_EN : mux; src: examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:174.8-174.41
def v_n1253 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n1137 inputs state) == 1 then (v_n1252 inputs state) else (v_n386 inputs state))

-- n1254 : mux
def v_n1254 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n1253 inputs state) == 1 then (v_n1250 inputs state) else (v_n1249 inputs state))

-- n1255 : constant
def v_n1255 (inputs : Inputs) (state : State) : BitVec 1 := (0b1 : BitVec 1)

-- n1256 : mux
def v_n1256 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n386 inputs state) == 1 then (v_n1158 inputs state) else (v_n1255 inputs state))

-- n1257 : constant
def v_n1257 (inputs : Inputs) (state : State) : BitVec 1 := (0b1 : BitVec 1)

-- check_insn.rs1_rdata_or_zero : mux; src: examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:68.34-68.51
def v_check_insn_rs1_rdata_or_zero (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n1242 inputs state) == 1 then (v_rvfi_rs1_rdata inputs state) else (v_n3 inputs state))

-- check_insn.rs2_rdata_or_zero : mux; src: examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:69.34-69.51
def v_check_insn_rs2_rdata_or_zero (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n1251 inputs state) == 1 then (v_rvfi_rs2_rdata inputs state) else (v_n3 inputs state))

-- check_insn.insn_spec.result : add; src: examples/riscv/upstream/riscv-formal/insn_add.v:45.17-45.23
def v_check_insn_insn_spec_result (inputs : Inputs) (state : State) : BitVec 32 := ((v_check_insn_rs1_rdata_or_zero inputs state) + (v_check_insn_rs2_rdata_or_zero inputs state))

-- $flatten\check_insn.\insn_spec.$examples/riscv/upstream/riscv-formal/insn_add.v:50$reduce_bool$133_Y : reduce_or; src: examples/riscv/upstream/riscv-formal/insn_add.v:50.26-50.51
def v_n1261 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_check_insn_spec_rd_addr inputs state) != 0))

-- check_insn.spec_rd_wdata : mux; src: examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:61.34-61.47
def v_check_insn_spec_rd_wdata (inputs : Inputs) (state : State) : BitVec 32 := (if (v_n1261 inputs state) == 1 then (v_check_insn_insn_spec_result inputs state) else (v_n3 inputs state))

-- $flatten\check_insn.$examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:177$eq$205_Y : equal; src: examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:177.14-177.39
def v_n1263 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_check_insn_spec_rd_wdata inputs state) == (v_rvfi_rd_wdata inputs state)))

-- n1264 : mux
def v_n1264 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n1202 inputs state) == 1 then (v_n1263 inputs state) else (v_n1257 inputs state))

-- n1265 : constant
def v_n1265 (inputs : Inputs) (state : State) : BitVec 1 := (0b1 : BitVec 1)

-- check_insn.spec_pc_wdata : add; src: examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:62.34-62.47
def v_check_insn_spec_pc_wdata (inputs : Inputs) (state : State) : BitVec 32 := ((v_rvfi_pc_rdata inputs state) + (v_n259 inputs state))

-- $flatten\check_insn.$examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:178$eq$207_Y : equal; src: examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:178.47-178.72
def v_n1267 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_check_insn_spec_pc_wdata inputs state) == (v_rvfi_pc_wdata inputs state)))

-- n1268 : mux
def v_n1268 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n1202 inputs state) == 1 then (v_n1267 inputs state) else (v_n1265 inputs state))

-- n1269 : constant
def v_n1269 (inputs : Inputs) (state : State) : BitVec 1 := (0b1 : BitVec 1)

-- n1270 : slice
def v_n1270 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 0 1 (v_rvfi_mem_wmask inputs state))

-- n1271 : mux
def v_n1271 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n386 inputs state) == 1 then (v_n1270 inputs state) else (v_n1269 inputs state))

-- n1272 : constant
def v_n1272 (inputs : Inputs) (state : State) : BitVec 1 := (0b1 : BitVec 1)

-- n1273 : reduce_or
def v_n1273 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_rvfi_mem_addr inputs state) != 0))

-- $flatten\check_insn.$examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:181$eq$212_Y : bitwise_not; src: examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:181.48-181.73
def v_n1274 (inputs : Inputs) (state : State) : BitVec 1 := (~~~(v_n1273 inputs state))

-- n1275 : mux
def v_n1275 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n386 inputs state) == 1 then (v_n1274 inputs state) else (v_n1272 inputs state))

-- n1276 : constant
def v_n1276 (inputs : Inputs) (state : State) : BitVec 1 := (0b1 : BitVec 1)

-- $flatten\check_insn.$examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:198$eq$244_Y : bitwise_not; src: examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:198.13-198.30
def v_n1277 (inputs : Inputs) (state : State) : BitVec 1 := (~~~(v_rvfi_trap inputs state))

-- n1278 : mux
def v_n1278 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n1202 inputs state) == 1 then (v_n1277 inputs state) else (v_n1276 inputs state))

-- n1279 : constant
def v_n1279 (inputs : Inputs) (state : State) : BitVec 1 := (0b1 : BitVec 1)

-- n1280 : slice
def v_n1280 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.extractLsb' 0 1 (v_rvfi_mem_rmask inputs state))

-- $flatten\check_insn.$procmux$484$\Y : mux
def v_n1281 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n1270 inputs state) == 1 then (v_n387 inputs state) else (v_n386 inputs state))

-- $flatten\check_insn.$examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:189$assert$218_EN : mux; src: examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:189.9-189.29
def v_n1282 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n1137 inputs state) == 1 then (v_n1281 inputs state) else (v_n386 inputs state))

-- n1283 : mux
def v_n1283 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n1282 inputs state) == 1 then (v_n1280 inputs state) else (v_n1279 inputs state))

-- n1284 : constant
def v_n1284 (inputs : Inputs) (state : State) : BitVec 1 := (0b1 : BitVec 1)

-- n1285 : slice
def v_n1285 (inputs : Inputs) (state : State) : BitVec 8 := (BitVec.extractLsb' 0 8 (v_rvfi_mem_wdata inputs state))

-- n1286 : reduce_or
def v_n1286 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n1285 inputs state) != 0))

-- $flatten\check_insn.$examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:187$eq$217$\Y : bitwise_not
def v_n1287 (inputs : Inputs) (state : State) : BitVec 1 := (~~~(v_n1286 inputs state))

-- n1288 : mux
def v_n1288 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n386 inputs state) == 1 then (v_n1287 inputs state) else (v_n1284 inputs state))

-- n1289 : constant
def v_n1289 (inputs : Inputs) (state : State) : BitVec 1 := (0b1 : BitVec 1)

-- n1290 : mux
def v_n1290 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n386 inputs state) == 1 then (v_n1121 inputs state) else (v_n1289 inputs state))

-- n1291 : constant
def v_n1291 (inputs : Inputs) (state : State) : BitVec 1 := (0b1 : BitVec 1)

-- n1292 : mux
def v_n1292 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n386 inputs state) == 1 then (v_n1280 inputs state) else (v_n1291 inputs state))

-- n1293 : constant
def v_n1293 (inputs : Inputs) (state : State) : BitVec 1 := (0b1 : BitVec 1)

-- n1294 : slice
def v_n1294 (inputs : Inputs) (state : State) : BitVec 8 := (BitVec.extractLsb' 0 8 (v_rvfi_mem_rdata inputs state))

-- $flatten\check_insn.$examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:190$eq$220_Y : equal; src: examples/riscv/upstream/riscv-formal/rvfi_insn_check.sv:190.16-190.58
def v_n1295 (inputs : Inputs) (state : State) : BitVec 1 := (BitVec.ofBool ((v_n1294 inputs state) == (v_n1285 inputs state)))

-- n1296 : mux
def v_n1296 (inputs : Inputs) (state : State) : BitVec 1 := (if (v_n1282 inputs state) == 1 then (v_n1295 inputs state) else (v_n1293 inputs state))

end Signals

namespace Next
-- Next register value; aliases: cpu.regfile[31]; src: unavailable after lowering
def v_cpu_regfile_31_ (inputs : Inputs) (state : State) : BitVec 32 := (Signals.v_n531 inputs state)

-- Next register value; aliases: cpu.regfile[0]; src: unavailable after lowering
def v_cpu_regfile_0_ (inputs : Inputs) (state : State) : BitVec 32 := (Signals.v_n574 inputs state)

-- Next register value; aliases: cpu.regfile[1]; src: unavailable after lowering
def v_cpu_regfile_1_ (inputs : Inputs) (state : State) : BitVec 32 := (Signals.v_n578 inputs state)

-- Next register value; aliases: cpu.regfile[2]; src: unavailable after lowering
def v_cpu_regfile_2_ (inputs : Inputs) (state : State) : BitVec 32 := (Signals.v_n582 inputs state)

-- Next register value; aliases: cpu.regfile[3]; src: unavailable after lowering
def v_cpu_regfile_3_ (inputs : Inputs) (state : State) : BitVec 32 := (Signals.v_n585 inputs state)

-- Next register value; aliases: cpu.regfile[4]; src: unavailable after lowering
def v_cpu_regfile_4_ (inputs : Inputs) (state : State) : BitVec 32 := (Signals.v_n589 inputs state)

-- Next register value; aliases: cpu.regfile[5]; src: unavailable after lowering
def v_cpu_regfile_5_ (inputs : Inputs) (state : State) : BitVec 32 := (Signals.v_n592 inputs state)

-- Next register value; aliases: cpu.regfile[6]; src: unavailable after lowering
def v_cpu_regfile_6_ (inputs : Inputs) (state : State) : BitVec 32 := (Signals.v_n595 inputs state)

-- Next register value; aliases: cpu.regfile[7]; src: unavailable after lowering
def v_cpu_regfile_7_ (inputs : Inputs) (state : State) : BitVec 32 := (Signals.v_n598 inputs state)

-- Next register value; aliases: cpu.regfile[8]; src: unavailable after lowering
def v_cpu_regfile_8_ (inputs : Inputs) (state : State) : BitVec 32 := (Signals.v_n603 inputs state)

-- Next register value; aliases: cpu.regfile[9]; src: unavailable after lowering
def v_cpu_regfile_9_ (inputs : Inputs) (state : State) : BitVec 32 := (Signals.v_n606 inputs state)

-- Next register value; aliases: cpu.regfile[10]; src: unavailable after lowering
def v_cpu_regfile_10_ (inputs : Inputs) (state : State) : BitVec 32 := (Signals.v_n609 inputs state)

-- Next register value; aliases: cpu.regfile[11]; src: unavailable after lowering
def v_cpu_regfile_11_ (inputs : Inputs) (state : State) : BitVec 32 := (Signals.v_n612 inputs state)

-- Next register value; aliases: cpu.regfile[12]; src: unavailable after lowering
def v_cpu_regfile_12_ (inputs : Inputs) (state : State) : BitVec 32 := (Signals.v_n616 inputs state)

-- Next register value; aliases: cpu.regfile[13]; src: unavailable after lowering
def v_cpu_regfile_13_ (inputs : Inputs) (state : State) : BitVec 32 := (Signals.v_n619 inputs state)

-- Next register value; aliases: cpu.regfile[14]; src: unavailable after lowering
def v_cpu_regfile_14_ (inputs : Inputs) (state : State) : BitVec 32 := (Signals.v_n622 inputs state)

-- Next register value; aliases: cpu.regfile[15]; src: unavailable after lowering
def v_cpu_regfile_15_ (inputs : Inputs) (state : State) : BitVec 32 := (Signals.v_n625 inputs state)

-- Next register value; aliases: cpu.regfile[16]; src: unavailable after lowering
def v_cpu_regfile_16_ (inputs : Inputs) (state : State) : BitVec 32 := (Signals.v_n630 inputs state)

-- Next register value; aliases: cpu.regfile[17]; src: unavailable after lowering
def v_cpu_regfile_17_ (inputs : Inputs) (state : State) : BitVec 32 := (Signals.v_n633 inputs state)

-- Next register value; aliases: cpu.regfile[18]; src: unavailable after lowering
def v_cpu_regfile_18_ (inputs : Inputs) (state : State) : BitVec 32 := (Signals.v_n636 inputs state)

-- Next register value; aliases: cpu.regfile[19]; src: unavailable after lowering
def v_cpu_regfile_19_ (inputs : Inputs) (state : State) : BitVec 32 := (Signals.v_n639 inputs state)

-- Next register value; aliases: cpu.regfile[20]; src: unavailable after lowering
def v_cpu_regfile_20_ (inputs : Inputs) (state : State) : BitVec 32 := (Signals.v_n643 inputs state)

-- Next register value; aliases: cpu.regfile[21]; src: unavailable after lowering
def v_cpu_regfile_21_ (inputs : Inputs) (state : State) : BitVec 32 := (Signals.v_n646 inputs state)

-- Next register value; aliases: cpu.regfile[22]; src: unavailable after lowering
def v_cpu_regfile_22_ (inputs : Inputs) (state : State) : BitVec 32 := (Signals.v_n649 inputs state)

-- Next register value; aliases: cpu.regfile[23]; src: unavailable after lowering
def v_cpu_regfile_23_ (inputs : Inputs) (state : State) : BitVec 32 := (Signals.v_n652 inputs state)

-- Next register value; aliases: cpu.regfile[24]; src: unavailable after lowering
def v_cpu_regfile_24_ (inputs : Inputs) (state : State) : BitVec 32 := (Signals.v_n656 inputs state)

-- Next register value; aliases: cpu.regfile[25]; src: unavailable after lowering
def v_cpu_regfile_25_ (inputs : Inputs) (state : State) : BitVec 32 := (Signals.v_n659 inputs state)

-- Next register value; aliases: cpu.regfile[26]; src: unavailable after lowering
def v_cpu_regfile_26_ (inputs : Inputs) (state : State) : BitVec 32 := (Signals.v_n662 inputs state)

-- Next register value; aliases: cpu.regfile[27]; src: unavailable after lowering
def v_cpu_regfile_27_ (inputs : Inputs) (state : State) : BitVec 32 := (Signals.v_n665 inputs state)

-- Next register value; aliases: cpu.regfile[28]; src: unavailable after lowering
def v_cpu_regfile_28_ (inputs : Inputs) (state : State) : BitVec 32 := (Signals.v_n668 inputs state)

-- Next register value; aliases: cpu.regfile[29]; src: unavailable after lowering
def v_cpu_regfile_29_ (inputs : Inputs) (state : State) : BitVec 32 := (Signals.v_n671 inputs state)

-- Next register value; aliases: cpu.regfile[30]; src: unavailable after lowering
def v_cpu_regfile_30_ (inputs : Inputs) (state : State) : BitVec 32 := (Signals.v_n674 inputs state)

-- Next register value; aliases: cpu.mem_rd_func_q; src: examples/riscv/upstream/nerv/nerv.sv:80.2-89.5
def v_cpu_mem_rd_func_q (inputs : Inputs) (state : State) : BitVec 5 := (Signals.v_n697 inputs state)

-- Next register value; aliases: cpu.rvfi_pre_valid; src: examples/riscv/upstream/nerv/nerv.sv:381.2-440.5
def v_cpu_rvfi_pre_valid (inputs : Inputs) (state : State) : BitVec 1 := (Signals.v_n701 inputs state)

-- Next register value; aliases: cpu.trap cpu.trapped; src: examples/riscv/upstream/nerv/nerv.sv:381.2-440.5
def v_cpu_trap (inputs : Inputs) (state : State) : BitVec 1 := (Signals.v_n884 inputs state)

-- Next register value; aliases: cpu.reset_q; src: examples/riscv/upstream/nerv/nerv.sv:381.2-440.5
def v_cpu_reset_q (inputs : Inputs) (state : State) : BitVec 1 := (Signals.v_reset inputs state)

-- Next register value; aliases: cpu.trapped_q; src: examples/riscv/upstream/nerv/nerv.sv:381.2-440.5
def v_cpu_trapped_q (inputs : Inputs) (state : State) : BitVec 1 := (Signals.v_cpu_trapped inputs state)

-- Next register value; aliases: cpu.pc; src: examples/riscv/upstream/nerv/nerv.sv:381.2-440.5
def v_cpu_pc (inputs : Inputs) (state : State) : BitVec 32 := (Signals.v_n938 inputs state)

-- Next register value; aliases: cpu.rvfi_pre_rd_addr; src: examples/riscv/upstream/nerv/nerv.sv:381.2-440.5
def v_cpu_rvfi_pre_rd_addr (inputs : Inputs) (state : State) : BitVec 5 := (Signals.v_n941 inputs state)

-- Next register value; aliases: cpu.mem_rd_reg_q; src: examples/riscv/upstream/nerv/nerv.sv:80.2-89.5
def v_cpu_mem_rd_reg_q (inputs : Inputs) (state : State) : BitVec 5 := (Signals.v_n946 inputs state)

-- Next register value; aliases: cpu.rvfi_pre_rd_wdata; src: examples/riscv/upstream/nerv/nerv.sv:381.2-440.5
def v_cpu_rvfi_pre_rd_wdata (inputs : Inputs) (state : State) : BitVec 32 := (Signals.v_n951 inputs state)

-- Next register value; aliases: cpu.mem_rd_enable_q; src: examples/riscv/upstream/nerv/nerv.sv:80.2-89.5
def v_cpu_mem_rd_enable_q (inputs : Inputs) (state : State) : BitVec 1 := (Signals.v_n957 inputs state)

-- Next register value; aliases: started; src: examples/riscv/NervHarness.sv:19.3-19.40
def v_started (inputs : Inputs) (state : State) : BitVec 1 := (Signals.v_n387 inputs state)

-- Next register value; aliases: check_insn.insn check_insn.insn_spec.rvfi_insn check_insn.rvfi_insn cpu.rvfi_insn rvfi_insn; src: examples/riscv/upstream/nerv/nerv.sv:381.2-440.5
def v_check_insn_insn (inputs : Inputs) (state : State) : BitVec 32 := (Signals.v_n978 inputs state)

-- Next register value; aliases: check_insn.rvfi_trap check_insn.trap cpu.rvfi_trap rvfi_trap; src: examples/riscv/upstream/nerv/nerv.sv:381.2-440.5
def v_check_insn_rvfi_trap (inputs : Inputs) (state : State) : BitVec 1 := (Signals.v_n980 inputs state)

-- Next register value; aliases: check_insn.halt check_insn.rvfi_halt cpu.rvfi_halt rvfi_halt; src: examples/riscv/upstream/nerv/nerv.sv:381.2-440.5
def v_check_insn_halt (inputs : Inputs) (state : State) : BitVec 1 := (Signals.v_n982 inputs state)

-- Next register value; aliases: check_insn.intr check_insn.rvfi_intr cpu.rvfi_intr rvfi_intr; src: examples/riscv/upstream/nerv/nerv.sv:381.2-440.5
def v_check_insn_intr (inputs : Inputs) (state : State) : BitVec 1 := (Signals.v_n984 inputs state)

-- Next register value; aliases: check_insn.rs1_addr check_insn.rvfi_rs1_addr cpu.rvfi_rs1_addr rvfi_rs1_addr; src: examples/riscv/upstream/nerv/nerv.sv:381.2-440.5
def v_check_insn_rs1_addr (inputs : Inputs) (state : State) : BitVec 5 := (Signals.v_n986 inputs state)

-- Next register value; aliases: check_insn.rs2_addr check_insn.rvfi_rs2_addr cpu.rvfi_rs2_addr rvfi_rs2_addr; src: examples/riscv/upstream/nerv/nerv.sv:381.2-440.5
def v_check_insn_rs2_addr (inputs : Inputs) (state : State) : BitVec 5 := (Signals.v_n988 inputs state)

-- Next register value; aliases: check_insn.rs1_rdata check_insn.rvfi_rs1_rdata cpu.rvfi_rs1_rdata rvfi_rs1_rdata; src: examples/riscv/upstream/nerv/nerv.sv:381.2-440.5
def v_check_insn_rs1_rdata (inputs : Inputs) (state : State) : BitVec 32 := (Signals.v_n990 inputs state)

-- Next register value; aliases: check_insn.rs2_rdata check_insn.rvfi_rs2_rdata cpu.rvfi_rs2_rdata rvfi_rs2_rdata; src: examples/riscv/upstream/nerv/nerv.sv:381.2-440.5
def v_check_insn_rs2_rdata (inputs : Inputs) (state : State) : BitVec 32 := (Signals.v_n992 inputs state)

-- Next register value; aliases: check_insn.insn_spec.rvfi_pc_rdata check_insn.pc_rdata check_insn.rvfi_pc_rdata cpu.rvfi_pc_rdata rvfi_pc_rdata; src: examples/riscv/upstream/nerv/nerv.sv:381.2-440.5
def v_check_insn_insn_spec_rvfi_pc_rdata (inputs : Inputs) (state : State) : BitVec 32 := (Signals.v_n994 inputs state)

-- Next register value; aliases: check_insn.pc_wdata check_insn.rvfi_pc_wdata cpu.rvfi_pc_wdata rvfi_pc_wdata; src: examples/riscv/upstream/nerv/nerv.sv:381.2-440.5
def v_check_insn_pc_wdata (inputs : Inputs) (state : State) : BitVec 32 := (Signals.v_n996 inputs state)

-- Next register value; aliases: check_insn.mem_addr check_insn.rvfi_mem_addr cpu.rvfi_mem_addr rvfi_mem_addr; src: examples/riscv/upstream/nerv/nerv.sv:381.2-440.5
def v_check_insn_mem_addr (inputs : Inputs) (state : State) : BitVec 32 := (Signals.v_n1017 inputs state)

-- Next register value; aliases: check_insn.mem_rmask check_insn.rvfi_mem_rmask cpu.rvfi_mem_rmask rvfi_mem_rmask; src: examples/riscv/upstream/nerv/nerv.sv:381.2-440.5
def v_check_insn_mem_rmask (inputs : Inputs) (state : State) : BitVec 4 := (Signals.v_n1055 inputs state)

-- Next register value; aliases: check_insn.mem_wmask check_insn.rvfi_mem_wmask cpu.rvfi_mem_wmask rvfi_mem_wmask; src: examples/riscv/upstream/nerv/nerv.sv:381.2-440.5
def v_check_insn_mem_wmask (inputs : Inputs) (state : State) : BitVec 4 := (Signals.v_n1079 inputs state)

-- Next register value; aliases: check_insn.mem_wdata check_insn.rvfi_mem_wdata cpu.rvfi_mem_wdata rvfi_mem_wdata; src: examples/riscv/upstream/nerv/nerv.sv:381.2-440.5
def v_check_insn_mem_wdata (inputs : Inputs) (state : State) : BitVec 32 := (Signals.v_n1096 inputs state)

-- Next register value; aliases: check_insn.rvfi_order cpu.rvfi_order rvfi_order; src: examples/riscv/upstream/nerv/nerv.sv:381.2-440.5
def v_check_insn_rvfi_order (inputs : Inputs) (state : State) : BitVec 64 := (Signals.v_n1103 inputs state)

-- Next register value; aliases: check_insn.rvfi_mode cpu.rvfi_mode rvfi_mode; src: examples/riscv/upstream/nerv/nerv.sv:381.2-440.5
def v_check_insn_rvfi_mode (inputs : Inputs) (state : State) : BitVec 2 := (Signals.v_n1106 inputs state)

-- Next register value; aliases: check_insn.rvfi_ixl cpu.rvfi_ixl rvfi_ixl; src: examples/riscv/upstream/nerv/nerv.sv:381.2-440.5
def v_check_insn_rvfi_ixl (inputs : Inputs) (state : State) : BitVec 2 := (Signals.v_n1109 inputs state)

end Next

def eval (inputs : Inputs) (state : State) : Outputs × State :=
  ({
     v__examples_riscv_NervHarness_sv_20_assume_254 := (Signals.v_n1113 inputs state),
     v__flatten_check_insn__examples_riscv_upstream_riscv_formal_rvfi_insn_check_sv_193_assert_228 := (Signals.v_n1116 inputs state),
     v__flatten_check_insn__examples_riscv_upstream_riscv_formal_rvfi_insn_check_sv_190_assert_226 := (Signals.v_n1139 inputs state),
     v__flatten_check_insn__examples_riscv_upstream_riscv_formal_rvfi_insn_check_sv_189_assert_232 := (Signals.v_n1145 inputs state),
     v__flatten_check_insn__examples_riscv_upstream_riscv_formal_rvfi_insn_check_sv_187_assert_230 := (Signals.v_n1150 inputs state),
     v__flatten_check_insn__examples_riscv_upstream_riscv_formal_rvfi_insn_check_sv_189_assert_225 := (Signals.v_n1152 inputs state),
     v__flatten_check_insn__examples_riscv_upstream_riscv_formal_rvfi_insn_check_sv_187_assert_223 := (Signals.v_n1156 inputs state),
     v__flatten_check_insn__examples_riscv_upstream_riscv_formal_rvfi_insn_check_sv_189_assert_239 := (Signals.v_n1162 inputs state),
     v__flatten_check_insn__examples_riscv_upstream_riscv_formal_rvfi_insn_check_sv_187_assert_237 := (Signals.v_n1167 inputs state),
     v__flatten_check_insn__examples_riscv_upstream_riscv_formal_rvfi_insn_check_sv_186_assert_236 := (Signals.v_n1169 inputs state),
     v__flatten_check_insn__examples_riscv_upstream_riscv_formal_rvfi_insn_check_sv_190_assert_240 := (Signals.v_n1173 inputs state),
     v__flatten_check_insn__examples_riscv_upstream_riscv_formal_rvfi_insn_check_sv_193_assert_235 := (Signals.v_n1175 inputs state),
     v__flatten_check_insn__examples_riscv_upstream_riscv_formal_rvfi_insn_check_sv_135_cover_166 := (Signals.v_n1183 inputs state),
     v__flatten_check_insn__examples_riscv_upstream_riscv_formal_rvfi_insn_check_sv_190_assert_233 := (Signals.v_n1187 inputs state),
     v__flatten_check_insn__examples_riscv_upstream_riscv_formal_rvfi_insn_check_sv_137_cover_170 := (Signals.v_n1191 inputs state),
     v__flatten_check_insn__examples_riscv_upstream_riscv_formal_rvfi_insn_check_sv_136_cover_167 := (Signals.v_n1196 inputs state),
     v__flatten_check_insn__examples_riscv_upstream_riscv_formal_rvfi_insn_check_sv_138_cover_172 := (Signals.v_n1200 inputs state),
     v__flatten_check_insn__examples_riscv_upstream_riscv_formal_rvfi_insn_check_sv_141_assume_178 := (Signals.v_n1203 inputs state),
     v__flatten_check_insn__examples_riscv_upstream_riscv_formal_rvfi_insn_check_sv_144_assert_182 := (Signals.v_n1205 inputs state),
     v__flatten_check_insn__examples_riscv_upstream_riscv_formal_rvfi_insn_check_sv_146_assert_185 := (Signals.v_n1212 inputs state),
     v__flatten_check_insn__examples_riscv_upstream_riscv_formal_rvfi_insn_check_sv_145_assert_183 := (Signals.v_n1217 inputs state),
     v__flatten_check_insn__examples_riscv_upstream_riscv_formal_rvfi_insn_check_sv_147_assert_187 := (Signals.v_n1221 inputs state),
     v__flatten_check_insn__examples_riscv_upstream_riscv_formal_rvfi_insn_check_sv_167_assert_193 := (Signals.v_n1229 inputs state),
     v__flatten_check_insn__examples_riscv_upstream_riscv_formal_rvfi_insn_check_sv_164_assert_190 := (Signals.v_n1237 inputs state),
     v__flatten_check_insn__examples_riscv_upstream_riscv_formal_rvfi_insn_check_sv_186_assert_229 := (Signals.v_n1239 inputs state),
     v__flatten_check_insn__examples_riscv_upstream_riscv_formal_rvfi_insn_check_sv_171_assert_197 := (Signals.v_n1245 inputs state),
     v__flatten_check_insn__examples_riscv_upstream_riscv_formal_rvfi_insn_check_sv_176_assert_202 := (Signals.v_n1248 inputs state),
     v__flatten_check_insn__examples_riscv_upstream_riscv_formal_rvfi_insn_check_sv_174_assert_200 := (Signals.v_n1254 inputs state),
     v__flatten_check_insn__examples_riscv_upstream_riscv_formal_rvfi_insn_check_sv_193_assert_242 := (Signals.v_n1256 inputs state),
     v__flatten_check_insn__examples_riscv_upstream_riscv_formal_rvfi_insn_check_sv_177_assert_204 := (Signals.v_n1264 inputs state),
     v__flatten_check_insn__examples_riscv_upstream_riscv_formal_rvfi_insn_check_sv_178_assert_206 := (Signals.v_n1268 inputs state),
     v__flatten_check_insn__examples_riscv_upstream_riscv_formal_rvfi_insn_check_sv_186_assert_215 := (Signals.v_n1271 inputs state),
     v__flatten_check_insn__examples_riscv_upstream_riscv_formal_rvfi_insn_check_sv_181_assert_211 := (Signals.v_n1275 inputs state),
     v__flatten_check_insn__examples_riscv_upstream_riscv_formal_rvfi_insn_check_sv_198_assert_243 := (Signals.v_n1278 inputs state),
     v__flatten_check_insn__examples_riscv_upstream_riscv_formal_rvfi_insn_check_sv_189_assert_218 := (Signals.v_n1283 inputs state),
     v__flatten_check_insn__examples_riscv_upstream_riscv_formal_rvfi_insn_check_sv_187_assert_216 := (Signals.v_n1288 inputs state),
     v__flatten_check_insn__examples_riscv_upstream_riscv_formal_rvfi_insn_check_sv_186_assert_222 := (Signals.v_n1290 inputs state),
     v__flatten_check_insn__examples_riscv_upstream_riscv_formal_rvfi_insn_check_sv_193_assert_221 := (Signals.v_n1292 inputs state),
     v__flatten_check_insn__examples_riscv_upstream_riscv_formal_rvfi_insn_check_sv_190_assert_219 := (Signals.v_n1296 inputs state),
     v_rvfi_valid := (Signals.v_rvfi_valid inputs state),
     v_rvfi_order := (Signals.v_cpu_rvfi_order inputs state),
     v_rvfi_insn := (Signals.v_rvfi_insn inputs state),
     v_rvfi_trap := (Signals.v_rvfi_trap inputs state),
     v_rvfi_halt := (Signals.v_rvfi_halt inputs state),
     v_rvfi_intr := (Signals.v_rvfi_intr inputs state),
     v_rvfi_mode := (Signals.v_rvfi_mode inputs state),
     v_rvfi_ixl := (Signals.v_rvfi_ixl inputs state),
     v_rvfi_rs1_addr := (Signals.v_rvfi_rs1_addr inputs state),
     v_rvfi_rs2_addr := (Signals.v_rvfi_rs2_addr inputs state),
     v_rvfi_rs1_rdata := (Signals.v_rvfi_rs1_rdata inputs state),
     v_rvfi_rs2_rdata := (Signals.v_rvfi_rs2_rdata inputs state),
     v_rvfi_rd_addr := (Signals.v_rvfi_rd_addr inputs state),
     v_rvfi_rd_wdata := (Signals.v_rvfi_rd_wdata inputs state),
     v_rvfi_pc_rdata := (Signals.v_rvfi_pc_rdata inputs state),
     v_rvfi_pc_wdata := (Signals.v_rvfi_pc_wdata inputs state),
     v_rvfi_mem_addr := (Signals.v_rvfi_mem_addr inputs state),
     v_rvfi_mem_rmask := (Signals.v_rvfi_mem_rmask inputs state),
     v_rvfi_mem_wmask := (Signals.v_rvfi_mem_wmask inputs state),
     v_rvfi_mem_rdata := (Signals.v_rvfi_mem_rdata inputs state),
     v_rvfi_mem_wdata := (Signals.v_rvfi_mem_wdata inputs state)
   }, {
     v_cpu_regfile_31_ := (Signals.v_n531 inputs state),
     v_cpu_regfile_0_ := (Signals.v_n574 inputs state),
     v_cpu_regfile_1_ := (Signals.v_n578 inputs state),
     v_cpu_regfile_2_ := (Signals.v_n582 inputs state),
     v_cpu_regfile_3_ := (Signals.v_n585 inputs state),
     v_cpu_regfile_4_ := (Signals.v_n589 inputs state),
     v_cpu_regfile_5_ := (Signals.v_n592 inputs state),
     v_cpu_regfile_6_ := (Signals.v_n595 inputs state),
     v_cpu_regfile_7_ := (Signals.v_n598 inputs state),
     v_cpu_regfile_8_ := (Signals.v_n603 inputs state),
     v_cpu_regfile_9_ := (Signals.v_n606 inputs state),
     v_cpu_regfile_10_ := (Signals.v_n609 inputs state),
     v_cpu_regfile_11_ := (Signals.v_n612 inputs state),
     v_cpu_regfile_12_ := (Signals.v_n616 inputs state),
     v_cpu_regfile_13_ := (Signals.v_n619 inputs state),
     v_cpu_regfile_14_ := (Signals.v_n622 inputs state),
     v_cpu_regfile_15_ := (Signals.v_n625 inputs state),
     v_cpu_regfile_16_ := (Signals.v_n630 inputs state),
     v_cpu_regfile_17_ := (Signals.v_n633 inputs state),
     v_cpu_regfile_18_ := (Signals.v_n636 inputs state),
     v_cpu_regfile_19_ := (Signals.v_n639 inputs state),
     v_cpu_regfile_20_ := (Signals.v_n643 inputs state),
     v_cpu_regfile_21_ := (Signals.v_n646 inputs state),
     v_cpu_regfile_22_ := (Signals.v_n649 inputs state),
     v_cpu_regfile_23_ := (Signals.v_n652 inputs state),
     v_cpu_regfile_24_ := (Signals.v_n656 inputs state),
     v_cpu_regfile_25_ := (Signals.v_n659 inputs state),
     v_cpu_regfile_26_ := (Signals.v_n662 inputs state),
     v_cpu_regfile_27_ := (Signals.v_n665 inputs state),
     v_cpu_regfile_28_ := (Signals.v_n668 inputs state),
     v_cpu_regfile_29_ := (Signals.v_n671 inputs state),
     v_cpu_regfile_30_ := (Signals.v_n674 inputs state),
     v_cpu_mem_rd_func_q := (Signals.v_n697 inputs state),
     v_cpu_rvfi_pre_valid := (Signals.v_n701 inputs state),
     v_cpu_trap := (Signals.v_n884 inputs state),
     v_cpu_reset_q := (Signals.v_reset inputs state),
     v_cpu_trapped_q := (Signals.v_cpu_trapped inputs state),
     v_cpu_pc := (Signals.v_n938 inputs state),
     v_cpu_rvfi_pre_rd_addr := (Signals.v_n941 inputs state),
     v_cpu_mem_rd_reg_q := (Signals.v_n946 inputs state),
     v_cpu_rvfi_pre_rd_wdata := (Signals.v_n951 inputs state),
     v_cpu_mem_rd_enable_q := (Signals.v_n957 inputs state),
     v_started := (Signals.v_n387 inputs state),
     v_check_insn_insn := (Signals.v_n978 inputs state),
     v_check_insn_rvfi_trap := (Signals.v_n980 inputs state),
     v_check_insn_halt := (Signals.v_n982 inputs state),
     v_check_insn_intr := (Signals.v_n984 inputs state),
     v_check_insn_rs1_addr := (Signals.v_n986 inputs state),
     v_check_insn_rs2_addr := (Signals.v_n988 inputs state),
     v_check_insn_rs1_rdata := (Signals.v_n990 inputs state),
     v_check_insn_rs2_rdata := (Signals.v_n992 inputs state),
     v_check_insn_insn_spec_rvfi_pc_rdata := (Signals.v_n994 inputs state),
     v_check_insn_pc_wdata := (Signals.v_n996 inputs state),
     v_check_insn_mem_addr := (Signals.v_n1017 inputs state),
     v_check_insn_mem_rmask := (Signals.v_n1055 inputs state),
     v_check_insn_mem_wmask := (Signals.v_n1079 inputs state),
     v_check_insn_mem_wdata := (Signals.v_n1096 inputs state),
     v_check_insn_rvfi_order := (Signals.v_n1103 inputs state),
     v_check_insn_rvfi_mode := (Signals.v_n1106 inputs state),
     v_check_insn_rvfi_ixl := (Signals.v_n1109 inputs state)
   })

theorem eval_next_v_cpu_regfile_31_ (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_cpu_regfile_31_ = Next.v_cpu_regfile_31_ inputs state := by rfl

theorem eval_next_v_cpu_regfile_0_ (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_cpu_regfile_0_ = Next.v_cpu_regfile_0_ inputs state := by rfl

theorem eval_next_v_cpu_regfile_1_ (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_cpu_regfile_1_ = Next.v_cpu_regfile_1_ inputs state := by rfl

theorem eval_next_v_cpu_regfile_2_ (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_cpu_regfile_2_ = Next.v_cpu_regfile_2_ inputs state := by rfl

theorem eval_next_v_cpu_regfile_3_ (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_cpu_regfile_3_ = Next.v_cpu_regfile_3_ inputs state := by rfl

theorem eval_next_v_cpu_regfile_4_ (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_cpu_regfile_4_ = Next.v_cpu_regfile_4_ inputs state := by rfl

theorem eval_next_v_cpu_regfile_5_ (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_cpu_regfile_5_ = Next.v_cpu_regfile_5_ inputs state := by rfl

theorem eval_next_v_cpu_regfile_6_ (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_cpu_regfile_6_ = Next.v_cpu_regfile_6_ inputs state := by rfl

theorem eval_next_v_cpu_regfile_7_ (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_cpu_regfile_7_ = Next.v_cpu_regfile_7_ inputs state := by rfl

theorem eval_next_v_cpu_regfile_8_ (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_cpu_regfile_8_ = Next.v_cpu_regfile_8_ inputs state := by rfl

theorem eval_next_v_cpu_regfile_9_ (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_cpu_regfile_9_ = Next.v_cpu_regfile_9_ inputs state := by rfl

theorem eval_next_v_cpu_regfile_10_ (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_cpu_regfile_10_ = Next.v_cpu_regfile_10_ inputs state := by rfl

theorem eval_next_v_cpu_regfile_11_ (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_cpu_regfile_11_ = Next.v_cpu_regfile_11_ inputs state := by rfl

theorem eval_next_v_cpu_regfile_12_ (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_cpu_regfile_12_ = Next.v_cpu_regfile_12_ inputs state := by rfl

theorem eval_next_v_cpu_regfile_13_ (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_cpu_regfile_13_ = Next.v_cpu_regfile_13_ inputs state := by rfl

theorem eval_next_v_cpu_regfile_14_ (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_cpu_regfile_14_ = Next.v_cpu_regfile_14_ inputs state := by rfl

theorem eval_next_v_cpu_regfile_15_ (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_cpu_regfile_15_ = Next.v_cpu_regfile_15_ inputs state := by rfl

theorem eval_next_v_cpu_regfile_16_ (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_cpu_regfile_16_ = Next.v_cpu_regfile_16_ inputs state := by rfl

theorem eval_next_v_cpu_regfile_17_ (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_cpu_regfile_17_ = Next.v_cpu_regfile_17_ inputs state := by rfl

theorem eval_next_v_cpu_regfile_18_ (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_cpu_regfile_18_ = Next.v_cpu_regfile_18_ inputs state := by rfl

theorem eval_next_v_cpu_regfile_19_ (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_cpu_regfile_19_ = Next.v_cpu_regfile_19_ inputs state := by rfl

theorem eval_next_v_cpu_regfile_20_ (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_cpu_regfile_20_ = Next.v_cpu_regfile_20_ inputs state := by rfl

theorem eval_next_v_cpu_regfile_21_ (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_cpu_regfile_21_ = Next.v_cpu_regfile_21_ inputs state := by rfl

theorem eval_next_v_cpu_regfile_22_ (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_cpu_regfile_22_ = Next.v_cpu_regfile_22_ inputs state := by rfl

theorem eval_next_v_cpu_regfile_23_ (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_cpu_regfile_23_ = Next.v_cpu_regfile_23_ inputs state := by rfl

theorem eval_next_v_cpu_regfile_24_ (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_cpu_regfile_24_ = Next.v_cpu_regfile_24_ inputs state := by rfl

theorem eval_next_v_cpu_regfile_25_ (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_cpu_regfile_25_ = Next.v_cpu_regfile_25_ inputs state := by rfl

theorem eval_next_v_cpu_regfile_26_ (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_cpu_regfile_26_ = Next.v_cpu_regfile_26_ inputs state := by rfl

theorem eval_next_v_cpu_regfile_27_ (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_cpu_regfile_27_ = Next.v_cpu_regfile_27_ inputs state := by rfl

theorem eval_next_v_cpu_regfile_28_ (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_cpu_regfile_28_ = Next.v_cpu_regfile_28_ inputs state := by rfl

theorem eval_next_v_cpu_regfile_29_ (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_cpu_regfile_29_ = Next.v_cpu_regfile_29_ inputs state := by rfl

theorem eval_next_v_cpu_regfile_30_ (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_cpu_regfile_30_ = Next.v_cpu_regfile_30_ inputs state := by rfl

theorem eval_next_v_cpu_mem_rd_func_q (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_cpu_mem_rd_func_q = Next.v_cpu_mem_rd_func_q inputs state := by rfl

theorem eval_next_v_cpu_rvfi_pre_valid (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_cpu_rvfi_pre_valid = Next.v_cpu_rvfi_pre_valid inputs state := by rfl

theorem eval_next_v_cpu_trap (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_cpu_trap = Next.v_cpu_trap inputs state := by rfl

theorem eval_next_v_cpu_reset_q (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_cpu_reset_q = Next.v_cpu_reset_q inputs state := by rfl

theorem eval_next_v_cpu_trapped_q (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_cpu_trapped_q = Next.v_cpu_trapped_q inputs state := by rfl

theorem eval_next_v_cpu_pc (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_cpu_pc = Next.v_cpu_pc inputs state := by rfl

theorem eval_next_v_cpu_rvfi_pre_rd_addr (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_cpu_rvfi_pre_rd_addr = Next.v_cpu_rvfi_pre_rd_addr inputs state := by rfl

theorem eval_next_v_cpu_mem_rd_reg_q (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_cpu_mem_rd_reg_q = Next.v_cpu_mem_rd_reg_q inputs state := by rfl

theorem eval_next_v_cpu_rvfi_pre_rd_wdata (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_cpu_rvfi_pre_rd_wdata = Next.v_cpu_rvfi_pre_rd_wdata inputs state := by rfl

theorem eval_next_v_cpu_mem_rd_enable_q (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_cpu_mem_rd_enable_q = Next.v_cpu_mem_rd_enable_q inputs state := by rfl

theorem eval_next_v_started (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_started = Next.v_started inputs state := by rfl

theorem eval_next_v_check_insn_insn (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_check_insn_insn = Next.v_check_insn_insn inputs state := by rfl

theorem eval_next_v_check_insn_rvfi_trap (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_check_insn_rvfi_trap = Next.v_check_insn_rvfi_trap inputs state := by rfl

theorem eval_next_v_check_insn_halt (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_check_insn_halt = Next.v_check_insn_halt inputs state := by rfl

theorem eval_next_v_check_insn_intr (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_check_insn_intr = Next.v_check_insn_intr inputs state := by rfl

theorem eval_next_v_check_insn_rs1_addr (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_check_insn_rs1_addr = Next.v_check_insn_rs1_addr inputs state := by rfl

theorem eval_next_v_check_insn_rs2_addr (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_check_insn_rs2_addr = Next.v_check_insn_rs2_addr inputs state := by rfl

theorem eval_next_v_check_insn_rs1_rdata (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_check_insn_rs1_rdata = Next.v_check_insn_rs1_rdata inputs state := by rfl

theorem eval_next_v_check_insn_rs2_rdata (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_check_insn_rs2_rdata = Next.v_check_insn_rs2_rdata inputs state := by rfl

theorem eval_next_v_check_insn_insn_spec_rvfi_pc_rdata (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_check_insn_insn_spec_rvfi_pc_rdata = Next.v_check_insn_insn_spec_rvfi_pc_rdata inputs state := by rfl

theorem eval_next_v_check_insn_pc_wdata (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_check_insn_pc_wdata = Next.v_check_insn_pc_wdata inputs state := by rfl

theorem eval_next_v_check_insn_mem_addr (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_check_insn_mem_addr = Next.v_check_insn_mem_addr inputs state := by rfl

theorem eval_next_v_check_insn_mem_rmask (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_check_insn_mem_rmask = Next.v_check_insn_mem_rmask inputs state := by rfl

theorem eval_next_v_check_insn_mem_wmask (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_check_insn_mem_wmask = Next.v_check_insn_mem_wmask inputs state := by rfl

theorem eval_next_v_check_insn_mem_wdata (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_check_insn_mem_wdata = Next.v_check_insn_mem_wdata inputs state := by rfl

theorem eval_next_v_check_insn_rvfi_order (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_check_insn_rvfi_order = Next.v_check_insn_rvfi_order inputs state := by rfl

theorem eval_next_v_check_insn_rvfi_mode (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_check_insn_rvfi_mode = Next.v_check_insn_rvfi_mode inputs state := by rfl

theorem eval_next_v_check_insn_rvfi_ixl (inputs : Inputs) (state : State) :
    (eval inputs state).2.v_check_insn_rvfi_ixl = Next.v_check_insn_rvfi_ixl inputs state := by rfl

theorem agrees (i : Inputs) (s : State) : eval i s = v_NervAdd.eval i s := by rfl
end v_NervAdd.Named
