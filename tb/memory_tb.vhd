library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory_tb is
end memory_tb;

architecture behavior of memory_tb is
    signal clk : std_logic := '0';
    signal mem_write_en : std_logic := '0';
    signal mem_addr : std_logic_vector(11 downto 0) := (others => '0');
    signal mem_data_in : std_logic_vector(31 downto 0) := (others => '0');
    signal mem_data_out : std_logic_vector(31 downto 0);

    constant CLK_PERIOD : time := 10 ns;

    procedure check(
        signal_name : in string;
        actual : in std_logic_vector(31 downto 0);
        expected : in std_logic_vector(31 downto 0)
    ) is
    begin
        assert actual = expected
            report signal_name & " expected 0x" & to_hstring(expected) &
                    ", got 0x" & to_hstring(actual)
            severity error;
    end procedure;
begin
    uut: entity work.memory
        port map (
            clk => clk,
            mem_write_en => mem_write_en,
            mem_addr => mem_addr,
            mem_data_in => mem_data_in,
            mem_data_out => mem_data_out
        );

    clk_process : process
    begin
        clk <= '0'; wait for CLK_PERIOD / 2;
        clk <= '1'; wait for CLK_PERIOD / 2;
    end process;

    stim_proc : process
    begin
        mem_addr <= "000000000000"; wait for 1 ns;
        check("M[0] reset vector", mem_data_out, x"00000002");

        mem_addr <= "000000000001"; wait for 1 ns;
        check("M[1] interrupt vector", mem_data_out, x"00000002");

        mem_addr <= "000000000010"; wait for 1 ns;
        check("M[2]", mem_data_out, x"DEADBEEF");

        mem_addr <= "000000000011"; wait for 1 ns;
        check("M[3]", mem_data_out, x"12345678");

        mem_addr <= "000000000100"; wait for 1 ns;
        check("M[4]", mem_data_out, x"CAFEBABE");

        mem_addr <= "000000000101"; wait for 1 ns;
        check("M[5]", mem_data_out, x"AABBCCDD");

        mem_addr <= "000000000110"; wait for 1 ns;
        check("M[6]", mem_data_out, x"11223344");

        mem_addr <= "000000000111"; wait for 1 ns;
        check("M[7]", mem_data_out, x"55667788");

        mem_addr <= "000000001000"; wait for 1 ns;
        check("M[8]", mem_data_out, x"99AABBCC");

        mem_addr <= "000000001001"; wait for 1 ns;
        check("M[9]", mem_data_out, x"DDEEFF00");

        mem_addr <= "000000001010"; wait for 1 ns;
        check("M[10] unwritten", mem_data_out, x"00000000");

        mem_addr <= "000001111111"; wait for 1 ns;
        check("M[127] unwritten", mem_data_out, x"00000000");

        mem_write_en <= '1';
        mem_addr <= "000001111111";
        mem_data_in <= x"FEEDFACE";
        wait until rising_edge(clk);
        wait for 1 ns;
        mem_write_en <= '0';
        check("M[127] after write", mem_data_out, x"FEEDFACE");

        mem_addr <= "000001111110"; wait for 1 ns;
        check("M[126] not corrupted", mem_data_out, x"00000000");

        mem_addr <= "000010000000"; wait for 1 ns;
        check("M[128] not corrupted", mem_data_out, x"00000000");

        mem_write_en <= '1';
        mem_addr <= "000000000010";
        mem_data_in <= x"FFFFFFFF";
        wait until rising_edge(clk);
        wait for 1 ns;
        mem_write_en <= '0';
        check("M[2] after overwrite", mem_data_out, x"FFFFFFFF");

        mem_addr <= "000000000011"; wait for 1 ns;
        check("M[3] still intact", mem_data_out, x"12345678");

        mem_addr <= "000000000100"; wait for 1 ns;
        check("M[4] still intact", mem_data_out, x"CAFEBABE");

        report "PASS: memory_tb";
        wait;
    end process;

end behavior;
