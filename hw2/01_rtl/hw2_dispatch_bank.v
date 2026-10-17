
// The scoreboard follows the same 256-word boundary as the payload caches.
// No extra cycle is introduced for either an index commit or a dispatch grant.
module hw2_dispatch_bank #(parameter WORDS=256,GROUPS=1)(
    input clk,rstn,start,running,enabled,commit,
    input [7:0] bank_id,
    input [15:0] commit_id,index_max,
    input [16:0] vertex_count,
    input [GROUPS-1:0] fire,
    input [16*GROUPS-1:0] triangle_ids,
    output [WORDS-1:0] eligible
);

    reg [WORDS-1:0] present,issued;
    reg [16*WORDS-1:0] maximum_index;
    always @(posedge clk or negedge rstn) begin
        if(!rstn) maximum_index<={16*WORDS{1'b0}};
        else if(enabled&&!start&&running&&commit&&commit_id[15:8]==bank_id)
            maximum_index[{commit_id[7:0],4'b0}+:16]<=index_max;
    end
    integer dispatch_port;
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin present<={WORDS{1'b0}};issued<={WORDS{1'b0}};end
        else if(start) begin present<={WORDS{1'b0}};issued<={WORDS{1'b0}};end
        else if(running) begin
            if(commit&&commit_id[15:8]==bank_id) present[commit_id[7:0]]<=1'b1;
            for(dispatch_port=0;dispatch_port<GROUPS;dispatch_port=dispatch_port+1)
                if(fire[dispatch_port]&&triangle_ids[16*dispatch_port+8+:8]==bank_id)
                    issued[triangle_ids[16*dispatch_port+:8]]<=1'b1;
        end
    end
    genvar word;
    generate for(word=0;word<WORDS;word=word+1) begin: eligibility
        assign eligible[word]=enabled&&running&&present[word]&&!issued[word]&&
            ({1'b0,maximum_index[16*word+:16]}<vertex_count);
    end endgenerate
endmodule
