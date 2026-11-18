# Pipelined CPU — VHDL Implementation

A 32-bit CPU written in VHDL for a computer architecture course project. It implements a custom 26-instruction ISA with a six-stage pipeline, forwarding, hazard detection, branch prediction, interrupts and a Python assembler.

---

## Project Structure

~~~text
Pipelined-32-bit-CPU/
├── assembler/          # Project-specific Python assembler
├── programs/           # Assembly test programs
├── src/
│   ├── components/     # ALU, registers, shared memory, and helpers
│   ├── control/        # Decode, hazards, and branch prediction
│   ├── pipeline/       # Registers between pipeline stages
│   ├── stages/         # Fetch, decode, execution, and memory access
│   └── top_level.vhd   # CPU integration
├── tb/                 # Component and program testbenches
├── sim/                # Simulation scenarios
│   └── waves/          # Waveform presets
├── docs/               # Course specification, original report, and schematics
└── run.do              # Main Questa runner
~~~

---

## Architecture Overview

The CPU implements a **6-stage pipeline**:

```mermaid
flowchart LR
    IF[Fetch] -->|IF/ID| ID[Decode]
    ID -->|ID/EX1| EX1
    EX1 -->|EX1/EX2| EX2
    EX2 -->|EX2/MEM| MEM[Memory]
    MEM -->|MEM/WB| WB[Write-back]
```

**Control logic:**

- **Control Unit** — decodes 6-bit opcodes into all datapath control signals
- **Hazard Unit** — detects data/control hazards; issues stalls and flushes
- **Forwarding Unit** — resolves data hazards by bypassing results between stages
- **2-bit Branch Predictor** — predicts conditional branch direction dynamically
- **Interrupt Handler** — latches and serializes hardware interrupt requests

---

Reset reads its start address directly from word 0. Instruction fetch and data access share one 4096-word memory array with two read ports and one clocked data write port. A store is visible to subsequent instruction fetches.

## Pipeline Stages

| Stage | File | Description |
|-------|------|-------------|
| **Fetch (IF)** | `fetch.vhd` | Holds PC; selects next address from sequential, branch recovery, or memory-supplied addresses |
| **Decode (ID)** | `decode.vhd` | Reads registers, decodes control signals, and selects injected pipeline operations |
| **Execute 1 (EX1)** | `ex1.vhd` | Selects forwarded operands and runs the ALU |
| **Execute 2 (EX2)** | `ex2.vhd` | Resolves branches, updates flags (CCR), and calculates data addresses |
| **Memory (MEM)** | `memory.vhd` | Data memory read/write; stack pointer updates |
| **Write-Back (WB)** | `top_level.vhd` | Routes MEM/WB results to the register file and output port |

---

## Pipeline Registers

| Register | File | Carries |
|----------|------|---------|
| IF/ID | `if_id.vhd` | Instruction word, PC |
| ID/EX1 | `id_ex1.vhd` | Decoded control signals, register values, immediates |
| EX1/EX2 | `ex1_ex2.vhd` | ALU result, forwarded operands, branch info |
| EX2/MEM | `ex2_mem.vhd` | Memory address/data, writeback controls |
| MEM/WB | `mem_wb.vhd` | Memory read data, ALU result, destination register |

---

## Components

| File | Description |
|------|-------------|
| `alu.vhd` | 32-bit ALU with 8 operations; produces Carry, Zero, Negative flags |
| `register_file.vhd` | 8×32-bit register file with two read ports and two write ports |
| `memory.vhd` | Word memory with combinational reads and clocked writes |
| `sign_extend.vhd` | Sign-extends immediates to 32 bits |
| `zero_extend.vhd` | Standalone utility for zero extension to 32 bits |
| `conditional_jump_decoder.vhd` | Identifies conditional branches and extracts their target immediate |
| `interrupt_handler.vhd` | Latches hardware interrupt; serializes service requests |
| `forwarding_unit.vhd` | Generates forwarding mux selects to resolve RAW hazards |

---

## ALU Operations

| `alu_op` | Operation |
|----------|-----------|
| `0000` | ADD |
| `0001` | SUB |
| `0010` | AND |
| `0011` | NOT |
| `0100` | Increment operand 1 |
| `0101` | Decrement operand 1 |
| `0110` | MOV / pass operand |
| `0111` | Pass operand 1 and set carry |

---

## Instruction Set (Opcode Summary)

| Opcode | Mnemonic | Type |
|--------|----------|------|
| `000000` | NOP | — |
| `000001` | HLT | — |
| `000010` | SETC | One-Operand |
| `000011` | NOT | One-Operand |
| `000100` | INC | One-Operand |
| `000101` | OUT | One-Operand |
| `000110` | IN | One-Operand |
| `000111` | MOV | Two-Operand |
| `001000` | SWAP | Two-Operand |
| `001001` | ADD | Two-Operand |
| `001010` | SUB | Two-Operand |
| `001011` | AND | Two-Operand |
| `001100` | IADD | Immediate |
| `001101` | PUSH | Memory |
| `001110` | POP | Memory |
| `001111` | LDM | Memory |
| `010000` | LDD | Memory |
| `010001` | STD | Memory |
| `010010` | JZ | Branch |
| `010011` | JN | Branch |
| `010100` | JC | Branch |
| `010101` | JMP | Branch |
| `010110` | CALL | Branch |
| `010111` | RET | Branch |
| `011000` | INT | Interrupt |
| `011001` | RTI | Interrupt |

---

## Top-Level Ports

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `clk` | Input | 1 | System clock |
| `rst` | Input | 1 | Active-high reset |
| `interrupt` | Input | 1 | Hardware interrupt request |
| `input_port` | Input | 32 | External data input (for IN instruction) |
| `output_port` | Output | 32 | External data output (for OUT instruction) |
| `fetch_pc_debug` | Output | 12 | Current PC value (debug) |
| `core_enable` | Output | 1 | Core active signal |

---

## Assembler

Run from the repository root:

~~~powershell
python assembler/assembler.py programs/branch.asm
~~~

The assembler accepts the 26 project instructions, labels, hexadecimal values, .ORG, and raw data words. It writes program.mem for CPU memory and input.mem for the testbench input port. For IN instructions, comments such as "IN R1 # R1=30" supply test input values.

Words 0 through 3 hold the reset and interrupt vectors. The programs place these explicitly with .ORG 0. Use --no-input-output for a testbench that drives a fixed input port.

---

## Simulation

Start QuestaSim in the repository root:

```tcl
do run.do
```

The script rebuilds the work library, compiles the CPU and testbenches, assembles the branch program, opens its waveform and runs until the testbench completes.

To switch to another program after that:

```tcl
do sim/memory.do
do sim/one_operand.do
do sim/two_operand.do
```

Component test scripts are also in `sim/`, such as `do sim/test_alu.do`. These use the library compiled by `run.do`.

Verified in QuestaSim using component tests and assembly-program simulations covering arithmetic, branches, memory, forwarding and interrupt handling.

## Dependencies

| Tool | Version |
|------|---------|
| ModelSim / QuestaSim | QuestaSim 2021.1 |
| Python | 3.8 or later (for assembler) |
| VHDL Standard | VHDL-2008 |

---

## References

- Patterson & Hennessy, *Computer Organization and Design*
- IEEE Standard VHDL Language Reference Manual (IEEE 1076-2008)

The report and schematics in `docs/` are the original course documents. The [instruction-set notes](docs/isa.md) describe the current implementation.
