library ieee;
use ieee.std_logic_1164.all;

entity zero_extend is
    port (
        imm_16bit : in std_logic_vector(15 downto 0);
        imm_32bit : out std_logic_vector(31 downto 0)
    );
end zero_extend;

architecture ze_rtl of zero_extend is
begin
    imm_32bit(31 downto 16) <= (others => '0');
    imm_32bit(15 downto 0) <= imm_16bit;
end ze_rtl;
