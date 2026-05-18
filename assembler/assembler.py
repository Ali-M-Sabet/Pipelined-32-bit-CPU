"""
Team 10 Custom Processor Assembler
==================================

This program converts an assembly file into the plain hex memory format used by
the VHDL memory module.

The generated program.mem file has:
    - one 32-bit memory word per line
    - 8 hexadecimal digits per word
    - no address prefixes

Memory layout used by default:
    M[0] = reset/start address
    M[1] = hardware interrupt ISR address
    M[2] = software INT 0 ISR address
    M[3] = software INT 1 ISR address

Normal code starts at address 4 unless --code-start changes it.
"""

from __future__ import annotations

import argparse
import re
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, List, Optional, Tuple, Union


# Maps every assembly mnemonic to the 6-bit opcode used in instruction bits [31:26].
OPCODES: Dict[str, int] = {
    "NOP":  0b000000,
    "HLT":  0b000001,
    "SETC": 0b000010,
    "NOT":  0b000011,
    "INC":  0b000100,
    "OUT":  0b000101,
    "IN":   0b000110,
    "MOV":  0b000111,
    "SWAP": 0b001000,
    "ADD":  0b001001,
    "SUB":  0b001010,
    "AND":  0b001011,
    "IADD": 0b001100,
    "PUSH": 0b001101,
    "POP":  0b001110,
    "LDM":  0b001111,
    "LDD":  0b010000,
    "STD":  0b010001,
    "JZ":   0b010010,
    "JN":   0b010011,
    "JC":   0b010100,
    "JMP":  0b010101,
    "CALL": 0b010110,
    "RET":  0b010111,
    "INT":  0b011000,
    "RTI":  0b011001,
}

# VHDL memory has 12-bit addresses, so it can hold 4096 words.
DEFAULT_MEMORY_WORDS = 4096

# Addresses 0..3 are reserved for vectors, so normal code starts at 4.
DEFAULT_CODE_START = 4

# Data starts far from code by default so code and data do not collide easily.
DEFAULT_DATA_START = 512

# User-friendly names for the four reserved vector table addresses.
VECTOR_ADDR: Dict[str, int] = {
    "RESET": 0,
    "START": 0,
    "HW": 1,
    "HW_INT": 1,
    "HARDWARE": 1,
    "INT0": 2,
    "SW_INT0": 2,
    "INT1": 3,
    "SW_INT1": 3,
}


@dataclass
class SourceItem:
    # Final memory address for this source line.
    address: int
    # Source text after comments are removed.
    text: str
    # Original source line number, used for helpful error messages.
    line_no: int
    # True when this item is raw data from .word instead of an instruction.
    is_word_directive: bool = False
    # Optional value used by the testbench input-port memory.
    input_value: Optional[int] = None


def fail(message: str, line_no: Optional[int] = None) -> None:
    # Stop assembly immediately and print either a line-specific or general error.
    if line_no is not None:
        raise SystemExit(f"Assembler error on line {line_no}: {message}")
    raise SystemExit(f"Assembler error: {message}")


def strip_comment(line: str) -> str:
    # Remove anything after ';' because assembly comments can start with semicolon.
    line = line.split(";", 1)[0]
    # Remove anything after '#' because some files use shell-style comments.
    line = line.split("#", 1)[0]
    # Remove leading/trailing whitespace so parsing becomes simpler.
    return line.strip()


def comment_text(line: str) -> str:
    # Find comment markers so IN tests can read optional input values from comments.
    markers = [pos for pos in (line.find(";"), line.find("#")) if pos != -1]
    # No marker means this line has no comment text.
    if not markers:
        return ""
    # Return text after the first comment marker.
    return line[min(markers) + 1 :].strip()


def split_operands(text: str) -> List[str]:
    # Treat commas as spaces so "ADD R1,R2,R3" and "ADD R1 R2 R3" both work.
    return text.replace(",", " ").split()


