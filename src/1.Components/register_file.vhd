library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Register file: stores the CPU general-purpose registers and supports two write ports.
entity register_file is
    port (
        clk : in std_logic;
        rst : in std_logic;
        reg_write_en : in std_logic;
        reg_write_addr : in std_logic_vector(2 downto 0);
        reg_write_data : in std_logic_vector(31 downto 0);
        reg_write2_en : in std_logic;
        reg_write2_addr : in std_logic_vector(2 downto 0);
        reg_write2_data : in std_logic_vector(31 downto 0);
        reg_read_addr1 : in std_logic_vector(2 downto 0);
        reg_read_addr2 : in std_logic_vector(2 downto 0);
        reg_read_data1 : out std_logic_vector(31 downto 0);
        reg_read_data2 : out std_logic_vector(31 downto 0)
    );
end register_file;

-- Architecture block: contains the internal signals, instances, and logic for this entity.
architecture rtl of register_file is


    -- Declarations block: names the internal wires, storage, constants, and submodules used below.
    type reg_array is array (0 to 7) of std_logic_vector(31 downto 0);

    signal registers : reg_array := (others => (others => '0'));
    signal write_addr_int : integer range 0 to 7;
    signal write2_addr_int : integer range 0 to 7;
    signal read_addr1_int : integer range 0 to 7;
    signal read_addr2_int : integer range 0 to 7;

    begin

    write_addr_int <= to_integer(unsigned(reg_write_addr));
    write2_addr_int <= to_integer(unsigned(reg_write2_addr));
    read_addr1_int <= to_integer(unsigned(reg_read_addr1));
    read_addr2_int <= to_integer(unsigned(reg_read_addr2));
    -- Process block: describes behavior that runs when its sensitivity signals change or a clock edge occurs.
    process(clk, rst)
    begin

        if rst = '1' then
            registers <= (others => (others => '0'));
        elsif rising_edge(clk) then
            if reg_write_en = '1' then
                registers(write_addr_int) <= reg_write_data;
            end if;
            if reg_write2_en = '1' then
                registers(write2_addr_int) <= reg_write2_data;
            end if;
        end if;
    end process;

    reg_read_data1 <= reg_write2_data when(reg_write2_en = '1' and read_addr1_int = write2_addr_int) else
                        reg_write_data when(reg_write_en = '1' and read_addr1_int = write_addr_int) else
                        registers(read_addr1_int);


    reg_read_data2 <= reg_write2_data when(reg_write2_en = '1' and read_addr2_int = write2_addr_int) else
                        reg_write_data when(reg_write_en = '1' and read_addr2_int = write_addr_int) else
                        registers(read_addr2_int);


    end rtl;
