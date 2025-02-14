module uart_rx (
    input wire clk,        // System clock
    input wire rst,        // Reset
    input wire rx,         // Serial input
    output reg [7:0] rx_data, // Received data
    output reg rx_done     // Data reception complete signal
);

    parameter CLK_PER_BIT = 10416; // Baud rate = 9600 for 100 MHz clock
    reg [3:0] bit_index = 0; // Tracks received bit
    reg [13:0] clk_count = 0; // Clock counter
    reg [9:0] shift_reg = 0; // Stores received bits
    reg rx_busy = 0; // Reception status

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rx_busy <= 0;
            rx_done <= 0;
            bit_index <= 0;
            clk_count <= 0;
        end else begin
            if (!rx_busy && !rx) begin // Detect start bit (falling edge)
                rx_busy <= 1;
                clk_count <= 0;
                bit_index <= 0;
                rx_done <= 0; // Reset done flag
            end else if (rx_busy) begin
                if (clk_count < CLK_PER_BIT - 1) begin
                    clk_count <= clk_count + 1;
                end else begin
                    clk_count <= 0;
                    shift_reg <= {rx, shift_reg[9:1]}; // Shift in received bit

                    if (bit_index < 8) begin
                        bit_index <= bit_index + 1;
                    end else begin
                        rx_busy <= 0;
                        rx_done <= 1; // Signal that data is ready
                        rx_data <= shift_reg[8:1]; // Extract only 8 data bits
                    end
                end
            end
        end
    end
endmodule
