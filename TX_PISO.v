module TX_PISO (clk, rst, load, shift, piso_in, piso_out);
    input clk;
    input rst;
    input load;
    input shift;
    input [7:0] piso_in;
    output piso_out;

    reg [7:0] temp;
    assign piso_out = temp[0];

    always @(posedge clk, posedge rst) begin
        if (rst) temp <= 0;
        else begin
            if (load) temp <= piso_in;
            else if (shift) temp <= {1'b0, temp[7:1]};
            else temp <= temp;
        end
    end
endmodule