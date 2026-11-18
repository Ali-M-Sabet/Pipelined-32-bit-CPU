library ieee;
use ieee.std_logic_1164.all;

entity hazard_unit is
    port (
        rst : in std_logic;

        instruction_sel_decode : out std_logic_vector(2 downto 0);
        pc_we : out std_logic;

        inst_in_ifid : in std_logic_vector(31 downto 0);

        rdst_in_id_ex1 : in std_logic_vector(2 downto 0);
        is_load_from_IDEX1 : in std_logic;
        mem_r_from_id_ex1 : in std_logic;

        ret_from_id_ex1 : in std_logic;
        int_state_id_ex1 : in std_logic_vector(1 downto 0);
        hw_interrupt_active : in std_logic;
        hw_decode_drained : in std_logic;

        halt_in_ex1_ex2 : in std_logic;
        is_load_from_EX1EX2 : in std_logic;
        rdst_in_ex1_ex2 : in std_logic_vector(2 downto 0);
        mem_r_from_ex1_ex2 : in std_logic;
        predicted_t_from_EX1EX2 : in std_logic;
        ret_from_ex1_ex2 : in std_logic;
        int_state_ex1_ex2 : in std_logic_vector(1 downto 0);

        branch_decision_from_EX2 : in std_logic;

        ret_from_ex2_mem : in std_logic;
        int_state_ex2_mem : in std_logic_vector(1 downto 0);

        ret_from_mem_wb : in std_logic;
        int_state_mem_wb : in std_logic_vector(1 downto 0);

        rsrc1_sel_decode : out std_logic;
        rdst_sel_decode : out std_logic;
        pc_src_sel : out std_logic_vector(2 downto 0);
        we_if_id : out std_logic;
        we_id_ex1 : out std_logic;
        we_ex1_ex2 : out std_logic;
        restore_flags_ex2 : out std_logic;

        flush_if : out std_logic;
        flush_id : out std_logic;
        flush_ex1 : out std_logic;
        flush_ex2 : out std_logic;
        flush_mem : out std_logic
    );
end entity;

architecture rtl of hazard_unit is
    signal rsrc1_addr : std_logic_vector(2 downto 0) := (others => '0');
    signal rsrc2_addr : std_logic_vector(2 downto 0) := (others => '0');
begin
    rsrc1_addr <= inst_in_ifid(22 downto 20);
    rsrc2_addr <= inst_in_ifid(19 downto 17);

    process (all)
    begin
        flush_if <= '0';
        flush_id <= '0';
        flush_ex1 <= '0';
        flush_ex2 <= '0';
        flush_mem <= '0';
        we_ex1_ex2 <= '1';
        we_id_ex1 <= '1';
        we_if_id <= '1';
        instruction_sel_decode <= "000";
        pc_we <= '1';
        pc_src_sel <= "000";
        rsrc1_sel_decode <= '0';
        rdst_sel_decode <= '0';
        restore_flags_ex2 <= '0';

        if rst = '1' then
            flush_if <= '1';
            flush_id <= '1';
            flush_ex1 <= '1';
            flush_ex2 <= '1';
            flush_mem <= '1';
            pc_we <= '0';

        elsif halt_in_ex1_ex2 = '1' then
            pc_we <= '0';
            we_ex1_ex2 <= '0';
            we_id_ex1 <= '0';
            we_if_id <= '0';
            instruction_sel_decode <= "001";

        elsif ret_from_id_ex1 = '1' or ret_from_ex1_ex2 = '1' or ret_from_ex2_mem = '1' then
            pc_we <= '0';
            instruction_sel_decode <= "001";

        elsif ret_from_mem_wb = '1' then
            flush_if <= '1';
            pc_we <= '1';
            instruction_sel_decode <= "001";
            pc_src_sel <= "011";
            if int_state_mem_wb = "11" then
                restore_flags_ex2 <= '1';
            end if;

        elsif (branch_decision_from_EX2 = '1' and predicted_t_from_EX1EX2 = '0') then
            flush_if <= '1';
            flush_id <= '1';
            flush_ex1 <= '1';
            pc_src_sel <= "001";

        elsif (branch_decision_from_EX2 = '0' and predicted_t_from_EX1EX2 = '1') then
            flush_if <= '1';
            flush_id <= '1';
            flush_ex1 <= '1';
            pc_src_sel <= "010";

        elsif hw_interrupt_active = '1' and int_state_id_ex1 = "01" then
            pc_we <= '0';
            we_if_id <= '0';
            instruction_sel_decode <= "101";

        elsif int_state_id_ex1 = "01" then
            pc_we <= '0';
            we_if_id <= '0';
            instruction_sel_decode <= "010";

        elsif int_state_id_ex1 = "10" or int_state_ex1_ex2 = "10" or int_state_ex2_mem = "10" then
            pc_we <= '0';
            we_if_id <= '0';
            instruction_sel_decode <= "001";

        elsif int_state_mem_wb = "10" then
            flush_if <= '1';
            pc_we <= '1';
            instruction_sel_decode <= "001";
            pc_src_sel <= "011";

        elsif (is_load_from_IDEX1 = '1' and mem_r_from_id_ex1 = '1' and (rdst_in_id_ex1 = rsrc1_addr or rdst_in_id_ex1 = rsrc2_addr))
                    or (is_load_from_EX1EX2 = '1' and mem_r_from_ex1_ex2 = '1' and (rdst_in_ex1_ex2 = rsrc1_addr or rdst_in_ex1_ex2 = rsrc2_addr))
        then
            pc_we <= '0';
            we_if_id <= '0';
            instruction_sel_decode <= "001";

        elsif hw_interrupt_active = '1' and hw_decode_drained = '0' then
            pc_we <= '0';
            flush_if <= '1';

        elsif hw_interrupt_active = '1' then
            pc_we <= '0';
            we_if_id <= '0';
            instruction_sel_decode <= "100";

        end if;
    end process;
end architecture;
