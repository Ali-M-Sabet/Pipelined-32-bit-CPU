library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity shared_memory is
    port (
        clk : in std_logic;
        mem_write_en : in std_logic;
        mem_addr : in std_logic_vector(11 downto 0);
        mem_data_in : in std_logic_vector(31 downto 0);
        mem_data_out : out std_logic_vector(31 downto 0);
        fetch_addr : in std_logic_vector(11 downto 0);
        fetch_data : out std_logic_vector(31 downto 0);
        reset_vector : out std_logic_vector(11 downto 0)
    );
end entity;

architecture rtl of shared_memory is
    type memory_t is array (0 to 4095) of std_logic_vector(31 downto 0);

    impure function load_program return memory_t is
        file program_file : text open read_mode is "program.mem";
        variable line_buffer : line;
        variable words : memory_t := (others => (others => '0'));
        variable address : natural := 0;
    begin
        while not endfile(program_file) loop
            readline(program_file, line_buffer);
            if line_buffer'length > 0 then
                hread(line_buffer, words(address));
                address := address + 1;
            end if;
        end loop;
        return words;
    end function;

    signal mem : memory_t := load_program;
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if mem_write_en = '1' then
                assert not is_x(mem_addr) report "Unknown memory write address" severity failure;
                if not is_x(mem_addr) then
                    mem(to_integer(unsigned(mem_addr))) <= mem_data_in;
                end if;
            end if;
        end if;
    end process;

    mem_data_out <= mem(to_integer(unsigned(mem_addr))) when not is_x(mem_addr) else (others => 'X');
    fetch_data <= mem(to_integer(unsigned(fetch_addr))) when not is_x(fetch_addr) else (others => 'X');
    reset_vector <= mem(0)(11 downto 0);
end rtl;

library ieee;
use ieee.std_logic_1164.all;

-- Single-port interface for memory unit tests.
entity memory is
    port (
        clk : in std_logic;
        mem_write_en : in std_logic;
        mem_addr : in std_logic_vector(11 downto 0);
        mem_data_in : in std_logic_vector(31 downto 0);
        mem_data_out : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of memory is
begin
    storage : entity work.shared_memory
        port map (
            clk => clk,
            mem_write_en => mem_write_en,
            mem_addr => mem_addr,
            mem_data_in => mem_data_in,
            mem_data_out => mem_data_out,
            fetch_addr => (others => '0'),
            fetch_data => open,
            reset_vector => open
        );
end architecture;
