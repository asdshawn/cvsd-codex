
module hw2_fp_dot4(input [127:0] a,b, output [31:0] z, output [7:0] status);
    wire [31:0] product[0:3];
    wire [31:0] sum[0:4];
    wire [7:0] sm[0:3],sa[0:3];
    assign sum[0]=32'h00000000;
    genvar k;
    generate for(k=0;k<4;k=k+1) begin: column
        hw2_fp_mul mul(.a(a[32*k+:32]),.b(b[32*k+:32]),
                      .z(product[k]),.status(sm[k]));
        hw2_fp_add add(.a(sum[k]),.b(product[k]),.z(sum[k+1]),.status(sa[k]));
    end endgenerate
    assign z=sum[4];
    assign status=sm[0]|sm[1]|sm[2]|sm[3]|sa[0]|sa[1]|sa[2]|sa[3];
endmodule
