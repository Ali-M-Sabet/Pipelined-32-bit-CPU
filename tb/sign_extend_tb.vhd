library ieee;
use ieee.std_logic_1164.all;

entity sign_extend_tb is end entity;

architecture test of sign_extend_tb is
    signal stimulus : std_logic_vector(15 downto 0);
    signal result : std_logic_vector(31 downto 0);
begin
    dut : entity work.sign_extend
        port map (imm_16bit => stimulus, imm_32bit => result);

    process
        procedure check(value : std_logic_vector(15 downto 0);
                        expected : std_logic_vector(31 downto 0)) is
        begin
            stimulus <= value;
            wait for 10 ns;
            assert result = expected
                report "Input " & to_hstring(value) & " expected " &
                        to_hstring(expected) & ", got " & to_hstring(result)
                severity failure;
        end procedure;
    begin
        check(x"00AB", x"000000AB");
        check(x"FF5B", x"FFFFFF5B");
        check(x"0000", x"00000000");
        check(x"FFFF", x"FFFFFFFF");
        report "PASS: sign_extend_tb";
        wait;
    end process;
end architecture;
