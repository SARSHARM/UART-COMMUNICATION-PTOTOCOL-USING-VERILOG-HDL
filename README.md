# UART Communication Protocol Design

![UART ](https://github.com/user-attachments/assets/2626127d-b922-4b35-94fc-83a3f63301f3)\
![image](https://github.com/user-attachments/assets/6f139d14-0227-4f7c-9a5f-c3af9130dcf1)


A Verilog implementation of a UART (Universal Asynchronous Receiver/Transmitter) module with configurable baud rates, error detection, and testbenches for simulation.

## Features
- **Full-duplex communication**: Supports simultaneous transmission and reception.
- **Baud Rate Generator (BRG)**: Configurable baud rates for TX and RX.
- **Error Detection**:
  - Parity error checking (even/odd parity support).
  - Stop bit error detection.
- **Testbenches**: Functional verification using Icarus Verilog/ModelSim.
- **Modular Design**: Separate modules for TX, RX, FSM, and parity logic.

## Repository Structure
```bash
UART_Design
├── src               # Verilog source code
│    UART_TX.v        # Transmitter module
│    UART_RX.v        # Receiver mc
│    BRG.v            # Baud Rate Generator
│    TX_FSM.v         # Transmitter Finite State Machine
│    RX_FSM.v         # Receiver Finite Machine
│    TX_PARITY.v      # Parity generator for TX
│    TX_MUX.v         # Multiplexer for TX data
├── tb                # Testbenches
│    UART_tb.v        # Main testbench
│    BRG_tb.v         # Baud Rate Generator testbench
├── docs              # Documentation
│    waveforms        # Simulation waveform screenshots
│    design.md        # Design specifications
├── simulations       # Simulation output files (vcd)
├── scripts           # Automation scripts
│    run_sim.sh       # Script to run simulations
│    gtkwave.tcl      # Tcl script for waveform viewing
├── README.md         # Project overview
└── .gitignore        # Excludes temporary files
```
