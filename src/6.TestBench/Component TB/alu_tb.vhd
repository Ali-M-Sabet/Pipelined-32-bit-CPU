LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE std.textio.ALL;
USE ieee.std_logic_textio.ALL;

-- Empty testbench entity because this file drives the ALU internally.
ENTITY alu_tb IS
END alu_tb;

-- Architecture block: contains the internal signals, instances, and logic for this entity.
ARCHITECTURE behavioral OF alu_tb IS

    -- Signals connected to the ALU inputs and outputs.
    SIGNAL operand1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL operand2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL alu_op : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL alu_result : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL alu_flags : STD_LOGIC_VECTOR(2 DOWNTO 0);

    -- Easier names for the three ALU flags: zero, negative, and carry.
    SIGNAL z_flag : STD_LOGIC;
    SIGNAL n_flag : STD_LOGIC;
    SIGNAL c_flag : STD_LOGIC;

    -- Counters used to print the final test summary.
    SIGNAL test_count : INTEGER := 0;
    SIGNAL pass_count : INTEGER := 0;
    SIGNAL fail_count : INTEGER := 0;

BEGIN




    -- Device Under Test: this creates one ALU instance and connects it to the testbench signals.
    DUT : ENTITY work.ALU
        PORT MAP(
            operand1 => operand1,
            operand2 => operand2,
            alu_op => alu_op,
            alu_result => alu_result,
            alu_flags => alu_flags
        );


    -- Split the packed flags bus into individual readable flags.
    z_flag <= alu_flags(0);
    n_flag <= alu_flags(1);
    c_flag <= alu_flags(2);




    -- Main test process: runs once, applies all test vectors, prints results, then stops.
    PROCESS

        -- TextIO line buffer used when writing messages to the simulator console.
        VARIABLE L : line;


        -- Helper procedure for one ALU test case.
        -- It drives inputs, waits for the ALU output, compares against expected values,
        -- then prints PASS or FAIL and updates the counters.
        PROCEDURE test_alu (
            op1_val : STD_LOGIC_VECTOR(31 DOWNTO 0);
            op2_val : STD_LOGIC_VECTOR(31 DOWNTO 0);
            op : STD_LOGIC_VECTOR(2 DOWNTO 0);
            exp_res : STD_LOGIC_VECTOR(31 DOWNTO 0);
            exp_z : STD_LOGIC;
            exp_n : STD_LOGIC;
            exp_c : STD_LOGIC;
            test_name : STRING
        ) IS
        BEGIN

            -- Count every call to this procedure as one test.
            test_count <= test_count + 1;


            -- Apply this test's operands and operation code to the ALU.
            operand1 <= op1_val;
            operand2 <= op2_val;
            alu_op <= op;


            -- Give the combinational ALU time to produce its result in simulation.
            WAIT FOR 10 ns;


            -- Check both the result value and all three flags.
            IF (alu_result = exp_res AND
                z_flag = exp_z AND
                n_flag = exp_n AND
                c_flag = exp_c) THEN


                -- The actual output matched the expected output, so print a passing line.
                write(L, STRING'("[PASS] "));
                write(L, test_name);
                write(L, STRING'(" -> Result: 0x"));
                hwrite(L, alu_result);
                write(L, STRING'(" Flags[Z,N,C]="));
                write(L, z_flag);
                write(L, n_flag);
                write(L, c_flag);
                writeline(output, L);

                pass_count <= pass_count + 1;

            ELSE


                -- Something did not match, so print the expected values and the actual values.
                write(L, STRING'("[FAIL] "));
                write(L, test_name);
                writeline(output, L);

                write(L, STRING'("  Expected: 0x"));
                hwrite(L, exp_res);
                write(L, STRING'(" Flags[Z,N,C]="));
                write(L, exp_z);
                write(L, exp_n);
                write(L, exp_c);
                writeline(output, L);

                write(L, STRING'("  Got:      0x"));
                hwrite(L, alu_result);
                write(L, STRING'(" Flags[Z,N,C]="));
                write(L, z_flag);
                write(L, n_flag);
                write(L, c_flag);
                writeline(output, L);

                fail_count <= fail_count + 1;

            END IF;

        END PROCEDURE;

    BEGIN


        -- Test set 1: NOP should ignore operands and produce zero.
        write(output, STRING'(""));
        write(output, STRING'("======== TEST SET 1: NOP (000) ========"));
        writeline(output, L);


        test_alu(x"12345678", x"ABCDEF00", "000",
        x"00000000", '1', '0', '0',
        "NOP: basic (should zero out)");

        test_alu(x"FFFFFFFF", x"FFFFFFFF", "000",
        x"00000000", '1', '0', '0',
        "NOP: with all ones inputs");

        test_alu(x"7FFFFFFF", x"80000000", "000",
        x"00000000", '1', '0', '0',
        "NOP: ignores all operands");


        -- Test set 2: NOT flips every bit of operand1.
        write(output, STRING'(""));
        write(output, STRING'("======== TEST SET 2: NOT (001) ========"));
        writeline(output, L);


        test_alu(x"00000000", x"00000000", "001",
        x"FFFFFFFF", '0', '1', '0',
        "NOT(0): all bits set -> negative");


        test_alu(x"FFFFFFFF", x"FFFFFFFF", "001",
        x"00000000", '1', '0', '0',
        "NOT(all 1s): gives zero");


        test_alu(x"AAAAAAAA", x"55555555", "001",
        x"55555555", '0', '0', '0',
        "NOT(alternating pattern 1)");


        test_alu(x"55555555", x"AAAAAAAA", "001",
        x"AAAAAAAA", '0', '1', '0',
        "NOT(alternating pattern 2)");


        test_alu(x"00000001", x"12345678", "001",
        x"FFFFFFFE", '0', '1', '0',
        "NOT(1): flips all bits");


        test_alu(x"7FFFFFFF", x"00000000", "001",
        x"80000000", '0', '1', '0',
        "NOT(max positive): becomes negative");


        -- Test set 3: INC adds one to operand1 and checks wraparound/carry.
        write(output, STRING'(""));
        write(output, STRING'("======== TEST SET 3: INC (010) ========"));
        writeline(output, L);


        test_alu(x"00000005", x"FFFFFFFF", "010",
        x"00000006", '0', '0', '0',
        "INC(5) = 6: basic");


        test_alu(x"00000000", x"00000000", "010",
        x"00000001", '0', '0', '0',
        "INC(0) = 1: zero increment");


        test_alu(x"7FFFFFFF", x"00000000", "010",
        x"80000000", '0', '1', '0',
        "INC(max positive) = min negative: crosses sign");


        test_alu(x"FFFFFFFF", x"00000000", "010",
        x"00000000", '1', '0', '1',
        "INC(0xFFFFFFFF) overflows: C=1");


        test_alu(x"FFFFFFFE", x"00000000", "010",
        x"FFFFFFFF", '0', '1', '0',
        "INC(-2) = -1: stays negative");


        test_alu(x"80000000", x"00000000", "010",
        x"80000001", '0', '1', '0',
        "INC(min negative) stays negative");


        -- Test set 4: MOV copies operand1 to the result and ignores operand2.
        write(output, STRING'(""));
        write(output, STRING'("======== TEST SET 4: MOV (011) ========"));
        writeline(output, L);


        test_alu(x"12345678", x"ABCDEF00", "011",
        x"12345678", '0', '0', '0',
        "MOV: normal value");

        test_alu(x"00000000", x"FFFFFFFF", "011",
        x"00000000", '1', '0', '0',
        "MOV(0): operand2 ignored");

        test_alu(x"80000000", x"00000000", "011",
        x"80000000", '0', '1', '0',
        "MOV(min negative): sign preserved");

        test_alu(x"7FFFFFFF", x"7FFFFFFF", "011",
        x"7FFFFFFF", '0', '0', '0',
        "MOV(max positive): positive");

        test_alu(x"FFFFFFFF", x"00000000", "011",
        x"FFFFFFFF", '0', '1', '0',
        "MOV(-1): negative");


        -- Test set 5: ADD adds operand1 and operand2 and checks zero/negative/carry.
        write(output, STRING'(""));
        write(output, STRING'("======== TEST SET 5: ADD (100) ========"));
        writeline(output, L);


        test_alu(x"00000005", x"00000003", "100",
        x"00000008", '0', '0', '0',
        "ADD(5 + 3 = 8): basic");


        test_alu(x"00000000", x"00000000", "100",
        x"00000000", '1', '0', '0',
        "ADD(0 + 0 = 0): zero");


        test_alu(x"FFFFFFFF", x"00000001", "100",
        x"00000000", '1', '0', '1',
        "ADD(-1 + 1): unsigned overflow, C=1");


        test_alu(x"FFFFFFFF", x"FFFFFFFF", "100",
        x"FFFFFFFE", '0', '1', '1',
        "ADD(-1 + -1): negative, C=1");


        test_alu(x"7FFFFFFF", x"7FFFFFFF", "100",
        x"FFFFFFFE", '0', '1', '0',
        "ADD(max + max): no unsigned overflow, C=0");


        test_alu(x"80000000", x"80000000", "100",
        x"00000000", '1', '0', '1',
        "ADD(min + min): wraps to 0, C=1");


        test_alu(x"7FFFFFFF", x"80000000", "100",
        x"FFFFFFFF", '0', '1', '0',
        "ADD(max pos + min neg): gives -1");


        test_alu(x"40000000", x"40000000", "100",
        x"80000000", '0', '1', '0',
        "ADD(large + large): no unsigned overflow, C=0");


        test_alu(x"00000001", x"FFFFFFFF", "100",
        x"00000000", '1', '0', '1',
        "ADD(1 + -1 = 0): C=1 (unsigned overflow)");

        -- Test set 6: SUB subtracts operand2 from operand1 and checks borrow behavior.
        write(output, STRING'(""));
        write(output, STRING'("======== TEST SET 6: SUB (101) ========"));
        writeline(output, L);


        test_alu(x"0000000A", x"00000003", "101",
        x"00000007", '0', '0', '0',
        "SUB(10 - 3 = 7): basic");


        test_alu(x"00000005", x"00000005", "101",
        x"00000000", '1', '0', '0',
        "SUB(5 - 5 = 0): equal");


        test_alu(x"00000000", x"00000001", "101",
        x"FFFFFFFF", '0', '1', '1',
        "SUB(0 - 1 = -1): borrow, C=1");


        test_alu(x"00000001", x"00000002", "101",
        x"FFFFFFFF", '0', '1', '1',
        "SUB(1 - 2 = -1): borrow, C=1");


        test_alu(x"80000000", x"00000001", "101",
        x"7FFFFFFF", '0', '0', '0',
        "SUB(min - 1): no borrow in unsigned, C=0");


        test_alu(x"7FFFFFFF", x"80000000", "101",
        x"FFFFFFFF", '0', '1', '1',
        "SUB(max - min): unsigned borrow, C=1");


        test_alu(x"FFFFFFFF", x"FFFFFFFF", "101",
        x"00000000", '1', '0', '0',
        "SUB(-1 - (-1) = 0)");


        test_alu(x"00000000", x"80000000", "101",
        x"80000000", '0', '1', '1',
        "SUB(0 - min): gives min, borrow");


        test_alu(x"80000000", x"80000000", "101",
        x"00000000", '1', '0', '0',
        "SUB(min - min = 0)");


        test_alu(x"7FFFFFFF", x"00000001", "101",
        x"7FFFFFFE", '0', '0', '0',
        "SUB(max - 1): stays positive");

        -- Test set 7: AND performs bitwise AND between operand1 and operand2.
        write(output, STRING'(""));
        write(output, STRING'("======== TEST SET 7: AND (110) ========"));
        writeline(output, L);


        test_alu(x"FFFF0000", x"0FFF0000", "110",
        x"0FFF0000", '0', '0', '0',
        "AND(mask): keeps common bits");


        test_alu(x"FFFFFFFF", x"00000000", "110",
        x"00000000", '1', '0', '0',
        "AND(all 1s & all 0s = 0)");


        test_alu(x"AAAAAAAA", x"55555555", "110",
        x"00000000", '1', '0', '0',
        "AND(alternating patterns = 0)");


        test_alu(x"F0F0F0F0", x"F0F0F0F0", "110",
        x"F0F0F0F0", '0', '1', '0',
        "AND(same value): result negative");


        test_alu(x"12345678", x"87654321", "110",
        x"02244220", '0', '0', '0',
        "AND(random values)");


        test_alu(x"FFFFFFFF", x"FFFFFFFF", "110",
        x"FFFFFFFF", '0', '1', '0',
        "AND(all 1s & all 1s): stays -1");


        test_alu(x"80000000", x"FFFFFFFF", "110",
        x"80000000", '0', '1', '0',
        "AND(keeps sign bit)");


        -- Test set 8: PASS returns operand1 unchanged.
        write(output, STRING'(""));
        write(output, STRING'("======== TEST SET 8: PASS (111) ========"));
        writeline(output, L);


        test_alu(x"DEADBEEF", x"CAFEBABE", "111",
        x"DEADBEEF", '0', '1', '0',
        "PASS(random): operand2 ignored");

        test_alu(x"00000000", x"FFFFFFFF", "111",
        x"00000000", '1', '0', '0',
        "PASS(0): zero");

        test_alu(x"7FFFFFFF", x"00000000", "111",
        x"7FFFFFFF", '0', '0', '0',
        "PASS(max positive): positive");

        test_alu(x"80000000", x"00000000", "111",
        x"80000000", '0', '1', '0',
        "PASS(min negative): negative");

        test_alu(x"FFFFFFFF", x"00000000", "111",
        x"FFFFFFFF", '0', '1', '0',
        "PASS(-1): negative");


        WAIT FOR 10 ns;

        -- Print a final summary after all test cases have run.
        writeline(output, L);
        write(L, STRING'("========================================"));
        writeline(output, L);
        write(L, STRING'("TEST SUMMARY"));
        writeline(output, L);
        write(L, STRING'("========================================"));
        writeline(output, L);

        write(L, STRING'("Total Tests:  "));
        write(L, test_count);
        writeline(output, L);

        write(L, STRING'("Passed:       "));
        write(L, pass_count);
        writeline(output, L);

        write(L, STRING'("Failed:       "));
        write(L, fail_count);
        writeline(output, L);

        write(L, STRING'("========================================"));
        writeline(output, L);

        -- Decide whether the whole simulation passed based on the number of failed tests.
        IF fail_count = 0 THEN
            write(L, STRING'("[SUCCESS] ALL TESTS PASSED!"));
        ELSE
            write(L, STRING'("[FAILURE] SOME TESTS FAILED!"));
        END IF;
        writeline(output, L);

        write(L, STRING'("========================================"));
        writeline(output, L);

        -- Stop the process forever so the simulation does not restart the tests.
        WAIT;

    END PROCESS;

END behavioral;
