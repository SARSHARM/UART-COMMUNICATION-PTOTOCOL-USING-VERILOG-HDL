module TX_FSM(
    input clk,
    input rst,
    input TX_start,
    output reg [1:0] select,
    output reg load,
    output reg shift,
    output reg parity_load,
    output reg TX_busy
);

    // Internal registers and parameters
    reg [2:0] count;
    reg count_en;
    wire data_done;
    parameter IDLE = 3'b000, START = 3'b001, DATA = 3'b010, PARITY = 3'b011, STOP = 3'b100;
    reg [2:0] present_state, next_state;

    assign data_done = (count == 7); // For 8-bit data

    // Counter logic
    always @(posedge clk, posedge rst) begin
        if (rst) count <= 0;
        else count <= (count_en && !data_done) ? count + 1 : 0;
    end

    // State transition
    always @(posedge clk, posedge rst) begin
        if (rst) present_state <= IDLE;
        else present_state <= next_state;
    end

    // Next state logic (unchanged)
    always @(*) begin
        case (present_state)
            IDLE:   next_state = TX_start ? START : IDLE;
            START:  next_state = DATA;
            DATA:   next_state = data_done ? PARITY : DATA;
            PARITY: next_state = STOP;
            STOP:   next_state = TX_start ? START : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Corrected output logic
    always @(*) begin
        case (present_state)
            IDLE: begin
                select = 2'b11; // Idle (high)
                load = 0;
                shift = 0;
                parity_load = 0;
                TX_busy = 0;
                count_en = 0;
            end
            START: begin
                select = 2'b00; // Start bit (low)
                load = 1;      // Load data into shift register
                shift = 0;
                parity_load = 0; // Fix: Disable here
                TX_busy = 1;
                count_en = 0;
            end
            DATA: begin
                select = 2'b01; // Data bits
                load = 0;
                shift = 1;      // Shift data out
                parity_load = data_done; // Fix: Load parity after data
                TX_busy = 1;
                count_en = 1;
            end
            PARITY: begin
                select = 2'b10; // Parity bit
                load = 0;
                shift = 0;
                parity_load = 0;
                TX_busy = 1;
                count_en = 0;
            end
            STOP: begin
                select = 2'b11; // Stop bit (high)
                load = 0;
                shift = 0;
                parity_load = 0;
                TX_busy = (next_state != IDLE); // Fix: Deassert when leaving STOP
                count_en = 0;
            end
        endcase
    end

endmodule