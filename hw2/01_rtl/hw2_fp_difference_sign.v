
// For finite IEEE FP32 a,b, sign(RNE(a-b)) equals compare(a,b), including
// subnormals: distinct representable operands differ by at least 2^-149.
// Only opposite signs with an exponent of 254 can overflow a-b. Preserve
// that exceptional-result check with DW subtraction; normal pixels need only
// DW comparison. VERIFY_VALUE exposes the full result for independent tests.
module hw2_fp_difference_sign #(parameter VERIFY_VALUE=0)(
    input enable,
    input [31:0] a,b,
    output eq,lt,gt,unordered,fault,
    output [31:0] difference,
    output [7:0] status
);
    wire evaluate=enable&&(VERIFY_VALUE||
        ((a[31]!=b[31])&&(a[30:23]==8'hfe||b[30:23]==8'hfe)));
    hw2_fp_sub exceptional(.a(evaluate?a:32'b0),.b(evaluate?b:32'b0),
        .z(difference),.status(status));
    hw2_fp_cmp order(.a(enable?a:32'b0),.b(enable?b:32'b0),
        .eq(eq),.lt(lt),.gt(gt),.unordered(unordered));
    assign fault=enable&&(a[30:23]==8'hff||b[30:23]==8'hff||difference[30:23]==8'hff);
endmodule
