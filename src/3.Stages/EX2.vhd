

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

-- EX2 stage: updates flags, resolves branches, and calculates memory addresses.
entity EX2 is
  port (




    clk                                 : in  std_logic;
    rst                                 : in  std_logic;

    HLT_in_ex1_ex2                      : in  std_logic;
    HLT_out_ex2_mem                     : out std_logic;

    out_enable_in_ex1_ex2               : in  std_logic;
    out_enable_out_ex2_mem              : out std_logic;

    swap_state_in_ex1_ex2               : in  std_logic_vector(1 downto 0);
    swap_state_out_hazard_fwd_ex2_mem   : out std_logic_vector(1 downto 0);

    is_load_in_ex1_ex2                  : in  std_logic;
    is_load_out_hazard_ex2_mem          : out std_logic;

    INT_state_in_ex1_ex2                : in  std_logic_vector(1 downto 0);
    INT_state_out_hazard_bccr_ex2_mem   : out std_logic_vector(1 downto 0);

    ret_in_ex1_ex2                      : in  std_logic;
    ret_out_hazard_ex2_mem              : out std_logic;

    reg_WE_in_ex1_ex2                   : in  std_logic;
    reg_WE_out_fwd_ex2_mem              : out std_logic;

    reg_data_in_ex1_ex2                 : in  std_logic_vector(2 downto 0);
    reg_data_out_ex2_mem                : out std_logic_vector(2 downto 0);

    mem_R_in_ex1_ex2                    : in  std_logic;
    mem_R_out_hazard_ex2_mem            : out std_logic;

    mem_WE_in_ex1_ex2                   : in  std_logic;
    mem_WE_out_ex2_mem                  : out std_logic;

    mem_data_sel_in_ex1_ex2             : in  std_logic_vector(1 downto 0);
    mem_data_sel_out_ex2_mem            : out std_logic_vector(1 downto 0);

    mem_addr_sel_in_ex1_ex2             : in  std_logic_vector(2 downto 0);
    mem_addr_sel_out_ex2_mem            : out std_logic_vector(2 downto 0);


    add_sel_in_ex1_ex2                  : in  std_logic;

    SP_WE_in_ex1_ex2                    : in  std_logic;
    SP_WE_out_ex2_mem                   : out std_logic;

    newSP_sel_in_ex1_ex2                : in  std_logic;
    newSP_sel_out_ex2_mem               : out std_logic;


    branch_op_in_ex1_ex2                : in  std_logic_vector(3 downto 0);
    modify_fl_in_ex1_ex2                : in  std_logic_vector(2 downto 0);
    ccr_sel_in_ex1_ex2                  : in  std_logic_vector(2 downto 0);

    alu_op_in_ex1_ex2                   : in  std_logic_vector(3 downto 0);
    alu_op_out_fwd_ex2_mem              : out std_logic_vector(3 downto 0);

    pc_in_ex1_ex2                       : in  std_logic_vector(11 downto 0);

    pc_out_branch_ex2_mem               : out std_logic_vector(11 downto 0);

    HW_INT_ret_in_ex1_ex2               : in  std_logic_vector(11 downto 0);
    HW_INT_ret_out_ex2_mem              : out std_logic_vector(11 downto 0);





    ccr_in_ex1_ex2                      : in  std_logic_vector(2 downto 0);


    alu_result_in_ex1_ex2               : in  std_logic_vector(31 downto 0);
    alu_result_out_ex2_mem              : out std_logic_vector(31 downto 0);

    rsrc1_in_ex1_ex2                    : in  std_logic_vector(31 downto 0);
    rsrc1_out_ex2_mem                   : out std_logic_vector(31 downto 0);


    rsrc2_in_ex1_ex2                    : in  std_logic_vector(31 downto 0);
    rsrc2_out_ex2_mem                   : out std_logic_vector(31 downto 0);

    imm_in_ex1_ex2                      : in  std_logic_vector(15 downto 0);
    imm_out_ex2_mem                     : out std_logic_vector(15 downto 0);

    reg_dst_addr_in_ex1_ex2             : in  std_logic_vector(2 downto 0);
    reg_dst_addr_out_hazard_fwd_ex2_mem : out std_logic_vector(2 downto 0);

    input_port_in_ex1_ex2               : in  std_logic_vector(31 downto 0);
    input_port_out_ex2_mem              : out std_logic_vector(31 downto 0);





    add_result_out_ex2_mem              : out std_logic_vector(11 downto 0);


    branch_decision_out_hazard          : out std_logic;




    restore_flags_in                    : in  std_logic
  );
end entity;

-- Architecture block: contains the internal signals, instances, and logic for this entity.
architecture rtl of EX2 is

  -- Declarations block: names the internal wires, storage, constants, and submodules used below.
  signal ccr_str      : std_logic_vector(2 downto 0);
  signal bccr_str     : std_logic_vector(2 downto 0);
  signal add_operand1 : std_logic_vector(31 downto 0);
  signal add_operand2 : std_logic_vector(31 downto 0);
  signal add_sum      : std_logic_vector(31 downto 0);