def parse_register(token: str, line_no: Optional[int] = None) -> int:
    # Normalize register names so r0 and R0 are accepted the same way.
    token = token.strip().upper()

    # Only 8 registers exist because the instruction format has 3 register bits.
    if not re.fullmatch(r"R[0-7]", token):
        fail(f"expected register R0..R7, got '{token}'", line_no)

    # Convert "R3" into integer 3.
    return int(token[1])


def parse_number(token: str, labels: Dict[str, int], line_no: Optional[int] = None) -> int:
    # Remove spaces around the number or label.
    token = token.strip()

    # Labels are stored uppercase, so compare using uppercase.
    upper = token.upper()
    if upper in labels:
        return labels[upper]

    # Save the sign separately so -0x10 and -10 are easy to parse.
    sign = -1 if token.startswith("-") else 1
    unsigned = token[1:] if token[:1] in "+-" else token

    # Python can parse 0x... and 0b... automatically with base 0.
    if unsigned.lower().startswith(("0x", "0b")):
        try:
            return sign * int(unsigned, 0)
        except ValueError:
            fail(f"expected number or label, got '{token}'", line_no)

    # Bare values are treated as hexadecimal, so "10" means 0x10, not decimal 10.
    if re.fullmatch(r"[0-9A-Fa-f]+", unsigned):
        return sign * int(unsigned, 16)

    # Anything else is not a valid number and not a known label.
    fail(f"expected number or label, got '{token}'", line_no)

    # This return is unreachable, but it keeps type checkers satisfied.
    return 0


def parse_input_comment_value(comment: str, line_no: Optional[int] = None) -> Optional[int]:
    # If there is no comment, this instruction has no testbench input value.
    if not comment:
        return None

    # Pull the first number-looking token out of the comment.
    matches = re.findall(r"(?<![A-Za-z0-9_])(?:0x[0-9A-Fa-f]+|[0-9A-Fa-f]+)(?![A-Za-z0-9_])", comment)

    # Ignore common English words that accidentally look like hex digits.
    matches = [
        value
        for value in matches
        if value.lower() not in {"add", "added", "bad", "c", "d", "e", "f"}
    ]

    # No useful number was found in the comment.
    if not matches:
        return None

    # Store input values as unsigned 32-bit words for input.mem.
    return to_u32(parse_number(matches[0], {}, line_no), line_no)


def to_u16(value: int, line_no: Optional[int] = None) -> int:
    # This is the immediate overflow check.
    # The instruction has only 16 immediate bits, so values must fit in 16 bits.
    #
    # Allowed negative range:
    #   -32768..-1
    # These are converted to 16-bit two's complement by value & 0xFFFF.
    #
    # Allowed positive range:
    #   0..65535
    # Positive labels/addresses/immediates can use the whole unsigned 16-bit range.
    if value < -32768 or value > 0xFFFF:
        fail(f"16-bit immediate/address out of range: {value}", line_no)

    # Masking converts negative values to two's complement and keeps positive values unchanged.
    # Example: -1 & 0xFFFF = 0xFFFF.
    return value & 0xFFFF


def to_u32(value: int, line_no: Optional[int] = None) -> int:
    # This is the 32-bit word overflow check for .word values and vector targets.
    #
    # Allowed negative range:
    #   -2147483648..-1
    #
    # Allowed positive range:
    #   0..0xFFFFFFFF
    if value < -2147483648 or value > 0xFFFFFFFF:
        fail(f"32-bit word out of range: {value}", line_no)

    # Masking converts negative values to 32-bit two's complement.
    return value & 0xFFFFFFFF


def parse_offset_base(token: str, labels: Dict[str, int], line_no: Optional[int] = None) -> Tuple[int, int]:
    # Match memory syntax like 4(R2), -1(R3), or label(R1).
    match = re.fullmatch(r"(.+)\((R[0-7])\)", token.strip(), re.IGNORECASE)

    # If the syntax is not offset(register), the memory instruction is invalid.
    if not match:
        fail(f"expected memory operand like offset(Rx), got '{token}'", line_no)

    # The first group is the offset part before the parentheses.
    offset_text = match.group(1).strip()
    # The second group is the base register inside the parentheses.
    base_reg_text = match.group(2).strip()

    # Parse the offset as a number or label.
    offset_value = parse_number(offset_text, labels, line_no)
    # Parse the base register as R0..R7.
    base_reg = parse_register(base_reg_text, line_no)

    # Return both pieces so LDD/STD can encode them.
    return offset_value, base_reg


