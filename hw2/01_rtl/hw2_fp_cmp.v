module hw2_fp_cmp(input [31:0] a,b, output eq,lt,gt,unordered);
    wire [31:0] lint_unused_min,lint_unused_max;
    wire [7:0] lint_unused_status0,lint_unused_status1;
    DW_fp_cmp #(23,8,1) ip(.a(a),.b(b),.zctr(1'b0),.aeqb(eq),
        .altb(lt),.agtb(gt),.unordered(unordered),.z0(lint_unused_min),
        .z1(lint_unused_max),.status0(lint_unused_status0),.status1(lint_unused_status1));
endmodule
