module BRG (
    input clk_in,
    input rst,
    output reg clk_rx,
    output reg clk_tx
);
    parameter DIVISOR = 434; // Example: 50 MHz / 115200 baud ≈ 434
    reg [15:0] counter_rx;   // Counter for RX clock
    reg [15:0] counter_tx;   // Counter for TX clock

    // Generate RX clock (115200 baud)
    always @(posedge clk_in or posedge rst) begin
        if (rst) begin
            counter_rx <= 0;
            clk_rx <= 0;
        end
        else begin
            if (counter_rx >= DIVISOR - 1) begin
                counter_rx <= 0;
                clk_rx <= ~clk_rx; // Toggle RX clock
            end
            else begin
                counter_rx <= counter_rx + 1;
            end
        end
    end

    // Generate TX clock (same as RX for simplicity)
    always @(posedge clk_in or posedge rst) begin
        if (rst) begin
            counter_tx <= 0;
            clk_tx <= 0;
        end
        else begin
            if (counter_tx >= DIVISOR - 1) begin
                counter_tx <= 0;
                clk_tx <= ~clk_tx; // Toggle TX clock
            end
            else begin
                counter_tx <= counter_tx + 1;
            end
        end
    end

endmodule