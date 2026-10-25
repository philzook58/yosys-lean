module Ops(input [7:0] a, b, input [3:0] sh, input sel,
  output [7:0] add_, sub_, mul_, div_, mod_, and_, or_, xor_, not_, neg_,
  output [7:0] shl_, shr_, ashr_, mux_,
  output eq_, ne_, sgt_, sge_, ugt_, uge_, ra_, ro_, rx_,
  output [15:0] cat_, zext_, sext_, output [3:0] slice_);
  assign add_ = a + b;
  assign sub_ = a - b;
  assign mul_ = a * b;
  assign div_ = a / b;
  assign mod_ = a % b;
  assign and_ = a & b;
  assign or_ = a | b;
  assign xor_ = a ^ b;
  assign not_ = ~a;
  assign neg_ = -a;
  assign shl_ = a << sh;
  assign shr_ = a >> sh;
  assign ashr_ = $signed(a) >>> sh;
  assign mux_ = sel ? b : a;
  assign eq_ = a == b;
  assign ne_ = a != b;
  assign sgt_ = $signed(a) > $signed(b);
  assign sge_ = $signed(a) >= $signed(b);
  assign ugt_ = a > b;
  assign uge_ = a >= b;
  assign ra_ = &a;
  assign ro_ = |a;
  assign rx_ = ^a;
  assign cat_ = {a, b};
  assign zext_ = a;
  assign sext_ = $signed(a);
  assign slice_ = a[5:2];
endmodule
