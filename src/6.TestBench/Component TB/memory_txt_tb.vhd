library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Testbench block: drives this module with simulation inputs and checks the expected behavior.
entity ta_memory_tb is
end entity;

-- Architecture block: contains the internal signals, instances, and logic for this entity.
architecture behavior of ta_memory_tb is
    -- Declarations block: names the internal wires, storage, constants, and submodules used below.
    component top_level is
        port (
            clk            : in  std_logic;
            rst            : in  std_logic;
            interrupt      : in  std_logic;
            input_port     : in  std_logic_vector(31 downto 0);
            output_port    : out std_logic_vector(31 downto 0);
            fetch_pc_debug : out std_logic_vector(11 downto 0);
            core_enable    : out std_logic
        );
    end component;

    signal clk             : std_logic := '0';
    signal rst             : std_logic := '1';
    signal interrupt       : std_logic := '0';
    signal input_port      : std_logic_vector(31 downto 0) := (others => '0');
    signal output_port     : std_logic_vector(31 downto 0);
    signal fetch_pc_debug  : std_logic_vector(11 downto 0);
    signal core_enable     : std_logic;
    signal pass_index_seen : integer := 0;
    signal saw_failure     : boolean := false;

    constant CLK_PERIOD : time := 10 ns;

    type input_mem_t is array (0 to 4095) of std_logic_vector(31 downto 0);

    impure function load_input_mem(filename : string) return input_mem_t is
        use ieee.std_logic_textio.all;
        use std.textio.all;
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
            clk            => clk,
            rst            => rst,
            interrupt      => interrupt,
            input_port     => input_port,
            output_port    => output_port,
            fetch_pc_debug => fetch_pc_debug,
            core_enable    => core_enable
        );

    input_port <= input_values(to_integer(unsigned(fetch_pc_debug)));

    -- Process block: describes behavior that runs when its sensitivity signals change or a clock edge occurs.
    clk_process : process
    begin
        clk <= '0';
        wait for CLK_PERIOD / 2;
        clk <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    -- Process block: describes behavior that runs when its sensitivity signals change or a clock edge occurs.
    stim_proc : process
    begin
        rst <= '1';
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        rst <= '0';

        wait for 4 us;

        assert saw_failure = false
            report "TA memory test saw a wrong output marker/order"
            severity error;

        assert pass_index_seen = 5
            report "TA memory test did not observe all expected OUT values"
            severity error;

        if saw_failure = false and pass_index_seen = 5 then
            assert false report "TA memory outputs observed in order" severity note;
        end if;

        wait;
    end process;

    -- Process block: describes behavior that runs when its sensitivity signals change or a clock edge occurs.
    monitor_proc : process
        variable last_output : std_logic_vector(31 downto 0) := (others => '0');
        variable pass_index  : integer := 0;
    begin
        wait until rising_edge(clk);

        if rst = '1' then
            last_output := (others => '0');
            pass_index := 0;
            pass_index_seen <= 0;
            saw_failure <= false;
        elsif output_port /= last_output then
            last_output := output_port;

            -- Case block: chooses behavior for the current operation/control value.
            case output_port is
                when x"00000019" =>
                    if pass_index = 0 then
                        pass_index := 1;
                        pass_index_seen <= 1;
                    elsif pass_index = 2 then
                        pass_index := 3;
                        pass_index_seen <= 3;
                    else
                        saw_failure <= true;
                        assert false report "Unexpected memory output/order at 0x00000019" severity error;
                    end if;
                when x"0000001E" =>
                    if pass_index = 1 then
                        pass_index := 2;
                        pass_index_seen <= 2;
                    else
                        saw_failure <= true;
                        assert false report "Unexpected memory output/order at 0x0000001E" severity error;
                    end if;
                when x"00000010" =>
                    if pass_index /= 4 then
                        saw_failure <= true;
                        assert false report "Unexpected memory output/order at 0x00000010" severity error;
                    end if;
                    pass_index := 5;
                    pass_index_seen <= 5;
                when x"00000005" =>
                    if pass_index /= 3 then
                        saw_failure <= true;
                        assert false report "Unexpected memory output/order at 0x00000005" severity error;
                    end if;
                    pass_index := 4;
                    pass_index_seen <= 4;
                when others =>
                    null;
            end case;
        end if;
    end process;
end architecture;
