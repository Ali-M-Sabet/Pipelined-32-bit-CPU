LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- Testbench block: drives this module with simulation inputs and checks the expected behavior.
ENTITY sign_extend_tb IS
END sign_extend_tb;

-- Architecture block: contains the internal signals, instances, and logic for this entity.
ARCHITECTURE behavioral OF sign_extend_tb IS

    -- Declarations block: names the internal wires, storage, constants, and submodules used below.
    COMPONENT sign_extend IS
        PORT (
            imm_16bit : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            imm_32bit : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL imm_16bit : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL imm_32bit : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN

    uut : sign_extend PORT MAP(
        imm_16bit => imm_16bit,
        imm_32bit => imm_32bit
    );

    -- Process block: describes behavior that runs when its sensitivity signals change or a clock edge occurs.
    PROCESS
    BEGIN

        imm_16bit <= x"00AB";
        WAIT FOR 10 ns;
        ASSERT imm_32bit = x"000000AB"
        REPORT "Test 1 FAILED: Expected 0x000000AB, got "

            SEVERITY error;
        REPORT "Test 1 PASSED: 0x00AB sign-extended to 0x000000AB (positive)";


        imm_16bit <= x"FF5B";
        WAIT FOR 10 ns;
        ASSERT imm_32bit = x"FFFFFF5B"
        REPORT "Test 2 FAILED: Expected 0xFFFFFF5B, got "

            SEVERITY error;
        REPORT "Test 2 PASSED: 0xFF5B sign-extended to 0xFFFFFF5B (negative)";


        imm_16bit <= x"0000";
        WAIT FOR 10 ns;
        ASSERT imm_32bit = x"00000000"
        REPORT "Test 3 FAILED"
            SEVERITY error;
        REPORT "Test 3 PASSED: 0x0000 sign-extended to 0x00000000 (zero)";


        imm_16bit <= x"FFFF";
        WAIT FOR 10 ns;
        ASSERT imm_32bit = x"FFFFFFFF"
        REPORT "Test 4 FAILED: Expected 0xFFFFFFFF, got "

            SEVERITY error;
        REPORT "Test 4 PASSED: 0xFFFF sign-extended to 0xFFFFFFFF (-1)";

        WAIT;
    END PROCESS;

END behavioral;
