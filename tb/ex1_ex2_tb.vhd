library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity EX1EX2_tb is
end EX1EX2_tb;

architecture behavior of EX1EX2_tb is
    signal clk : std_logic := '0';
    signal flush : std_logic := '0';
    signal write_en : std_logic := '0';

    signal predicted_T : std_logic := '0';
    signal pc : std_logic_vector(11 downto 0) := (others => '0');
    signal HW_INT_ret : std_logic_vector(11 downto 0) := (others => '0');
    signal ccr : std_logic_vector(2 downto 0) := (others => '0');
    signal alu_res : std_logic_vector(31 downto 0) := (others => '0');
    signal rsrc1 : std_logic_vector(31 downto 0) := (others => '0');
    signal rsrc2 : std_logic_vector(31 downto 0) := (others => '0');
    signal imm : std_logic_vector(15 downto 0) := (others => '0');
    signal reg_dst_addr : std_logic_vector(2 downto 0) := (others => '0');
    signal input_port : std_logic_vector(31 downto 0) := (others => '0');

    signal alu_op : std_logic_vector(3 downto 0) := (others => '0');
    signal ccr_sel : std_logic_vector(2 downto 0) := (others => '0');
    signal modify_ccr : std_logic_vector(2 downto 0) := (others => '0');
    signal branch_op : std_logic_vector(3 downto 0) := (others => '0');
    signal newSP_sel : std_logic := '0';
    signal SP_WE : std_logic := '0';
    signal add_sel : std_logic := '0';
    signal mem_addr_sel : std_logic_vector(2 downto 0) := (others => '0');
    signal mem_data_sel : std_logic_vector(1 downto 0) := (others => '0');
    signal mem_WE : std_logic := '0';
    signal mem_R : std_logic := '0';
    signal reg_data : std_logic_vector(2 downto 0) := (others => '0');
    signal reg_WE : std_logic := '0';
    signal ret : std_logic := '0';
    signal INT_state : std_logic_vector(1 downto 0) := (others => '0');
    signal is_load : std_logic := '0';
    signal swap_state : std_logic_vector(1 downto 0) := (others => '0');
    signal out_enable : std_logic := '0';

    signal predicted_T_out : std_logic;
    signal pc_out : std_logic_vector(11 downto 0);
    signal HW_INT_ret_out : std_logic_vector(11 downto 0);
    signal ccr_out : std_logic_vector(2 downto 0);
    signal alu_res_out : std_logic_vector(31 downto 0);
    signal rsrc1_out : std_logic_vector(31 downto 0);
    signal rsrc2_out : std_logic_vector(31 downto 0);
    signal imm_out : std_logic_vector(15 downto 0);
    signal reg_dst_addr_out : std_logic_vector(2 downto 0);
    signal input_port_out : std_logic_vector(31 downto 0);

    signal alu_op_out : std_logic_vector(3 downto 0);
    signal ccr_sel_out : std_logic_vector(2 downto 0);
    signal modify_ccr_out : std_logic_vector(2 downto 0);
    signal branch_op_out : std_logic_vector(3 downto 0);
    signal newSP_sel_out : std_logic;
    signal SP_WE_out : std_logic;
    signal add_sel_out : std_logic;
    signal mem_addr_sel_out : std_logic_vector(2 downto 0);
    signal mem_data_sel_out : std_logic_vector(1 downto 0);
    signal mem_WE_out : std_logic;
    signal mem_R_out : std_logic;
    signal reg_data_out : std_logic_vector(2 downto 0);
    signal reg_WE_out : std_logic;
    signal ret_out : std_logic;
    signal INT_state_out : std_logic_vector(1 downto 0);
    signal is_load_out : std_logic;
    signal swap_state_out : std_logic_vector(1 downto 0);
    signal out_enable_out : std_logic;

    constant CLK_PERIOD : time := 10 ns;