def encode_r_type(opcode: int, rdst: int = 0, rsrc1: int = 0, rsrc2: int = 0) -> int:
    # Build instruction fields:
    # [31:26] opcode, [25:23] Rdst, [22:20] Rsrc1, [19:17] Rsrc2.
    return (
        ((opcode & 0b111111) << 26)
        | ((rdst & 0b111) << 23)
        | ((rsrc1 & 0b111) << 20)
        | ((rsrc2 & 0b111) << 17)
    )


def encode_i_type(opcode: int, rdst: int = 0, rsrc1: int = 0, rsrc2: int = 0, imm: int = 0) -> int:
    # Build an instruction that also uses the lower 16 bits for an immediate/offset.
    return (
        ((opcode & 0b111111) << 26)
        | ((rdst & 0b111) << 23)
        | ((rsrc1 & 0b111) << 20)
        | ((rsrc2 & 0b111) << 17)
        | (imm & 0xFFFF)
    )


def encode_j_type(opcode: int, imm: int = 0) -> int:
    # Build jump/simple instructions that only need opcode and a 16-bit immediate.
    return ((opcode & 0b111111) << 26) | (imm & 0xFFFF)


def encode_s_type(opcode: int, rdst: int = 0, rsrc1: int = 0) -> int:
    # Build one-operand or source-only instructions.
    return (
        ((opcode & 0b111111) << 26)
        | ((rdst & 0b111) << 23)
        | ((rsrc1 & 0b111) << 20)
    )


def require_count(tokens: List[str], expected_count: int, line_no: int) -> None:
    # Verify that the instruction has exactly the required number of tokens.
    if len(tokens) != expected_count:
        mnemonic = tokens[0] if tokens else "<empty>"
        got = max(len(tokens) - 1, 0)
        expected = expected_count - 1
        fail(f"{mnemonic} expects {expected} operand(s), got {got}", line_no)


