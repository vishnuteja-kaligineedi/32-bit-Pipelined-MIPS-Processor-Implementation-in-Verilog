# 32-bit-Pipelined-MIPS-Processor-Implementation-in-Verilog
📌 Project Overview

This project implements a complete 32-bit 5-stage pipelined MIPS processor using Verilog HDL.
The processor follows a classic pipeline architecture consisting of Instruction Fetch (IF), Instruction Decode (ID), Execute (EX), Memory (MEM), and Write Back (WB) stages.
Pipeline registers and a forwarding-based hazard unit are included to improve performance and correctness.

🧱 Pipeline Architecture
The processor is divided into the following stages:

1 . Instruction Fetch (IF)

2.Instruction Decode (ID)

3.Execution (EX)

4.Memory Access (MEM)

5.Write Back (WB)

Pipeline registers are placed between each stage to allow simultaneous execution of multiple instructions.

🔹 Instruction Fetch (IF) Stage

In the Instruction Fetch (IF) stage, the Program Counter (PC) is updated, and the instruction corresponding to the current PC value is fetched from the instruction memory. The next instruction address is computed as PC + 4, and branch or jump target addresses are selected using control logic.

🔹 Instruction Decode (ID) Stage

In the Instruction Decode (ID) stage, the fetched instruction is decoded to determine the operation type. Source operands are read from the register file, immediate values are generated using sign extension, and the main control unit produces the necessary control signals. The decoded information, operands, and control signals are stored in the ID/EX pipeline register and forwarded to the execution stage.

🔹 Execution (EX) Stage

The Execution (EX) stage performs arithmetic and logical operations using the Arithmetic Logic Unit (ALU). It also calculates branch target addresses and evaluates branch conditions. To handle data hazards, forwarding logic is used to select the correct operands from later pipeline stages when required. The results of the execution stage are stored in the EX/MEM pipeline register.

🔹 Memory (MEM) Stage

In the Memory Access (MEM) stage, data memory is accessed for load and store instructions. Load operations read data from memory, while store operations write data to memory. The data read from memory, along with the ALU result and control signals, are passed to the Write Back stage through the MEM/WB pipeline register.

🔹 Write Back (WB) Stage

The Write Back (WB) stage completes instruction execution by selecting the appropriate result from the ALU output, memory read data, or PC + 4, depending on the instruction type. This selected result is written back into the destination register in the register file, completing the instruction cycle.

⚠️ Hazard & Forwarding Unit

The hazard and forwarding unit detects data hazards by comparing the source registers in the Execute (EX) stage with the destination registers in the Memory (MEM) and Write Back (WB) stages. When a match is found and register write is enabled, the unit generates forwarding control signals to forward the required data directly to the ALU inputs. This prevents incorrect data usage and reduces pipeline stalls, ensuring correct execution of dependent instructions.

🛠 Tools Used

1.Verilog HDL

2.Xilinx Vivado
