module hw2_fp_div(input [31:0] a,b, output [31:0] z, output [7:0] status);
    DW_fp_div #(23,8,1) ip(.a(a),.b(b),.rnd(3'b000),.z(z),.status(status));
endmodule
