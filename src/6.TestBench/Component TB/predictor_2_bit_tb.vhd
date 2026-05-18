LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE std.textio.ALL;
USE ieee.std_logic_textio.ALL;

-- Testbench block: drives this module with simulation inputs and checks the expected behavior.
ENTITY predictor_2_bit_tb IS
END ENTITY predictor_2_bit_tb;

-- Architecture block: contains the internal signals, instances, and logic for this entity.
ARCHITECTURE testbench OF predictor_2_bit_tb IS


    -- Declarations block: names the internal wires, storage, constants, and submodules used below.
    SIGNAL clk : STD_LOGIC;
    SIGNAL rst : STD_LOGIC;
    SIGNAL prev_prediction : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL is_conditional_branch : STD_LOGIC;
    SIGNAL predicted_taken : STD_LOGIC;


    SIGNAL test_count : INTEGER := 0;
    SIGNAL pass_count : INTEGER := 0;
    SIGNAL fail_count : INTEGER := 0;


    CONSTANT CLK_PERIOD : TIME := 100 ns;

BEGIN




    -- Instance block: connects this submodule to the surrounding signals.
    dut : ENTITY work.predictor_2_bit
        PORT MAP(
            clk => clk,
            rst => rst,
            prev_prediction => prev_prediction,
            is_conditional_branch => is_conditional_branch,
            predicted_taken => predicted_taken
        );




    -- Process block: describes behavior that runs when its sensitivity signals change or a clock edge occurs.
    clock_gen : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR CLK_PERIOD / 2;
        clk <= '1';
        WAIT FOR CLK_PERIOD / 2;
    END PROCESS;



    -- Process block: describes behavior that runs when its sensitivity signals change or a clock edge occurs.
    PROCESS
        VARIABLE line_out : line;
        VARIABLE expected : STD_LOGIC;
    BEGIN


        write(line_out, STRING'("================================================================================"));
        writeline(output, line_out);
        write(line_out, STRING'("2-BIT BRANCH PREDICTOR TESTBENCH - SEQUENTIAL TRAVERSAL"));
        writeline(output, line_out);
        write(line_out, STRING'("================================================================================"));
        writeline(output, line_out);
        writeline(output, line_out);




        write(line_out, STRING'("[TEST 1] RESET - Initialize to 00 (Strong Predict Not Taken)"));
        writeline(output, line_out);
        rst <= '1';
        prev_prediction <= "00";
        is_conditional_branch <= '1';
        WAIT UNTIL rising_edge(clk);
        WAIT UNTIL rising_edge(clk);

        test_count <= test_count + 1;
        expected := '0';
        IF predicted_taken = expected THEN
            write(line_out, STRING'("  PASS: Reset successful, state = 00, predicted_taken = 0"));
            pass_count <= pass_count + 1;
        ELSE
            write(line_out, STRING'("  FAIL: Reset failed, expected 0, got "));
            write(line_out, predicted_taken);
            fail_count <= fail_count + 1;
        END IF;
        writeline(output, line_out);
        writeline(output, line_out);

        rst <= '0';






        write(line_out, STRING'("[TEST 2] 00 + Taken (10)
        writeline(output, line_out);
        write(line_out, STRING'("  Current state: 00, sending feedback: 10 (branch was taken)"));
        writeline(output, line_out);
        prev_prediction <= "10";
        WAIT UNTIL rising_edge(clk);
        test_count <= test_count + 1;
        expected := '0';
        IF predicted_taken = expected THEN
            write(line_out, STRING'("  PASS: Now in state 01, predicted_taken = 0"));
            pass_count <= pass_count + 1;
        ELSE
            write(line_out, STRING'("  FAIL: Expected 0, got "));
            write(line_out, predicted_taken);
            fail_count <= fail_count + 1;
        END IF;
        writeline(output, line_out);
        writeline(output, line_out);




        write(line_out, STRING'("[TEST 3] 01 + NOT Taken (01)
        writeline(output, line_out);
        write(line_out, STRING'("  Current state: 01, sending feedback: 01 (branch NOT taken)"));
        writeline(output, line_out);
        prev_prediction <= "01";
        WAIT UNTIL rising_edge(clk);
        test_count <= test_count + 1;
        expected := '0';
        IF predicted_taken = expected THEN
            write(line_out, STRING'("  PASS: Back in state 00, predicted_taken = 0"));
            pass_count <= pass_count + 1;
        ELSE
            write(line_out, STRING'("  FAIL: Expected 0, got "));
            write(line_out, predicted_taken);
            fail_count <= fail_count + 1;
        END IF;
        writeline(output, line_out);
        writeline(output, line_out);




        write(line_out, STRING'("[TEST 4] 00 + NOT Taken (01)
        writeline(output, line_out);
        write(line_out, STRING'("  Current state: 00, sending feedback: 01 (branch NOT taken)"));
        writeline(output, line_out);
        prev_prediction <= "01";
        WAIT UNTIL rising_edge(clk);
        test_count <= test_count + 1;
        expected := '0';
        IF predicted_taken = expected THEN
            write(line_out, STRING'("  PASS: Stayed in state 00, predicted_taken = 0"));
            pass_count <= pass_count + 1;
        ELSE
            write(line_out, STRING'("  FAIL: Expected 0, got "));
            write(line_out, predicted_taken);
            fail_count <= fail_count + 1;
        END IF;
        writeline(output, line_out);
        writeline(output, line_out);




        write(line_out, STRING'("[TEST 5] 00 + Taken (10)
        writeline(output, line_out);
        write(line_out, STRING'("  Current state: 00, sending feedback: 10 (branch WAS taken)"));
        writeline(output, line_out);
        prev_prediction <= "10";
        WAIT UNTIL rising_edge(clk);
        test_count <= test_count + 1;
        expected := '0';
        IF predicted_taken = expected THEN
            write(line_out, STRING'("  PASS: Now in state 01, predicted_taken = 0"));
            pass_count <= pass_count + 1;
        ELSE
            write(line_out, STRING'("  FAIL: Expected 0, got "));
            write(line_out, predicted_taken);
            fail_count <= fail_count + 1;
        END IF;
        writeline(output, line_out);
        writeline(output, line_out);




        write(line_out, STRING'("[TEST 6] 01 + Taken (10)
        writeline(output, line_out);
        write(line_out, STRING'("  Current state: 01, sending feedback: 10 (branch WAS taken)"));
        writeline(output, line_out);
        prev_prediction <= "10";
        WAIT UNTIL rising_edge(clk);
        test_count <= test_count + 1;
        expected := '1';
        IF predicted_taken = expected THEN
            write(line_out, STRING'("  PASS: Now in state 11, predicted_taken = 1"));
            pass_count <= pass_count + 1;
        ELSE
            write(line_out, STRING'("  FAIL: Expected 1, got "));
            write(line_out, predicted_taken);
            fail_count <= fail_count + 1;
        END IF;
        writeline(output, line_out);
        writeline(output, line_out);




        write(line_out, STRING'("[TEST 7] 11 + Taken (10)
        writeline(output, line_out);
        write(line_out, STRING'("  Current state: 11, sending feedback: 10 (branch WAS taken)"));
        writeline(output, line_out);
        prev_prediction <= "10";
        WAIT UNTIL rising_edge(clk);
        test_count <= test_count + 1;
        expected := '1';
        IF predicted_taken = expected THEN
            write(line_out, STRING'("  PASS: Stayed in state 11, predicted_taken = 1"));
            pass_count <= pass_count + 1;
        ELSE
            write(line_out, STRING'("  FAIL: Expected 1, got "));
            write(line_out, predicted_taken);
            fail_count <= fail_count + 1;
        END IF;
        writeline(output, line_out);
        writeline(output, line_out);




        write(line_out, STRING'("[TEST 8] 11 + NOT Taken (01)
        writeline(output, line_out);
        write(line_out, STRING'("  Current state: 11, sending feedback: 01 (branch NOT taken)"));
        writeline(output, line_out);
        prev_prediction <= "01";
        WAIT UNTIL rising_edge(clk);
        test_count <= test_count + 1;
        expected := '1';
        IF predicted_taken = expected THEN
            write(line_out, STRING'("  PASS: Now in state 10, predicted_taken = 1"));
            pass_count <= pass_count + 1;
        ELSE
            write(line_out, STRING'("  FAIL: Expected 1, got "));
            write(line_out, predicted_taken);
            fail_count <= fail_count + 1;
        END IF;
        writeline(output, line_out);
        writeline(output, line_out);




        write(line_out, STRING'("[TEST 9] 10 + Taken (10)
        writeline(output, line_out);
        write(line_out, STRING'("  Current state: 10, sending feedback: 10 (branch WAS taken)"));
        writeline(output, line_out);
        prev_prediction <= "10";
        WAIT UNTIL rising_edge(clk);
        test_count <= test_count + 1;
        expected := '1';
        IF predicted_taken = expected THEN
            write(line_out, STRING'("  PASS: Now in state 11, predicted_taken = 1"));
            pass_count <= pass_count + 1;
        ELSE
            write(line_out, STRING'("  FAIL: Expected 1, got "));
            write(line_out, predicted_taken);
            fail_count <= fail_count + 1;
        END IF;
        writeline(output, line_out);
        writeline(output, line_out);




        write(line_out, STRING'("[TEST 10] 11 + NOT Taken (01)
        writeline(output, line_out);
        write(line_out, STRING'("  Current state: 11, sending feedback: 01 (branch NOT taken)"));
        writeline(output, line_out);
        prev_prediction <= "01";
        WAIT UNTIL rising_edge(clk);
        test_count <= test_count + 1;
        expected := '1';
        IF predicted_taken = expected THEN
            write(line_out, STRING'("  PASS: Now in state 10, predicted_taken = 1"));
            pass_count <= pass_count + 1;
        ELSE
            write(line_out, STRING'("  FAIL: Expected 1, got "));
            write(line_out, predicted_taken);
            fail_count <= fail_count + 1;
        END IF;
        writeline(output, line_out);
        writeline(output, line_out);




        write(line_out, STRING'("[TEST 11] 10 + NOT Taken (01)
        writeline(output, line_out);
        write(line_out, STRING'("  Current state: 10, sending feedback: 01 (branch NOT taken)"));
        writeline(output, line_out);
        prev_prediction <= "01";
        WAIT UNTIL rising_edge(clk);
        test_count <= test_count + 1;
        expected := '0';
        IF predicted_taken = expected THEN
            write(line_out, STRING'("  PASS: Now in state 00, predicted_taken = 0"));
            pass_count <= pass_count + 1;
        ELSE
            write(line_out, STRING'("  FAIL: Expected 0, got "));
            write(line_out, predicted_taken);
            fail_count <= fail_count + 1;
        END IF;
        writeline(output, line_out);
        writeline(output, line_out);




        write(line_out, STRING'("[TEST 12] 00 + Ignore (00)
        writeline(output, line_out);
        write(line_out, STRING'("  Current state: 00, sending feedback: 00 (ignore, no update)"));
        writeline(output, line_out);
        prev_prediction <= "00";
        WAIT UNTIL rising_edge(clk);
        test_count <= test_count + 1;
        expected := '0';
        IF predicted_taken = expected THEN
            write(line_out, STRING'("  PASS: Stayed in state 00, predicted_taken = 0"));
            pass_count <= pass_count + 1;
        ELSE
            write(line_out, STRING'("  FAIL: Expected 0, got "));
            write(line_out, predicted_taken);
            fail_count <= fail_count + 1;
        END IF;
        writeline(output, line_out);
        writeline(output, line_out);




        write(line_out, STRING'("[TEST 13] 00 + Ignore (11)
        writeline(output, line_out);
        write(line_out, STRING'("  Current state: 00, sending feedback: 11 (ignore, no update)"));
        writeline(output, line_out);
        prev_prediction <= "11";
        WAIT UNTIL rising_edge(clk);
        test_count <= test_count + 1;
        expected := '0';
        IF predicted_taken = expected THEN
            write(line_out, STRING'("  PASS: Stayed in state 00, predicted_taken = 0"));
            pass_count <= pass_count + 1;
        ELSE
            write(line_out, STRING'("  FAIL: Expected 0, got "));
            write(line_out, predicted_taken);
            fail_count <= fail_count + 1;
        END IF;
        writeline(output, line_out);
        writeline(output, line_out);





        write(line_out, STRING'("[SETUP] Going back to state 11 for conditional branch test"));
        writeline(output, line_out);
        prev_prediction <= "10";
        WAIT UNTIL rising_edge(clk);
        prev_prediction <= "10";
        WAIT UNTIL rising_edge(clk);
        writeline(output, line_out);

        write(line_out, STRING'("[TEST 14] State 11 + is_conditional_branch = 0
        writeline(output, line_out);
        write(line_out, STRING'("  Current state: 11, but is_conditional_branch=0"));
        writeline(output, line_out);
        is_conditional_branch <= '0';
        WAIT UNTIL rising_edge(clk);
        test_count <= test_count + 1;
        expected := '0';
        IF predicted_taken = expected THEN
            write(line_out, STRING'("  PASS: Output 0 when is_conditional_branch=0"));
            pass_count <= pass_count + 1;
        ELSE
            write(line_out, STRING'("  FAIL: Expected 0, got "));
            write(line_out, predicted_taken);
            fail_count <= fail_count + 1;
        END IF;
        writeline(output, line_out);
        writeline(output, line_out);




        write(line_out, STRING'("[TEST 15] State 11 + is_conditional_branch = 1
        writeline(output, line_out);
        write(line_out, STRING'("  Current state: 11, is_conditional_branch=1"));
        writeline(output, line_out);
        is_conditional_branch <= '1';
        WAIT UNTIL rising_edge(clk);
        test_count <= test_count + 1;
        expected := '1';
        IF predicted_taken = expected THEN
            write(line_out, STRING'("  PASS: Output 1 when state=11 and is_conditional_branch=1"));
            pass_count <= pass_count + 1;
        ELSE
            write(line_out, STRING'("  FAIL: Expected 1, got "));
            write(line_out, predicted_taken);
            fail_count <= fail_count + 1;
        END IF;
        writeline(output, line_out);
        writeline(output, line_out);




        write(line_out, STRING'("================================================================================"));
        writeline(output, line_out);
        write(line_out, STRING'("TEST SUMMARY"));
        writeline(output, line_out);
        write(line_out, STRING'("================================================================================"));
        writeline(output, line_out);
        write(line_out, STRING'("Total Tests: "));
        write(line_out, test_count);
        writeline(output, line_out);
        write(line_out, STRING'("Passed:      "));
        write(line_out, pass_count);
        writeline(output, line_out);
        write(line_out, STRING'("Failed:      "));
        write(line_out, fail_count);
        writeline(output, line_out);
        write(line_out, STRING'("================================================================================"));
        writeline(output, line_out);

        IF fail_count = 0 THEN
            write(line_out, STRING'("ALL TESTS PASSED!"));
        ELSE
            write(line_out, STRING'("SOME TESTS FAILED!"));
        END IF;
        writeline(output, line_out);
        write(line_out, STRING'("================================================================================"));
        writeline(output, line_out);

        WAIT;
    END PROCESS;

END ARCHITECTURE testbench;
