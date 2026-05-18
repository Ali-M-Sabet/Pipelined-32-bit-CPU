library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Testbench block: drives this module with simulation inputs and checks the expected behavior.
entity memory_tb is
end memory_tb;

-- Architecture block: contains the internal signals, instances, and logic for this entity.
architecture behavior of memory_tb is

    -- Declarations block: names the internal wires, storage, constants, and submodules used below.
    component memory
        port (
            clk          : in  std_logic;
            mem_write_en : in  std_logic;
            mem_addr     : in  std_logic_vector(11 downto 0);
            mem_data_in  : in  std_logic_vector(31 downto 0);
            mem_data_out : out std_logic_vector(31 downto 0)
        );
    end component;

    signal clk          : std_logic := '0';
    signal mem_write_en : std_logic := '0';
    signal mem_addr     : std_logic_vector(11 downto 0)  := (others => '0');
    signal mem_data_in  : std_logic_vector(31 downto 0) := (others => '0');
    signal mem_data_out : std_logic_vector(31 downto 0);

    constant CLK_PERIOD : time := 10 ns;

    procedure check(
        signal_name : in string;
        actual      : in std_logic_vector(31 downto 0);
        expected    : in std_logic_vector(31 downto 0)
    ) is
    begin
        if actual = expected then
            report "[PASS] " & signal_name &
                   " = 0x" & integer'image(to_integer(unsigned(actual)));
        else
            report "[FAIL] " & signal_name &
                   " | expected 0x" & integer'image(to_integer(unsigned(expected))) &
                   " | got 0x"      & integer'image(to_integer(unsigned(actual)))
            severity error;
        end if;
    end procedure;

begin

    uut: memory
        port map (
            clk          => clk,
            mem_write_en => mem_write_en,
            mem_addr     => mem_addr,
            mem_data_in  => mem_data_in,
            mem_data_out => mem_data_out
        );

    -- Process block: describes behavior that runs when its sensitivity signals change or a clock edge occurs.
    clk_process : process
    begin
        clk <= '0'; wait for CLK_PERIOD / 2;
        clk <= '1'; wait for CLK_PERIOD / 2;
    end process;

    -- Process block: describes behavior that runs when its sensitivity signals change or a clock edge occurs.
    stim_proc : process
    begin




        report "=== TEST 1: Verify program.mem loaded ===";

        mem_addr <= "000000000000"; wait for 1 ns;
        check("M[0] reset vector",     mem_data_out, x"00000002");

        mem_addr <= "000000000001"; wait for 1 ns;
        check("M[1] interrupt vector", mem_data_out, x"00000002");

        mem_addr <= "000000000010"; wait for 1 ns;
        check("M[2]",                  mem_data_out, x"DEADBEEF");

        mem_addr <= "000000000011"; wait for 1 ns;
        check("M[3]",                  mem_data_out, x"12345678");

        mem_addr <= "000000000100"; wait for 1 ns;
        check("M[4]",                  mem_data_out, x"CAFEBABE");

        mem_addr <= "000000000101"; wait for 1 ns;
        check("M[5]",                  mem_data_out, x"AABBCCDD");

        mem_addr <= "000000000110"; wait for 1 ns;
        check("M[6]",                  mem_data_out, x"11223344");

        mem_addr <= "000000000111"; wait for 1 ns;
        check("M[7]",                  mem_data_out, x"55667788");

        mem_addr <= "000000001000"; wait for 1 ns;
        check("M[8]",                  mem_data_out, x"99AABBCC");

        mem_addr <= "000000001001"; wait for 1 ns;
        check("M[9]",                  mem_data_out, x"DDEEFF00");




        report "=== TEST 2: Unwritten addresses = 0 ===";

        mem_addr <= "000000001010"; wait for 1 ns;
        check("M[10] unwritten",  mem_data_out, x"00000000");

        mem_addr <= "000001111111"; wait for 1 ns;
        check("M[127] unwritten", mem_data_out, x"00000000");




        report "=== TEST 3: Runtime write ===";

        mem_write_en <= '1';
        mem_addr     <= "000001111111";
        mem_data_in  <= x"FEEDFACE";
        wait until rising_edge(clk);
        wait for 1 ns;
        mem_write_en <= '0';
        check("M[127] after write", mem_data_out, x"FEEDFACE");




        report "=== TEST 4: Write isolation ===";

        mem_addr <= "000001111110"; wait for 1 ns;
        check("M[126] not corrupted", mem_data_out, x"00000000");

        mem_addr <= "000010000000"; wait for 1 ns;
        check("M[128] not corrupted", mem_data_out, x"00000000");




        report "=== TEST 5: Overwrite M[2] (was 0xDEADBEEF) ===";

        mem_write_en <= '1';
        mem_addr     <= "000000000010";
        mem_data_in  <= x"FFFFFFFF";
        wait until rising_edge(clk);
        wait for 1 ns;
        mem_write_en <= '0';
        check("M[2] after overwrite", mem_data_out, x"FFFFFFFF");




        report "=== TEST 6: Neighbours unaffected ===";

        mem_addr <= "000000000011"; wait for 1 ns;
        check("M[3] still intact", mem_data_out, x"12345678");

        mem_addr <= "000000000100"; wait for 1 ns;
        check("M[4] still intact", mem_data_out, x"CAFEBABE");

        report "=== ALL TESTS COMPLETE ===";
        wait;
    end process;

end behavior;
