# Pipelined CPU — VHDL Implementation

A fully pipelined **32-bit CPU** implemented in VHDL, featuring a 5-stage pipeline, hazard detection and forwarding, a 2-bit dynamic branch predictor, hardware interrupt support, and a custom assembler. Designed and simulated as part of a computer architecture course project.

---

## Project Structure

```
Team 5/
├── src/
│   ├── 1.Components/          # Reusable building blocks
│   ├── 2.PIPLINE REGISTERS/   # Inter-stage pipeline registers
│   ├── 3.Stages/              # The 5 pipeline stage implementations
│   ├── 4.Controlling/         # Control unit, hazard unit, branch predictor
│   ├── 5.TOP/                 # Top-level integration
│   ├── 6.TestBench/           # Component & system testbenches + do files
│   └── waveforms/             # Waveform scripts for key test scenarios
├── assembler/
│   ├── assembler.py           # Python assembler (assembly → .mem)
│   ├── test.asm               # Example assembly program
│   ├── program.mem            # Assembler output (instruction memory)
│   └── README.txt             # Assembler usage guide
├── Schematic/                 # Block diagrams and schematic screenshots
└── Report/                   # Design report and schema PDF
```

---

## Architecture Overview

The CPU implements a **6-stage pipeline**:

```
┌─────────┐   IF/ID   ┌─────────┐   ID/EX1  ┌─────────┐   EX1/EX2
│  FETCH  │ ─────────► │ DECODE  │ ─────────► │   EX1   │ ──────────►
└─────────┘           └─────────┘           └─────────┘
                                                                        
  EX1/EX2  ┌─────────┐  EX2/MEM  ┌─────────┐  MEM/WB  ┌─────────┐
 ─────────► │   EX2   │ ─────────► │ MEMORY  │ ─────────► │   WB    │
            └─────────┘           └─────────┘           └─────────┘
```

**Cross-cutting units** (active every cycle):
- **Control Unit** — decodes 6-bit opcodes into all datapath control signals
- **Hazard Unit** — detects data/control hazards; issues stalls and flushes
- **Forwarding Unit** — resolves data hazards by bypassing results between stages
- **2-bit Branch Predictor** — predicts conditional branch direction dynamically
- **Interrupt Handler** — latches and serializes hardware interrupt requests

---

## Pipeline Stages

| Stage | File | Description |
|-------|------|-------------|
| **Fetch (IF)** | `FETCH.vhd` | Holds PC; selects next address via 3-way mux (sequential, branch target, fallthrough, memory read) |
| **Decode (ID)** | `DECODE.vhd` | Reads register file, sign/zero extends immediates, decodes control signals |
| **Execute 1 (EX1)** | `EX1.vhd` | ALU operation, forwarding muxes, branch condition evaluation |
| **Execute 2 (EX2)** | `EX2.vhd` | Second ALU stage; final branch decision; updates flags (CCR) |
| **Memory (MEM)** | `MEMORY.vhd` | Data memory read/write; stack pointer updates |
| **Write-Back (WB)** | `WB.vhd` | Writes result back to the register file |

---

## Pipeline Registers

| Register | File | Carries |
|----------|------|---------|
| IF/ID | `IF_ID.vhd` | Instruction word, PC |
| ID/EX1 | `ID_EX1.vhd` | Decoded control signals, register values, immediates |
| EX1/EX2 | `EX1_EX2.vhd` | ALU result, forwarded operands, branch info |
| EX2/MEM | `EX2_MEM.vhd` | Memory address/data, writeback controls |
| MEM/WB | `MEM_WB.vhd` | Memory read data, ALU result, destination register |

---

## Components

| File | Description |
|------|-------------|
| `alu.vhd` | 32-bit ALU with 8 operations; produces Carry, Zero, Negative flags |
| `register_file.vhd` | 8×32-bit register file with dual read ports and one write port |
| `memory_file.vhd` | Synchronous data memory |
| `pre_adder.vhd` | Pre-adder for address computation |
| `sign_extend.vhd` | Sign-extends immediates to 32 bits |
| `zero_extend.vhd` | Zero-extends immediates to 32 bits |
| `conditional_jump_decoder.vhd` | Evaluates branch conditions against CCR flags |
| `intrupt_handler.vhd` | Latches hardware interrupt; serializes service requests |
| `forwarding_unit.vhd` | Generates forwarding mux selects to resolve RAW hazards |

