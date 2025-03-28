# 🖥️ Miniature Pipelined ARM Processor  

This project implements a **pipelined processor** based on the **LEGv8 architecture**, a subset of the **ARM v8 64-bit** instruction set. The processor features a **5-stage pipeline** (Fetch, Decode, Execute, Memory, Writeback) with **forwarding** and **hazard detection units** to handle data hazards and optimize performance. Implemented in **VHDL**, this processor supports various ARM instructions, demonstrating the practical application of advanced computer architecture principles.  

🔗 **Project Documentation:** [Miniature Pipelined ARM Processor](https://narrow-theory-18d.notion.site/Miniature-Pipelined-ARM-Processor-1b9436c3d41a81438de6f8c903e54d96?pvs=74)  

## 🔧 Key Features  
- **5-Stage Pipeline** – Fetch, Decode, Execute, Memory, Writeback.  
- **Forwarding and Hazard Detection** – Resolves data hazards and optimizes processor performance.  
- **ARM v8 Instruction Support** – Implements key instructions from the ARM v8 64-bit instruction set.  
- **Practical Application of Computer Architecture** – Demonstrates advanced principles such as pipeline optimization and control flow handling.  

## ⚙️ How It Works  
The processor operates by fetching instructions from instruction memory, decoding them, executing operations using the **ALU**, accessing data memory when necessary, and writing results back to the registers.  
- **Forwarding Unit** – Detects data dependencies and routes data between pipeline stages to resolve hazards.  
- **Hazard Detection Unit** – Manages pipeline stalls for situations like load-use hazards.  
- **Early Branch Resolution** – Handles control flow instructions in the decode stage.  

## 🚀 How to Run the Program  
1. Install **GHDL** and a **waveform viewer** (e.g., **GTKWave**) on your system.  
2. Place all VHDL files (.vhd) in a single directory.  
3. Use the provided **Makefile** to compile and run the simulation:  
    - For example program 1: Run `make p1`  
    - For example program 2: Run `make p2`  
   This will compile the VHDL files, run the simulation, and generate a waveform file.  

## 👀 How to Check the Result  
1. Open the generated **waveform file** (e.g., 'pipelinedcpu1_p1.ghw' or 'pipelinedcpu1_p2.ghw') using **GTKWave**.  
2. Key signals to observe include:
    - **PC** (Program Counter)  
    - **Instruction**  
    - **RegisterFile contents**  
    - **ALU outputs**  

📌 *For more details, check the project documentation linked above.*  
