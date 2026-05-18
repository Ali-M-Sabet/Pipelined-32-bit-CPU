LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-- Control unit: converts each opcode into the control signals needed by the pipeline.
ENTITY control_unit IS
    PORT (
        opcode : IN STD_LOGIC_VECTOR(5 DOWNTO 0);

        alu_src : OUT STD_LOGIC;
        alu_op : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        ccr_sel : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        mod_fl : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        branch_op : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);

        newSP_sel : OUT STD_LOGIC;
        SP_WE : OUT STD_LOGIC;
        add_sel : OUT STD_LOGIC;

        mem_addr_sel : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        mem_data_sel : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        mem_we : OUT STD_LOGIC;
        mem_r : OUT STD_LOGIC;

        reg_data : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        reg_we : OUT STD_LOGIC;

        ret : OUT STD_LOGIC;
        int_state : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);

        is_load : OUT STD_LOGIC;
        swap_state : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        swap_reg_enable : OUT STD_LOGIC;

        hlt : OUT STD_LOGIC;
        out_enable : OUT STD_LOGIC
    );
END control_unit;

-- Architecture block: contains the internal signals, instances, and logic for this entity.
ARCHITECTURE behavioral OF control_unit IS
BEGIN

    -- Process block: describes behavior that runs when its sensitivity signals change or a clock edge occurs.
    PROCESS (opcode)
    BEGIN


        alu_src <= '0';
        alu_op <= "0000";
        ccr_sel <= "000";
        mod_fl <= "000";
        branch_op <= "0000";

        newSP_sel <= '0';
        SP_WE <= '0';
        add_sel <= '0';

        mem_addr_sel <= "000";
        mem_data_sel <= "00";
        mem_we <= '0';
        mem_r <= '0';

        reg_data <= "000";
        reg_we <= '0';

        ret <= '0';
        int_state <= "00";

        is_load <= '0';
        swap_state <= "00";
        swap_reg_enable <= '0';

        hlt <= '0';
        out_enable <= '0';




        -- Case block: chooses behavior for the current operation/control value.
        CASE opcode IS


            WHEN "000000" =>
                NULL;


            WHEN "000001" =>
                hlt <= '1';


            WHEN "000010" =>
                alu_op <= "0111";
                ccr_sel <= "011";


            WHEN "000011" =>
                alu_op <= "0011";
                ccr_sel <= "100";
                reg_data <= "011";
                reg_we <= '1';


            WHEN "000100" =>
                alu_op <= "0100";
                ccr_sel <= "111";
                reg_data <= "011";
                reg_we <= '1';


            WHEN "000101" =>
                out_enable <= '1';
                alu_op <= "0110";


            WHEN "000110" =>
                reg_data <= "100";
                reg_we <= '1';


            WHEN "000111" =>
                alu_op <= "0110";
                reg_data <= "101";
                reg_we <= '1';


            WHEN "001000" =>
                alu_op <= "0110";
                reg_data <= "101";
                reg_we <= '1';
                swap_state <= "01";
                swap_reg_enable <= '1';


            WHEN "001001" =>
                alu_op <= "0000";
                ccr_sel <= "111";
                reg_data <= "011";
                reg_we <= '1';


            WHEN "001010" =>
                alu_op <= "0001";
                ccr_sel <= "111";
                reg_data <= "011";
                reg_we <= '1';


            WHEN "001011" =>
                alu_op <= "0010";
                ccr_sel <= "100";
                reg_data <= "011";
                reg_we <= '1';


            WHEN "001100" =>
                alu_src <= '1';
                alu_op <= "0000";
                ccr_sel <= "111";
                reg_data <= "011";
                reg_we <= '1';


            WHEN "001101" =>
                newSP_sel <= '1';
                SP_WE <= '1';
                mem_addr_sel <= "010";
                mem_data_sel <= "01";
                mem_we <= '1';


            WHEN "001110" =>
                SP_WE <= '1';
                mem_addr_sel <= "011";
                mem_r <= '1';
                reg_data <= "001";
                reg_we <= '1';


            WHEN "001111" =>
                reg_data <= "010";
                reg_we <= '1';
                is_load <= '1';


            WHEN "010000" =>
                mem_addr_sel <= "001";
                mem_r <= '1';
                reg_data <= "001";
                reg_we <= '1';
                is_load <= '1';


            WHEN "010001" =>
                add_sel <= '1';
                mem_addr_sel <= "001";
                mem_data_sel <= "01";
                mem_we <= '1';


            WHEN "010010" =>
                mod_fl <= "010";
                branch_op <= "0001";


            WHEN "010011" =>
                mod_fl <= "011";
                branch_op <= "0010";


            WHEN "010100" =>
                mod_fl <= "100";
                branch_op <= "0011";


            WHEN "010101" =>
                branch_op <= "0100";


            WHEN "010110" =>
                branch_op <= "0101";
                newSP_sel <= '1';
                SP_WE <= '1';
                mem_addr_sel <= "010";
                mem_data_sel <= "10";
                mem_we <= '1';


            WHEN "010111" =>
                branch_op <= "0110";
                SP_WE <= '1';
                mem_addr_sel <= "011";
                mem_r <= '1';
                ret <= '1';


            WHEN "011000" =>
                branch_op <= "0111";
                newSP_sel <= '1';
                SP_WE <= '1';
                mem_addr_sel <= "010";
                mem_data_sel <= "10";
                mem_we <= '1';
                int_state <= "01";


            WHEN "011001" =>
                ccr_sel <= "111";
                branch_op <= "1000";
                SP_WE <= '1';
                mem_addr_sel <= "011";
                mem_r <= '1';
                ret <= '1';
                int_state <= "11";

            WHEN OTHERS =>
                NULL;

        END CASE;

    END PROCESS;

END behavioral;
