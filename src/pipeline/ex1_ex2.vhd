library ieee;
use ieee.std_logic_1164.all;

entity EX1EX2 is
    port (
        clk : in std_logic;
        flush : in std_logic;
        write_en : in std_logic;

        predicted_T : in std_logic;
        pc : in std_logic_vector(11 downto 0);
        HW_INT_ret : in std_logic_vector(11 downto 0);
        ccr : in std_logic_vector(2 downto 0);
        alu_res : in std_logic_vector(31 downto 0);
        rsrc1 : in std_logic_vector(31 downto 0);
        rsrc2 : in std_logic_vector(31 downto 0);
        imm : in std_logic_vector(15 downto 0);
        reg_dst_addr : in std_logic_vector(2 downto 0);
        input_port : in std_logic_vector(31 downto 0);

        alu_op : in std_logic_vector(3 downto 0);
        ccr_sel : in std_logic_vector(2 downto 0);
        modify_ccr : in std_logic_vector(2 downto 0);
        branch_op : in std_logic_vector(3 downto 0);
        newSP_sel : in std_logic;
        SP_WE : in std_logic;
        add_sel : in std_logic;
        mem_addr_sel : in std_logic_vector(2 downto 0);
        mem_data_sel : in std_logic_vector(1 downto 0);
        mem_WE : in std_logic;
        mem_R : in std_logic;
        reg_data : in std_logic_vector(2 downto 0);
        reg_WE : in std_logic;
        ret : in std_logic;
        INT_state : in std_logic_vector(1 downto 0);
        is_load : in std_logic;
        swap_state : in std_logic_vector(1 downto 0);
        out_enable : in std_logic;
        HLT : in std_logic;

        predicted_T_out : out std_logic := '0';
        pc_out : out std_logic_vector(11 downto 0) := (others => '0');
        HW_INT_ret_out : out std_logic_vector(11 downto 0) := (others => '0');
        ccr_out : out std_logic_vector(2 downto 0) := (others => '0');
        alu_res_out : out std_logic_vector(31 downto 0) := (others => '0');
        rsrc1_out : out std_logic_vector(31 downto 0) := (others => '0');
        rsrc2_out : out std_logic_vector(31 downto 0) := (others => '0');
        imm_out : out std_logic_vector(15 downto 0) := (others => '0');
        reg_dst_addr_out : out std_logic_vector(2 downto 0) := (others => '0');
        input_port_out : out std_logic_vector(31 downto 0) := (others => '0');

        alu_op_out : out std_logic_vector(3 downto 0) := (others => '0');
        ccr_sel_out : out std_logic_vector(2 downto 0) := (others => '0');
        modify_ccr_out : out std_logic_vector(2 downto 0) := (others => '0');
        branch_op_out : out std_logic_vector(3 downto 0) := (others => '0');
        newSP_sel_out : out std_logic := '0';
        SP_WE_out : out std_logic := '0';
        add_sel_out : out std_logic := '0';
        mem_addr_sel_out : out std_logic_vector(2 downto 0) := (others => '0');
        mem_data_sel_out : out std_logic_vector(1 downto 0) := (others => '0');
        mem_WE_out : out std_logic := '0';
        mem_R_out : out std_logic := '0';
        reg_data_out : out std_logic_vector(2 downto 0) := (others => '0');
        reg_WE_out : out std_logic := '0';
        ret_out : out std_logic := '0';
        INT_state_out : out std_logic_vector(1 downto 0) := (others => '0');
        is_load_out : out std_logic := '0';
        swap_state_out : out std_logic_vector(1 downto 0) := (others => '0');
        out_enable_out : out std_logic := '0';
        HLT_out : out std_logic := '0'
    );
end entity;

architecture rtl of EX1EX2 is
begin
    -- Flush has priority over write_en.
    process (clk)
    begin
        if rising_edge(clk) then
            if flush = '1' then

                predicted_T_out <= '0';
                pc_out <= (others => '0');
                HW_INT_ret_out <= (others => '0');
                ccr_out <= (others => '0');
                alu_res_out <= (others => '0');
                rsrc1_out <= (others => '0');
                rsrc2_out <= (others => '0');
                imm_out <= (others => '0');
                reg_dst_addr_out <= (others => '0');
                input_port_out <= (others => '0');

                alu_op_out <= (others => '0');
                ccr_sel_out <= (others => '0');
                modify_ccr_out <= (others => '0');
                branch_op_out <= (others => '0');
                newSP_sel_out <= '0';
                SP_WE_out <= '0';
                add_sel_out <= '0';
                mem_addr_sel_out <= (others => '0');
                mem_data_sel_out <= (others => '0');
                mem_WE_out <= '0';
                mem_R_out <= '0';
                reg_data_out <= (others => '0');
                reg_WE_out <= '0';
                ret_out <= '0';
                INT_state_out <= (others => '0');
                is_load_out <= '0';
                swap_state_out <= (others => '0');
                out_enable_out <= '0';
                HLT_out <= '0';

            elsif write_en = '1' then

                predicted_T_out <= predicted_T;
                pc_out <= pc;
                HW_INT_ret_out <= HW_INT_ret;
                ccr_out <= ccr;
                alu_res_out <= alu_res;
                rsrc1_out <= rsrc1;
                rsrc2_out <= rsrc2;
                imm_out <= imm;
                reg_dst_addr_out <= reg_dst_addr;
                input_port_out <= input_port;

                alu_op_out <= alu_op;
                ccr_sel_out <= ccr_sel;
                modify_ccr_out <= modify_ccr;
                branch_op_out <= branch_op;
                newSP_sel_out <= newSP_sel;
                SP_WE_out <= SP_WE;
                add_sel_out <= add_sel;
                mem_addr_sel_out <= mem_addr_sel;
                mem_data_sel_out <= mem_data_sel;
                mem_WE_out <= mem_WE;
                mem_R_out <= mem_R;
                reg_data_out <= reg_data;
                reg_WE_out <= reg_WE;
                ret_out <= ret;
                INT_state_out <= INT_state;
                is_load_out <= is_load;
                swap_state_out <= swap_state;
                out_enable_out <= out_enable;
                HLT_out <= HLT;
            end if;
        end if;
    end process;
end rtl;
