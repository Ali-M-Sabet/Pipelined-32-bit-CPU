# Instruction set

The architectural reference is the [course handout](architecture_project_sp26.pdf), pages 1–3. The [original report](report.pdf) and [assembler](../assembler/assembler.py) describe the instruction encoding.

## Implementation

- Eight writable 32-bit registers, R0–R7, with separate PC and SP.
- One 4096-word memory holds instructions, data and the stack. Fetch and data access have separate read ports into the same array; data writes occur on the rising clock edge.
- Reset loads PC from word 0. Hardware interrupts use word 1; INT 0 and INT 1 use words 2 and 3. SP starts at 4095.
- Instructions have a six-bit opcode in bits 31–26. The assembler emits one 32-bit word per instruction. Register fields occupy bits 25–23, 22–20 and 19–17; immediates occupy bits 15–0. INT uses bit 16 for its vector index.
- Arithmetic wraps to 32 bits. The status flags are carry, negative and zero; each instruction selects which flags it changes. SUB carry means no borrow.
- PC, SP and memory addresses are 12 bits, addressing the 4096-word memory.

| Opcodes | Behavior |
| --- | --- |
| 0–2 | NOP advances execution, HLT freezes execution until reset, SETC sets carry. |
| 3–8 | NOT complements, INC increments, OUT writes the output port, IN samples the input port, MOV copies, SWAP exchanges registers. |
| 9–12 | ADD, SUB, AND, IADD produce the specified register result and update the applicable flags. |
| 13–17 | PUSH writes then decrements SP, POP increments SP then reads, LDM loads an immediate, LDD and STD access base plus offset. |
| 18–23 | JZ, JN, JC select the target by their flag and clear the tested flag on a taken branch. JMP is unconditional. CALL saves the return PC and jumps. RET restores the return PC. |
| 24–25 | INT saves the return PC and flags and loads its vector. RTI restores the PC and flags. |

## Interrupt operation

Pulse the hardware interrupt input for one clock cycle while the CPU is running and no ISR is active. The CPU handles one interrupt at a time and accepts the next request after `RTI`.

On entry, fetch pauses while the final decoded instruction advances. The CPU saves the held fetch PC on the stack and the flags in a backup register, then loads the handler address from word 1. RTI restores the saved PC and flags. Load, branch-recovery and return hazards retain their priority during entry.
