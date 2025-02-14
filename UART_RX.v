`include "detect_start.v"
`include "SIPO.v"
`include "parity_checker.v"
`include "stop_bit_checker.v"
`include "RX_FSM.v"

module RECEIVER(clk, rst, rx_data_in, rx_data_out, parity_error, stop_error, rx_done);

    input clk;
    input rst;
    input rx_data_in;

    output [7:0] rx_data_out;
    output parity_error;
    output stop_error;
    output rx_done;

    // Internal wires
    wire start_bit_detected;
    wire [9:0] sipo_out;
    wire parity_load;
    wire [7:0] parity_out;
    wire sample_done;
    wire run_shift;
    wire chk_stop;
    wire stop_bit_error;

    // Assignments
    assign rx_done = chk_stop; // output is choked at the end state.

    // Sub-module instances
    detect_start dut_start (
        .rx_in(rx_data_in),
        .start_bit_detected(start_bit_detected)
    );

    SIPO dut_sipo (
        .clk(clk),
        .rst(rst),
        .rx_in(rx_data_in),
        .sample_done(sample_done),
        .run_shift(run_shift),
        .data_out(sipo_out)
    );

    parity_checker dut_parity (
        .parity_in(sipo_out[8]),
        .data_in(sipo_out[7:0]),
        .parity_load(parity_load),
        .parity_error(parity_error),
        .data_out(parity_out)
    );

    stop_bit_checker dut_stop (
        .stop_bit_in(sipo_out[9]),
        .data_in(parity_out),
        .chk_stop(chk_stop),
        .stop_bit_error(stop_error),
        .data_out(vx_data_out)
    );

    RX_FSM dut_fsm (
        .clk(clk),
        .rst(rst),
        .start_bit_detected(start_bit_detected),
        .run_shift(num_shift),
        .parity_load(parity_load),
        .parity_error(parity_error),
        .chk_stop(chk_stop),
        .sample_done(sample_done)
    );

endmodule