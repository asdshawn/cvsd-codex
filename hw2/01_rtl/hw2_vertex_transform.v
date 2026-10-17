module hw2_vertex_transform(
    input enable,
    input [511:0] mv,mp,
    input [31:0] x,y,z,width_fp,height_fp,
    output [31:0] screen_x,screen_y,
    output fault,w_zero,
    output [7:0] status
);
    // Row-major words occupy consecutively increasing 32-bit slices.
    localparam [511:0] IDENTITY={32'h3f800000,32'b0,32'b0,32'b0,
        32'b0,32'h3f800000,32'b0,32'b0,
        32'b0,32'b0,32'h3f800000,32'b0,
        32'b0,32'b0,32'b0,32'h3f800000};
    wire [511:0] safe_mv=enable?mv:IDENTITY;
    wire [511:0] safe_mp=enable?mp:IDENTITY;
    wire [127:0] q={32'h3f800000,enable?z:32'b0,
                  enable?y:32'b0,enable?x:32'b0};
    wire [127:0] view,clip;
    wire [7:0] sv[0:3],sp[0:3];
    genvar r;
    generate for(r=0;r<4;r=r+1) begin: row
        hw2_fp_dot4 v(.a(safe_mv[128*r+:128]),.b(q),
                     .z(view[32*r+:32]),.status(sv[r]));
        if(r!=2) begin: used_projection
            hw2_fp_dot4 p(.a(safe_mp[128*r+:128]),.b(view),
                         .z(clip[32*r+:32]),.status(sp[r]));
        end else begin: unused_projection_z
            assign clip[32*r+:32]=32'd0;
            assign sp[r]=8'd0;
        end
    end endgenerate
    wire [31:0] ndcx,ndcy,xplus,yminus,xhalf,yhalf;
    wire [7:0] ss[0:7];
    wire lint_unused_lt,lint_unused_gt,lint_unused_unordered;
    hw2_fp_cmp wz(.a(clip[127:96]),.b(32'b0),.eq(w_zero),
                  .lt(lint_unused_lt),.gt(lint_unused_gt),.unordered(lint_unused_unordered));
    hw2_fp_div dx(.a(clip[31:0]),.b(clip[127:96]),.z(ndcx),.status(ss[0]));
    hw2_fp_div dy(.a(clip[63:32]),.b(clip[127:96]),.z(ndcy),.status(ss[1]));
    hw2_fp_add ax(.a(ndcx),.b(32'h3f800000),.z(xplus),.status(ss[2]));
    hw2_fp_sub ay(.a(32'h3f800000),.b(ndcy),.z(yminus),.status(ss[3]));
    hw2_fp_mul hx(.a(xplus),.b(32'h3f000000),.z(xhalf),.status(ss[4]));
    hw2_fp_mul hy(.a(yminus),.b(32'h3f000000),.z(yhalf),.status(ss[5]));
    hw2_fp_mul wx(.a(xhalf),.b(width_fp),.z(screen_x),.status(ss[6]));
    hw2_fp_mul wy(.a(yhalf),.b(height_fp),.z(screen_y),.status(ss[7]));
    assign fault=enable&&(w_zero || clip[126:119]==8'hff ||
                        screen_x[30:23]==8'hff || screen_y[30:23]==8'hff);
    assign status=sv[0]|sv[1]|sv[2]|sv[3]|sp[0]|sp[1]|sp[2]|sp[3]|
                  ss[0]|ss[1]|ss[2]|ss[3]|ss[4]|ss[5]|ss[6]|ss[7];
endmodule
