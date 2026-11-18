library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Flags: carry, negative, zero.
entity alu is
    port (
        operand1 : in std_logic_vector(31 downto 0);
        operand2 : in std_logic_vector(31 downto 0);
        alu_op : in std_logic_vector(3 downto 0);
        alu_result : out std_logic_vector(31 downto 0);
        alu_flags : out std_logic_vector(2 downto 0)
    );
end alu;

architecture behavioral of alu is
begin
    process (all)
        variable result : std_logic_vector(31 downto 0);
        variable carry : std_logic;
        variable zero : std_logic;
        variable result_33bit : unsigned(32 downto 0);
    begin
        carry := '0';
        result := (others => '0');

        case alu_op is

            when "0000" => -- ADD
                result_33bit := unsigned('0' & operand1) + unsigned('0' & operand2);
                result := std_logic_vector(result_33bit(31 downto 0));
                carry := result_33bit(32);

            when "0001" => -- SUB; carry means no borrow
                result_33bit := unsigned('0' & operand1) - unsigned('0' & operand2);
                result := std_logic_vector(result_33bit(31 downto 0));
                if unsigned(operand1) < unsigned(operand2) then
                    carry := '0';
                else
                    carry := '1';
                end if;

            when "0010" => -- AND
                result := operand1 and operand2;

            when "0011" => -- NOT
                result := not operand1;

            when "0100" => -- Increment
                result_33bit := unsigned('0' & operand1) + 1;
                result := std_logic_vector(result_33bit(31 downto 0));
                carry := result_33bit(32);

            when "0101" => -- Decrement
                result_33bit := unsigned('0' & operand1) - 1;
                result := std_logic_vector(result_33bit(31 downto 0));
                if unsigned(operand1) = to_unsigned(0, operand1'length) then
                    carry := '1';
                else
                    carry := '0';
                end if;

            when "0110" => -- Pass operand 1
                result := operand1;

            when "0111" => -- Pass operand 1 and set carry
                result := operand1;
                carry := '1';

            when others =>
                null;

        end case;

        if result = x"00000000" then
            zero := '1';
        else
            zero := '0';
        end if;

        alu_result <= result;
        alu_flags <= carry & result(31) & zero;
    end process;

end behavioral;
