library ieee;
use ieee.std_logic_1164.all;

entity incrementer_tb is end entity;

architecture test of incrementer_tb is
    signal stimulus : std_logic_vector(31 downto 0);
    signal result : std_logic_vector(31 downto 0);
begin
    dut : entity work.incrementer
        generic map (N => 32)
        port map (a => stimulus, result => result);

    process
        procedure check(value : std_logic_vector(31 downto 0);
                        expected : std_logic_vector(31 downto 0)) is
        begin
            stimulus <= value;
            wait for 1 ns;
            assert result = expected
                report "Input " & to_hstring(value) & " expected " &
                        to_hstring(expected) & ", got " & to_hstring(result)
                severity failure;
        end procedure;
    begin
        check(x"00000000", x"00000001");
        check(x"00000001", x"00000002");
        check(x"000000FF", x"00000100");
        check(x"12345678", x"12345679");
        check(x"FFFFFFFF", x"00000000");
        check(x"00000010", x"00000011");
        report "PASS: incrementer_tb";
        wait;
    end process;
end architecture;
