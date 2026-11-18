library ieee;
use ieee.std_logic_1164.all;

entity IFID is
    port (
        clk : in std_logic;
        flush : in std_logic;
        write_en : in std_logic;
        predicted_T : in std_logic;
        inst : in std_logic_vector(31 downto 0);
        input_port : in std_logic_vector(31 downto 0);
        pc : in std_logic_vector(11 downto 0);
        predicted_T_out : out std_logic := '0';
        inst_out : out std_logic_vector(31 downto 0) := (others => '0');
        input_port_out : out std_logic_vector(31 downto 0) := (others => '0');
        pc_out : out std_logic_vector(11 downto 0) := (others => '0')
    );
end entity;

architecture rtl of IFID is
begin
    -- Flush has priority over write_en.
    process (clk)
    begin
        if rising_edge(clk) then
            if flush = '1' then
                predicted_T_out <= '0';
                inst_out <= (others => '0');
                input_port_out <= (others => '0');
                pc_out <= (others => '0');
            elsif write_en = '1' then
                predicted_T_out <= predicted_T;
                inst_out <= inst;
                input_port_out <= input_port;
                pc_out <= pc;
            end if;
        end if;
    end process;
end rtl;
