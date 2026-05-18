LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- Conditional branch decoder: detects conditional jump instructions and extracts their target immediate.
ENTITY conditional_jump_decoder IS
    PORT (
        instr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        imm16 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        is_conditional_branch : OUT STD_LOGIC
    );
END conditional_jump_decoder;

-- Architecture block: contains the internal signals, instances, and logic for this entity.
ARCHITECTURE Behavioral OF conditional_jump_decoder IS

    -- Declarations block: names the internal wires, storage, constants, and submodules used below.
    SIGNAL opcode : STD_LOGIC_VECTOR(5 DOWNTO 0);

BEGIN


    opcode <= instr(31 DOWNTO 26);
    imm16 <= instr(15 DOWNTO 0);


    is_conditional_branch <= '1' WHEN
        (opcode = "010010") OR
        (opcode = "010011") OR
        (opcode = "010100")
        ELSE
        '0';

END Behavioral;
