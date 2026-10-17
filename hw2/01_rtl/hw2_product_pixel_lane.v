
module hw2_product_pixel_lane #(parameter VERIFY_EDGE_VALUES=0)(
    input enable,area_positive,area_negative,
    input [31:0] ab_col,ab_row,bc_col,bc_row,ca_col,ca_row,
    output hit,fault,
    output [7:0] status
);
    wire [31:0] lint_unused_e0,lint_unused_e1,lint_unused_e2;
    wire [7:0] ss[0:2];
    wire [2:0] eq,lt,gt,un;
    wire [2:0] edge_fault;
    hw2_fp_difference_sign #(VERIFY_EDGE_VALUES) s0(.enable(enable),.a(ab_row),.b(ab_col),
        .eq(eq[0]),.lt(lt[0]),.gt(gt[0]),.unordered(un[0]),.fault(edge_fault[0]),.difference(lint_unused_e0),.status(ss[0]));
    hw2_fp_difference_sign #(VERIFY_EDGE_VALUES) s1(.enable(enable),.a(bc_row),.b(bc_col),
        .eq(eq[1]),.lt(lt[1]),.gt(gt[1]),.unordered(un[1]),.fault(edge_fault[1]),.difference(lint_unused_e1),.status(ss[1]));
    hw2_fp_difference_sign #(VERIFY_EDGE_VALUES) s2(.enable(enable),.a(ca_row),.b(ca_col),
        .eq(eq[2]),.lt(lt[2]),.gt(gt[2]),.unordered(un[2]),.fault(edge_fault[2]),.difference(lint_unused_e2),.status(ss[2]));
    // Verification probes retain the exact DW subtraction results in simulation.
    `ifdef HW2_SIM_DIAGNOSTICS
    wire [31:0] e0=lint_unused_e0,e1=lint_unused_e1,e2=lint_unused_e2;
    `endif
    assign hit=enable&&!(|un)&&!(|edge_fault)&&
        ((area_positive&&(&(gt|eq)))||(area_negative&&(&(lt|eq))));
    assign fault=enable&&((|un)||(|edge_fault));
    assign status=ss[0]|ss[1]|ss[2];
endmodule
