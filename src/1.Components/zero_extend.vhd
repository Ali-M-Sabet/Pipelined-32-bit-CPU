LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- Zero extender: converts a 16-bit immediate into a 32-bit value by filling upper bits with zero.
ENTITY zero_extend IS
    PORT (

        imm_16bit : IN STD_LOGIC_VECTOR(15 DOWNTO 0);


        imm_32bit : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END zero_extend;

-- Architecture block: contains the internal signals, instances, and logic for this entity.
ARCHITECTURE ze_rtl OF zero_extend IS
BEGIN
    imm_32bit(31 DOWNTO 16) <= (OTHERS => '0');
    imm_32bit(15 DOWNTO 0) <= imm_16bit;
END ze_rtl;
