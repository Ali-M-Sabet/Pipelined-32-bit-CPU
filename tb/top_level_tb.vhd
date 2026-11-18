library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity top_level_tb is
end top_level_tb;

architecture behavior of top_level_tb is
    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    signal interrupt : std_logic := '0';
    signal input_port : std_logic_vector(31 downto 0) := (others => '0');

    signal output_port : std_logic_vector(31 downto 0);
    signal fetch_pc_debug : std_logic_vector(11 downto 0);
    signal core_enable : std_logic;

    constant CLK_PERIOD : time := 10 ns;

    type input_mem_t is array (0 to 4095) of std_logic_vector(31 downto 0);

    impure function load_inputs return input_mem_t is
        file input_file : text open read_mode is "input.mem";
        variable line_buffer : line;
        variable words : input_mem_t := (others => (others => '0'));
        variable address : natural := 0;
    begin
        while not endfile(input_file) loop
            readline(input_file, line_buffer);
            if line_buffer'length > 0 then
                hread(line_buffer, words(address));
                address := address + 1;
            end if;
        end loop;
        return words;
    end function;

    constant input_values : input_mem_t := load_inputs;
begin
    uut : entity work.top_level
        port map (
            clk => clk,
            rst => rst,
            interrupt => interrupt,
            input_port => input_port,
            output_port => output_port,
            fetch_pc_debug => fetch_pc_debug,
            core_enable => core_enable
        );

    input_port <= input_values(to_integer(unsigned(fetch_pc_debug)))
        when not is_x(fetch_pc_debug) else (others => 'X');

    clk <= not clk after CLK_PERIOD / 2;

    stim_proc : process
    begin
        rst <= '1';
        wait until rising_edge(clk);
        rst <= '0';

        for i in 1 to 55 loop
            wait until rising_edge(clk);
        end loop;

        report "Completed: top-level smoke run";
        wait;
    end process;

end behavior;
