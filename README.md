# ARM32-in-Verilog

Implemetation of a pipelined ARM32 processor in Verilog. 

Runs the accompanied Factorial 6 program at up to 200 MHz frequency on an EP2C35F672C6 FPGA.

See lab6.pdf for a not-so-descriptive yet useful report on the design details and performance.


Modules:
LAB6.v - Top module containing the controller and instructions
ALU.v - ALU module
conditional.v - Condition checker module
decoder.v - Instruction decoder module
hazard.v - Hazard detection module
testbench.v - Test bench. Provides the clock input and allows for monitoring of signals.
Additional built-in-modules found in the built-in-modules folder.

Some assembly programs that run on the processor are provided in assemblyprograms.s
