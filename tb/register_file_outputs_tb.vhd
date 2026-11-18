library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_file_outputs_tb is
end entity;

architecture behavior of register_file_outputs_tb is
    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    signal reg_write_en : std_logic := '0';
    signal reg_write_addr : std_logic_vector(2 downto 0) := (others => '0');
    signal reg_write_data : std_logic_vector(31 downto 0) := (others => '0');
    signal reg_write2_en : std_logic := '0';
    signal reg_write2_addr : std_logic_vector(2 downto 0) := (others => '0');
    signal reg_write2_data : std_logic_vector(31 downto 0) := (others => '0');
    signal reg_read_addr1 : std_logic_vector(2 downto 0) := (others => '0');
    signal reg_read_addr2 : std_logic_vector(2 downto 0) := (others => '0');
    signal reg_read_data1 : std_logic_vector(31 downto 0);
    signal reg_read_data2 : std_logic_vector(31 downto 0);

    signal r0_view : std_logic_vector(31 downto 0) := (others => '0');
    signal r1_view : std_logic_vector(31 downto 0) := (others => '0');
    signal r2_view : std_logic_vector(31 downto 0) := (others => '0');
    signal r3_view : std_logic_vector(31 downto 0) := (others => '0');
    signal r4_view : std_logic_vector(31 downto 0) := (others => '0');
    signal r5_view : std_logic_vector(31 downto 0) := (others => '0');
    signal r6_view : std_logic_vector(31 downto 0) := (others => '0');
    signal r7_view : std_logic_vector(31 downto 0) := (others => '0');

    constant CLK_PERIOD : time := 10 ns;

    procedure write_reg(
        signal we : out std_logic;
        signal wa : out std_logic_vector(2 downto 0);
        signal wd : out std_logic_vector(31 downto 0);
        constant idx : in natural;
        constant val : in std_logic_vector(31 downto 0)
    ) is
    begin
        we <= '1';
        wa <= std_logic_vector(to_unsigned(idx, 3));
        wd <= val;
        wait until rising_edge(clk);
        wait for 1 ns;
        we <= '0';
    end procedure;
begin
    dut : entity work.register_file
        port map (
            clk => clk,
            rst => rst,
            reg_write_en => reg_write_en,
            reg_write_addr => reg_write_addr,
            reg_write_data => reg_write_data,
            reg_write2_en => reg_write2_en,
            reg_write2_addr => reg_write2_addr,
            reg_write2_data => reg_write2_data,
            reg_read_addr1 => reg_read_addr1,
            reg_read_addr2 => reg_read_addr2,
            reg_read_data1 => reg_read_data1,
            reg_read_data2 => reg_read_data2
        );

    clk_process : process
    begin
        clk <= '0'; wait for CLK_PERIOD / 2;
        clk <= '1'; wait for CLK_PERIOD / 2;
    end process;

    stim_proc : process
    begin
        rst <= '1';
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        rst <= '0';
        wait for 1 ns;

        write_reg(reg_write_en, reg_write_addr, reg_write_data, 0, x"00000000");
        write_reg(reg_write_en, reg_write_addr, reg_write_data, 1, x"00000019");
        write_reg(reg_write_en, reg_write_addr, reg_write_data, 2, x"0000001E");
        write_reg(reg_write_en, reg_write_addr, reg_write_data, 3, x"00000019");
        write_reg(reg_write_en, reg_write_addr, reg_write_data, 4, x"00000005");
        write_reg(reg_write_en, reg_write_addr, reg_write_data, 5, x"0000001E");
        write_reg(reg_write_en, reg_write_addr, reg_write_data, 6, x"00000000");
        write_reg(reg_write_en, reg_write_addr, reg_write_data, 7, x"00000000");

        reg_read_addr1 <= "000"; wait for 1 ns; r0_view <= reg_read_data1;
        reg_read_addr1 <= "001"; wait for 1 ns; r1_view <= reg_read_data1;
        reg_read_addr1 <= "010"; wait for 1 ns; r2_view <= reg_read_data1;
        reg_read_addr1 <= "011"; wait for 1 ns; r3_view <= reg_read_data1;
        reg_read_addr1 <= "100"; wait for 1 ns; r4_view <= reg_read_data1;
        reg_read_addr1 <= "101"; wait for 1 ns; r5_view <= reg_read_data1;
        reg_read_addr1 <= "110"; wait for 1 ns; r6_view <= reg_read_data1;
        reg_read_addr1 <= "111"; wait for 1 ns; r7_view <= reg_read_data1;
        wait for 1 ns;

        assert r0_view = x"00000000" report "R0 mismatch" severity error;
        assert r1_view = x"00000019" report "R1 mismatch" severity error;
        assert r2_view = x"0000001E" report "R2 mismatch" severity error;
        assert r3_view = x"00000019" report "R3 mismatch" severity error;
        assert r4_view = x"00000005" report "R4 mismatch" severity error;
        assert r5_view = x"0000001E" report "R5 mismatch" severity error;
        assert r6_view = x"00000000" report "R6 mismatch" severity error;
        assert r7_view = x"00000000" report "R7 mismatch" severity error;

        report "PASS: register_file_outputs_tb";
        wait;
    end process;
end architecture;
