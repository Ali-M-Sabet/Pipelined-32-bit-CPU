"""Assembler for the pipelined CPU. Bare numbers are hexadecimal."""

import argparse
import re
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, List, NoReturn, Optional, Tuple

OPCODES = {
    "NOP": 0b000000,
    "HLT": 0b000001,
    "SETC": 0b000010,
    "NOT": 0b000011,
    "INC": 0b000100,
    "OUT": 0b000101,
    "IN": 0b000110,
    "MOV": 0b000111,
    "SWAP": 0b001000,
    "ADD": 0b001001,
    "SUB": 0b001010,
    "AND": 0b001011,
    "IADD": 0b001100,
    "PUSH": 0b001101,
    "POP": 0b001110,
    "LDM": 0b001111,
    "LDD": 0b010000,
    "STD": 0b010001,
    "JZ": 0b010010,
    "JN": 0b010011,
    "JC": 0b010100,
    "JMP": 0b010101,
    "CALL": 0b010110,
    "RET": 0b010111,
    "INT": 0b011000,
    "RTI": 0b011001,
}

MEMORY_WORDS = 4096


@dataclass
class SourceItem:
    address: int
    text: str
    line_no: int
    input_value: Optional[int]


def fail(message: str, line_no: Optional[int] = None) -> NoReturn:
    if line_no is not None:
        raise SystemExit(f"Assembler error on line {line_no}: {message}")
    raise SystemExit(f"Assembler error: {message}")


def strip_comment(line: str) -> str:
    line = line.split(";", 1)[0]
    line = line.split("#", 1)[0]
    return line.strip()


def comment_text(line: str) -> str:
    markers = [pos for pos in (line.find(";"), line.find("#")) if pos != -1]
    if not markers:
        return ""
    return line[min(markers) + 1 :].strip()


def split_operands(text: str) -> List[str]:
    return text.replace(",", " ").split()


def parse_register(token: str, line_no: Optional[int] = None) -> int:
    token = token.strip().upper()

    if not re.fullmatch(r"R[0-7]", token):
        fail(f"expected register R0..R7, got '{token}'", line_no)

    return int(token[1])


def parse_number(token: str, labels: Dict[str, int], line_no: Optional[int] = None) -> int:
    token = token.strip()

    upper = token.upper()
    if upper in labels:
        return labels[upper]

    sign = -1 if token.startswith("-") else 1
    unsigned = token[1:] if token[:1] in "+-" else token

    if unsigned.lower().startswith(("0x", "0b")):
        try:
            return sign * int(unsigned, 0)
        except ValueError:
            fail(f"expected number or label, got '{token}'", line_no)

    # Bare values are treated as hexadecimal, so "10" means 0x10, not decimal 10.
    if re.fullmatch(r"[0-9A-Fa-f]+", unsigned):
        return sign * int(unsigned, 16)

    fail(f"expected number or label, got '{token}'", line_no)


def parse_input_comment_value(comment: str, line_no: Optional[int] = None) -> Optional[int]:
    # IN R1 # R1=30 supplies the testbench input at this instruction address.
    if not comment:
        return None

    assignment = re.search(
        r"\bR[0-7]\s*=\s*([+-]?(?:0x[0-9A-Fa-f]+|0b[01]+|[0-9A-Fa-f]+))(?![A-Za-z0-9_])",
        comment, re.IGNORECASE,
    )
    if assignment:
        return to_u32(parse_number(assignment.group(1), {}, line_no), line_no)

    return None


def to_u16(value: int, line_no: Optional[int] = None) -> int:
    if value < -32768 or value > 0xFFFF:
        fail(f"16-bit immediate/address out of range: {value}", line_no)

    # Accept signed immediates and raw 16-bit patterns; encode two's complement.
    return value & 0xFFFF


def to_u32(value: int, line_no: Optional[int] = None) -> int:
    if value < -2147483648 or value > 0xFFFFFFFF:
        fail(f"32-bit word out of range: {value}", line_no)

    return value & 0xFFFFFFFF


def parse_offset_base(token: str, labels: Dict[str, int], line_no: Optional[int] = None) -> Tuple[int, int]:
    match = re.fullmatch(r"(.+)\((R[0-7])\)", token.strip(), re.IGNORECASE)

    if not match:
        fail(f"expected memory operand like offset(Rx), got '{token}'", line_no)

    offset_text = match.group(1).strip()
    base_reg_text = match.group(2).strip()

    offset_value = parse_number(offset_text, labels, line_no)
    base_reg = parse_register(base_reg_text, line_no)

    return offset_value, base_reg


