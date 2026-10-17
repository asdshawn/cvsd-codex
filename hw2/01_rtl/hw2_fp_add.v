// FP32 arithmetic is implemented exclusively by combinational DesignWare IP.
// The licensed simulation models are referenced by rtl.f, never redistributed.
module hw2_fp_add(input [31:0] a,b, output [31:0] z, output [7:0] status);
    DW_fp_add #(23,8,1) ip(.a(a),.b(b),.rnd(3'b000),.z(z),.status(status));
endmodule
