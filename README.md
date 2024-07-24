# Overview:
This project implements a pipelined processor based on the LEGv8 architecture, a subset of the ARM v8 64-bit instruction set. The processor features a 5-stage pipeline (Fetch, Decode, Execute, Memory, Writeback) with forwarding and hazard detection units to handle data hazards and optimize performance. Implemented in VHDL, the processor supports various ARM instructions and demonstrates practical application of advanced computer architecture principles.

# How it works:
The processor fetches instructions from instruction memory, decodes them, executes operations using the ALU, accesses data memory when needed, and writes results back to registers. The forwarding unit detects data dependencies and routes data between pipeline stages to resolve hazards. The hazard detection unit manages pipeline stalls for scenarios like load-use hazards. Control flow instructions are handled with early branch resolution in the decode stage.

# How to run the program:
- Ensure GHDL and a waveform viewer (like GTKWave) are installed on your system.
- Place all VHDL files (.vhd) in a single directory.
- Use the provided Makefile to compile and run the simulation:

  For example program 1: Run 'make p1'
  
  For example program 2: Run 'make p2'

This will compile the VHDL files, run the simulation, and generate a waveform file.

# How to check the result:
- Open the generated waveform file (e.g., 'pipelinedcpu1_p1.ghw' or 'pipelinedcpu1_p2.ghw') using GTKWave.
- key signals include PC, Instruction, RegisterFile contents, ALU outputs, etc.