def encode_instruction(text: str, labels: Dict[str, int], line_no: int) -> int:
    # Split the instruction into mnemonic and operands.
    tokens = split_operands(text)

    # Empty text should never reach here, but catch it for safety.
    if not tokens:
        fail("empty instruction", line_no)

    # The first token is the instruction name.
    mnemonic = tokens[0].upper()

    # Reject instructions that are not in the opcode table.
    if mnemonic not in OPCODES:
        fail(f"unknown instruction '{mnemonic}'", line_no)

    # Get the numeric opcode for this mnemonic.
    opcode = OPCODES[mnemonic]

    # No-operand instructions.
    if mnemonic in {"NOP", "HLT", "SETC", "RET", "RTI"}:
        require_count(tokens, 1, line_no)
        return encode_j_type(opcode, 0)

    # One-register instructions where hardware reads the same register as source/destination.
    if mnemonic in {"NOT", "INC"}:
        require_count(tokens, 2, line_no)
        r = parse_register(tokens[1], line_no)
        return encode_s_type(opcode, rdst=r, rsrc1=r)

    # Source-only instructions: OUT and PUSH read one register.
    if mnemonic in {"OUT", "PUSH"}:
        require_count(tokens, 2, line_no)
        r = parse_register(tokens[1], line_no)
        return encode_s_type(opcode, rsrc1=r)

    # Destination-only instructions: IN and POP write one register.
    if mnemonic in {"IN", "POP"}:
        require_count(tokens, 2, line_no)
        r = parse_register(tokens[1], line_no)
        return encode_s_type(opcode, rdst=r)

    # Two-register instructions.
    if mnemonic in {"MOV", "SWAP"}:
        require_count(tokens, 3, line_no)
        rdst = parse_register(tokens[1], line_no)
        rsrc = parse_register(tokens[2], line_no)

        # SWAP stores both registers so the hardware can later write both values.
        if mnemonic == "SWAP":
            return encode_r_type(opcode, rdst=rdst, rsrc1=rsrc, rsrc2=rdst)

        # MOV only needs destination and one source.
        return encode_r_type(opcode, rdst=rdst, rsrc1=rsrc)

    # Three-register ALU instructions.
    if mnemonic in {"ADD", "SUB", "AND"}:
        require_count(tokens, 4, line_no)
        rdst = parse_register(tokens[1], line_no)
        rsrc1 = parse_register(tokens[2], line_no)
        rsrc2 = parse_register(tokens[3], line_no)
        return encode_r_type(opcode, rdst=rdst, rsrc1=rsrc1, rsrc2=rsrc2)

    # Immediate add: destination, source register, 16-bit immediate.
    if mnemonic == "IADD":
        require_count(tokens, 4, line_no)
        rdst = parse_register(tokens[1], line_no)
        rsrc = parse_register(tokens[2], line_no)

        # If the third operand is accidentally written as a register, encode its number.
        if re.fullmatch(r"R[0-7]", tokens[3].strip(), re.IGNORECASE):
            imm_value = parse_register(tokens[3], line_no)
        else:
            imm_value = parse_number(tokens[3], labels, line_no)

        # Check immediate overflow and convert negative values to 16-bit two's complement.
        imm = to_u16(imm_value, line_no)
        return encode_i_type(opcode, rdst=rdst, rsrc1=rsrc, imm=imm)

    # Load immediate: destination register and 16-bit immediate.
    if mnemonic == "LDM":
        require_count(tokens, 3, line_no)
        rdst = parse_register(tokens[1], line_no)
        imm = to_u16(parse_number(tokens[2], labels, line_no), line_no)
        return encode_i_type(opcode, rdst=rdst, imm=imm)

    # Load from memory: LDD Rdst, offset(Rbase).
    if mnemonic == "LDD":
        require_count(tokens, 3, line_no)
        rdst = parse_register(tokens[1], line_no)
        offset, base = parse_offset_base(tokens[2], labels, line_no)
        imm = to_u16(offset, line_no)
        return encode_i_type(opcode, rdst=rdst, rsrc1=base, imm=imm)

    # Store to memory: STD Rdata, offset(Rbase).
    if mnemonic == "STD":
        require_count(tokens, 3, line_no)
        data_reg = parse_register(tokens[1], line_no)
        offset, base_reg = parse_offset_base(tokens[2], labels, line_no)
        imm = to_u16(offset, line_no)
        return encode_i_type(opcode, rsrc1=data_reg, rsrc2=base_reg, imm=imm)

    # Branch and call instructions encode the target in the lower 16 bits.
    if mnemonic in {"JZ", "JN", "JC", "JMP", "CALL"}:
        require_count(tokens, 2, line_no)
        target = to_u16(parse_number(tokens[1], labels, line_no), line_no)
        return encode_j_type(opcode, target)

    # Software interrupt: index is encoded in instruction bit 16.
    if mnemonic == "INT":
        require_count(tokens, 2, line_no)
        index = parse_number(tokens[1], labels, line_no)

        # The hardware only supports INT 0 and INT 1.
        if index not in (0, 1):
            fail("INT index must be 0 or 1", line_no)

        return ((opcode & 0b111111) << 26) | ((index & 1) << 16)

    # This should not happen unless OPCODES contains an unhandled mnemonic.
    fail(f"instruction '{mnemonic}' exists in opcode table but is not implemented", line_no)
    return 0


