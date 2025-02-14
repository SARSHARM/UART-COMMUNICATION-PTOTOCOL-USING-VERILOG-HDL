module uart_tx (
    input wire clk,        // System clock
    input wire rst,        // Reset
    input wire tx_start,   // Start transmission signal
    input wire [7:0] tx_data, // Data to be transmitted
    output reg tx,         // Serial output
    output reg tx_busy     // Transmitter busy signal
);

    parameter CLK_PER_BIT = 10416; // Baud rate = 9600 for 100 MHz clock
    reg [3:0] bit_index = 0; // Tracks the current bit being transmitted
    reg [13:0] clk_count = 0; // Clock divider counter
    reg [9:0] shift_reg = 10'b1111111111; // Start bit, data bits, stop bit
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tx <= 1;
            tx_busy <= 0;
            bit_index <= 0;
            clk_count <= 0;
        end else if (tx_start && !tx_busy) begin
            shift_reg <= {1'b1, tx_data, 1'b0}; // Start bit, data, stop bit
            tx_busy <= 1;
            bit_index <= 0;
            clk_count <= 0;
        end else if (tx_busy) begin
            if (clk_count < CLK_PER_BIT - 1) begin
                clk_count <= clk_count + 1;
            end else begin
                clk_count <= 0;
                tx <= shift_reg[0]; // Transmit LSB first
                shift_reg <= shift_reg >> 1; // Shift right
                if (bit_index < 9) begin
                    bit_index <= bit_index + 1;
                end else begin
                    tx_busy <= 0; // Transmission complete
                end
            end
        end
    end
endmodule
