# Introduction
This is a simple implement of MIPS CPU, both single cycle and multicycle(pipelined), written in Verilog HDL.
The code is tested with Modelsim 10.
## Supported instructions:
- add, sub, addu, subu, ori, lui, sll, srl, sra, slt, slti, addi
- sw, lw
- beq, bne
- j, jr, jal
# How to use
Translate the test code into 32 bits binary instuctions and set up the document name in mips, which is written in relative path, and then they can be read via the mips.v module.