begin


  -- Process block: describes behavior that runs when its sensitivity signals change or a clock edge occurs.
  process (clk, rst)
  begin
    if rst = '1' then
      bccr_str <= (others => '0');
    elsif rising_edge(clk) then
      if INT_state_in_ex1_ex2 = "01" then
        bccr_str <= ccr_str;
      end if;
    end if;
  end process;
















  -- Process block: describes behavior that runs when its sensitivity signals change or a clock edge occurs.
  process (clk, rst)
    variable v_ccr : std_logic_vector(2 downto 0);
  begin
    if rst = '1' then
      ccr_str <= (others => '0');
    elsif rising_edge(clk) then
      if restore_flags_in = '1' then
        ccr_str <= bccr_str;
      else

        -- Case block: chooses behavior for the current operation/control value.
        case ccr_sel_in_ex1_ex2 is
          when "000" => v_ccr := ccr_str;
          when "001" => v_ccr := ccr_str(2) & ccr_str(1) & ccr_in_ex1_ex2(0);
          when "010" => v_ccr := ccr_str(2) & ccr_in_ex1_ex2(1) & ccr_str(0);
          when "011" => v_ccr := ccr_in_ex1_ex2(2) & ccr_str(1) & ccr_str(0);
          when "100" => v_ccr := ccr_str(2) & ccr_in_ex1_ex2(1) & ccr_in_ex1_ex2(0);
          when "101" => v_ccr := ccr_in_ex1_ex2(2) & ccr_str(1) & ccr_in_ex1_ex2(0);
          when "110" => v_ccr := ccr_in_ex1_ex2(2) & ccr_in_ex1_ex2(1) & ccr_str(0);
          when "111" => v_ccr := ccr_in_ex1_ex2;
          when others => v_ccr := ccr_str;
        end case;


        -- Case block: chooses behavior for the current operation/control value.
        case modify_fl_in_ex1_ex2 is
          when "001" => v_ccr(2) := '1';
          when "010" => v_ccr(0) := '0';
          when "011" => v_ccr(1) := '0';
          when "100" => v_ccr(2) := '0';
          when others => null;
        end case;

        ccr_str <= v_ccr;
      end if;
    end if;
  end process;







  -- Multiplexer block: selects one output value from several choices based on a control signal.
  with add_sel_in_ex1_ex2 select add_operand1 <=
    rsrc1_in_ex1_ex2    when '0',
    rsrc2_in_ex1_ex2    when '1',
    (others => '0')     when others;

  add_operand2 <= (31 downto 16 => '0') & imm_in_ex1_ex2;
  add_sum      <= std_logic_vector(unsigned(add_operand1) + unsigned(add_operand2));

  add_result_out_ex2_mem <= add_sum(11 downto 0);








  branch_decision_out_hazard <= '1' when ((branch_op_in_ex1_ex2 = "0100" or branch_op_in_ex1_ex2 = "0101") or
                                          (branch_op_in_ex1_ex2 = "0001" and ccr_str(0) = '1') or
                                          (branch_op_in_ex1_ex2 = "0010" and ccr_str(1) = '1') or
                                          (branch_op_in_ex1_ex2 = "0011" and ccr_str(2) = '1'))
                                else '0';




  HLT_out_ex2_mem                     <= HLT_in_ex1_ex2;
  out_enable_out_ex2_mem              <= out_enable_in_ex1_ex2;
  swap_state_out_hazard_fwd_ex2_mem   <= swap_state_in_ex1_ex2;
  is_load_out_hazard_ex2_mem          <= is_load_in_ex1_ex2;
  INT_state_out_hazard_bccr_ex2_mem   <= INT_state_in_ex1_ex2;
  ret_out_hazard_ex2_mem              <= ret_in_ex1_ex2;
  reg_WE_out_fwd_ex2_mem              <= reg_WE_in_ex1_ex2;
  reg_data_out_ex2_mem                <= reg_data_in_ex1_ex2;
  mem_R_out_hazard_ex2_mem            <= mem_R_in_ex1_ex2;
  mem_WE_out_ex2_mem                  <= mem_WE_in_ex1_ex2;
  mem_data_sel_out_ex2_mem            <= mem_data_sel_in_ex1_ex2;
  mem_addr_sel_out_ex2_mem            <= mem_addr_sel_in_ex1_ex2;
  SP_WE_out_ex2_mem                   <= SP_WE_in_ex1_ex2;
  newSP_sel_out_ex2_mem               <= newSP_sel_in_ex1_ex2;
  alu_op_out_fwd_ex2_mem              <= alu_op_in_ex1_ex2;
  pc_out_branch_ex2_mem               <= pc_in_ex1_ex2;
  HW_INT_ret_out_ex2_mem              <= HW_INT_ret_in_ex1_ex2;

  alu_result_out_ex2_mem              <= alu_result_in_ex1_ex2;
  rsrc1_out_ex2_mem                   <= rsrc1_in_ex1_ex2;
  rsrc2_out_ex2_mem                   <= rsrc2_in_ex1_ex2;
  imm_out_ex2_mem                     <= imm_in_ex1_ex2;
  reg_dst_addr_out_hazard_fwd_ex2_mem <= reg_dst_addr_in_ex1_ex2;
  input_port_out_ex2_mem              <= input_port_in_ex1_ex2;

end architecture;
