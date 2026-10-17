// Exact common subexpressions, shared by a whole row or column:
// Eab(x,y) = R( R(dxab*R(y+.5-ay)) - R(dyab*R(x+.5-ax)) ).
// This retains every original FP32 rounding boundary.
module hw2_coverage_grid(
    input enable,
    input [31:0] ax,ay,bx,by,cx,cy,
    input [31:0] dxab,dyab,dxbc,dybc,dxca,dyca,
    output [8191:0] ab_col,ab_row,bc_col,bc_row,ca_col,ca_row,
    output [7:0] status
);
    wire [7:0] item_status[0:255];
    genvar c;
    generate for(c=0;c<256;c=c+1) begin: coordinate
        localparam [7:0] COORD=c;
        wire [31:0] center;
        wire [31:0] relative[0:5];
        wire [7:0] ss[0:5],sm[0:5];
        hw2_pixel_center_lut lut(.coordinate(COORD),.value(center));
        hw2_fp_sub s0(.a(enable?center:32'b0),.b(enable?ax:32'b0),.z(relative[0]),.status(ss[0]));
        hw2_fp_sub s1(.a(enable?center:32'b0),.b(enable?ay:32'b0),.z(relative[1]),.status(ss[1]));
        hw2_fp_sub s2(.a(enable?center:32'b0),.b(enable?bx:32'b0),.z(relative[2]),.status(ss[2]));
        hw2_fp_sub s3(.a(enable?center:32'b0),.b(enable?by:32'b0),.z(relative[3]),.status(ss[3]));
        hw2_fp_sub s4(.a(enable?center:32'b0),.b(enable?cx:32'b0),.z(relative[4]),.status(ss[4]));
        hw2_fp_sub s5(.a(enable?center:32'b0),.b(enable?cy:32'b0),.z(relative[5]),.status(ss[5]));
        hw2_fp_mul m0(.a(enable?dyab:32'b0),.b(relative[0]),.z(ab_col[32*c+:32]),.status(sm[0]));
        hw2_fp_mul m1(.a(enable?dxab:32'b0),.b(relative[1]),.z(ab_row[32*c+:32]),.status(sm[1]));
        hw2_fp_mul m2(.a(enable?dybc:32'b0),.b(relative[2]),.z(bc_col[32*c+:32]),.status(sm[2]));
        hw2_fp_mul m3(.a(enable?dxbc:32'b0),.b(relative[3]),.z(bc_row[32*c+:32]),.status(sm[3]));
        hw2_fp_mul m4(.a(enable?dyca:32'b0),.b(relative[4]),.z(ca_col[32*c+:32]),.status(sm[4]));
        hw2_fp_mul m5(.a(enable?dxca:32'b0),.b(relative[5]),.z(ca_row[32*c+:32]),.status(sm[5]));
        assign item_status[c]=ss[0]|ss[1]|ss[2]|ss[3]|ss[4]|ss[5]|
                              sm[0]|sm[1]|sm[2]|sm[3]|sm[4]|sm[5];
    end endgenerate
    wire [7:0] status_chain[0:256];
    assign status_chain[0]=8'b0;
    genvar k;
    generate for(k=0;k<256;k=k+1) begin: status_fold
        assign status_chain[k+1]=status_chain[k]|item_status[k];
    end endgenerate
    assign status=status_chain[256];
endmodule
