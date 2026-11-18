library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decode_stage is
    port (
        clk : in std_logic;
        rst : in std_logic;

        predicted_t : in std_logic;
        pc : in std_logic_vector(11 downto 0);
        inst : in std_logic_vector(31 downto 0);
        input_port_in : in std_logic_vector(31 downto 0);

        instruction_sel : in std_logic_vector(2 downto 0);
        rsrc1_sel : in std_logic;
        rdst_sel : in std_logic;

        reg_we : in std_logic;
        reg_data_sel : in std_logic_vector(2 downto 0);
        reg_wb_addr : in std_logic_vector(2 downto 0);
        reg_we2 : in std_logic;
        reg_wb2_addr : in std_logic_vector(2 downto 0);
        reg_wb2_data : in std_logic_vector(31 downto 0);
        mem_data_out : in std_logic_vector(31 downto 0);
        imm_wb : in std_logic_vector(15 downto 0);
        alu_res_wb : in std_logic_vector(31 downto 0);
        input_port_wb : in std_logic_vector(31 downto 0);
        rsrc1_wb : in std_logic_vector(31 downto 0);

        hw_int_ret_ex1 : in std_logic_vector(11 downto 0);

        predicted_t_out : out std_logic;
        hw_int_ret : out std_logic_vector(11 downto 0);
        pc_out : out std_logic_vector(11 downto 0);
        rsrc1 : out std_logic_vector(31 downto 0);
        rsrc2 : out std_logic_vector(31 downto 0);
        imm : out std_logic_vector(15 downto 0);
        reg_dst_addr : out std_logic_vector(2 downto 0);
        rsrc1_addr : out std_logic_vector(2 downto 0);
        rsrc2_addr : out std_logic_vector(2 downto 0);
        input_port_out : out std_logic_vector(31 downto 0);
        hlt : out std_logic;
        out_enable : out std_logic;
        swap_state : out std_logic_vector(1 downto 0);
        is_load : out std_logic;
        int_state : out std_logic_vector(1 downto 0);
        ret : out std_logic;
        reg_we_out : out std_logic;
        reg_data_out : out std_logic_vector(2 downto 0);
        mem_r : out std_logic;
        mem_we : out std_logic;
        mem_data_sel : out std_logic_vector(1 downto 0);
        mem_addr_sel : out std_logic_vector(2 downto 0);
        add_sel : out std_logic;
        sp_we : out std_logic;
        new_sp_sel : out std_logic;
        branch_op : out std_logic_vector(3 downto 0);
        modify_fl : out std_logic_vector(2 downto 0);
        ccr_sel : out std_logic_vector(2 downto 0);
        alu_op : out std_logic_vector(3 downto 0);
        alu_src : out std_logic;

        int_state_hz : out std_logic_vector(1 downto 0);
        swap_state_hz : out std_logic_vector(1 downto 0)
    );
end entity;

architecture rtl of decode_stage is
    type ctrl_t is record
        alu_src : std_logic;
        alu_op : std_logic_vector(3 downto 0);
        ccr_sel : std_logic_vector(2 downto 0);
        mod_fl : std_logic_vector(2 downto 0);
        branch_op : std_logic_vector(3 downto 0);
        newSP_sel : std_logic;
        SP_WE : std_logic;
        add_sel : std_logic;
        mem_addr_sel : std_logic_vector(2 downto 0);
        mem_data_sel : std_logic_vector(1 downto 0);
        mem_we : std_logic;
        mem_r : std_logic;
        reg_data : std_logic_vector(2 downto 0);
        reg_we : std_logic;
        ret : std_logic;
        int_state : std_logic_vector(1 downto 0);
        is_load : std_logic;
        swap_state : std_logic_vector(1 downto 0);
        swap_reg_enable : std_logic;
        hlt : std_logic;
        out_enable : std_logic;
    end record;

    -- A bubble must have no register, memory, flag or output side effects.
    constant CTRL_NOP : ctrl_t := (
        alu_src => '0',
        alu_op => "0000",
        ccr_sel => "000",
        mod_fl => "000",
        branch_op => "0000",
        newSP_sel => '0',
        SP_WE => '0',
        add_sel => '0',
        mem_addr_sel => "000",
        mem_data_sel => "00",
        mem_we => '0',
        mem_r => '0',
        reg_data => "000",
        reg_we => '0',
        ret => '0',
        int_state => "00",
        is_load => '0',
        swap_state => "00",
        swap_reg_enable => '0',
        hlt => '0',
        out_enable => '0'
    );

    signal cu_raw : ctrl_t;

    signal cu_out : ctrl_t;

    signal wb_write_data : std_logic_vector(31 downto 0);
    signal imm_wb_sext : std_logic_vector(31 downto 0);
    signal swap1 : std_logic_vector(2 downto 0);
    signal swap2 : std_logic_vector(2 downto 0);
    signal selected_rsrc1_addr : std_logic_vector(2 downto 0);
    signal selected_rdst_addr : std_logic_vector(2 downto 0);

    signal int_idx : std_logic := '0';
