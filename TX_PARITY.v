module TX_PARITY(clk, rst, parity_load, parity_data_in, parity_out);
    input clk;
    input rst;
    input [7:0] parity_data_in;
    input parity_load;
    output reg parity_out;

    always @(posedge clk, posedge rst) begin
        if (rst) parity_out <= 0;
        else begin 
        if (parity_load) parity_out <= ^(parity_data_in);
        else parity_out <= parity_out;
    end
    end
endmodule