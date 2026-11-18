library ieee;
use ieee.std_logic_1164.all;

entity control_unit is
    port (
        opcode : in std_logic_vector(5 downto 0);

        alu_src : out std_logic;
        alu_op : out std_logic_vector(3 downto 0);
        ccr_sel : out std_logic_vector(2 downto 0);
        mod_fl : out std_logic_vector(2 downto 0);
        branch_op : out std_logic_vector(3 downto 0);

        newSP_sel : out std_logic;
        SP_WE : out std_logic;
        add_sel : out std_logic;

        mem_addr_sel : out std_logic_vector(2 downto 0);
        mem_data_sel : out std_logic_vector(1 downto 0);
        mem_we : out std_logic;
        mem_r : out std_logic;

        reg_data : out std_logic_vector(2 downto 0);
        reg_we : out std_logic;

        ret : out std_logic;
        int_state : out std_logic_vector(1 downto 0);

        is_load : out std_logic;
        swap_state : out std_logic_vector(1 downto 0);
        swap_reg_enable : out std_logic;

        hlt : out std_logic;
        out_enable : out std_logic
    );
end control_unit;

architecture behavioral of control_unit is
begin
    process (opcode)
    begin
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

        case opcode is

            when "000000" => -- NOP
                null;

            when "000001" => -- HLT
                hlt <= '1';

            when "000010" => -- SETC
                alu_op <= "0111";
                ccr_sel <= "011";

            when "000011" => -- NOT
                alu_op <= "0011";
                ccr_sel <= "100";
                reg_data <= "011";
                reg_we <= '1';

            when "000100" => -- INC
                alu_op <= "0100";
                ccr_sel <= "111";
                reg_data <= "011";
                reg_we <= '1';

            when "000101" => -- OUT
                out_enable <= '1';
                alu_op <= "0110";

            when "000110" => -- IN
                reg_data <= "100";
                reg_we <= '1';

            when "000111" => -- MOV
                alu_op <= "0110";
                reg_data <= "101";
                reg_we <= '1';

            when "001000" => -- SWAP
                alu_op <= "0110";
                reg_data <= "101";
                reg_we <= '1';
                swap_state <= "01";
                swap_reg_enable <= '1';

            when "001001" => -- ADD
                alu_op <= "0000";
                ccr_sel <= "111";
                reg_data <= "011";
                reg_we <= '1';

            when "001010" => -- SUB
                alu_op <= "0001";
                ccr_sel <= "111";
                reg_data <= "011";
                reg_we <= '1';

            when "001011" => -- AND
                alu_op <= "0010";
                ccr_sel <= "100";
                reg_data <= "011";
                reg_we <= '1';

            when "001100" => -- IADD
                alu_src <= '1';
                alu_op <= "0000";
                ccr_sel <= "111";
                reg_data <= "011";
                reg_we <= '1';

            when "001101" => -- PUSH
                newSP_sel <= '1';
                SP_WE <= '1';
                mem_addr_sel <= "010";
                mem_data_sel <= "01";
                mem_we <= '1';

            when "001110" => -- POP
                SP_WE <= '1';
                mem_addr_sel <= "011";
                mem_r <= '1';
                reg_data <= "001";
                reg_we <= '1';

            when "001111" => -- LDM
                reg_data <= "010";
                reg_we <= '1';
                is_load <= '1';

            when "010000" => -- LDD
                mem_addr_sel <= "001";
                mem_r <= '1';
                reg_data <= "001";
                reg_we <= '1';
                is_load <= '1';

            when "010001" => -- STD
                add_sel <= '1';
                mem_addr_sel <= "001";
                mem_data_sel <= "01";
                mem_we <= '1';

            when "010010" => -- JZ
                mod_fl <= "010";
                branch_op <= "0001";

            when "010011" => -- JN
                mod_fl <= "011";
                branch_op <= "0010";

            when "010100" => -- JC
                mod_fl <= "100";
                branch_op <= "0011";

            when "010101" => -- JMP
                branch_op <= "0100";

            when "010110" => -- CALL
                branch_op <= "0101";
                newSP_sel <= '1';
                SP_WE <= '1';
                mem_addr_sel <= "010";
                mem_data_sel <= "10";
                mem_we <= '1';

            when "010111" => -- RET
                branch_op <= "0110";
                SP_WE <= '1';
                mem_addr_sel <= "011";
                mem_r <= '1';
                ret <= '1';

            when "011000" => -- INT
                branch_op <= "0111";
                newSP_sel <= '1';
                SP_WE <= '1';
                mem_addr_sel <= "010";
                mem_data_sel <= "10";
                mem_we <= '1';
                int_state <= "01";

            when "011001" => -- RTI
                ccr_sel <= "111";
                branch_op <= "1000";
                SP_WE <= '1';
                mem_addr_sel <= "011";
                mem_r <= '1';
                ret <= '1';
                int_state <= "11";

            when others =>
                null;

        end case;
    end process;

end behavioral;
