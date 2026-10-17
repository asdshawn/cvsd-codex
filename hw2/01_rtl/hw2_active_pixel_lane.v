// FP32 products for the pixel being tested; no full-screen product grid.
module hw2_active_pixel_lane(
    input enable,area_positive,area_negative,
    input [7:0] x,y,
    input [31:0] ax,ay,bx,by,cx,cy,dxab,dyab,dxbc,dybc,dxca,dyca,
    output hit,fault,
    output [7:0] status
);
    wire [31:0] xc,yc;
    hw2_pixel_center_lut xlut(.coordinate(x),.value(xc));
    hw2_pixel_center_lut ylut(.coordinate(y),.value(yc));
    wire [31:0] relative[0:5],product[0:5];
    wire [7:0] ss[0:5],sm[0:5],edge_status;
    hw2_fp_sub s0(.a(enable?xc:32'b0),.b(enable?ax:32'b0),.z(relative[0]),.status(ss[0]));
    hw2_fp_sub s1(.a(enable?yc:32'b0),.b(enable?ay:32'b0),.z(relative[1]),.status(ss[1]));
    hw2_fp_sub s2(.a(enable?xc:32'b0),.b(enable?bx:32'b0),.z(relative[2]),.status(ss[2]));
    hw2_fp_sub s3(.a(enable?yc:32'b0),.b(enable?by:32'b0),.z(relative[3]),.status(ss[3]));
    hw2_fp_sub s4(.a(enable?xc:32'b0),.b(enable?cx:32'b0),.z(relative[4]),.status(ss[4]));
    hw2_fp_sub s5(.a(enable?yc:32'b0),.b(enable?cy:32'b0),.z(relative[5]),.status(ss[5]));
    hw2_fp_mul m0(.a(enable?dyab:32'b0),.b(relative[0]),.z(product[0]),.status(sm[0]));
    hw2_fp_mul m1(.a(enable?dxab:32'b0),.b(relative[1]),.z(product[1]),.status(sm[1]));
    hw2_fp_mul m2(.a(enable?dybc:32'b0),.b(relative[2]),.z(product[2]),.status(sm[2]));
    hw2_fp_mul m3(.a(enable?dxbc:32'b0),.b(relative[3]),.z(product[3]),.status(sm[3]));
    hw2_fp_mul m4(.a(enable?dyca:32'b0),.b(relative[4]),.z(product[4]),.status(sm[4]));
    hw2_fp_mul m5(.a(enable?dxca:32'b0),.b(relative[5]),.z(product[5]),.status(sm[5]));
    hw2_product_pixel_lane edge_test(.enable(enable),.area_positive(area_positive),.area_negative(area_negative),
        .ab_col(product[0]),.ab_row(product[1]),.bc_col(product[2]),.bc_row(product[3]),
        .ca_col(product[4]),.ca_row(product[5]),.hit(hit),.fault(fault),.status(edge_status));
    assign status=ss[0]|ss[1]|ss[2]|ss[3]|ss[4]|ss[5]|sm[0]|sm[1]|sm[2]|sm[3]|sm[4]|sm[5]|edge_status;
endmodule
