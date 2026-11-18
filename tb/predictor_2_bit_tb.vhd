library ieee;
use ieee.std_logic_1164.all;

entity predictor_2_bit_tb is
end entity;

architecture test of predictor_2_bit_tb is
    signal clk : std_logic := '0';
    signal rst : std_logic := '1';
    signal outcome : std_logic_vector(1 downto 0) := "00";
    signal conditional : std_logic := '1';
    signal taken : std_logic;
begin
    clk <= not clk after 5 ns;
    dut : entity work.predictor_2_bit
        port map (clk => clk, rst => rst, prev_prediction => outcome,
            is_conditional_branch => conditional, predicted_taken => taken);

    process
        procedure update(value : std_logic_vector(1 downto 0);
                            expected : std_logic; description : string) is
        begin
            outcome <= value;
            wait until falling_edge(clk);
            wait for 1 ns;
            assert taken = expected report description severity failure;
        end procedure;
    begin
        wait for 1 ns;
        assert taken = '0' report "Reset prediction should be not taken" severity failure;
        rst <= '0';

        update("10", '0', "First taken outcome");
        update("01", '0', "Not taken cancels the first taken outcome");
        update("10", '0', "First taken outcome after cancellation");
        update("10", '1', "Second taken outcome");
        update("00", '1', "No feedback must preserve taken prediction");
        update("11", '1', "Reserved feedback must preserve the prediction");
        conditional <= '0';
        wait for 1 ns;
        assert taken = '0' report "Prediction must apply only to conditional branches" severity failure;
        conditional <= '1';
        update("01", '1', "First not-taken outcome from strong taken");
        update("10", '1', "Taken outcome restores strong taken");
        update("01", '1', "First not-taken outcome after retraining");
        update("01", '0', "Second not-taken outcome");
        update("01", '0', "Not-taken state saturates");
        report "PASS: predictor_2_bit_tb";
        wait;
    end process;
end architecture;
