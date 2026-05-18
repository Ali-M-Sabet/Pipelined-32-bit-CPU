
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

-- Fetch stage: holds the PC and chooses the next instruction address.
entity fetch_stage is
  port (
    clk                      : in  std_logic;
    rst                      : in  std_logic;


    predicted_taken          : out std_logic;
    pc_current               : out std_logic_vector(11 downto 0);
    input_port_passthrough   : out std_logic_vector(31 downto 0);
    inst_to_ifid             : out std_logic_vector(31 downto 0);


    inst_mem_addr            : out std_logic_vector(11 downto 0);


    branch_prediction_result : in  std_logic_vector(1 downto 0);
    pc_write_en              : in  std_logic;
    pc_src_sel               : in  std_logic_vector(2 downto 0);


    branch_target_addr       : in  std_logic_vector(11 downto 0);
    branch_fallthrough_addr  : in  std_logic_vector(11 downto 0);


    instruction_word         : in  std_logic_vector(31 downto 0);


    mem_read_addr            : in  std_logic_vector(31 downto 0);


    input_port               : in  std_logic_vector(31 downto 0)
  );
end entity;

-- Architecture block: contains the internal signals, instances, and logic for this entity.
architecture rtl of fetch_stage is


  -- Declarations block: names the internal wires, storage, constants, and submodules used below.
  signal pc_reg : std_logic_vector(11 downto 0) := (others => '0');


  signal pc_plus1 : std_logic_vector(11 downto 0);



  signal pc_in      : std_logic_vector(11 downto 0);
  signal pc_mux_mid : std_logic_vector(11 downto 0);


  signal predicted             : std_logic;
  signal branch_predicted_addr : std_logic_vector(11 downto 0);


  signal conditional_jmp_addr : std_logic_vector(11 downto 0);

begin




  -- Multiplexer block: selects one output value from several choices based on a control signal.
  with pc_src_sel select pc_in <=
    pc_mux_mid              when "000",
    branch_target_addr      when "001",
    branch_fallthrough_addr            when "010",
    mem_read_addr(11 downto 0) when "011",
        (others => '0')     when others;



  pc_plus1 <= std_logic_vector(unsigned(pc_reg) + 1);

  -- Process block: describes behavior that runs when its sensitivity signals change or a clock edge occurs.
  process (clk, rst)
  begin
    if rst = '1' then
      pc_reg <= instruction_word(11 downto 0);
    elsif rising_edge(clk) then
      if pc_write_en = '1' then
        pc_reg <= pc_in;
      end if;
    end if;
  end process;

  pc_current    <= pc_reg;
  inst_mem_addr <= pc_reg;




  predicted <= branch_prediction_result(1);
  conditional_jmp_addr <= instruction_word(11 downto 0);

  -- Multiplexer block: selects one output value from several choices based on a control signal.
  with predicted select pc_mux_mid <=
    pc_plus1             when '0',
    conditional_jmp_addr when '1',
        (others => '0')  when others;


  inst_to_ifid           <= instruction_word;
  predicted_taken        <= predicted;
  input_port_passthrough <= input_port;

end architecture;
