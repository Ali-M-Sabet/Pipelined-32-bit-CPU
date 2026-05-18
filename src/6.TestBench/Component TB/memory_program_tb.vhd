library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Testbench block: drives this module with simulation inputs and checks the expected behavior.
entity memory_program_tb is
end entity;

-- Architecture block: contains the internal signals, instances, and logic for this entity.
architecture behavior of memory_program_tb is
    -- Declarations block: names the internal wires, storage, constants, and submodules used below.
    component memory is
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
    signal mem_addr     : std_logic_vector(11 downto 0) := (others => '0');
    signal mem_data_in  : std_logic_vector(31 downto 0) := (others => '0');
    signal mem_data_out : std_logic_vector(31 downto 0);

    constant CLK_PERIOD : time := 10 ns;

    procedure check_word(
        signal addr_sig : out std_logic_vector(11 downto 0);
        signal data_sig : in  std_logic_vector(31 downto 0);
        constant addr   : in  natural;
        constant expect : in  std_logic_vector(31 downto 0)
    ) is
    begin
        addr_sig <= std_logic_vector(to_unsigned(addr, 12));
        wait for 1 ns;
        assert data_sig = expect
            report "program.mem mismatch at address " & integer'image(addr)
            severity error;
    end procedure;

begin
    -- Instance block: connects this submodule to the surrounding signals.
    dut : memory
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
        check_word(mem_addr, mem_data_out, 16#000#, x"00000300");

        check_word(mem_addr, mem_data_out, 16#300#, x"32000000");
        check_word(mem_addr, mem_data_out, 16#301#, x"33000000");
        check_word(mem_addr, mem_data_out, 16#302#, x"34000000");
        check_word(mem_addr, mem_data_out, 16#303#, x"79000005");
        check_word(mem_addr, mem_data_out, 16#304#, x"68200000");
        check_word(mem_addr, mem_data_out, 16#305#, x"68400000");
        check_word(mem_addr, mem_data_out, 16#306#, x"71000000");
        check_word(mem_addr, mem_data_out, 16#307#, x"72000000");
        check_word(mem_addr, mem_data_out, 16#308#, x"4D440000");
        check_word(mem_addr, mem_data_out, 16#309#, x"35000000");
        check_word(mem_addr, mem_data_out, 16#30A#, x"88540200");
        check_word(mem_addr, mem_data_out, 16#30B#, x"88340201");
        check_word(mem_addr, mem_data_out, 16#30C#, x"83A00201");
        check_word(mem_addr, mem_data_out, 16#30D#, x"84A00200");
        check_word(mem_addr, mem_data_out, 16#30E#, x"4D8C0000");
        check_word(mem_addr, mem_data_out, 16#30F#, x"35000000");
        check_word(mem_addr, mem_data_out, 16#310#, x"32000000");
        check_word(mem_addr, mem_data_out, 16#311#, x"88880200");
        check_word(mem_addr, mem_data_out, 16#312#, x"83A00201");
        check_word(mem_addr, mem_data_out, 16#313#, x"82600200");
        check_word(mem_addr, mem_data_out, 16#314#, x"4A4C0000");
        check_word(mem_addr, mem_data_out, 16#315#, x"08000000");

        report "Memory program hex image loaded correctly" severity note;
        wait;
    end process;
end architecture;