begin
    uut: entity work.EX1EX2
        port map (
            clk => clk,
            flush => flush,
            write_en => write_en,
            predicted_T => predicted_T,
            pc => pc,
            HW_INT_ret => HW_INT_ret,
            ccr => ccr,
            alu_res => alu_res,
            rsrc1 => rsrc1,
            rsrc2 => rsrc2,
            imm => imm,
            reg_dst_addr => reg_dst_addr,
            input_port => input_port,
            alu_op => alu_op,
            ccr_sel => ccr_sel,
            modify_ccr => modify_ccr,
            branch_op => branch_op,
            newSP_sel => newSP_sel,
            SP_WE => SP_WE,
            add_sel => add_sel,
            mem_addr_sel => mem_addr_sel,
            mem_data_sel => mem_data_sel,
            mem_WE => mem_WE,
            mem_R => mem_R,
            reg_data => reg_data,
            reg_WE => reg_WE,
            ret => ret,
            INT_state => INT_state,
            is_load => is_load,
            swap_state => swap_state,
            out_enable => out_enable,

            predicted_T_out => predicted_T_out,
            pc_out => pc_out,
            HW_INT_ret_out => HW_INT_ret_out,
            ccr_out => ccr_out,
            alu_res_out => alu_res_out,
            rsrc1_out => rsrc1_out,
            rsrc2_out => rsrc2_out,
            imm_out => imm_out,
            reg_dst_addr_out => reg_dst_addr_out,
            input_port_out => input_port_out,
            alu_op_out => alu_op_out,
            HLT => '0',
            HLT_out => open,
            ccr_sel_out => ccr_sel_out,
            modify_ccr_out => modify_ccr_out,
            branch_op_out => branch_op_out,
            newSP_sel_out => newSP_sel_out,
            SP_WE_out => SP_WE_out,
            add_sel_out => add_sel_out,
            mem_addr_sel_out => mem_addr_sel_out,
            mem_data_sel_out => mem_data_sel_out,
            mem_WE_out => mem_WE_out,
            mem_R_out => mem_R_out,
            reg_data_out => reg_data_out,
            reg_WE_out => reg_WE_out,
            ret_out => ret_out,
            INT_state_out => INT_state_out,
            is_load_out => is_load_out,
            swap_state_out => swap_state_out,
            out_enable_out => out_enable_out
        );

    clk_process : process
    begin
        clk <= '0'; wait for CLK_PERIOD / 2;
        clk <= '1'; wait for CLK_PERIOD / 2;
    end process;

    stim_proc : process

        procedure drive_pattern_A is
        begin
            predicted_T <= '1';
            pc <= "000000000100";
            HW_INT_ret <= "000000000010";
            ccr <= "101";
            alu_res <= x"DEADBEEF";
            rsrc1 <= x"11111111";
            rsrc2 <= x"22222222";
            imm <= x"ABCD";
            reg_dst_addr <= "001";
            input_port <= x"CAFEBABE";
            alu_op <= "0101";
            ccr_sel <= "110";
            modify_ccr <= "011";
            branch_op <= "1010";
            newSP_sel <= '1';
            SP_WE <= '1';
            add_sel <= '1';
            mem_addr_sel <= "100";
            mem_data_sel <= "10";
            mem_WE <= '1';
            mem_R <= '1';
            reg_data <= "111";
            reg_WE <= '1';
            ret <= '1';
            INT_state <= "10";
            is_load <= '1';
            swap_state <= "01";
            out_enable <= '1';
        end procedure;

        procedure drive_pattern_B is
        begin
            predicted_T <= '0';
            pc <= "000000010000";
            HW_INT_ret <= "000000001111";
            ccr <= "010";
            alu_res <= x"AAAAAAAA";
            rsrc1 <= x"33333333";
            rsrc2 <= x"44444444";
            imm <= x"1234";
            reg_dst_addr <= "100";
            input_port <= x"FFFFFFFF";
            alu_op <= "0010";
            ccr_sel <= "001";
            modify_ccr <= "100";
            branch_op <= "0101";
            newSP_sel <= '0';
            SP_WE <= '0';
            add_sel <= '0';
            mem_addr_sel <= "010";
            mem_data_sel <= "01";
            mem_WE <= '0';
            mem_R <= '0';
            reg_data <= "010";
            reg_WE <= '0';
            ret <= '0';
            INT_state <= "01";
            is_load <= '0';
            swap_state <= "10";
            out_enable <= '0';
        end procedure;
    begin
        wait for 1 ns;
        assert pc_out = "000000000000" report "FAIL initial pc" severity error;
        assert ccr_out = "000" report "FAIL initial ccr" severity error;
        assert alu_res_out = x"00000000" report "FAIL initial alu_res" severity error;
        assert reg_WE_out = '0' report "FAIL initial reg_WE" severity error;

        write_en <= '0';
        drive_pattern_A;
        wait until rising_edge(clk);
        wait for 1 ns;
        assert pc_out = "000000000000" report "FAIL pc not held" severity error;
        assert ccr_out = "000" report "FAIL ccr not held" severity error;
        assert alu_res_out = x"00000000" report "FAIL alu_res not held" severity error;

        write_en <= '1';
        drive_pattern_A;
        wait until rising_edge(clk);
        wait for 1 ns;
        write_en <= '0';

        assert pc_out = "000000000100" report "FAIL pc" severity error;
        assert HW_INT_ret_out = "000000000010" report "FAIL HW_INT_ret" severity error;
        assert ccr_out = "101" report "FAIL ccr" severity error;
        assert alu_res_out = x"DEADBEEF" report "FAIL alu_res" severity error;
        assert rsrc1_out = x"11111111" report "FAIL rsrc1" severity error;
        assert rsrc2_out = x"22222222" report "FAIL rsrc2" severity error;
        assert imm_out = x"ABCD" report "FAIL imm" severity error;
        assert reg_dst_addr_out = "001" report "FAIL reg_dst_addr" severity error;
        assert input_port_out = x"CAFEBABE" report "FAIL input_port" severity error;
        assert predicted_T_out = '1' report "FAIL predicted_T" severity error;
        assert alu_op_out = "0101" report "FAIL alu_op" severity error;
        assert ccr_sel_out = "110" report "FAIL ccr_sel" severity error;
        assert modify_ccr_out = "011" report "FAIL modify_ccr" severity error;
        assert branch_op_out = "1010" report "FAIL branch_op" severity error;
        assert newSP_sel_out = '1' report "FAIL newSP_sel" severity error;
        assert SP_WE_out = '1' report "FAIL SP_WE" severity error;
        assert add_sel_out = '1' report "FAIL add_sel" severity error;
        assert mem_addr_sel_out = "100" report "FAIL mem_addr_sel" severity error;
        assert mem_data_sel_out = "10" report "FAIL mem_data_sel" severity error;
        assert mem_WE_out = '1' report "FAIL mem_WE" severity error;
        assert mem_R_out = '1' report "FAIL mem_R" severity error;
        assert reg_data_out = "111" report "FAIL reg_data" severity error;
        assert reg_WE_out = '1' report "FAIL reg_WE" severity error;
        assert ret_out = '1' report "FAIL ret" severity error;
        assert INT_state_out = "10" report "FAIL INT_state" severity error;
        assert is_load_out = '1' report "FAIL is_load" severity error;
        assert swap_state_out = "01" report "FAIL swap_state" severity error;
        assert out_enable_out = '1' report "FAIL out_enable" severity error;

        write_en <= '0';
        drive_pattern_B;
        wait until rising_edge(clk);
        wait for 1 ns;
        assert pc_out = "000000000100" report "FAIL pc held" severity error;
        assert ccr_out = "101" report "FAIL ccr held" severity error;
        assert alu_res_out = x"DEADBEEF" report "FAIL alu_res held" severity error;
        assert reg_WE_out = '1' report "FAIL reg_WE held" severity error;

        flush <= '1';
        write_en <= '0';
        wait until rising_edge(clk);
        wait for 1 ns;
        flush <= '0';
        assert pc_out = "000000000000" report "FAIL flushed pc" severity error;
        assert ccr_out = "000" report "FAIL flushed ccr" severity error;
        assert alu_res_out = x"00000000" report "FAIL flushed alu_res" severity error;
        assert reg_WE_out = '0' report "FAIL flushed reg_WE" severity error;
        assert mem_WE_out = '0' report "FAIL flushed mem_WE" severity error;

        write_en <= '1';
        drive_pattern_A;
        wait until rising_edge(clk);
        wait for 1 ns;

        flush <= '1';
        write_en <= '1';
        drive_pattern_B;
        wait until rising_edge(clk);
        wait for 1 ns;
        flush <= '0';
        write_en <= '0';

        assert pc_out = "000000000000" report "FAIL flush>wr pc" severity error;
        assert ccr_out = "000" report "FAIL flush>wr ccr" severity error;
        assert alu_res_out = x"00000000" report "FAIL flush>wr alu_res" severity error;
        assert reg_WE_out = '0' report "FAIL flush>wr reg_WE" severity error;

        write_en <= '1';
        drive_pattern_B;
        wait until rising_edge(clk);
        wait for 1 ns;
        write_en <= '0';

        assert pc_out = "000000010000" report "FAIL B pc" severity error;
        assert ccr_out = "010" report "FAIL B ccr" severity error;
        assert alu_res_out = x"AAAAAAAA" report "FAIL B alu_res" severity error;
        assert rsrc1_out = x"33333333" report "FAIL B rsrc1" severity error;
        assert rsrc2_out = x"44444444" report "FAIL B rsrc2" severity error;
        assert alu_op_out = "0010" report "FAIL B alu_op" severity error;
        assert branch_op_out = "0101" report "FAIL B branch_op" severity error;
        assert reg_WE_out = '0' report "FAIL B reg_WE" severity error;

        report "PASS: EX1EX2_tb";
        wait;
    end process;

end behavior;
