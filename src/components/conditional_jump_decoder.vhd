library ieee;
use ieee.std_logic_1164.all;

entity conditional_jump_decoder is
    port (
        instr : in std_logic_vector(31 downto 0);
        imm16 : out std_logic_vector(15 downto 0);
        is_conditional_branch : out std_logic
    );
end conditional_jump_decoder;

architecture behavioral of conditional_jump_decoder is
    signal opcode : std_logic_vector(5 downto 0);
begin
    opcode <= instr(31 downto 26);
    imm16 <= instr(15 downto 0);

    is_conditional_branch <= '1' when
        (opcode = "010010") or -- JZ
        (opcode = "010011") or -- JN
        (opcode = "010100") -- JC
        else '0';
end behavioral;
