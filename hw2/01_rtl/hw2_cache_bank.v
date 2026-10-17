// The leaf memories retain synchronous writes and combinational reads.
// Banking limits each synthesis unit to at most 256 words; no cycle is added.
module hw2_cache_bank #(parameter WIDTH=32,WORDS=256,READ_PORTS=1)(
    input clk,rstn,write_enable,
    input [7:0] write_addr,
    input [WIDTH-1:0] write_data,
    input [8*READ_PORTS-1:0] read_addr,
    output [WIDTH*READ_PORTS-1:0] read_data
);
    reg [WIDTH-1:0] words[0:WORDS-1];
    // The enhanced lint policy requires asynchronous reset for stored data.
    // Reads are still masked by the parent's committed-prefix validity check.
    integer reset_word;
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            for(reset_word=0;reset_word<WORDS;reset_word=reset_word+1)
                words[reset_word]<={WIDTH{1'b0}};
        end else if(write_enable) words[write_addr]<=write_data;
    end
    genvar p;
    generate for(p=0;p<READ_PORTS;p=p+1) begin: reads
        assign read_data[WIDTH*p+:WIDTH]=words[read_addr[8*p+:8]];
    end endgenerate
endmodule
