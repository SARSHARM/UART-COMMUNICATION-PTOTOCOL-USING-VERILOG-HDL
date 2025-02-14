module RX_FSM (clk, rst, start_bit_detected, run_shift, parity_load, parity_error, chk_stop, sample_done);
    input clk;
    input rst;
    input start_bit_detected;
    input parity_error;

    output reg run_shift;
    output reg parity_load;
    output reg chk_stop;
    output sample_done;

    // Internal registers and wires
    reg [3:0] bcount; // to clk the middle of data
    reg [3:0] count; // to check how many data I have received
    wire data_done;
    reg count_en; // to enable the count

    // State encoding
    parameter IDLE = 2'b00,
              DATA = 2'b01,
              PARITY = 2'b10,
              STOP = 2'b11;

    reg [1:0] present_state, next_state;

    // Sample done signal
    assign sample_done = (bcount == 7); // RX & clk have passed

    // bcount logic
    always @(posedge clk, posedge rst) begin
        if (rst) bcount <= 0;
        else begin
            if (present_state != IDLE) bcount <= bcount + 1;
            else bcount <= 0;
        end
    end

    // count logic
    always @(posedge clk, posedge rst) begin
        if (rst) count <= 0;
        else begin
            if (count_en) begin
                if (sample_done) count <= count + 1;
                else count <= count;
            end
            else count <= 0;
        end
    end

    // Data done signal
    assign data_done = (count == 11); // when STPO has received all 11 data, at that time data Rx is done

    // State transition logic
    always @(posedge clk, posedge rst) begin
        if (rst) present_state <= IDLE;
        else present_state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (present_state)
            IDLE: if (start_bit_detected) next_state = DATA;
                  else next_state = IDLE;

            DATA: if (data_done) next_state = PARITY;
                  else next_state = DATA;

            PARITY: if (parity_error) next_state = IDLE;
                    else next_state = STOP;

            STOP: next_state = IDLE;
        endcase
    end

    // Output logic
    always @(present_state) begin
        case (present_state)
            IDLE: begin
                count_en = 0;
                run_shift = 0;
                parity_load = 0;
                chk_stop = 0;
            end

            DATA: begin
                count_en = 1;
                run_shift = 1;
                parity_load = 0;
                chk_stop = 0;
            end

            PARITY: begin
                count_en = 0;
                run_shift = 0;
                parity_load = 1;
                chk_stop = 0;
            end

            STOP: begin
                count_en = 0;
                run_shift = 0;
                parity_load = 0;
                chk_stop = 1;
            end
        endcase
    end

endmodule