def first_pass(source_lines: List[str], code_start: int) -> Tuple[Dict[str, int], List[SourceItem], Dict[int, Union[int, str]]]:
    # First pass collects labels, source items, and vector directives.
    labels: Dict[str, int] = {}
    items: List[SourceItem] = []
    vectors: Dict[int, Union[int, str]] = {}

    # Track whether new items go into the text/code area or data area.
    current_section = "text"
    text_addr = code_start
    data_addr = DEFAULT_DATA_START
    current_addr = text_addr

    # Walk through the source file one line at a time.
    for line_no, original_line in enumerate(source_lines, start=1):
        # Read optional input-port value from the comment before removing comments.
        input_value = parse_input_comment_value(comment_text(original_line), line_no)
        # Remove comments and whitespace.
        line = strip_comment(original_line)

        # Skip empty/comment-only lines.
        if not line:
            continue

        # A line may contain one or more labels before the instruction.
        while True:
            label_match = re.match(r"^([A-Za-z_][A-Za-z0-9_]*)\s*:\s*(.*)$", line)
            if not label_match:
                break

            label_name = label_match.group(1).upper()
            rest_of_line = label_match.group(2).strip()

            # Duplicate labels are ambiguous, so reject them.
            if label_name in labels:
                fail(f"duplicate label '{label_name}'", line_no)

            # Store this label at the current memory address.
            labels[label_name] = current_addr
            line = rest_of_line

            # If this was a label-only line, continue with the next source line.
            if not line:
                break

        # A label-only line has no item to assemble.
        if not line:
            continue

        tokens = split_operands(line)
        first_token = tokens[0].upper()

        # Switch back to the text/code section.
        if first_token == ".TEXT":
            if len(tokens) != 1:
                fail(".text expects no operands", line_no)

            if current_section == "data":
                data_addr = current_addr
            current_section = "text"
            current_addr = text_addr
            continue

        # Switch to the data section.
        if first_token == ".DATA":
            if len(tokens) != 1:
                fail(".data expects no operands", line_no)

            if current_section == "text":
                text_addr = current_addr
            current_section = "data"
            current_addr = data_addr
            continue

        # Set the current output address manually.
        if first_token == ".ORG":
            if len(tokens) != 2:
                fail(".org expects exactly one address", line_no)

            new_addr = parse_number(tokens[1], labels, line_no)

            # .org must stay inside the 4096-word memory.
            if new_addr < 0 or new_addr >= DEFAULT_MEMORY_WORDS:
                fail(f".org address must be between 0 and {DEFAULT_MEMORY_WORDS - 1}", line_no)

            current_addr = new_addr
            if current_section == "text":
                text_addr = current_addr
            else:
                data_addr = current_addr
            continue

        # Define a vector table entry, such as ".vector int0 handler".
        if first_token == ".VECTOR":
            if len(tokens) != 3:
                fail(".vector expects: .vector <reset|hw_int|int0|int1> <target>", line_no)

            vector_name = tokens[1].upper()
            target_text = tokens[2]

            # Check that the vector name is one of the supported vector aliases.
            if vector_name not in VECTOR_ADDR:
                allowed = ", ".join(sorted(VECTOR_ADDR.keys()))
                fail(f"unknown vector '{vector_name}'. Allowed: {allowed}", line_no)

            vector_memory_address = VECTOR_ADDR[vector_name]

            # The target can be a number now or a label that resolves later.
            if re.fullmatch(r"[+-]?(?:0x[0-9A-Fa-f]+|0b[01]+|[0-9A-Fa-f]+)", target_text):
                target: Union[int, str] = parse_number(target_text, labels, line_no)
            else:
                target = target_text.upper()

            vectors[vector_memory_address] = target
            continue

        # Raw data word directive.
        if first_token == ".WORD":
            if len(tokens) != 2:
                fail(".word expects exactly one value", line_no)

            items.append(SourceItem(current_addr, line, line_no, is_word_directive=True))
            current_addr += 1
            if current_section == "text":
                text_addr = current_addr
            else:
                data_addr = current_addr
            continue

        # A bare number is treated as ".word number" for convenience.
        if len(tokens) == 1 and re.fullmatch(r"[+-]?(?:0x[0-9A-Fa-f]+|0b[01]+|[0-9A-Fa-f]+)", tokens[0]):
            items.append(SourceItem(current_addr, ".word " + tokens[0], line_no, is_word_directive=True))
            current_addr += 1
            if current_section == "text":
                text_addr = current_addr
            else:
                data_addr = current_addr
            continue

        # Anything else is treated as a real instruction.
        items.append(
            SourceItem(
                current_addr,
                line,
                line_no,
                is_word_directive=False,
                input_value=input_value if first_token == "IN" else None,
            )
        )
        current_addr += 1
        if current_section == "text":
            text_addr = current_addr
        else:
            data_addr = current_addr

    return labels, items, vectors