def encode_word(opcode: int, rdst: int = 0, rsrc1: int = 0,
                rsrc2: int = 0, imm: int = 0) -> int:
    # Opcode [31:26], registers [25:23]/[22:20]/[19:17], immediate [15:0].
    return (opcode << 26) | (rdst << 23) | (rsrc1 << 20) | (rsrc2 << 17) | (imm & 0xFFFF)


def require_count(tokens: List[str], expected_count: int, line_no: int) -> None:
    if len(tokens) != expected_count:
        mnemonic = tokens[0] if tokens else "<empty>"
        got = max(len(tokens) - 1, 0)
        expected = expected_count - 1
        fail(f"{mnemonic} expects {expected} operand(s), got {got}", line_no)


def encode_instruction(text: str, labels: Dict[str, int], line_no: int) -> int:
    tokens = split_operands(text)

    if not tokens:
        fail("empty instruction", line_no)

    mnemonic = tokens[0].upper()

    if mnemonic not in OPCODES:
        fail(f"unknown instruction '{mnemonic}'", line_no)

    opcode = OPCODES[mnemonic]

    if mnemonic in {"NOP", "HLT", "SETC", "RET", "RTI"}:
        require_count(tokens, 1, line_no)
        return encode_word(opcode)

    if mnemonic in {"NOT", "INC"}:
        require_count(tokens, 2, line_no)
        r = parse_register(tokens[1], line_no)
        return encode_word(opcode, rdst=r, rsrc1=r)

    if mnemonic in {"OUT", "PUSH"}:
        require_count(tokens, 2, line_no)
        r = parse_register(tokens[1], line_no)
        return encode_word(opcode, rsrc1=r)

    if mnemonic in {"IN", "POP"}:
        require_count(tokens, 2, line_no)
        r = parse_register(tokens[1], line_no)
        return encode_word(opcode, rdst=r)

    if mnemonic in {"MOV", "SWAP"}:
        require_count(tokens, 3, line_no)
        rdst = parse_register(tokens[1], line_no)
        rsrc = parse_register(tokens[2], line_no)

        # SWAP needs the original destination as its second source.
        if mnemonic == "SWAP":
            return encode_word(opcode, rdst=rdst, rsrc1=rsrc, rsrc2=rdst)

        return encode_word(opcode, rdst=rdst, rsrc1=rsrc)

    if mnemonic in {"ADD", "SUB", "AND"}:
        require_count(tokens, 4, line_no)
        rdst = parse_register(tokens[1], line_no)
        rsrc1 = parse_register(tokens[2], line_no)
        rsrc2 = parse_register(tokens[3], line_no)
        return encode_word(opcode, rdst=rdst, rsrc1=rsrc1, rsrc2=rsrc2)

    if mnemonic == "IADD":
        require_count(tokens, 4, line_no)
        rdst = parse_register(tokens[1], line_no)
        rsrc = parse_register(tokens[2], line_no)
        imm = to_u16(parse_number(tokens[3], labels, line_no), line_no)
        return encode_word(opcode, rdst=rdst, rsrc1=rsrc, imm=imm)

    if mnemonic == "LDM":
        require_count(tokens, 3, line_no)
        rdst = parse_register(tokens[1], line_no)
        imm = to_u16(parse_number(tokens[2], labels, line_no), line_no)
        return encode_word(opcode, rdst=rdst, imm=imm)

    if mnemonic == "LDD":
        require_count(tokens, 3, line_no)
        rdst = parse_register(tokens[1], line_no)
        offset, base = parse_offset_base(tokens[2], labels, line_no)
        imm = to_u16(offset, line_no)
        return encode_word(opcode, rdst=rdst, rsrc1=base, imm=imm)

    if mnemonic == "STD":
        require_count(tokens, 3, line_no)
        data_reg = parse_register(tokens[1], line_no)
        offset, base_reg = parse_offset_base(tokens[2], labels, line_no)
        imm = to_u16(offset, line_no)
        return encode_word(opcode, rsrc1=data_reg, rsrc2=base_reg, imm=imm)

    if mnemonic in {"JZ", "JN", "JC", "JMP", "CALL"}:
        require_count(tokens, 2, line_no)
        target = to_u16(parse_number(tokens[1], labels, line_no), line_no)
        return encode_word(opcode, imm=target)

    # Software interrupt: index is encoded in instruction bit 16.
    if mnemonic == "INT":
        require_count(tokens, 2, line_no)
        index = parse_number(tokens[1], labels, line_no)

        if index not in (0, 1):
            fail("INT index must be 0 or 1", line_no)

        return ((opcode & 0b111111) << 26) | ((index & 1) << 16)

    fail(f"instruction '{mnemonic}' exists in opcode table but is not implemented", line_no)


