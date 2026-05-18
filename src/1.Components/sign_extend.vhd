LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- Sign extender: converts a 16-bit signed immediate into a 32-bit signed value.
ENTITY sign_extend IS
    PORT (

        imm_16bit : IN STD_LOGIC_VECTOR(15 DOWNTO 0);


        imm_32bit : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END sign_extend;

-- Architecture block: contains the internal signals, instances, and logic for this entity.
ARCHITECTURE se_rtl OF sign_extend IS
BEGIN

    imm_32bit(31 DOWNTO 16) <= (OTHERS => imm_16bit(15));
    imm_32bit(15 DOWNTO 0) <= imm_16bit;
END se_rtl;