def resolve_vector_target(target: Union[int, str], labels: Dict[str, int], line_no: Optional[int] = None) -> int:
    # Numeric vector targets are already known.
    if isinstance(target, int):
        return to_u32(target, line_no)

    # Label vector targets are resolved after first_pass has collected labels.
    label_name = target.upper()
    if label_name not in labels:
        fail(f"unknown vector target label '{target}'", line_no)

    return to_u32(labels[label_name], line_no)


def second_pass(labels: Dict[str, int], items: List[SourceItem], vectors: Dict[int, Union[int, str]], code_start: int) -> Dict[int, int]:
    # Second pass encodes instructions and writes final memory words.
    memory: Dict[int, int] = {}

    # Default reset target is label START if it exists, otherwise code_start.
    default_reset_target = labels.get("START", code_start)

    # Initialize the vector table.
    memory[0] = to_u32(default_reset_target)
    memory[1] = 0
    memory[2] = 0
    memory[3] = 0

    # Apply user-provided vector directives.
    for vector_memory_address, target in vectors.items():
        memory[vector_memory_address] = resolve_vector_target(target, labels)

    # Encode every source item into its final memory address.
    for item in items:
        # Every emitted item must fit in the 4096-word memory.
        if item.address < 0 or item.address >= DEFAULT_MEMORY_WORDS:
            fail(f"memory address out of range: {item.address}", item.line_no)

        # Protect vector table addresses from accidental code placement.
        if item.address in memory and item.address < DEFAULT_CODE_START and not item.is_word_directive:
            fail(
                f"address {item.address} is reserved for the vector table. "
                f"Use .vector instead of placing code/.word there.",
                item.line_no,
            )

        # .word stores a raw 32-bit value.
        if item.is_word_directive:
            tokens = split_operands(item.text)
            value = parse_number(tokens[1], labels, item.line_no)
            memory[item.address] = to_u32(value, item.line_no)
        # Instructions are encoded according to opcode and operand format.
        else:
            memory[item.address] = encode_instruction(item.text, labels, item.line_no)

    return memory


def write_hex_memory(memory: Dict[int, int], output_path: Path, fill_to: Optional[int] = None) -> None:
    # There must be at least the vector table or something to write.
    if not memory:
        fail("nothing to write")

    # The default output length is the highest used address plus one.
    max_used_addr = max(memory.keys())

    # --fill-to forces the output file to have a fixed number of lines.
    if fill_to is not None:
        if fill_to <= 0:
            fail("--fill-to must be positive")
        if fill_to > DEFAULT_MEMORY_WORDS:
            fail(f"--fill-to cannot exceed {DEFAULT_MEMORY_WORDS}")
        final_length = fill_to
    else:
        final_length = max_used_addr + 1

    lines: List[str] = []

    # Write every address from 0 to final_length - 1.
    for address in range(final_length):
        # Missing memory addresses are filled with zero.
        word = memory.get(address, 0)
        # Format as exactly 8 uppercase hex digits.
        lines.append(f"{word & 0xFFFFFFFF:08X}")

    output_path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def write_binary_debug(memory: Dict[int, int], output_path: Path, fill_to: Optional[int] = None) -> None:
    # Binary debug output mirrors program.mem but uses 32 binary digits.
    max_used_addr = max(memory.keys())
    final_length = fill_to if fill_to is not None else max_used_addr + 1

    lines: List[str] = []
    for address in range(final_length):
        word = memory.get(address, 0)
        lines.append(f"{word & 0xFFFFFFFF:032b}")

    output_path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def write_input_memory(items: List[SourceItem], output_path: Path, fill_to: Optional[int] = None) -> None:
    # Build a PC-indexed map of input values used by testbenches.
    input_values = {
        item.address: item.input_value
        for item in items
        if item.input_value is not None
    }

    # If there are no input values, still write one zero word by default.
    max_used_addr = max([0, *input_values.keys()])
    final_length = fill_to if fill_to is not None else max_used_addr + 1

    lines: List[str] = []
    for address in range(final_length):
        word = input_values.get(address, 0)
        lines.append(f"{word & 0xFFFFFFFF:08X}")

    output_path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def assemble_file(
    input_path: Path,
    output_path: Path,
    bin_output_path: Optional[Path],
    input_output_path: Optional[Path],
    fill_to: Optional[int],
    code_start: int,
) -> None:
    # Make sure the requested input file exists.
    if not input_path.exists():
        fail(f"input file does not exist: {input_path}")

    # Keep addresses 0..3 reserved for vectors.
    if code_start < 4:
        fail("code_start must be at least 4 because addresses 0..3 are reserved vectors")

    # Read the assembly file as text lines.
    source_lines = input_path.read_text(encoding="utf-8").splitlines()

    # First pass records labels and source item addresses.
    labels, items, vectors = first_pass(source_lines, code_start=code_start)
    # Second pass turns those source items into numeric machine words.
    memory = second_pass(labels, items, vectors, code_start=code_start)

    # Write the main program.mem output.
    write_hex_memory(memory, output_path, fill_to=fill_to)

    # Optionally write a binary debug version.
    if bin_output_path is not None:
        write_binary_debug(memory, bin_output_path, fill_to=fill_to)

    # Optionally write input.mem for testbench input-port values.
    if input_output_path is not None:
        write_input_memory(items, input_output_path, fill_to=fill_to)

    # Print a short success report.
    print(f"Assembled successfully: {input_path}")
    print(f"Wrote hex memory file: {output_path}")

    if bin_output_path is not None:
        print(f"Wrote binary debug file: {bin_output_path}")

    if input_output_path is not None:
        print(f"Wrote PC-indexed input file: {input_output_path}")

    print(f"Memory words written: {fill_to if fill_to is not None else max(memory.keys()) + 1}")


