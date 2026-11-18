library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity ta_one_operand_tb is end entity;

architecture test of ta_one_operand_tb is
    signal clk : std_logic := '0';
    signal rst : std_logic := '1';
    signal input_port : std_logic_vector(31 downto 0);
    signal output_port : std_logic_vector(31 downto 0);
    signal fetch_pc_debug : std_logic_vector(11 downto 0);
    signal core_enable : std_logic;

    type word_array is array (natural range <>) of std_logic_vector(31 downto 0);
    constant expected : word_array := (x"00000006", x"FFFFFFEF", x"FFFFFFF0");
    signal output_count : natural := 0;

    impure function load_inputs return word_array is
        file input_file : text open read_mode is "input.mem";
        variable line_buffer : line;
        variable words : word_array(0 to 4095) := (others => (others => '0'));
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

    constant input_values : word_array(0 to 4095) := load_inputs;
begin
    clk <= not clk after 5 ns;

    uut : entity work.top_level
        port map (clk => clk, rst => rst, interrupt => '0',
            input_port => input_port, output_port => output_port,
            fetch_pc_debug => fetch_pc_debug, core_enable => core_enable);

    -- Input values are indexed by fetch PC.
    input_port <= input_values(to_integer(unsigned(fetch_pc_debug)))
        when not is_x(fetch_pc_debug) else (others => 'X');

    process
    begin
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        rst <= '0';
        wait for 2 us;
        assert output_count = expected'length
            report "Missing one-operand program outputs" severity failure;
        report "PASS: one-operand program";
        wait;
    end process;

    process
        variable previous : std_logic_vector(31 downto 0) := (others => '0');
    begin
        wait until rising_edge(clk);
        if rst = '0' and output_port /= previous then
            assert output_count < expected'length
                report "Unexpected extra one-operand output" severity failure;
            assert output_port = expected(output_count)
                report "one-operand output " & integer'image(output_count) &
                        " expected " & to_hstring(expected(output_count)) &
                        ", got " & to_hstring(output_port) severity failure;
            previous := output_port;
            output_count <= output_count + 1;
        end if;
    end process;
end architecture;
