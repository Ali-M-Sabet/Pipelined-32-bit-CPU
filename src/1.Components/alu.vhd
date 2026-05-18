LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-- ALU block: performs arithmetic/logic operations and produces carry, negative, and zero flags.
ENTITY alu IS
    PORT (
        operand1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        operand2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        alu_op : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        alu_result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        alu_flags : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
END alu;

-- Architecture block: contains the internal signals, instances, and logic for this entity.
ARCHITECTURE behavioral OF alu IS
BEGIN

    -- Process block: describes behavior that runs when its sensitivity signals change or a clock edge occurs.
    PROCESS (operand1, operand2, alu_op)
        VARIABLE result : STD_LOGIC_VECTOR(31 DOWNTO 0);
        VARIABLE carry : STD_LOGIC;
        VARIABLE zero : STD_LOGIC;
        VARIABLE negative : STD_LOGIC;


        VARIABLE a : signed(31 DOWNTO 0);
        VARIABLE b : signed(31 DOWNTO 0);
        VARIABLE r : signed(31 DOWNTO 0);
        VARIABLE result_33bit : unsigned(32 DOWNTO 0);

    BEGIN

        a := signed(operand1);
        b := signed(operand2);


        carry := '0';
        zero := '0';
        negative := '0';
        result := (OTHERS => '0');



        -- Case block: chooses behavior for the current operation/control value.
        CASE alu_op IS

            WHEN "0000" =>
                result_33bit := unsigned('0' & operand1) + unsigned('0' & operand2);
                result := STD_LOGIC_VECTOR(result_33bit(31 DOWNTO 0));
                carry := result_33bit(32);

            WHEN "0001" =>
                result_33bit := unsigned('0' & operand1) - unsigned('0' & operand2);
                result := STD_LOGIC_VECTOR(result_33bit(31 DOWNTO 0));
                if unsigned(operand1) < unsigned(operand2) then
                    carry := '0';
                else
                    carry := '1';
                end if;

            WHEN "0010" =>
                result := operand1 AND operand2;
                carry := '0';

            WHEN "0011" =>
                result := NOT operand1;
                carry := '0';

            WHEN "0100" =>
                result_33bit := unsigned('0' & operand1) + 1;
                result := STD_LOGIC_VECTOR(result_33bit(31 DOWNTO 0));
                carry := result_33bit(32);

            WHEN "0101" =>
                result_33bit := unsigned('0' & operand1) - 1;
                result := STD_LOGIC_VECTOR(result_33bit(31 DOWNTO 0));
                if unsigned(operand1) = to_unsigned(0, operand1'length) then
                    carry := '1';
                else
                    carry := '0';
                end if;

            WHEN "0110" =>
                result := operand1;
                carry := '0';

            WHEN "0111" =>
                result := operand1;
                carry := '1';

            WHEN OTHERS =>
                result := (OTHERS => '0');
                carry := '0';

        END CASE;






        IF result = x"00000000" THEN
            zero := '1';
        ELSE
            zero := '0';
        END IF;


        negative := result(31);






        alu_result <= result;
        alu_flags <= carry & negative & zero;

    END PROCESS;

END behavioral;