def build_arg_parser() -> argparse.ArgumentParser:
    # Create the command-line parser for this script.
    parser = argparse.ArgumentParser(
        description="Team 10 assembler: converts .asm into plain hex program.mem"
    )

    parser.add_argument(
        "input",
        help="input assembly file, example: test.asm",
    )

    parser.add_argument(
        "-o",
        "--output",
        default="program.mem",
        help="output memory file name. Default: program.mem in the current/root folder",
    )

    parser.add_argument(
        "--bin",
        action="store_true",
        help="also generate program.bin with 32-bit binary text lines for debugging",
    )

    parser.add_argument(
        "--bin-output",
        default="program.bin",
        help="binary debug output file name when --bin is used. Default: program.bin",
    )

    parser.add_argument(
        "--input-output",
        default="input.mem",
        help="PC-indexed input-port values for the testbench. Default: input.mem",
    )

    parser.add_argument(
        "--no-input-output",
        action="store_true",
        help="do not write input.mem",
    )

    parser.add_argument(
        "--fill-to",
        type=int,
        default=None,
        help="optionally force output to contain N memory words, e.g. --fill-to 4096",
    )

    parser.add_argument(
        "--code-start",
        type=int,
        default=DEFAULT_CODE_START,
        help="address where normal code starts. Default: 4",
    )

    return parser


def main(argv: Optional[List[str]] = None) -> int:
    # Build parser and read command-line arguments.
    parser = build_arg_parser()
    args = parser.parse_args(argv)

    # Convert string paths into Path objects.
    input_path = Path(args.input)
    output_path = Path(args.output)
    bin_output_path = Path(args.bin_output) if args.bin else None
    input_output_path = None if args.no_input_output else Path(args.input_output)

    # Run the actual assembler.
    assemble_file(
        input_path=input_path,
        output_path=output_path,
        bin_output_path=bin_output_path,
        input_output_path=input_output_path,
        fill_to=args.fill_to,
        code_start=args.code_start,
    )

    # Return success to the operating system.
    return 0


if __name__ == "__main__":
    try:
        # Run main() when this file is executed as a script.
        raise SystemExit(main())
    except KeyboardInterrupt:
        # Print a clean message if the user presses Ctrl+C.
        print("\nAssembler cancelled.", file=sys.stderr)
        raise SystemExit(1)
