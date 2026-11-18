library ieee;
use ieee.std_logic_1164.all;

entity alu_tb is
end entity;

architecture test of alu_tb is
    signal a, b, result : std_logic_vector(31 downto 0);
    signal op : std_logic_vector(3 downto 0);
    signal flags : std_logic_vector(2 downto 0);
begin
    dut : entity work.alu
        port map (operand1 => a, operand2 => b, alu_op => op,
            alu_result => result, alu_flags => flags);

    process
        procedure check(
            operation : std_logic_vector(3 downto 0);
            lhs, rhs, expected : std_logic_vector(31 downto 0);
            expected_flags : std_logic_vector(2 downto 0)
        ) is
        begin
            op <= operation;
            a <= lhs;
            b <= rhs;
            wait for 10 ns;
            assert result = expected and flags = expected_flags
                report "ALU operation " & to_hstring(operation) & " failed"
                severity failure;
        end procedure;
    begin
        -- Flags are carry, negative, zero.
        check("0000", x"FFFFFFFF", x"00000001", x"00000000", "101");
        check("0000", x"7FFFFFFF", x"00000001", x"80000000", "010");
        check("0001", x"00000000", x"00000001", x"FFFFFFFF", "010");
        check("0001", x"00000007", x"00000003", x"00000004", "100");
        check("0001", x"00000003", x"00000003", x"00000000", "101");
        check("0010", x"FF00FF00", x"0FF00FF0", x"0F000F00", "000");
        check("0011", x"00000000", x"FFFFFFFF", x"FFFFFFFF", "010");
        check("0100", x"FFFFFFFF", x"00000000", x"00000000", "101");
        check("0101", x"00000000", x"00000000", x"FFFFFFFF", "110");
        check("0101", x"00000001", x"00000000", x"00000000", "001");
        check("0110", x"81234567", x"FFFFFFFF", x"81234567", "010");
        check("0111", x"00000000", x"FFFFFFFF", x"00000000", "101");
        check("1111", x"FFFFFFFF", x"FFFFFFFF", x"00000000", "001");
        report "PASS: alu_tb";
        wait;
    end process;
end architecture;
