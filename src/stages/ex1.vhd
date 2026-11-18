library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity EX1 is
    port (

        HLT_in_id_ex1 : in std_logic;
        HLT_out_ex1_ex2 : out std_logic;

        out_enable_in_id_ex1 : in std_logic;
        out_enable_out_ex1_ex2 : out std_logic;

        swap_state_in_id_ex1 : in std_logic_vector(1 downto 0);
        swap_state_out_hazard_ex1_ex2 : out std_logic_vector(1 downto 0);

        is_load_in_id_ex1 : in std_logic;
        is_load_out_hazard_ex1_ex2 : out std_logic;

        INT_state_in_id_ex1 : in std_logic_vector(1 downto 0);
        INT_state_out_hazard_ex1_ex2 : out std_logic_vector(1 downto 0);

        ret_in_id_ex1 : in std_logic;
        ret_out_hazard_ex1_ex2 : out std_logic;

        reg_WE_in_id_ex1 : in std_logic;
        reg_WE_out_ex1_ex2 : out std_logic;

        reg_data_in_id_ex1 : in std_logic_vector(2 downto 0);
        reg_data_out_ex1_ex2 : out std_logic_vector(2 downto 0);

        mem_R_in_id_ex1 : in std_logic;
        mem_R_out_ex1_ex2 : out std_logic;

        mem_WE_in_id_ex1 : in std_logic;
        mem_WE_out_ex1_ex2 : out std_logic;

        mem_data_sel_in_id_ex1 : in std_logic_vector(1 downto 0);
        mem_data_sel_out_ex1_ex2 : out std_logic_vector(1 downto 0);

        mem_addr_sel_in_id_ex1 : in std_logic_vector(2 downto 0);
        mem_addr_sel_out_ex1_ex2 : out std_logic_vector(2 downto 0);

        add_sel_in_id_ex1 : in std_logic;
        add_sel_out_ex1_ex2 : out std_logic;

        SP_WE_in_id_ex1 : in std_logic;
        SP_WE_out_ex1_ex2 : out std_logic;

        newSP_sel_in_id_ex1 : in std_logic;
        newSP_sel_out_ex1_ex2 : out std_logic;

        branch_op_in_id_ex1 : in std_logic_vector(3 downto 0);
        branch_op_out_ex1_ex2 : out std_logic_vector(3 downto 0);

        modify_ccr_in_id_ex1 : in std_logic_vector(2 downto 0);
        modify_ccr_out_ex1_ex2 : out std_logic_vector(2 downto 0);

        ccr_sel_in_id_ex1 : in std_logic_vector(2 downto 0);
        ccr_sel_out_ex1_ex2 : out std_logic_vector(2 downto 0);

        alu_op_in_id_ex1 : in std_logic_vector(3 downto 0);
        alu_op_out_alu_ex1_ex2 : out std_logic_vector(3 downto 0);

        alu_src_in_id_ex1 : in std_logic;

        predicted_T_in_id_ex1 : in std_logic;
        predicted_T_out_ex1_ex2 : out std_logic;

        HW_INT_ret_in_id_ex1 : in std_logic_vector(11 downto 0);
        HW_INT_ret_out_ex1_ex2 : out std_logic_vector(11 downto 0);

        pc_in_id_ex1 : in std_logic_vector(11 downto 0);
        pc_out_ex1_ex2 : out std_logic_vector(11 downto 0);

        rsrc1_in_id_ex1 : in std_logic_vector(31 downto 0);
        rsrc2_in_id_ex1 : in std_logic_vector(31 downto 0);

        imm_in_id_ex1 : in std_logic_vector(15 downto 0);
        imm_out_ex1_ex2 : out std_logic_vector(15 downto 0);

        reg_dst_addr_in_id_ex1 : in std_logic_vector(2 downto 0);
        reg_dst_addr_out_hazard_ex1_ex2 : out std_logic_vector(2 downto 0);

        rsrc1_addr_in_id_ex1 : in std_logic_vector(2 downto 0);
        rsrc1_addr_out_fwd : out std_logic_vector(2 downto 0);

        rsrc2_addr_in_id_ex1 : in std_logic_vector(2 downto 0);
        rsrc2_addr_out_fwd : out std_logic_vector(2 downto 0);

        input_port_in_id_ex1 : in std_logic_vector(31 downto 0);
        input_port_out_ex1_ex2 : out std_logic_vector(31 downto 0);

        ccr_out_ex1_ex2 : out std_logic_vector(2 downto 0);
        alu_result_out_ex1_ex2 : out std_logic_vector(31 downto 0);

        alu_res_in_ex1_ex2 : in std_logic_vector(31 downto 0);
        alu_res_in_ex2_mem : in std_logic_vector(31 downto 0);
        alu_res_in_mem_wb : in std_logic_vector(31 downto 0);
        rsrc2_in_ex1_ex2 : in std_logic_vector(31 downto 0);
        rsrc2_in_ex2_mem : in std_logic_vector(31 downto 0);
        rsrc2_in_mem_wb : in std_logic_vector(31 downto 0);

        input_in_ex1_ex2 : in std_logic_vector(31 downto 0);
        input_in_ex2_mem : in std_logic_vector(31 downto 0);
        input_in_mem_wb : in std_logic_vector(31 downto 0);

        mem_data_out_in_mem_wb : in std_logic_vector(31 downto 0);

        imm_in_ex1_ex2 : in std_logic_vector(15 downto 0);
        imm_in_ex2_mem : in std_logic_vector(15 downto 0);
        imm_in_mem_wb : in std_logic_vector(15 downto 0);

        rsrc1_fwd_sel_in_fwd : in std_logic_vector(3 downto 0);
        rsrc2_fwd_sel_in_fwd : in std_logic_vector(3 downto 0);

        rsrc1_out_ex1_ex2 : out std_logic_vector(31 downto 0);
        rsrc2_out_ex1_ex2 : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of EX1 is
    signal alu_input1 : std_logic_vector(31 downto 0);
    signal alu_input2 : std_logic_vector(31 downto 0);

    signal alu_input2_mid : std_logic_vector(31 downto 0);

    signal se_imm_local : std_logic_vector(31 downto 0);
    signal se_imm_in_ex1_ex2 : std_logic_vector(31 downto 0);
    signal se_imm_in_ex2_mem : std_logic_vector(31 downto 0);
    signal se_imm_in_mem_wb : std_logic_vector(31 downto 0);
begin
    se_imm_local <= std_logic_vector(resize(signed(imm_in_id_ex1), 32));
    se_imm_in_ex1_ex2 <= std_logic_vector(resize(signed(imm_in_ex1_ex2), 32));
    se_imm_in_ex2_mem <= std_logic_vector(resize(signed(imm_in_ex2_mem), 32));
    se_imm_in_mem_wb <= std_logic_vector(resize(signed(imm_in_mem_wb), 32));

    with rsrc1_fwd_sel_in_fwd select alu_input1 <=
        rsrc1_in_id_ex1 when "0000",
        alu_res_in_ex1_ex2 when "0001",
        alu_res_in_ex2_mem when "0010",
        alu_res_in_mem_wb when "0011",
        mem_data_out_in_mem_wb when "0100",
        se_imm_in_ex1_ex2 when "0101",
        se_imm_in_ex2_mem when "0110",
        se_imm_in_mem_wb when "0111",
        input_in_ex1_ex2 when "1000",
        input_in_ex2_mem when "1001",
        input_in_mem_wb when "1010",
        rsrc2_in_ex1_ex2 when "1011",
        rsrc2_in_ex2_mem when "1100",
        rsrc2_in_mem_wb when "1101",
        (others => '0') when others;

    with rsrc2_fwd_sel_in_fwd select alu_input2_mid <=
        rsrc2_in_id_ex1 when "0000",
        alu_res_in_ex1_ex2 when "0001",
        alu_res_in_ex2_mem when "0010",
        alu_res_in_mem_wb when "0011",
        mem_data_out_in_mem_wb when "0100",
        se_imm_in_ex1_ex2 when "0101",
        se_imm_in_ex2_mem when "0110",
        se_imm_in_mem_wb when "0111",
        input_in_ex1_ex2 when "1000",
        input_in_ex2_mem when "1001",
        input_in_mem_wb when "1010",
        rsrc2_in_ex1_ex2 when "1011",
        rsrc2_in_ex2_mem when "1100",
        rsrc2_in_mem_wb when "1101",
        (others => '0') when others;

    alu_input2 <= se_imm_local when alu_src_in_id_ex1 = '1' else alu_input2_mid;

    u_alu: entity work.alu
        port map (
            operand1 => alu_input1,
            operand2 => alu_input2,
            alu_op => alu_op_in_id_ex1,
            alu_result => alu_result_out_ex1_ex2,
            alu_flags => ccr_out_ex1_ex2
        );

    HLT_out_ex1_ex2 <= HLT_in_id_ex1;
    out_enable_out_ex1_ex2 <= out_enable_in_id_ex1;
    swap_state_out_hazard_ex1_ex2 <= swap_state_in_id_ex1;
    is_load_out_hazard_ex1_ex2 <= is_load_in_id_ex1;
    INT_state_out_hazard_ex1_ex2 <= INT_state_in_id_ex1;
    ret_out_hazard_ex1_ex2 <= ret_in_id_ex1;
    reg_WE_out_ex1_ex2 <= reg_WE_in_id_ex1;
    reg_data_out_ex1_ex2 <= reg_data_in_id_ex1;
    mem_R_out_ex1_ex2 <= mem_R_in_id_ex1;
    mem_WE_out_ex1_ex2 <= mem_WE_in_id_ex1;
    mem_data_sel_out_ex1_ex2 <= mem_data_sel_in_id_ex1;
    mem_addr_sel_out_ex1_ex2 <= mem_addr_sel_in_id_ex1;
    add_sel_out_ex1_ex2 <= add_sel_in_id_ex1;
    SP_WE_out_ex1_ex2 <= SP_WE_in_id_ex1;
    newSP_sel_out_ex1_ex2 <= newSP_sel_in_id_ex1;
    branch_op_out_ex1_ex2 <= branch_op_in_id_ex1;
    modify_ccr_out_ex1_ex2 <= modify_ccr_in_id_ex1;
    ccr_sel_out_ex1_ex2 <= ccr_sel_in_id_ex1;
    alu_op_out_alu_ex1_ex2 <= alu_op_in_id_ex1;
    predicted_T_out_ex1_ex2 <= predicted_T_in_id_ex1;
    HW_INT_ret_out_ex1_ex2 <= HW_INT_ret_in_id_ex1;
    pc_out_ex1_ex2 <= pc_in_id_ex1;

    imm_out_ex1_ex2 <= imm_in_id_ex1;
    input_port_out_ex1_ex2 <= input_port_in_id_ex1;

    reg_dst_addr_out_hazard_ex1_ex2 <= reg_dst_addr_in_id_ex1;
    rsrc1_addr_out_fwd <= rsrc1_addr_in_id_ex1;
    rsrc2_addr_out_fwd <= rsrc2_addr_in_id_ex1;

    rsrc1_out_ex1_ex2 <= alu_input1;
    rsrc2_out_ex1_ex2 <= alu_input2_mid;
end architecture;
