library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

-- Testbench block: drives this module with simulation inputs and checks the expected behavior.
entity top_level_tb is
end top_level_tb;

-- Architecture block: contains the internal signals, instances, and logic for this entity.
architecture behavior of top_level_tb is

    -- Declarations block: names the internal wires, storage, constants, and submodules used below.
    component top_level is
        port (
            clk         : in  std_logic;
            rst         : in  std_logic;
            interrupt   : in  std_logic;
            input_port  : in  std_logic_vector(31 downto 0);
            output_port : out std_logic_vector(31 downto 0);
            fetch_pc_debug : out std_logic_vector(11 downto 0);
            core_enable : out std_logic
        );
    end component;

    signal clk         : std_logic := '0';
    signal rst         : std_logic := '0';
    signal interrupt   : std_logic := '0';
    signal input_port  : std_logic_vector(31 downto 0) := (others => '0');

    signal output_port : std_logic_vector(31 downto 0);
    signal fetch_pc_debug : std_logic_vector(11 downto 0);
    signal core_enable : std_logic;

    constant CLK_PERIOD : time := 10 ns;

    type input_mem_t is array (0 to 4095) of std_logic_vector(31 downto 0);

    impure function load_input_mem(filename : string) return input_mem_t is
        file     f      : text;
        variable status : file_open_status;
        variable l      : line;
        variable mem    : input_mem_t := (others => (others => '0'));
        variable word   : std_logic_vector(31 downto 0);
        variable i      : integer := 0;
    begin
        file_open(status, f, filename, read_mode);
        if status = open_ok then
            while not endfile(f) and i <= 4095 loop
                readline(f, l);
                if l'length > 0 then
                    hread(l, word);
                    mem(i) := word;
                    i := i + 1;
                end if;
            end loop;
            file_close(f);
        end if;
        return mem;
    end function;

    signal input_values : input_mem_t := load_input_mem("input.mem");

begin

    uut : top_level
        port map (
            clk         => clk,
            rst         => rst,
            interrupt   => interrupt,
            input_port  => input_port,
            output_port => output_port,
            fetch_pc_debug => fetch_pc_debug,
            core_enable => core_enable
        );

    input_port <= input_values(to_integer(unsigned(fetch_pc_debug)));

    -- Process block: describes behavior that runs when its sensitivity signals change or a clock edge occurs.
    clk_process : process
    begin
        clk <= '0'; wait for CLK_PERIOD / 2;
        clk <= '1'; wait for CLK_PERIOD / 2;
    end process;

    -- Process block: describes behavior that runs when its sensitivity signals change or a clock edge occurs.
    stim_proc : process
    begin

        rst <= '1';
        wait until rising_edge(clk);
        rst <= '0';

        for i in 0 to 30 loop
            wait until rising_edge(clk);
        end loop;

        for i in 0 to 23 loop
            wait until rising_edge(clk);
        end loop;

        wait;
    end process;

end behavior;
