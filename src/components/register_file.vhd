library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

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

architecture rtl of register_file is
    type reg_array is array (0 to 7) of std_logic_vector(31 downto 0);

    signal registers : reg_array := (others => (others => '0'));
begin
    process (clk, rst)
    begin
        if rst = '1' then
            registers <= (others => (others => '0'));
        elsif rising_edge(clk) then
            if reg_write_en = '1' then
                assert not is_x(reg_write_addr) report "Unknown register write address" severity failure;
                if not is_x(reg_write_addr) then
                    registers(to_integer(unsigned(reg_write_addr))) <= reg_write_data;
                end if;
            end if;
            -- Port two has priority when both writes select the same register.
            if reg_write2_en = '1' then
                assert not is_x(reg_write2_addr) report "Unknown second register write address" severity failure;
                if not is_x(reg_write2_addr) then
                    registers(to_integer(unsigned(reg_write2_addr))) <= reg_write2_data;
                end if;
            end if;
        end if;
    end process;

    reg_read_data1 <= reg_write2_data when(reg_write2_en = '1' and reg_read_addr1 = reg_write2_addr) else
        reg_write_data when(reg_write_en = '1' and reg_read_addr1 = reg_write_addr) else
        registers(to_integer(unsigned(reg_read_addr1))) when not is_x(reg_read_addr1) else
        (others => 'X');

    reg_read_data2 <= reg_write2_data when(reg_write2_en = '1' and reg_read_addr2 = reg_write2_addr) else
        reg_write_data when(reg_write_en = '1' and reg_read_addr2 = reg_write_addr) else
        registers(to_integer(unsigned(reg_read_addr2))) when not is_x(reg_read_addr2) else
        (others => 'X');
end rtl;
