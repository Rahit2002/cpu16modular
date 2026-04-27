Project: CPU16 – Custom 16‑bit CPU with MAC, NN, and MATMUL
Author: Your Name (Assistant Software Engineer)

---

Summary:
CPU16 is a custom 16‑bit CPU implemented in Verilog that supports:
- Basic ALU operations: ADD, SUB, AND, OR, XOR, MUL
- MAC and MAC2 (multiply‑accumulate) units
- Neural unit NN for x1·w1 + x2·w2 + b
- 2×2 matrix multiply (MATMUL)
- Control + I/O: LOADI, MOV, OUT, STOP, and a new NOT instruction

Tools used:
- Vivado 2023 (or your version)
- ModelSim / XSim for simulation
- Custom C assembler (assemblerfull.c) that converts assembly
  to 16‑bit hex for instruction memory (program.txt)

Usage:
1. Write assembly in input.txt (e.g., LOADI, ADD, MAC, NN, MATMUL)
2. Compile assembler: gcc assemblerfull.c -o asmful
3. Run: ./asmful  → generates program.txt
4. Simulate in Vivado: CPU16_tb_moduler_behav
5. Inspect consol: final values R0, R1, R2 and dbg(R1) trace

Key files:
- CPU16.v      → Top CPU module
- ALU16.v      → ALU with ADD, SUB, ..., MUL, NOT
- MAC.v        → MAC0 producing mac_out
- NN.v         → Neural unit NN
- Mat_mul.v    → Matrix‑multiply core
- instr_mem.v  → Instruction memory
- reg_file.v   → 8‑register file
- assemblerfull.c → C assembler (input.txt → program.txt)

ISA:
- 16‑bit fixed‑length instructions
- 8 registers R0–R7
- Supported mnemonics: NOP, LOADI, ADD, SUB, AND, OR, XOR,
  MUL, MAC, MAC2, NN, MATMUL, MOV, OUT, NOT, STOP

Testcases:
- Short test: 3 LOADI instructions (covers reset, IR, RF)
- Full test: all modules (ALU, MAC, MAC2, NN, MATMUL, MOV, OUT)

this readme is AI generated with perplexity
