library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is
    port (
        clk : in std_logic;
        rst : in std_logic;
        interrupt : in std_logic;
        input_port : in std_logic_vector(31 downto 0);

        output_port : out std_logic_vector(31 downto 0);
        fetch_pc_debug : out std_logic_vector(11 downto 0);
        core_enable : out std_logic
    );
end entity;

architecture rtl of top_level is
    signal reset_vector : std_logic_vector(11 downto 0);

    signal instruction_memory_data_out : std_logic_vector(31 downto 0) := (others => '0');
    signal data_memory_data_out : std_logic_vector(31 downto 0) := (others => '0');

    signal predict_fetch : std_logic;
    signal pc_fetch : std_logic_vector(11 downto 0);
    signal input_port_fetch : std_logic_vector(31 downto 0);
    signal inst_fetch : std_logic_vector(31 downto 0);
    signal mem_addr_out_fetch : std_logic_vector(11 downto 0);

    signal predict_to_decode : std_logic;
    signal pc_to_decode : std_logic_vector(11 downto 0);
    signal inst_to_decode : std_logic_vector(31 downto 0);
    signal input_port_to_decode : std_logic_vector(31 downto 0);

    signal predicted_t_to_IDEX1 : std_logic;
    signal hw_int_ret_to_IDEX1 : std_logic_vector(11 downto 0);
    signal pc_to_IDEX1 : std_logic_vector(11 downto 0);
    signal rsrc1_to_IDEX1 : std_logic_vector(31 downto 0);
    signal rsrc2_to_IDEX1 : std_logic_vector(31 downto 0);
    signal imm_to_IDEX1 : std_logic_vector(15 downto 0);
    signal reg_dst_addr_to_IDEX1 : std_logic_vector(2 downto 0);
    signal rsrc1_addr_to_IDEX1 : std_logic_vector(2 downto 0);
    signal rsrc2_addr_to_IDEX1 : std_logic_vector(2 downto 0);
    signal input_port_to_IDEX1 : std_logic_vector(31 downto 0);

    signal alu_src_to_IDEX1 : std_logic;
    signal alu_op_to_IDEX1 : std_logic_vector(3 downto 0);
    signal ccr_sel_to_IDEX1 : std_logic_vector(2 downto 0);
    signal modify_fl_to_IDEX1 : std_logic_vector(2 downto 0);
    signal branch_op_to_IDEX1 : std_logic_vector(3 downto 0);
    signal new_sp_sel_to_IDEX1 : std_logic;
    signal sp_we_to_IDEX1 : std_logic;
    signal add_sel_to_IDEX1 : std_logic;
    signal mem_addr_sel_to_IDEX1 : std_logic_vector(2 downto 0);
    signal mem_data_sel_to_IDEX1 : std_logic_vector(1 downto 0);
    signal mem_we_to_IDEX1 : std_logic;
    signal mem_r_to_IDEX1 : std_logic;
    signal reg_data_to_IDEX1 : std_logic_vector(2 downto 0);
    signal reg_we_to_IDEX1 : std_logic;
    signal ret_to_IDEX1 : std_logic;
    signal int_state_to_IDEX1 : std_logic_vector(1 downto 0);
    signal is_load_to_IDEX1 : std_logic;
    signal swap_state_to_IDEX1 : std_logic_vector(1 downto 0);
    signal out_enable_to_IDEX1 : std_logic;
    signal hlt_to_IDEX1 : std_logic;

    signal predicted_t_from_IDEX1 : std_logic;
    signal hw_int_ret_from_IDEX1 : std_logic_vector(11 downto 0);
    signal pc_from_IDEX1 : std_logic_vector(11 downto 0);
    signal rsrc1_from_IDEX1 : std_logic_vector(31 downto 0);
    signal rsrc2_from_IDEX1 : std_logic_vector(31 downto 0);
    signal imm_from_IDEX1 : std_logic_vector(15 downto 0);
    signal reg_dst_addr_from_IDEX1 : std_logic_vector(2 downto 0);
    signal rsrc1_addr_from_IDEX1 : std_logic_vector(2 downto 0);
    signal rsrc2_addr_from_IDEX1 : std_logic_vector(2 downto 0);
    signal input_port_from_IDEX1 : std_logic_vector(31 downto 0);

    signal alu_src_from_IDEX1 : std_logic;
    signal alu_op_from_IDEX1 : std_logic_vector(3 downto 0);
    signal ccr_sel_from_IDEX1 : std_logic_vector(2 downto 0);
    signal modify_ccr_from_IDEX1 : std_logic_vector(2 downto 0);
    signal branch_op_from_IDEX1 : std_logic_vector(3 downto 0);
    signal new_sp_sel_from_IDEX1 : std_logic;
    signal sp_we_from_IDEX1 : std_logic;
    signal add_sel_from_IDEX1 : std_logic;
    signal mem_addr_sel_from_IDEX1 : std_logic_vector(2 downto 0);
    signal mem_data_sel_from_IDEX1 : std_logic_vector(1 downto 0);
    signal mem_we_from_IDEX1 : std_logic;
    signal mem_r_from_IDEX1 : std_logic;
    signal reg_data_from_IDEX1 : std_logic_vector(2 downto 0);
    signal reg_we_from_IDEX1 : std_logic;
    signal ret_from_IDEX1 : std_logic;
    signal int_state_from_IDEX1 : std_logic_vector(1 downto 0);
    signal is_load_from_IDEX1 : std_logic;
    signal swap_state_from_IDEX1 : std_logic_vector(1 downto 0);
    signal out_enable_from_IDEX1 : std_logic;
    signal hlt_from_IDEX1 : std_logic;

    signal predicted_t_from_EX1 : std_logic;
    signal hw_int_ret_from_EX1 : std_logic_vector(11 downto 0);
    signal pc_from_EX1 : std_logic_vector(11 downto 0);
    signal rsrc1_from_EX1 : std_logic_vector(31 downto 0);
    signal rsrc2_from_EX1 : std_logic_vector(31 downto 0);
    signal imm_from_EX1 : std_logic_vector(15 downto 0);
    signal input_port_from_EX1 : std_logic_vector(31 downto 0);
    signal alu_result_from_EX1 : std_logic_vector(31 downto 0);
    signal ccr_from_EX1 : std_logic_vector(2 downto 0);

    signal alu_op_from_EX1 : std_logic_vector(3 downto 0);
    signal ccr_sel_from_EX1 : std_logic_vector(2 downto 0);
    signal modify_ccr_from_EX1 : std_logic_vector(2 downto 0);
    signal branch_op_from_EX1 : std_logic_vector(3 downto 0);
    signal new_sp_sel_from_EX1 : std_logic;
    signal sp_we_from_EX1 : std_logic;
    signal add_sel_from_EX1 : std_logic;
    signal mem_addr_sel_from_EX1 : std_logic_vector(2 downto 0);
    signal mem_data_sel_from_EX1 : std_logic_vector(1 downto 0);
    signal mem_we_from_EX1 : std_logic;
    signal mem_r_from_EX1 : std_logic;
    signal reg_data_from_EX1 : std_logic_vector(2 downto 0);
    signal reg_we_from_EX1 : std_logic;
    signal out_enable_from_EX1 : std_logic;
    signal hlt_from_EX1 : std_logic;

    signal swap_state_from_EX1 : std_logic_vector(1 downto 0);
    signal is_load_from_EX1 : std_logic;
    signal int_state_from_EX1 : std_logic_vector(1 downto 0);
    signal ret_from_EX1 : std_logic;
    signal reg_dst_addr_from_EX1 : std_logic_vector(2 downto 0);

    signal predicted_t_from_EX1EX2 : std_logic;
    signal pc_from_EX1EX2 : std_logic_vector(11 downto 0);
    signal hw_int_ret_from_EX1EX2 : std_logic_vector(11 downto 0);
    signal ccr_from_EX1EX2 : std_logic_vector(2 downto 0);
    signal alu_res_from_EX1EX2 : std_logic_vector(31 downto 0);
    signal rsrc1_from_EX1EX2 : std_logic_vector(31 downto 0);
    signal rsrc2_from_EX1EX2 : std_logic_vector(31 downto 0);
    signal imm_from_EX1EX2 : std_logic_vector(15 downto 0);
    signal reg_dst_addr_from_EX1EX2 : std_logic_vector(2 downto 0);
    signal input_port_from_EX1EX2 : std_logic_vector(31 downto 0);

    signal alu_op_from_EX1EX2 : std_logic_vector(3 downto 0);
    signal ccr_sel_from_EX1EX2 : std_logic_vector(2 downto 0);
    signal modify_ccr_from_EX1EX2 : std_logic_vector(2 downto 0);
    signal branch_op_from_EX1EX2 : std_logic_vector(3 downto 0);
    signal new_sp_sel_from_EX1EX2 : std_logic;
    signal sp_we_from_EX1EX2 : std_logic;
    signal add_sel_from_EX1EX2 : std_logic;
    signal mem_addr_sel_from_EX1EX2 : std_logic_vector(2 downto 0);
    signal mem_data_sel_from_EX1EX2 : std_logic_vector(1 downto 0);
    signal mem_we_from_EX1EX2 : std_logic;
    signal mem_r_from_EX1EX2 : std_logic;
    signal reg_data_from_EX1EX2 : std_logic_vector(2 downto 0);
    signal reg_we_from_EX1EX2 : std_logic;
    signal ret_from_EX1EX2 : std_logic;
    signal int_state_from_EX1EX2 : std_logic_vector(1 downto 0);
    signal is_load_from_EX1EX2 : std_logic;
    signal swap_state_from_EX1EX2 : std_logic_vector(1 downto 0);
    signal out_enable_from_EX1EX2 : std_logic;
    signal hlt_from_EX1EX2 : std_logic;

    signal hlt_from_EX2 : std_logic;
    signal out_enable_from_EX2 : std_logic;
    signal swap_state_from_EX2 : std_logic_vector(1 downto 0);
    signal is_load_from_EX2 : std_logic;
    signal int_state_from_EX2 : std_logic_vector(1 downto 0);
    signal ret_from_EX2 : std_logic;
    signal reg_we_from_EX2 : std_logic;
    signal reg_data_from_EX2 : std_logic_vector(2 downto 0);
    signal mem_r_from_EX2 : std_logic;
    signal mem_we_from_EX2 : std_logic;
    signal mem_data_sel_from_EX2 : std_logic_vector(1 downto 0);
    signal mem_addr_sel_from_EX2 : std_logic_vector(2 downto 0);
    signal sp_we_from_EX2 : std_logic;
    signal new_sp_sel_from_EX2 : std_logic;
    signal alu_op_from_EX2 : std_logic_vector(3 downto 0);
    signal pc_from_EX2 : std_logic_vector(11 downto 0);
    signal hw_int_ret_from_EX2 : std_logic_vector(11 downto 0);
    signal alu_result_from_EX2 : std_logic_vector(31 downto 0);
    signal rsrc1_from_EX2 : std_logic_vector(31 downto 0);
    signal rsrc2_from_EX2 : std_logic_vector(31 downto 0);
    signal imm_from_EX2 : std_logic_vector(15 downto 0);
    signal reg_dst_addr_from_EX2 : std_logic_vector(2 downto 0);
    signal input_port_from_EX2 : std_logic_vector(31 downto 0);

    signal add_result_from_EX2 : std_logic_vector(11 downto 0);
    signal branch_decision_from_EX2 : std_logic;

    signal pc_from_EX2MEM : std_logic_vector(11 downto 0);
    signal hw_int_ret_from_EX2MEM : std_logic_vector(11 downto 0);
    signal alu_res_from_EX2MEM : std_logic_vector(31 downto 0);
    signal add_result_from_EX2MEM : std_logic_vector(11 downto 0);
    signal rsrc1_from_EX2MEM : std_logic_vector(31 downto 0);
    signal rsrc2_from_EX2MEM : std_logic_vector(31 downto 0);
    signal imm_from_EX2MEM : std_logic_vector(15 downto 0);
    signal reg_dst_addr_from_EX2MEM : std_logic_vector(2 downto 0);
    signal input_port_from_EX2MEM : std_logic_vector(31 downto 0);

    signal alu_op_from_EX2MEM : std_logic_vector(3 downto 0);
    signal new_sp_sel_from_EX2MEM : std_logic;
    signal sp_we_from_EX2MEM : std_logic;
    signal mem_addr_sel_from_EX2MEM : std_logic_vector(2 downto 0);
    signal mem_data_sel_from_EX2MEM : std_logic_vector(1 downto 0);
    signal mem_we_from_EX2MEM : std_logic;
    signal mem_r_from_EX2MEM : std_logic;
    signal reg_data_from_EX2MEM : std_logic_vector(2 downto 0);
    signal reg_we_from_EX2MEM : std_logic;
    signal ret_from_EX2MEM : std_logic;
    signal int_state_from_EX2MEM : std_logic_vector(1 downto 0);
    signal is_load_from_EX2MEM : std_logic;
    signal swap_state_from_EX2MEM : std_logic_vector(1 downto 0);
    signal out_enable_from_EX2MEM : std_logic;
    signal hlt_from_EX2MEM : std_logic;

    signal hlt_from_MEM : std_logic;
    signal out_enable_from_MEM : std_logic;
    signal is_load_from_MEM : std_logic;
    signal sw_intdone_from_MEM : std_logic_vector(1 downto 0);
    signal ret_from_MEM : std_logic;
    signal reg_we_from_MEM : std_logic;
    signal reg_data_from_MEM : std_logic_vector(2 downto 0);
    signal alu_op_from_MEM : std_logic_vector(3 downto 0);
    signal alu_res_from_MEM : std_logic_vector(31 downto 0);
    signal rsrc1_from_MEM : std_logic_vector(31 downto 0);
    signal rsrc2_from_MEM : std_logic_vector(31 downto 0);
    signal imm_from_MEM : std_logic_vector(15 downto 0);
    signal reg_dst_addr_from_MEM : std_logic_vector(2 downto 0);
    signal input_port_from_MEM : std_logic_vector(31 downto 0);
    signal mem_data_out_to_wb_from_MEM : std_logic_vector(31 downto 0);
    signal swap_state_from_MEM : std_logic_vector(1 downto 0);
    signal mem_r_from_MEM : std_logic;
    signal mem_we_from_MEM : std_logic;
    signal mem_addr_from_MEM : std_logic_vector(11 downto 0);
    signal mem_write_data_from_MEM : std_logic_vector(31 downto 0);

    signal alu_res_from_MEMWB : std_logic_vector(31 downto 0);
    signal rsrc1_from_MEMWB : std_logic_vector(31 downto 0);
    signal rsrc2_from_MEMWB : std_logic_vector(31 downto 0);
    signal mem_data_out_from_MEMWB : std_logic_vector(31 downto 0);
    signal imm_from_MEMWB : std_logic_vector(15 downto 0);
    signal reg_dst_addr_from_MEMWB : std_logic_vector(2 downto 0);
    signal input_port_from_MEMWB : std_logic_vector(31 downto 0);
    signal alu_op_from_MEMWB : std_logic_vector(3 downto 0);
    signal reg_data_from_MEMWB : std_logic_vector(2 downto 0);
    signal reg_we_from_MEMWB : std_logic;
    signal ret_from_MEMWB : std_logic;
    signal sw_intdone_from_MEMWB : std_logic_vector(1 downto 0);
    signal is_load_from_MEMWB : std_logic;
    signal swap_state_from_MEMWB : std_logic_vector(1 downto 0);
    signal out_enable_from_MEMWB : std_logic;
    signal hlt_from_MEMWB : std_logic;

    signal operand1_sel : std_logic_vector(3 downto 0);
    signal operand2_sel : std_logic_vector(3 downto 0);

    signal branch_fall_through_plus1 : std_logic_vector(11 downto 0);

    signal hz_pc_we : std_logic;
    signal hz_flush_if : std_logic;
    signal hz_flush_id : std_logic;
    signal hz_flush_ex1 : std_logic;
    signal hz_flush_ex2 : std_logic;
    signal hz_flush_mem : std_logic;
    signal hz_we_if_id : std_logic;
    signal hz_we_id_ex1 : std_logic;
    signal hz_we_ex1_ex2 : std_logic;
    signal hz_instruction_sel_decode : std_logic_vector(2 downto 0);
    signal hz_rsrc1_sel_decode : std_logic;
    signal hz_rdst_sel_decode : std_logic;
    signal hz_restore_flags_ex2 : std_logic;

    signal hz_pc_src_sel : std_logic_vector(2 downto 0);
    signal output_port_str : std_logic_vector(31 downto 0) := (others=> '0');
    signal predictor_taken : std_logic;
    signal predictor_fetch_result : std_logic_vector(1 downto 0);
    signal predictor_update_result : std_logic_vector(1 downto 0);
    signal fetch_is_cond_branch : std_logic;
    signal resolved_cond_branch : std_logic;
    signal hw_interrupt_request : std_logic;
    signal hw_interrupt_done : std_logic;
    signal hw_interrupt_active : std_logic := '0';
    signal hw_decode_drained : std_logic := '0';
    signal reg_we2_to_decode : std_logic;
