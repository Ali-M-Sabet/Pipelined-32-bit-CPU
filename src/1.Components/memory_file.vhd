library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

-- Memory block: stores 4096 32-bit words and loads the initial program from program.mem.
entity memory is
    port (
        clk          : in  std_logic;
        mem_write_en : in  std_logic;
        mem_addr     : in  std_logic_vector(11 downto 0);
        mem_data_in  : in  std_logic_vector(31 downto 0);
        mem_data_out : out std_logic_vector(31 downto 0)
    );
end entity;

-- Architecture block: contains the internal signals, instances, and logic for this entity.
architecture rtl of memory is

    -- Declarations block: names the internal wires, storage, constants, and submodules used below.
    type memory_t is array (0 to 4095) of std_logic_vector(31 downto 0);







    impure function load_mem(filename : string) return memory_t is
        file     f    : text open read_mode is filename;
        variable l    : line;
        variable mem  : memory_t := (others => (others => '0'));
        variable word : std_logic_vector(31 downto 0);
        variable i    : integer := 0;
    begin
        while not endfile(f) loop
            readline(f, l);

            if l'length > 0 then
                hread(l, word);
                mem(i) := word;
                i := i + 1;
            end if;
        end loop;
        return mem;
    end function;

    signal addr_int : integer range 0 to 4095;
    signal mem      : memory_t := load_mem("program.mem");

begin

    addr_int <= to_integer(unsigned(mem_addr));


    -- Process block: describes behavior that runs when its sensitivity signals change or a clock edge occurs.
    process(clk)
    begin
        if rising_edge(clk) then
            if mem_write_en = '1' then
                mem(addr_int) <= mem_data_in;
            end if;
        end if;
    end process;


    mem_data_out <= mem(addr_int);

end rtl;