def assemble(source: str) -> Tuple[Dict[int, int], Dict[int, int]]:
    labels: Dict[str, int] = {}
    items: List[SourceItem] = []
    occupied = set()
    address = 4  # Words 0-3 hold reset, hardware IRQ, INT 0, and INT 1 vectors.

    # Pass 1 records addresses so instructions can refer to labels defined later.
    for line_no, original in enumerate(source.splitlines(), 1):
        text = strip_comment(original)
        while text:
            label = re.match(r"^([A-Za-z_][A-Za-z0-9_]*)\s*:\s*(.*)$", text)
            if not label:
                break
            name, text = label.group(1).upper(), label.group(2).strip()
            if name in labels:
                fail(f"duplicate label '{name}'", line_no)
            labels[name] = address
        if not text:
            continue

        tokens = split_operands(text)
        if tokens[0].upper() == ".ORG":
            require_count(tokens, 2, line_no)
            address = parse_number(tokens[1], labels, line_no)
            if not 0 <= address < MEMORY_WORDS:
                fail(".ORG address must be between 0 and FFF", line_no)
            continue
        if not 0 <= address < MEMORY_WORDS:
            fail("program exceeds the 4096-word memory", line_no)
        if address in occupied:
            fail(f"memory address already defined: {address:X}", line_no)
        occupied.add(address)

        input_value = None
        if tokens[0].upper() == "IN":
            input_value = parse_input_comment_value(comment_text(original), line_no)
        items.append(SourceItem(address, text, line_no, input_value))
        address += 1

    # Explicit vector words in the source replace these defaults.
    memory = {0: labels.get("START", 4), 1: 0, 2: 0, 3: 0}
    inputs: Dict[int, int] = {}
    # Pass 2 resolves labels and encodes each word.
    for item in items:
        tokens = split_operands(item.text)
        if tokens[0].upper() == ".WORD":
            require_count(tokens, 2, item.line_no)
            word = to_u32(parse_number(tokens[1], labels, item.line_no), item.line_no)
        elif len(tokens) == 1 and re.fullmatch(
            r"[+-]?(?:0x[0-9A-Fa-f]+|0b[01]+|[0-9A-Fa-f]+)", tokens[0]
        ):
            word = to_u32(parse_number(tokens[0], labels, item.line_no), item.line_no)
        else:
            if item.address < 4:
                fail("addresses 0-3 are reserved for vector words", item.line_no)
            word = encode_instruction(item.text, labels, item.line_no)
        memory[item.address] = word
        if item.input_value is not None:
            inputs[item.address] = item.input_value
    return memory, inputs


def write_memory(path: Path, words: Dict[int, int]) -> None:
    length = max(words, default=0) + 1
    # Fill unused addresses with zero; VHDL reads one hex word per line.
    lines = [f"{words.get(address, 0):08X}" for address in range(length)]
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> None:
    parser = argparse.ArgumentParser(description="Assemble a pipelined CPU program")
    parser.add_argument("source", type=Path, help="assembly program")
    parser.add_argument(
        "--no-input-output", action="store_true",
        help="skip input.mem for tests with a fixed input port",
    )
    args = parser.parse_args()

    memory, inputs = assemble(args.source.read_text(encoding="utf-8"))
    write_memory(Path("program.mem"), memory)
    if not args.no_input_output:
        write_memory(Path("input.mem"), inputs)
    print(f"Assembled {args.source} ({max(memory) + 1} words)")


if __name__ == "__main__":
    try:
        main()
    except OSError as error:
        raise SystemExit(f"Assembler error: {error}")
