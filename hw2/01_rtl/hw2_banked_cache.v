
module hw2_banked_cache #(parameter WIDTH=32,WORDS=65536,READ_PORTS=1)(
    input clk,rstn,write_enable,
    input [15:0] write_addr,
    input [WIDTH-1:0] write_data,
    input [READ_PORTS-1:0] read_valid,
    input [16*READ_PORTS-1:0] read_addr,
    output [WIDTH*READ_PORTS-1:0] read_data
);
    localparam BANKS=(WORDS+255)/256;
    wire [WIDTH*READ_PORTS-1:0] bank_data[0:BANKS-1];
    wire [8*READ_PORTS-1:0] word_addr;
    genvar b,p;
    generate for(p=0;p<READ_PORTS;p=p+1) begin: addresses
        assign word_addr[8*p+:8]=read_addr[16*p+:8];
    end endgenerate
    generate for(b=0;b<BANKS;b=b+1) begin: banks
        localparam SIZE=((WORDS-256*b)<256)?(WORDS-256*b):256;
        localparam [7:0] BANK_ID=b;
        hw2_cache_bank #(.WIDTH(WIDTH),.WORDS(SIZE),.READ_PORTS(READ_PORTS)) storage(
            .clk(clk),.rstn(rstn),.write_enable(write_enable&&(write_addr[15:8]==BANK_ID)),
            .write_addr(write_addr[7:0]),.write_data(write_data),
            .read_addr(word_addr),.read_data(bank_data[b]));
    end endgenerate
    generate for(p=0;p<READ_PORTS;p=p+1) begin: output_ports
        wire [WIDTH-1:0] choices[0:BANKS-1];
        for(b=0;b<BANKS;b=b+1) begin: choices_by_bank
            assign choices[b]=bank_data[b][WIDTH*p+:WIDTH];
        end
        assign read_data[WIDTH*p+:WIDTH]=read_valid[p]?choices[read_addr[16*p+8+:8]]:{WIDTH{1'b0}};
    end endgenerate
endmodule
