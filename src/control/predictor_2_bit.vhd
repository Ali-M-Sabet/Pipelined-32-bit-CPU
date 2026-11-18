library ieee;
use ieee.std_logic_1164.all;

-- Two-bit predictor. Feedback 10 means taken; 01 means not taken; other values hold.
entity predictor_2_bit is
    port (
        clk : in std_logic;
        rst : in std_logic;
        prev_prediction : in std_logic_vector(1 downto 0);
        is_conditional_branch : in std_logic;
        predicted_taken : out std_logic
    );
end entity predictor_2_bit;

architecture rtl of predictor_2_bit is
    signal state : std_logic_vector(1 downto 0);
begin
    process (clk, rst)
    begin
        if rst = '1' then
            state <= "00";
        elsif falling_edge(clk) then
            if prev_prediction = "10" then
                case state is
                    when "00" => state <= "01";
                    when "01" | "10" | "11" => state <= "11";
                    when others => state <= "00";
                end case;
            elsif prev_prediction = "01" then
                case state is
                    when "11" => state <= "10";
                    when others => state <= "00";
                end case;
            end if;
        end if;
    end process;

    predicted_taken <= '1' when (is_conditional_branch = '1' and (state = "11" or state = "10"))
        else
        '0';
end architecture rtl;
