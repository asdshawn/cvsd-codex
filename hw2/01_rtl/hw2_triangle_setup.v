module hw2_triangle_setup(
    input [31:0] ax,ay,bx,by,cx,cy,
    output [31:0] dxab,dyab,dxbc,dybc,dxca,dyca,area,
    output area_zero,area_positive,area_negative,fault,
    output [7:0] status
);
    wire [7:0] ss[0:6];
    wire unordered;
    hw2_fp_sub s0(.a(bx),.b(ax),.z(dxab),.status(ss[0]));
    hw2_fp_sub s1(.a(by),.b(ay),.z(dyab),.status(ss[1]));
    hw2_fp_sub s2(.a(cx),.b(bx),.z(dxbc),.status(ss[2]));
    hw2_fp_sub s3(.a(cy),.b(by),.z(dybc),.status(ss[3]));
    hw2_fp_sub s4(.a(ax),.b(cx),.z(dxca),.status(ss[4]));
    hw2_fp_sub s5(.a(ay),.b(cy),.z(dyca),.status(ss[5]));
    hw2_fp_edge d(.ax(ax),.ay(ay),.dx(dxab),.dy(dyab),.px(cx),.py(cy),
                  .edge_value(area),.status(ss[6]));
    hw2_fp_cmp c(.a(area),.b(32'b0),.eq(area_zero),.lt(area_negative),
                 .gt(area_positive),.unordered(unordered));
    assign fault=unordered || area[30:23]==8'hff;
    assign status=ss[0]|ss[1]|ss[2]|ss[3]|ss[4]|ss[5]|ss[6];
endmodule