begin
    -- Fetch stops while the last decoded instruction drains; resume at the held PC.

    branch_fall_through_plus1 <= std_logic_vector(unsigned(pc_from_EX1EX2) + 1);

    u_branch_decoder: entity work.conditional_jump_decoder
        port map (
            instr => instruction_memory_data_out,
            imm16 => open,
            is_conditional_branch => fetch_is_cond_branch
        );

    resolved_cond_branch <= '1' when (branch_op_from_EX1EX2 = "0001" or
        branch_op_from_EX1EX2 = "0010" or
        branch_op_from_EX1EX2 = "0011")
        else '0';

    predictor_update_result <= "10" when (resolved_cond_branch = '1' and branch_decision_from_EX2 = '1') else
        "01" when (resolved_cond_branch = '1' and branch_decision_from_EX2 = '0') else
        "00";

    predictor_fetch_result <= predictor_taken & '0';

    hw_interrupt_done <= '1' when (ret_from_MEMWB = '1' and sw_intdone_from_MEMWB = "11") else '0';
    -- SWAP uses the register file's second write port in the same WB cycle.
    reg_we2_to_decode <= reg_we_from_MEMWB when swap_state_from_MEMWB = "01" else '0';

    process (clk, rst)
    begin
        if rst = '1' then
            hw_interrupt_active <= '0';
        elsif rising_edge(clk) then
            if hw_interrupt_done = '1' then
                hw_interrupt_active <= '0';
            elsif hw_interrupt_request = '1' then
                hw_interrupt_active <= '1';
            elsif hw_interrupt_active = '1' and int_state_from_IDEX1 = "10" then
                hw_interrupt_active <= '0';
            end if;
        end if;
    end process;

    process (clk, rst)
    begin
        if rst = '1' then
            hw_decode_drained <= '0';
        elsif rising_edge(clk) then
            if hw_interrupt_active = '0' then
                hw_decode_drained <= '0';
            elsif hz_instruction_sel_decode = "000" and hz_flush_id = '0' then
                hw_decode_drained <= '1';
            end if;
        end if;
    end process;
    u_interrupt_handler: entity work.interrupt_handler
        port map (
            clk => clk,
            rst => rst,
            hw_interrupt => interrupt,
            interrupt_done => hw_interrupt_done,
            interrupt_request => hw_interrupt_request
        );

    u_predictor: entity work.predictor_2_bit
        port map (
            clk => clk,
            rst => rst,
            prev_prediction => predictor_update_result,
            is_conditional_branch => fetch_is_cond_branch,
            predicted_taken => predictor_taken
        );

    u_memory: entity work.shared_memory
        port map (
            clk => clk,
            mem_write_en => mem_we_from_MEM,
            mem_addr => mem_addr_from_MEM,
            mem_data_in => mem_write_data_from_MEM,
            mem_data_out => data_memory_data_out,
            fetch_addr => mem_addr_out_fetch,
            fetch_data => instruction_memory_data_out,
            reset_vector => reset_vector
        );

    u_hazard_unit: entity work.hazard_unit
        port map (
            rst => rst,
            instruction_sel_decode => hz_instruction_sel_decode,
            pc_we => hz_pc_we,
            inst_in_ifid => inst_to_decode,
            rdst_in_id_ex1 => reg_dst_addr_from_IDEX1,
            is_load_from_IDEX1 => is_load_from_IDEX1,
            mem_r_from_id_ex1 => mem_r_from_IDEX1,

            ret_from_id_ex1 => ret_from_IDEX1,
            int_state_id_ex1 => int_state_from_IDEX1,
            hw_interrupt_active => hw_interrupt_active,
            hw_decode_drained => hw_decode_drained,
            halt_in_ex1_ex2 => hlt_from_EX1EX2,
            is_load_from_EX1EX2 => is_load_from_EX1EX2,
            rdst_in_ex1_ex2 => reg_dst_addr_from_EX1EX2,
            mem_r_from_ex1_ex2 => mem_r_from_EX1EX2,
            predicted_t_from_EX1EX2 => predicted_t_from_EX1EX2,
            ret_from_ex1_ex2 => ret_from_EX1EX2,
            int_state_ex1_ex2 => int_state_from_EX1EX2,
            branch_decision_from_EX2 => branch_decision_from_EX2,

            ret_from_ex2_mem => ret_from_EX2MEM,
            int_state_ex2_mem => int_state_from_EX2MEM,
            ret_from_mem_wb => ret_from_MEMWB,
            int_state_mem_wb => sw_intdone_from_MEMWB,
            rsrc1_sel_decode => hz_rsrc1_sel_decode,
            rdst_sel_decode => hz_rdst_sel_decode,
            pc_src_sel => hz_pc_src_sel,
            we_if_id => hz_we_if_id,
            we_id_ex1 => hz_we_id_ex1,
            we_ex1_ex2 => hz_we_ex1_ex2,
            restore_flags_ex2 => hz_restore_flags_ex2,
            flush_if => hz_flush_if,
            flush_id => hz_flush_id,
            flush_ex1 => hz_flush_ex1,
            flush_ex2 => hz_flush_ex2,
            flush_mem => hz_flush_mem
        );

    u_fetch_stage: entity work.fetch_stage
        port map (
            reset_vector => reset_vector,
            clk => clk,
            rst => rst,
            predicted_taken => predict_fetch,
            pc_current => pc_fetch,
            input_port_passthrough => input_port_fetch,
            inst_to_ifid => inst_fetch,
            inst_mem_addr => mem_addr_out_fetch,
            branch_prediction_result => predictor_fetch_result,
            pc_write_en => hz_pc_we,
            pc_src_sel => hz_pc_src_sel,
            branch_target_addr => imm_from_EX1EX2(11 downto 0),
            branch_fallthrough_addr => branch_fall_through_plus1,
            instruction_word => instruction_memory_data_out,
            mem_read_addr => mem_data_out_from_MEMWB,
            input_port => input_port
        );

    u_IFID: entity work.IFID
        port map (
            clk => clk,
            flush => hz_flush_if,
            write_en => hz_we_if_id,
            predicted_T => predict_fetch,
            inst => inst_fetch,
            input_port => input_port_fetch,
            pc => pc_fetch,
            predicted_T_out => predict_to_decode,
            inst_out => inst_to_decode,
            input_port_out => input_port_to_decode,
            pc_out => pc_to_decode
        );

    u_decode_stage: entity work.decode_stage
        port map (
            clk => clk,
            rst => rst,

            predicted_t => predict_to_decode,
            pc => pc_to_decode,
            inst => inst_to_decode,
            input_port_in => input_port_to_decode,

            instruction_sel => hz_instruction_sel_decode,
            rsrc1_sel => hz_rsrc1_sel_decode,
            rdst_sel => hz_rdst_sel_decode,

            reg_we => reg_we_from_MEMWB,
            reg_data_sel => reg_data_from_MEMWB,
            reg_wb_addr => reg_dst_addr_from_MEMWB,
            reg_we2 => reg_we2_to_decode,
            reg_wb2_addr => imm_from_MEMWB(2 downto 0),
            reg_wb2_data => rsrc2_from_MEMWB,
            mem_data_out => mem_data_out_from_MEMWB,
            imm_wb => imm_from_MEMWB,
            alu_res_wb => alu_res_from_MEMWB,
            input_port_wb => input_port_from_MEMWB,
            rsrc1_wb => rsrc1_from_MEMWB,

            hw_int_ret_ex1 => pc_fetch,

            predicted_t_out => predicted_t_to_IDEX1,
            hw_int_ret => hw_int_ret_to_IDEX1,
            pc_out => pc_to_IDEX1,
            rsrc1 => rsrc1_to_IDEX1,
            rsrc2 => rsrc2_to_IDEX1,
            imm => imm_to_IDEX1,
            reg_dst_addr => reg_dst_addr_to_IDEX1,
            rsrc1_addr => rsrc1_addr_to_IDEX1,
            rsrc2_addr => rsrc2_addr_to_IDEX1,
            input_port_out => input_port_to_IDEX1,
            hlt => hlt_to_IDEX1,
            out_enable => out_enable_to_IDEX1,
            swap_state => swap_state_to_IDEX1,
            is_load => is_load_to_IDEX1,
            int_state => int_state_to_IDEX1,
            ret => ret_to_IDEX1,
            reg_we_out => reg_we_to_IDEX1,
            reg_data_out => reg_data_to_IDEX1,
            mem_r => mem_r_to_IDEX1,
            mem_we => mem_we_to_IDEX1,
            mem_data_sel => mem_data_sel_to_IDEX1,
            mem_addr_sel => mem_addr_sel_to_IDEX1,
            add_sel => add_sel_to_IDEX1,
            sp_we => sp_we_to_IDEX1,
            new_sp_sel => new_sp_sel_to_IDEX1,
            branch_op => branch_op_to_IDEX1,
            modify_fl => modify_fl_to_IDEX1,
            ccr_sel => ccr_sel_to_IDEX1,
            alu_op => alu_op_to_IDEX1,
            alu_src => alu_src_to_IDEX1,

            int_state_hz => open,
            swap_state_hz => open
        );

    u_IDEX1: entity work.IDEX1
        port map (
            clk => clk,
            flush => hz_flush_id,
            write_en => hz_we_id_ex1,

            predicted_T => predicted_t_to_IDEX1,
            HW_INT_ret => hw_int_ret_to_IDEX1,
            pc => pc_to_IDEX1,
            rsrc1 => rsrc1_to_IDEX1,
            rsrc2 => rsrc2_to_IDEX1,
            imm => imm_to_IDEX1,
            reg_dst_addr => reg_dst_addr_to_IDEX1,
            rsrc1_addr => rsrc1_addr_to_IDEX1,
            rsrc2_addr => rsrc2_addr_to_IDEX1,
            input_port => input_port_to_IDEX1,

            alu_src => alu_src_to_IDEX1,
            alu_op => alu_op_to_IDEX1,
            ccr_sel => ccr_sel_to_IDEX1,
            modify_ccr => modify_fl_to_IDEX1,
            branch_op => branch_op_to_IDEX1,
            newSP_sel => new_sp_sel_to_IDEX1,
            SP_WE => sp_we_to_IDEX1,
            add_sel => add_sel_to_IDEX1,
            mem_addr_sel => mem_addr_sel_to_IDEX1,
            mem_data_sel => mem_data_sel_to_IDEX1,
            mem_WE => mem_we_to_IDEX1,
            mem_R => mem_r_to_IDEX1,
            reg_data => reg_data_to_IDEX1,
            reg_WE => reg_we_to_IDEX1,
            ret => ret_to_IDEX1,
            INT_state => int_state_to_IDEX1,
            is_load => is_load_to_IDEX1,
            swap_state => swap_state_to_IDEX1,
            out_enable => out_enable_to_IDEX1,
            HLT => hlt_to_IDEX1,

            predicted_T_out => predicted_t_from_IDEX1,
            HW_INT_ret_out => hw_int_ret_from_IDEX1,
            pc_out => pc_from_IDEX1,
            rsrc1_out => rsrc1_from_IDEX1,
            rsrc2_out => rsrc2_from_IDEX1,
            imm_out => imm_from_IDEX1,
            reg_dst_addr_out => reg_dst_addr_from_IDEX1,
            rsrc1_addr_out => rsrc1_addr_from_IDEX1,
            rsrc2_addr_out => rsrc2_addr_from_IDEX1,
            input_port_out => input_port_from_IDEX1,

            alu_src_out => alu_src_from_IDEX1,
            alu_op_out => alu_op_from_IDEX1,
            ccr_sel_out => ccr_sel_from_IDEX1,
            modify_ccr_out => modify_ccr_from_IDEX1,
            branch_op_out => branch_op_from_IDEX1,
            newSP_sel_out => new_sp_sel_from_IDEX1,
            SP_WE_out => sp_we_from_IDEX1,
            add_sel_out => add_sel_from_IDEX1,
            mem_addr_sel_out => mem_addr_sel_from_IDEX1,
            mem_data_sel_out => mem_data_sel_from_IDEX1,
            mem_WE_out => mem_we_from_IDEX1,
            mem_R_out => mem_r_from_IDEX1,
            reg_data_out => reg_data_from_IDEX1,
            reg_WE_out => reg_we_from_IDEX1,
            ret_out => ret_from_IDEX1,
            INT_state_out => int_state_from_IDEX1,
            is_load_out => is_load_from_IDEX1,
            swap_state_out => swap_state_from_IDEX1,
            out_enable_out => out_enable_from_IDEX1,
            HLT_out => hlt_from_IDEX1
        );

    u_EX1: entity work.EX1
        port map (

            HLT_in_id_ex1 => hlt_from_IDEX1,
            HLT_out_ex1_ex2 => hlt_from_EX1,

            out_enable_in_id_ex1 => out_enable_from_IDEX1,
            out_enable_out_ex1_ex2 => out_enable_from_EX1,

            swap_state_in_id_ex1 => swap_state_from_IDEX1,
            swap_state_out_hazard_ex1_ex2 => swap_state_from_EX1,

            is_load_in_id_ex1 => is_load_from_IDEX1,
            is_load_out_hazard_ex1_ex2 => is_load_from_EX1,

            INT_state_in_id_ex1 => int_state_from_IDEX1,
            INT_state_out_hazard_ex1_ex2 => int_state_from_EX1,

            ret_in_id_ex1 => ret_from_IDEX1,
            ret_out_hazard_ex1_ex2 => ret_from_EX1,

            reg_WE_in_id_ex1 => reg_we_from_IDEX1,
            reg_WE_out_ex1_ex2 => reg_we_from_EX1,

            reg_data_in_id_ex1 => reg_data_from_IDEX1,
            reg_data_out_ex1_ex2 => reg_data_from_EX1,

            mem_R_in_id_ex1 => mem_r_from_IDEX1,
            mem_R_out_ex1_ex2 => mem_r_from_EX1,

            mem_WE_in_id_ex1 => mem_we_from_IDEX1,
            mem_WE_out_ex1_ex2 => mem_we_from_EX1,

            mem_data_sel_in_id_ex1 => mem_data_sel_from_IDEX1,
            mem_data_sel_out_ex1_ex2 => mem_data_sel_from_EX1,

            mem_addr_sel_in_id_ex1 => mem_addr_sel_from_IDEX1,
            mem_addr_sel_out_ex1_ex2 => mem_addr_sel_from_EX1,

            add_sel_in_id_ex1 => add_sel_from_IDEX1,
            add_sel_out_ex1_ex2 => add_sel_from_EX1,

            SP_WE_in_id_ex1 => sp_we_from_IDEX1,
            SP_WE_out_ex1_ex2 => sp_we_from_EX1,

            newSP_sel_in_id_ex1 => new_sp_sel_from_IDEX1,
            newSP_sel_out_ex1_ex2 => new_sp_sel_from_EX1,

            branch_op_in_id_ex1 => branch_op_from_IDEX1,
            branch_op_out_ex1_ex2 => branch_op_from_EX1,

            modify_ccr_in_id_ex1 => modify_ccr_from_IDEX1,
            modify_ccr_out_ex1_ex2 => modify_ccr_from_EX1,

            ccr_sel_in_id_ex1 => ccr_sel_from_IDEX1,
            ccr_sel_out_ex1_ex2 => ccr_sel_from_EX1,

            alu_op_in_id_ex1 => alu_op_from_IDEX1,
            alu_op_out_alu_ex1_ex2 => alu_op_from_EX1,

            alu_src_in_id_ex1 => alu_src_from_IDEX1,

            predicted_T_in_id_ex1 => predicted_t_from_IDEX1,
            predicted_T_out_ex1_ex2 => predicted_t_from_EX1,

            HW_INT_ret_in_id_ex1 => hw_int_ret_from_IDEX1,
            HW_INT_ret_out_ex1_ex2 => hw_int_ret_from_EX1,

            pc_in_id_ex1 => pc_from_IDEX1,
            pc_out_ex1_ex2 => pc_from_EX1,

            rsrc1_in_id_ex1 => rsrc1_from_IDEX1,
            rsrc2_in_id_ex1 => rsrc2_from_IDEX1,

            imm_in_id_ex1 => imm_from_IDEX1,
            imm_out_ex1_ex2 => imm_from_EX1,

            reg_dst_addr_in_id_ex1 => reg_dst_addr_from_IDEX1,
            reg_dst_addr_out_hazard_ex1_ex2 => reg_dst_addr_from_EX1,

            rsrc1_addr_in_id_ex1 => rsrc1_addr_from_IDEX1,
            rsrc1_addr_out_fwd => open,

            rsrc2_addr_in_id_ex1 => rsrc2_addr_from_IDEX1,
            rsrc2_addr_out_fwd => open,

            input_port_in_id_ex1 => input_port_from_IDEX1,
            input_port_out_ex1_ex2 => input_port_from_EX1,

            ccr_out_ex1_ex2 => ccr_from_EX1,
            alu_result_out_ex1_ex2 => alu_result_from_EX1,

            alu_res_in_ex1_ex2 => alu_res_from_EX1EX2,
            alu_res_in_ex2_mem => alu_res_from_EX2MEM,
            alu_res_in_mem_wb => alu_res_from_MEMWB,
            rsrc2_in_ex1_ex2 => rsrc2_from_EX1EX2,
            rsrc2_in_ex2_mem => rsrc2_from_EX2MEM,
            rsrc2_in_mem_wb => rsrc2_from_MEMWB,
            mem_data_out_in_mem_wb => mem_data_out_from_MEMWB,
            imm_in_ex1_ex2 => imm_from_EX1EX2,
            imm_in_ex2_mem => imm_from_EX2MEM,
            imm_in_mem_wb => imm_from_MEMWB,
            input_in_ex1_ex2 => input_port_from_EX1EX2,
            input_in_ex2_mem => input_port_from_EX2MEM,
            input_in_mem_wb => input_port_from_MEMWB,

            rsrc1_fwd_sel_in_fwd => operand1_sel,
            rsrc2_fwd_sel_in_fwd => operand2_sel,

            rsrc1_out_ex1_ex2 => rsrc1_from_EX1,
            rsrc2_out_ex1_ex2 => rsrc2_from_EX1
        );

    u_EX1EX2: entity work.EX1EX2
        port map (
            clk => clk,
            flush => hz_flush_ex1,
            write_en => hz_we_ex1_ex2,

            predicted_T => predicted_t_from_EX1,
            pc => pc_from_EX1,
            HW_INT_ret => hw_int_ret_from_EX1,
            ccr => ccr_from_EX1,
            alu_res => alu_result_from_EX1,
            rsrc1 => rsrc1_from_EX1,
            rsrc2 => rsrc2_from_EX1,
            imm => imm_from_EX1,
            reg_dst_addr => reg_dst_addr_from_EX1,
            input_port => input_port_from_EX1,

            alu_op => alu_op_from_EX1,
            ccr_sel => ccr_sel_from_EX1,
            modify_ccr => modify_ccr_from_EX1,
            branch_op => branch_op_from_EX1,
            newSP_sel => new_sp_sel_from_EX1,
            SP_WE => sp_we_from_EX1,
            add_sel => add_sel_from_EX1,
            mem_addr_sel => mem_addr_sel_from_EX1,
            mem_data_sel => mem_data_sel_from_EX1,
            mem_WE => mem_we_from_EX1,
            mem_R => mem_r_from_EX1,
            reg_data => reg_data_from_EX1,
            reg_WE => reg_we_from_EX1,
            ret => ret_from_EX1,
            INT_state => int_state_from_EX1,
            is_load => is_load_from_EX1,
            swap_state => swap_state_from_EX1,
            out_enable => out_enable_from_EX1,
            HLT => hlt_from_EX1,

            predicted_T_out => predicted_t_from_EX1EX2,
            pc_out => pc_from_EX1EX2,
            HW_INT_ret_out => hw_int_ret_from_EX1EX2,
            ccr_out => ccr_from_EX1EX2,
            alu_res_out => alu_res_from_EX1EX2,
            rsrc1_out => rsrc1_from_EX1EX2,
            rsrc2_out => rsrc2_from_EX1EX2,
            imm_out => imm_from_EX1EX2,
            reg_dst_addr_out => reg_dst_addr_from_EX1EX2,
            input_port_out => input_port_from_EX1EX2,

            alu_op_out => alu_op_from_EX1EX2,
            ccr_sel_out => ccr_sel_from_EX1EX2,
            modify_ccr_out => modify_ccr_from_EX1EX2,
            branch_op_out => branch_op_from_EX1EX2,
            newSP_sel_out => new_sp_sel_from_EX1EX2,
            SP_WE_out => sp_we_from_EX1EX2,
            add_sel_out => add_sel_from_EX1EX2,
            mem_addr_sel_out => mem_addr_sel_from_EX1EX2,
            mem_data_sel_out => mem_data_sel_from_EX1EX2,
            mem_WE_out => mem_we_from_EX1EX2,
            mem_R_out => mem_r_from_EX1EX2,
            reg_data_out => reg_data_from_EX1EX2,
            reg_WE_out => reg_we_from_EX1EX2,
            ret_out => ret_from_EX1EX2,
            INT_state_out => int_state_from_EX1EX2,
            is_load_out => is_load_from_EX1EX2,
            swap_state_out => swap_state_from_EX1EX2,
            out_enable_out => out_enable_from_EX1EX2,
            HLT_out => hlt_from_EX1EX2
        );

    u_EX2: entity work.EX2
        port map (
            clk => clk,
            rst => rst,

            HLT_in_ex1_ex2 => hlt_from_EX1EX2,
            HLT_out_ex2_mem => hlt_from_EX2,

            out_enable_in_ex1_ex2 => out_enable_from_EX1EX2,
            out_enable_out_ex2_mem => out_enable_from_EX2,

            swap_state_in_ex1_ex2 => swap_state_from_EX1EX2,
            swap_state_out_hazard_fwd_ex2_mem => swap_state_from_EX2,

            is_load_in_ex1_ex2 => is_load_from_EX1EX2,
            is_load_out_hazard_ex2_mem => is_load_from_EX2,

            INT_state_in_ex1_ex2 => int_state_from_EX1EX2,
            INT_state_out_hazard_bccr_ex2_mem => int_state_from_EX2,

            ret_in_ex1_ex2 => ret_from_EX1EX2,
            ret_out_hazard_ex2_mem => ret_from_EX2,

            reg_WE_in_ex1_ex2 => reg_we_from_EX1EX2,
            reg_WE_out_fwd_ex2_mem => reg_we_from_EX2,

            reg_data_in_ex1_ex2 => reg_data_from_EX1EX2,
            reg_data_out_ex2_mem => reg_data_from_EX2,

            mem_R_in_ex1_ex2 => mem_r_from_EX1EX2,
            mem_R_out_hazard_ex2_mem => mem_r_from_EX2,

            mem_WE_in_ex1_ex2 => mem_we_from_EX1EX2,
            mem_WE_out_ex2_mem => mem_we_from_EX2,

            mem_data_sel_in_ex1_ex2 => mem_data_sel_from_EX1EX2,
            mem_data_sel_out_ex2_mem => mem_data_sel_from_EX2,

            mem_addr_sel_in_ex1_ex2 => mem_addr_sel_from_EX1EX2,
            mem_addr_sel_out_ex2_mem => mem_addr_sel_from_EX2,

            add_sel_in_ex1_ex2 => add_sel_from_EX1EX2,

            SP_WE_in_ex1_ex2 => sp_we_from_EX1EX2,
            SP_WE_out_ex2_mem => sp_we_from_EX2,

            newSP_sel_in_ex1_ex2 => new_sp_sel_from_EX1EX2,
            newSP_sel_out_ex2_mem => new_sp_sel_from_EX2,

            branch_op_in_ex1_ex2 => branch_op_from_EX1EX2,
            modify_fl_in_ex1_ex2 => modify_ccr_from_EX1EX2,
            ccr_sel_in_ex1_ex2 => ccr_sel_from_EX1EX2,

            alu_op_in_ex1_ex2 => alu_op_from_EX1EX2,
            alu_op_out_fwd_ex2_mem => alu_op_from_EX2,

            pc_in_ex1_ex2 => pc_from_EX1EX2,
            pc_out_branch_ex2_mem => pc_from_EX2,

            HW_INT_ret_in_ex1_ex2 => hw_int_ret_from_EX1EX2,
            HW_INT_ret_out_ex2_mem => hw_int_ret_from_EX2,

            ccr_in_ex1_ex2 => ccr_from_EX1EX2,

            alu_result_in_ex1_ex2 => alu_res_from_EX1EX2,
            alu_result_out_ex2_mem => alu_result_from_EX2,

            rsrc1_in_ex1_ex2 => rsrc1_from_EX1EX2,
            rsrc1_out_ex2_mem => rsrc1_from_EX2,

            rsrc2_in_ex1_ex2 => rsrc2_from_EX1EX2,
            rsrc2_out_ex2_mem => rsrc2_from_EX2,

            imm_in_ex1_ex2 => imm_from_EX1EX2,
            imm_out_ex2_mem => imm_from_EX2,

            reg_dst_addr_in_ex1_ex2 => reg_dst_addr_from_EX1EX2,
            reg_dst_addr_out_hazard_fwd_ex2_mem => reg_dst_addr_from_EX2,

            input_port_in_ex1_ex2 => input_port_from_EX1EX2,
            input_port_out_ex2_mem => input_port_from_EX2,

            add_result_out_ex2_mem => add_result_from_EX2,
            branch_decision_out_hazard => branch_decision_from_EX2,
            restore_flags_in => hz_restore_flags_ex2
        );

    u_EX2MEM: entity work.EX2MEM
        port map (
            clk => clk,
            flush => hz_flush_ex2,
            write_en => '1',

            pc => pc_from_EX2,
            HW_INT_ret => hw_int_ret_from_EX2,
            alu_res => alu_result_from_EX2,
            add_result => add_result_from_EX2,
            rsrc1 => rsrc1_from_EX2,
            rsrc2 => rsrc2_from_EX2,
            imm => imm_from_EX2,
            reg_dst_addr => reg_dst_addr_from_EX2,
            input_port => input_port_from_EX2,

            alu_op => alu_op_from_EX2,
            newSP_sel => new_sp_sel_from_EX2,
            SP_WE => sp_we_from_EX2,
            mem_addr_sel => mem_addr_sel_from_EX2,
            mem_data_sel => mem_data_sel_from_EX2,
            mem_WE => mem_we_from_EX2,
            mem_R => mem_r_from_EX2,
            reg_data => reg_data_from_EX2,
            reg_WE => reg_we_from_EX2,
            ret => ret_from_EX2,
            INT_state => int_state_from_EX2,
            is_load => is_load_from_EX2,
            swap_state => swap_state_from_EX2,
            out_enable => out_enable_from_EX2,
            HLT => hlt_from_EX2,

            pc_out => pc_from_EX2MEM,
            HW_INT_ret_out => hw_int_ret_from_EX2MEM,
            alu_res_out => alu_res_from_EX2MEM,
            add_result_out => add_result_from_EX2MEM,
            rsrc1_out => rsrc1_from_EX2MEM,
            rsrc2_out => rsrc2_from_EX2MEM,
            imm_out => imm_from_EX2MEM,
            reg_dst_addr_out => reg_dst_addr_from_EX2MEM,
            input_port_out => input_port_from_EX2MEM,

            alu_op_out => alu_op_from_EX2MEM,
            newSP_sel_out => new_sp_sel_from_EX2MEM,
            SP_WE_out => sp_we_from_EX2MEM,
            mem_addr_sel_out => mem_addr_sel_from_EX2MEM,
            mem_data_sel_out => mem_data_sel_from_EX2MEM,
            mem_WE_out => mem_we_from_EX2MEM,
            mem_R_out => mem_r_from_EX2MEM,
            reg_data_out => reg_data_from_EX2MEM,
            reg_WE_out => reg_we_from_EX2MEM,
            ret_out => ret_from_EX2MEM,
            INT_state_out => int_state_from_EX2MEM,
            is_load_out => is_load_from_EX2MEM,
            swap_state_out => swap_state_from_EX2MEM,
            out_enable_out => out_enable_from_EX2MEM,
            HLT_out => hlt_from_EX2MEM
        );

    u_MEM: entity work.memory_stage
        port map (
            clk => clk,
            rst => rst,

            HLT => hlt_from_EX2MEM,
            out_enable => out_enable_from_EX2MEM,
            swap_state => swap_state_from_EX2MEM,
            is_load => is_load_from_EX2MEM,
            INT_state => int_state_from_EX2MEM,
            ret => ret_from_EX2MEM,
            reg_WE => reg_we_from_EX2MEM,
            reg_data => reg_data_from_EX2MEM,
            mem_R => mem_r_from_EX2MEM,
            mem_WE => mem_we_from_EX2MEM,
            mem_data_sel => mem_data_sel_from_EX2MEM,
            mem_addr_sel => mem_addr_sel_from_EX2MEM,
            SP_WE => sp_we_from_EX2MEM,
            newSP_sel => new_sp_sel_from_EX2MEM,
            alu_op => alu_op_from_EX2MEM,
            pc => pc_from_EX2MEM,
            HW_INT_ret => hw_int_ret_from_EX2MEM,
            alu_res => alu_res_from_EX2MEM,
            add_result => add_result_from_EX2MEM,
            rsrc1 => rsrc1_from_EX2MEM,
            rsrc2 => rsrc2_from_EX2MEM,
            imm => imm_from_EX2MEM,
            reg_dst_addr => reg_dst_addr_from_EX2MEM,
            input_port => input_port_from_EX2MEM,

            mem_data_out => data_memory_data_out,

            HLT_out => hlt_from_MEM,
            out_enable_out => out_enable_from_MEM,
            is_load_out => is_load_from_MEM,
            SW_INTDone_out => sw_intdone_from_MEM,
            ret_out => ret_from_MEM,
            reg_WE_out => reg_we_from_MEM,
            reg_data_out => reg_data_from_MEM,
            alu_op_out => alu_op_from_MEM,
            alu_res_out => alu_res_from_MEM,
            rsrc1_out => rsrc1_from_MEM,
            rsrc2_out => rsrc2_from_MEM,
            imm_out => imm_from_MEM,
            reg_dst_addr_out => reg_dst_addr_from_MEM,
            input_port_out => input_port_from_MEM,
            mem_data_out_to_wb => mem_data_out_to_wb_from_MEM,

            swap_state_out => swap_state_from_MEM,
            mem_R_out => mem_r_from_MEM,
            mem_WE_out => mem_we_from_MEM,
            mem_addr => mem_addr_from_MEM,
            mem_write_data => mem_write_data_from_MEM
        );

    u_MEMWB: entity work.MEMWB
        port map (
            clk => clk,
            flush => hz_flush_mem,
            write_en => '1',

            alu_res => alu_res_from_MEM,
            rsrc1 => rsrc1_from_MEM,
            rsrc2 => rsrc2_from_MEM,
            mem_data_out => mem_data_out_to_wb_from_MEM,
            imm => imm_from_MEM,
            reg_dst_addr => reg_dst_addr_from_MEM,
            input_port => input_port_from_MEM,

            alu_op => alu_op_from_MEM,
            reg_data => reg_data_from_MEM,
            reg_WE => reg_we_from_MEM,
            ret => ret_from_MEM,
            SW_INTDone => sw_intdone_from_MEM,
            is_load => is_load_from_MEM,
            swap_state => swap_state_from_MEM,
            out_enable => out_enable_from_MEM,
            HLT => hlt_from_MEM,

            alu_res_out => alu_res_from_MEMWB,
            rsrc1_out => rsrc1_from_MEMWB,
            rsrc2_out => rsrc2_from_MEMWB,
            mem_data_out_out => mem_data_out_from_MEMWB,
            imm_out => imm_from_MEMWB,
            reg_dst_addr_out => reg_dst_addr_from_MEMWB,
            input_port_out => input_port_from_MEMWB,

            alu_op_out => alu_op_from_MEMWB,
            reg_data_out => reg_data_from_MEMWB,
            reg_WE_out => reg_we_from_MEMWB,
            ret_out => ret_from_MEMWB,
            SW_INTDone_out => sw_intdone_from_MEMWB,
            is_load_out => is_load_from_MEMWB,
            swap_state_out => swap_state_from_MEMWB,
            out_enable_out => out_enable_from_MEMWB,
            HLT_out => hlt_from_MEMWB
        );

    u_forwarding: entity work.forwarding_unit
        port map (

            rsrc1_addr => rsrc1_addr_from_IDEX1,
            rsrc2_addr => rsrc2_addr_from_IDEX1,

            swap_state => swap_state_from_IDEX1,
            reg_WE_ex1_ex2 => reg_we_from_EX1EX2,
            reg_dst_addr_ex1_ex2 => reg_dst_addr_from_EX1EX2,
            reg_data_ex1_ex2 => reg_data_from_EX1EX2,
            swap_state_ex1_ex2 => swap_state_from_EX1EX2,
            swap_addr_ex1_ex2 => imm_from_EX1EX2(2 downto 0),

            reg_data_ex2_mem => reg_data_from_EX2MEM,
            reg_dst_addr_ex2_mem => reg_dst_addr_from_EX2MEM,
            reg_WE_ex2_mem => reg_we_from_EX2MEM,
            swap_state_ex2_mem => swap_state_from_EX2MEM,
            swap_addr_ex2_mem => imm_from_EX2MEM(2 downto 0),

            reg_WE_mem_wb => reg_we_from_MEMWB,
            reg_dst_addr_mem_wb => reg_dst_addr_from_MEMWB,
            reg_data_mem_wb => reg_data_from_MEMWB,
            swap_state_mem_wb => swap_state_from_MEMWB,
            swap_addr_mem_wb => imm_from_MEMWB(2 downto 0),

            operand1_sel => operand1_sel,
            operand2_sel => operand2_sel
        );

    process (clk, rst)
    begin
        if rst = '1' then
            output_port_str <= (others => '0');
        elsif rising_edge(clk) then
            if out_enable_from_MEMWB = '1' then
                output_port_str <= rsrc1_from_MEMWB;
            end if;
        end if;
    end process;

    output_port <= output_port_str;
    fetch_pc_debug <= pc_fetch;
    core_enable <= not hlt_from_MEMWB;
end architecture;