begin
    process (clk, rst)
    begin
        if rst = '1' then
            swap1 <= (others => '0');
            swap2 <= (others => '0');
        elsif rising_edge(clk) then
            if cu_out.swap_reg_enable = '1' then
                swap1 <= inst(22 downto 20);
                swap2 <= inst(25 downto 23);
            end if;
        end if;
    end process;

    process (clk, rst)
    begin
        if rst = '1' then
            int_idx <= '0';
        elsif rising_edge(clk) then
            if cu_raw.int_state = "01" then
                int_idx <= inst(16);
            end if;
        end if;
    end process;

    with rsrc1_sel select selected_rsrc1_addr <=
        inst(22 downto 20) when '0',
        swap2 when '1',
        (others => '0') when others;

    with rdst_sel select selected_rdst_addr <=
        inst(25 downto 23) when '0',
        swap1 when '1',
        (others => '0') when others;

    u_sign_extend: entity work.sign_extend
        port map (
            imm_16bit => imm_wb,
            imm_32bit => imm_wb_sext
        );

    u_reg_file: entity work.register_file
        port map (
            clk => clk,
            rst => rst,
            reg_write_en => reg_we,
            reg_write_addr => reg_wb_addr,
            reg_write_data => wb_write_data,
            reg_write2_en => reg_we2,
            reg_write2_addr => reg_wb2_addr,
            reg_write2_data => reg_wb2_data,
            reg_read_addr1 => selected_rsrc1_addr,
            reg_read_addr2 => inst(19 downto 17),
            reg_read_data1 => rsrc1,
            reg_read_data2 => rsrc2
        );

    u_control_unit: entity work.control_unit
        port map (
            opcode => inst(31 downto 26),
            alu_src => cu_raw.alu_src,
            alu_op => cu_raw.alu_op,
            ccr_sel => cu_raw.ccr_sel,
            mod_fl => cu_raw.mod_fl,
            branch_op => cu_raw.branch_op,
            newSP_sel => cu_raw.newSP_sel,
            SP_WE => cu_raw.SP_WE,
            add_sel => cu_raw.add_sel,
            mem_addr_sel => cu_raw.mem_addr_sel,
            mem_data_sel => cu_raw.mem_data_sel,
            mem_we => cu_raw.mem_we,
            mem_r => cu_raw.mem_r,
            reg_data => cu_raw.reg_data,
            reg_we => cu_raw.reg_we,
            ret => cu_raw.ret,
            int_state => cu_raw.int_state,
            is_load => cu_raw.is_load,
            swap_state => cu_raw.swap_state,
            swap_reg_enable => cu_raw.swap_reg_enable,
            hlt => cu_raw.hlt,
            out_enable => cu_raw.out_enable
        );

    -- Start injected steps as NOPs, then enable only their required controls.
    process (all)
        variable controls : ctrl_t;
    begin
        controls := CTRL_NOP;
        case instruction_sel is
            when "000" =>
                controls := cu_raw;
            when "010" => -- Read the selected software interrupt vector.
                if int_idx = '0' or int_idx = '1' then
                    controls.mem_r := '1';
                    controls.int_state := "10";
                    if int_idx = '0' then
                        controls.mem_addr_sel := "100";
                    else
                        controls.mem_addr_sel := "101";
                    end if;
                end if;
            when "011" => -- Complete SWAP.
                controls.alu_op := "0110";
                controls.reg_data := "101";
                controls.reg_we := '1';
                controls.swap_state := "10";
            when "100" => -- Save the hardware interrupt return PC.
                controls.branch_op := "0111";
                controls.newSP_sel := '1';
                controls.SP_WE := '1';
                controls.mem_addr_sel := "010";
                controls.mem_data_sel := "11";
                controls.mem_we := '1';
                controls.int_state := "01";
            when "101" => -- Read the hardware interrupt vector.
                controls.mem_addr_sel := "110";
                controls.mem_r := '1';
                controls.int_state := "10";
            when others => null;
        end case;
        cu_out <= controls;
    end process;

    alu_src <= cu_out.alu_src;
    alu_op <= cu_out.alu_op;
    ccr_sel <= cu_out.ccr_sel;
    modify_fl <= cu_out.mod_fl;
    branch_op <= cu_out.branch_op;
    new_sp_sel <= cu_out.newSP_sel;
    sp_we <= cu_out.SP_WE;
    add_sel <= cu_out.add_sel;
    mem_addr_sel <= cu_out.mem_addr_sel;
    mem_data_sel <= cu_out.mem_data_sel;
    mem_we <= cu_out.mem_we;
    mem_r <= cu_out.mem_r;
    reg_data_out <= cu_out.reg_data;
    reg_we_out <= cu_out.reg_we;
    ret <= cu_out.ret;
    int_state <= cu_out.int_state;
    is_load <= cu_out.is_load;
    swap_state <= cu_out.swap_state;
    hlt <= cu_out.hlt;
    out_enable <= cu_out.out_enable;

    with reg_data_sel select wb_write_data <=
        mem_data_out when "001",
        imm_wb_sext when "010",
        alu_res_wb when "011",
        input_port_wb when "100",
        rsrc1_wb when "101",
        (others => '0') when others;

    rsrc1_addr <= selected_rsrc1_addr;
    rsrc2_addr <= inst(19 downto 17);
    reg_dst_addr <= selected_rdst_addr;
    imm <= std_logic_vector(resize(unsigned(selected_rsrc1_addr), 16)) when cu_out.swap_state = "01" else
        inst(15 downto 0);
    pc_out <= pc;
    predicted_t_out <= predicted_t;
    input_port_out <= input_port_in;
    hw_int_ret <= hw_int_ret_ex1;
    int_state_hz <= cu_out.int_state;
    swap_state_hz <= cu_out.swap_state;
end architecture;
