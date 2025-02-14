`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.02.2025 20:56:00
// Design Name: 
// Module Name: UART_TX
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// MODULE FOR TRANSMITTER TX

`include "TX_MUX.v"
`include "TX_PARITY.v"
`include "TX_PISO.v"
`include "TX_FSM.v"

module UART_TX(clk, rst, TX_start, TX_data_in, TX_data_out, TX_busy);
    input clk;
    input rst;
    input TX_start;
    input [7:0] TX_data_in;
    output TX_data_out;
    output TX_busy;

    // Internal wires
    wire parity_out;
    wire piso_op;
    wire [1:0] mux_sel;
    wire piso_load;
    wire piso_shift;
    wire parity_load;

    // TX_MUX instance
    TX_MUX inst_mux (
        .select(mux_sel),
        .data_bit(piso_op),
        .parity_bit(parity_out),
        .tx_out(TX_data_out)
    );

    // TX_PARITY instance
    TX_PARITY inst_parity (
        .clk(clk),
        .rst(rst),
        .parity_load(parity_load),
        .parity_data_in(TX_data_in),
        .parity_out(parity_out)
    );

    // TX_PISO instance
    TX_PISO inst_PISO (
        .clk(clk),
        .rst(rst),
        .load(piso_load),
        .shift(piso_shift),
        .piso_in(TX_data_in),
        .piso_out(piso_op)
    );

    // TX_FSM instance
    TX_FSM inst_FSM (
        .clk(clk),
        .rst(rst),
        .TX_start(TX_start),
        .select(mux_sel),
        .load(piso_load),
        .shift(piso_shift),
        .parity_load(parity_load),
        .TX_busy(TX_busy)
    );

endmodule

