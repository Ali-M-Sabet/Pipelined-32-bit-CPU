library ieee;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

-- Memory stage: handles data memory addressing, writes, reads, and stack pointer updates.
entity memory_stage is
  port (
    clk                : in  std_logic;
    rst                : in  std_logic;


    HLT                : in  std_logic;
    out_enable         : in  std_logic;
    swap_state         : in  std_logic_vector(1 downto 0);
    is_load            : in  std_logic;
    INT_state          : in  std_logic_vector(1 downto 0);
    ret                : in  std_logic;
    reg_WE             : in  std_logic;
    reg_data           : in  std_logic_vector(2 downto 0);
    mem_R              : in  std_logic;
    mem_WE             : in  std_logic;
    mem_data_sel       : in  std_logic_vector(1 downto 0);
    mem_addr_sel       : in  std_logic_vector(2 downto 0);
    SP_WE              : in  std_logic;
    newSP_sel          : in  std_logic;
    alu_op             : in  std_logic_vector(3 downto 0);
    pc                 : in  std_logic_vector(11 downto 0);
    HW_INT_ret         : in  std_logic_vector(11 downto 0);
    alu_res            : in  std_logic_vector(31 downto 0);
    add_result         : in  std_logic_vector(11 downto 0);
    rsrc1              : in  std_logic_vector(31 downto 0);
    rsrc2              : in  std_logic_vector(31 downto 0);
    imm                : in  std_logic_vector(15 downto 0);
    reg_dst_addr       : in  std_logic_vector(2 downto 0);
    input_port         : in  std_logic_vector(31 downto 0);


    mem_data_out       : in  std_logic_vector(31 downto 0);


    HLT_out            : out std_logic;
    out_enable_out     : out std_logic;
    is_load_out        : out std_logic;
    SW_INTDone_out     : out std_logic_vector(1 downto 0);
    ret_out            : out std_logic;
    reg_WE_out         : out std_logic;
    reg_data_out       : out std_logic_vector(2 downto 0);
    alu_op_out         : out std_logic_vector(3 downto 0);
    alu_res_out        : out std_logic_vector(31 downto 0);
    rsrc1_out          : out std_logic_vector(31 downto 0);
    rsrc2_out          : out std_logic_vector(31 downto 0);
    imm_out            : out std_logic_vector(15 downto 0);
    reg_dst_addr_out   : out std_logic_vector(2 downto 0);
    input_port_out     : out std_logic_vector(31 downto 0);
    mem_data_out_to_wb : out std_logic_vector(31 downto 0);


    swap_state_out     : out std_logic_vector(1 downto 0);
    mem_R_out          : out std_logic;
    mem_WE_out         : out std_logic;
    mem_addr           : out std_logic_vector(11 downto 0);
    mem_write_data     : out std_logic_vector(31 downto 0)
  );
end entity;

-- Architecture block: contains the internal signals, instances, and logic for this entity.
architecture rtl of memory_stage is


  -- Declarations block: names the internal wires, storage, constants, and submodules used below.
  signal SP            : std_logic_vector(11 downto 0);
  signal newSP         : std_logic_vector(11 downto 0);
  signal sp_plus1      : std_logic_vector(11 downto 0);
  signal sp_minus1     : std_logic_vector(11 downto 0);
  signal pc_plus1      : std_logic_vector(11 downto 0);
  signal pc_plus1_32   : std_logic_vector(31 downto 0);
  signal HW_INT_ret_32 : std_logic_vector(31 downto 0);

begin


  sp_plus1  <= std_logic_vector(unsigned(SP) + 1);
  sp_minus1 <= std_logic_vector(unsigned(SP) - 1);

  newSP <= sp_plus1 when (newSP_sel = '0') else sp_minus1;

  -- Process block: describes behavior that runs when its sensitivity signals change or a clock edge occurs.
  process (clk, rst)
  begin
    if (rst = '1') then
      SP <= (others => '1');
    elsif rising_edge(clk) then
      if (SP_WE = '1') then
        SP <= newSP;
      end if;
    end if;
  end process;


  -- Multiplexer block: selects one output value from several choices based on a control signal.
  with mem_addr_sel select
    mem_addr <= add_result                           when "001",
                SP                                   when "010",
                sp_plus1                             when "011",
                std_logic_vector(to_unsigned(2, 12)) when "100",
                std_logic_vector(to_unsigned(3, 12)) when "101",
                std_logic_vector(to_unsigned(1, 12)) when "110",
                    (others => '0')                  when others;

  pc_plus1                    <= std_logic_vector(unsigned(pc) + 1);
  pc_plus1_32(31 downto 12)   <= (others => '0');
  pc_plus1_32(11 downto 0)     <= pc_plus1;
  HW_INT_ret_32(31 downto 12) <= (others => '0');
  HW_INT_ret_32(11 downto 0)   <= HW_INT_ret;


  -- Multiplexer block: selects one output value from several choices based on a control signal.
  with mem_data_sel select
    mem_write_data <= rsrc1               when "01",
                      pc_plus1_32         when "10",
                      HW_INT_ret_32       when "11",
                          (others => '0') when others;


  HLT_out            <= HLT;
  out_enable_out     <= out_enable;
  is_load_out        <= is_load;
  SW_INTDone_out     <= INT_state;
  ret_out            <= ret;
  reg_WE_out         <= reg_WE;
  reg_data_out       <= reg_data;
  alu_op_out         <= alu_op;
  alu_res_out        <= alu_res;
  rsrc1_out          <= rsrc1;
  rsrc2_out          <= rsrc2;
  mem_data_out_to_wb <= mem_data_out;
  imm_out            <= imm;
  reg_dst_addr_out   <= reg_dst_addr;
  input_port_out     <= input_port;


  swap_state_out <= swap_state;
  mem_R_out      <= mem_R;
  mem_WE_out     <= mem_WE;

end architecture;
