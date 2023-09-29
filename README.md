# RTL-to-GDS-Implementation-of-Low-Power-Configurable-Multi-Clock-Digital-System

#	- Description: It is responsible of receiving commands through UART receiver to do different system functions as register file reading/writing or doing some processing using ALU block and send result using 4 bytes frame through UART transmitter communication protocol.
# - Project phases:
o	RTL Design from Scratch of system blocks (ALU, Register File, Synchronous FIFO, Integer Clock Divider, Clock Gating, Synchronizers, Main Controller, UART TX, UART RX).
o	Integrate and verify functionality through self-checking testbench.
o	Constraining the system using synthesis TCL scripts.
o	Synthesize and optimize the design using design compiler tool.
o	Analyze Timing paths and fix setup and hold violations.
o	Verify Functionality equivalence using Formality tool.
o	Physical implementation of the system passing through ASIC flow phases and generate the GDS File.
o	Verify functionality post-layout considering the actual delays.