---

## ALU Operations

| `alu_op` | Operation |
|----------|-----------|
| `0000` | ADD |
| `0001` | SUB |
| `0010` | AND |
| `0011` | NOT |
| `0100` | NEG |
| `0101` | INC |
| `0110` | MOV / pass operand |
| `0111` | Flags-only (CMP) |

---

## Instruction Set (Opcode Summary)

| Opcode | Mnemonic | Type |
|--------|----------|------|
| `000000` | NOP | — |
| `000001` | HLT | — |
| `000010` | SETC | One-Operand |
| `000011` | NOT | One-Operand |
| `000100` | NEG | One-Operand |
| `000101` | OUT | One-Operand |
| `000110` | IN | One-Operand |
| `000111` | MOV | Two-Operand |
| `001000` | SWAP | Two-Operand |
| `001001` | ADD | Two-Operand |
| `001010` | SUB | Two-Operand |
| `001011` | AND | Two-Operand |
| `001100` | ADDI | Immediate |
| `001101` | PUSH | Memory |
| `001110` | POP | Memory |
| `001111` | LDI | Memory |
| `010000` | LDD | Memory |
| `010001` | STD | Memory |
| `010010` | JZ | Branch |
| `010011` | JN | Branch |
| `010100` | JC | Branch |
| `010101` | JMP | Branch |
| `010110` | CALL | Branch |
| `010111` | RET | Branch |
| `011000` | INT | Interrupt |
| `011001` | IRET | Interrupt |

---

## Top-Level Ports

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `clk` | Input | 1 | System clock |
| `rst` | Input | 1 | Active-high synchronous reset |
| `interrupt` | Input | 1 | Hardware interrupt request |
| `input_port` | Input | 32 | External data input (for IN instruction) |
| `output_port` | Output | 32 | External data output (for OUT instruction) |
| `fetch_pc_debug` | Output | 12 | Current PC value (debug) |
| `core_enable` | Output | 1 | Core active signal |

---

## Assembler

A Python assembler is included that converts assembly programs into `.mem` files loadable by the VHDL simulation.

```bash
# Basic usage
python assembler.py test.asm

# Custom output filename
python assembler.py test.asm -o my_program.mem

# Also generate a binary debug file
python assembler.py test.asm --bin

# Pad output to exactly 4096 words
python assembler.py test.asm --fill-to 4096
```

Output files are placed in the same directory as the assembler. The `.mem` file is used by the VHDL testbench via `$readmemh`.

---

## Simulation

This project uses **ModelSim / QuestaSim**.

```tcl
# Top-level test
do src/6.TestBench/do_files/test_top_level.do

# Branch hazard test
do src/6.TestBench/do_files/branch.do

# Memory operations test
do src/6.TestBench/do_files/memory.do

# One-operand instructions
do src/6.TestBench/do_files/oneop.do

# Two-operand instructions
do src/6.TestBench/do_files/twoop.do

# Individual component tests
do src/6.TestBench/do_files/test_alu.do
do src/6.TestBench/do_files/test_register_file_outputs.do
do src/6.TestBench/do_files/test_predictor_2_bit.do
```

Pre-built waveform scripts are also available under `src/waveforms/` for Branch, Memory, One-Operand, Two-Operand, and Hardware Interrupt scenarios.

---

## Dependencies

| Tool | Version |
|------|---------|
| ModelSim / QuestaSim | Any recent version |
| Python | 3.8 or later (for assembler) |
| VHDL Standard | VHDL-2008 |

---

## References

- Patterson & Hennessy, *Computer Organization and Design*
- IEEE Standard VHDL Language Reference Manual (IEEE 1076-2008)
