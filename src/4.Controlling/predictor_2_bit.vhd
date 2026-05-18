LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- 2-bit branch predictor: predicts conditional branch direction using a small saturating state machine.
ENTITY predictor_2_bit IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        prev_prediction : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        is_conditional_branch : IN STD_LOGIC;
        predicted_taken : OUT STD_LOGIC
    );
END ENTITY predictor_2_bit;

-- Architecture block: contains the internal signals, instances, and logic for this entity.
ARCHITECTURE rtl OF predictor_2_bit IS


    -- Declarations block: names the internal wires, storage, constants, and submodules used below.
    SIGNAL state : STD_LOGIC_VECTOR(1 DOWNTO 0);

BEGIN



    -- Process block: describes behavior that runs when its sensitivity signals change or a clock edge occurs.
    PROCESS (clk, rst)
        VARIABLE next_state : STD_LOGIC_VECTOR(1 DOWNTO 0);
    BEGIN
        IF rst = '1' THEN

            state <= "00";
        ELSIF falling_edge(clk) THEN

            next_state := state;


            IF prev_prediction = "01" OR prev_prediction = "10" THEN
                -- Case block: chooses behavior for the current operation/control value.
                CASE state IS

                    WHEN "11" =>
                        IF prev_prediction = "10" THEN

                            next_state := "11";
                        ELSE

                            next_state := "10";
                        END IF;


                    WHEN "10" =>
                        IF prev_prediction = "10" THEN

                            next_state := "11";
                        ELSE

                            next_state := "00";
                        END IF;


                    WHEN "01" =>
                        IF prev_prediction = "10" THEN

                            next_state := "11";
                        ELSE

                            next_state := "00";
                        END IF;


                    WHEN "00" =>
                        IF prev_prediction = "10" THEN

                            next_state := "01";
                        ELSE

                            next_state := "00";
                        END IF;

                    WHEN OTHERS =>
                        next_state := "00";
                END CASE;
            END IF;


            state <= next_state;
        END IF;
    END PROCESS;


    predicted_taken <= '1' WHEN (is_conditional_branch = '1' AND (state = "11" OR state = "10"))
        ELSE
        '0';

END ARCHITECTURE rtl;
