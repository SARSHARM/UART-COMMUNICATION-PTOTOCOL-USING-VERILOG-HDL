module detect_start(rx_in, start_bit_detected);
    input rx_in;
    output start_bit_detected;
    assign start_bit_detected = !(rx_in); // Start bit detected when input is 0
endmodule