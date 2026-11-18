library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity conditional_jump_decoder_tb is
end entity;

architecture test of conditional_jump_decoder_tb is
    signal instruction : std_logic_vector(31 downto 0);
    signal immediate : std_logic_vector(15 downto 0);
    signal conditional : std_logic;
begin
    dut : entity work.conditional_jump_decoder
        port map (instr => instruction, imm16 => immediate,
            is_conditional_branch => conditional);

    process
        procedure check(
            opcode : std_logic_vector(5 downto 0);
            target : std_logic_vector(15 downto 0);
            expected_conditional : std_logic
        ) is
        begin
            instruction <= opcode & "0000000000" & target;
            wait for 10 ns;
            assert immediate = target and conditional = expected_conditional
                report "Conditional jump decode failed for opcode " & to_hstring(opcode)
                severity failure;
        end procedure;
    begin
        check("010010", x"1234", '1'); -- JZ
        check("010011", x"FFFF", '1'); -- JN
        check("010100", x"0000", '1'); -- JC
        check("010101", x"AAAA", '0'); -- JMP
        check("010110", x"5555", '0'); -- CALL
        check("001001", x"ABCD", '0'); -- ADD
        check("000000", x"0000", '0'); -- NOP
        check("111111", x"FFFF", '0');
        -- Every possible opcode must classify correctly.
        for opcode in 0 to 63 loop
            if opcode >= 18 and opcode <= 20 then
                check(std_logic_vector(to_unsigned(opcode, 6)), x"5AA5", '1');
            else
                check(std_logic_vector(to_unsigned(opcode, 6)), x"5AA5", '0');
            end if;
        end loop;
        report "PASS: conditional_jump_decoder_tb";
        wait;
    end process;
end architecture;
