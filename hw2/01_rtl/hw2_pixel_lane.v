
module hw2_pixel_lane(
    input enable,area_positive,area_negative,
    input [31:0] ax,ay,bx,by,cx,cy,
    input [31:0] dxab,dyab,dxbc,dybc,dxca,dyca,
    input [31:0] px,py,
    output hit,fault,
    output [7:0] status
);
    wire [31:0] e0,e1,e2;
    wire [7:0] ss[0:2];
    wire [2:0] eq,lt,gt,un;
    hw2_fp_edge ab(.ax(enable?ax:32'b0),.ay(enable?ay:32'b0),
        .dx(enable?dxab:32'b0),.dy(enable?dyab:32'b0),
        .px(enable?px:32'b0),.py(enable?py:32'b0),.edge_value(e0),.status(ss[0]));
    hw2_fp_edge bc(.ax(enable?bx:32'b0),.ay(enable?by:32'b0),
        .dx(enable?dxbc:32'b0),.dy(enable?dybc:32'b0),
        .px(enable?px:32'b0),.py(enable?py:32'b0),.edge_value(e1),.status(ss[1]));
    hw2_fp_edge ca(.ax(enable?cx:32'b0),.ay(enable?cy:32'b0),
        .dx(enable?dxca:32'b0),.dy(enable?dyca:32'b0),
        .px(enable?px:32'b0),.py(enable?py:32'b0),.edge_value(e2),.status(ss[2]));
    hw2_fp_cmp c0(.a(e0),.b(32'b0),.eq(eq[0]),.lt(lt[0]),.gt(gt[0]),.unordered(un[0]));
    hw2_fp_cmp c1(.a(e1),.b(32'b0),.eq(eq[1]),.lt(lt[1]),.gt(gt[1]),.unordered(un[1]));
    hw2_fp_cmp c2(.a(e2),.b(32'b0),.eq(eq[2]),.lt(lt[2]),.gt(gt[2]),.unordered(un[2]));
    assign hit=enable && !(|un) &&
               ((area_positive && (&(gt|eq))) || (area_negative && (&(lt|eq))));
    assign fault=enable&&((|un)||e0[30:23]==8'hff||e1[30:23]==8'hff||e2[30:23]==8'hff);
    assign status=ss[0]|ss[1]|ss[2];
endmodule
