library ieee;
use ieee.std_logic_1164.all;

entity sign_extend is
    port (
        imm_16bit : in std_logic_vector(15 downto 0);
        imm_32bit : out std_logic_vector(31 downto 0)
    );
end sign_extend;

architecture se_rtl of sign_extend is
begin
    imm_32bit(31 downto 16) <= (others => imm_16bit(15));
    imm_32bit(15 downto 0) <= imm_16bit;
end se_rtl;
