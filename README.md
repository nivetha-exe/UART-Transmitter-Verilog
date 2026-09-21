# UART Transmitter - Verilog

A Verilog RTL implementation of an 8-bit UART transmitter.

## Features
- 50 MHz clock
- 9600 baud rate
- 8-bit data transmission
- LSB-first transmission
- Start and stop bits
- FSM-based design
- Busy status signal

## Files
- `uart_tx.v` - UART transmitter RTL
- `uart_tx_tb.v` - Testbench

## UART Frame
1 Start bit + 8 Data bits + 1 Stop bit
