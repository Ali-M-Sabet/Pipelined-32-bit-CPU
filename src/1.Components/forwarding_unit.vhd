library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

-- Forwarding unit: chooses newer pipeline values when an instruction needs data that has not reached write-back yet.
entity forwarding_unit is
  port (

    rsrc1_addr           : in  std_logic_vector(2 downto 0);
    rsrc2_addr           : in  std_logic_vector(2 downto 0);
    swap_state           : in  std_logic_vector(1 downto 0);



    reg_WE_ex1_ex2       : in  std_logic;
    reg_dst_addr_ex1_ex2 : in  std_logic_vector(2 downto 0);
    reg_data_ex1_ex2     : in  std_logic_vector(2 downto 0);
    swap_state_ex1_ex2   : in  std_logic_vector(1 downto 0);
    swap_addr_ex1_ex2    : in  std_logic_vector(2 downto 0);


    reg_data_ex2_mem     : in  std_logic_vector(2 downto 0);
    reg_dst_addr_ex2_mem : in  std_logic_vector(2 downto 0);
    reg_WE_ex2_mem       : in  std_logic;
    swap_state_ex2_mem   : in  std_logic_vector(1 downto 0);
    swap_addr_ex2_mem    : in  std_logic_vector(2 downto 0);


    reg_WE_mem_wb        : in  std_logic;
    reg_dst_addr_mem_wb  : in  std_logic_vector(2 downto 0);
    reg_data_mem_wb      : in  std_logic_vector(2 downto 0);
    swap_state_mem_wb    : in  std_logic_vector(1 downto 0);
    swap_addr_mem_wb     : in  std_logic_vector(2 downto 0);


    operand1_sel         : out std_logic_vector(3 downto 0);
    operand2_sel         : out std_logic_vector(3 downto 0)
  );
end entity;

-- Architecture block: contains the internal signals, instances, and logic for this entity.
architecture rtl of forwarding_unit is











  -- Declarations block: names the internal wires, storage, constants, and submodules used below.
  signal block_ex1_ex2_fwd : std_logic;

begin

  block_ex1_ex2_fwd <= '1' when swap_state = "10" else '0';

  -- Process block: describes behavior that runs when its sensitivity signals change or a clock edge occurs.
  process (rsrc1_addr, rsrc2_addr, block_ex1_ex2_fwd, reg_WE_ex1_ex2, reg_dst_addr_ex1_ex2, reg_data_ex1_ex2, swap_state_ex1_ex2, swap_addr_ex1_ex2, reg_WE_ex2_mem, reg_dst_addr_ex2_mem, reg_data_ex2_mem, swap_state_ex2_mem, swap_addr_ex2_mem, reg_WE_mem_wb, reg_dst_addr_mem_wb, reg_data_mem_wb, swap_state_mem_wb, swap_addr_mem_wb)
  begin

    operand1_sel <= (others => '0');
    operand2_sel <= (others => '0');



    if ((reg_WE_ex1_ex2 = '1') and (reg_dst_addr_ex1_ex2 = rsrc1_addr) and (block_ex1_ex2_fwd = '0')) then
      if (reg_data_ex1_ex2 = "010") then
        operand1_sel <= "0101";
      elsif (reg_data_ex1_ex2 = "011" or reg_data_ex1_ex2 = "101") then
        operand1_sel <= "0001";
      elsif (reg_data_ex1_ex2 = "100") then
        operand1_sel <= "1000";

      end if;


    elsif ((reg_WE_ex1_ex2 = '1') and (swap_state_ex1_ex2 = "01") and (swap_addr_ex1_ex2 = rsrc1_addr)) then
      operand1_sel <= "1011";

    elsif ((reg_WE_ex2_mem = '1') and (reg_dst_addr_ex2_mem = rsrc1_addr)) then
      if (reg_data_ex2_mem = "010") then
        operand1_sel <= "0110";
      elsif (reg_data_ex2_mem = "011" or reg_data_ex2_mem = "101") then
        operand1_sel <= "0010";
      elsif (reg_data_ex2_mem = "100") then
        operand1_sel <= "1001";
      end if;


    elsif ((reg_WE_ex2_mem = '1') and (swap_state_ex2_mem = "01") and (swap_addr_ex2_mem = rsrc1_addr)) then
      operand1_sel <= "1100";

    elsif ((reg_WE_mem_wb = '1') and (reg_dst_addr_mem_wb = rsrc1_addr)) then
      if (reg_data_mem_wb = "001") then
        operand1_sel <= "0100";
      elsif (reg_data_mem_wb = "010") then
        operand1_sel <= "0111";
      elsif (reg_data_mem_wb = "011" or reg_data_mem_wb = "101") then
        operand1_sel <= "0011";
      elsif (reg_data_mem_wb = "100") then
        operand1_sel <= "1010";
      end if;

    elsif ((reg_WE_mem_wb = '1') and (swap_state_mem_wb = "01") and (swap_addr_mem_wb = rsrc1_addr)) then
      operand1_sel <= "1101";

    end if;



    if ((reg_WE_ex1_ex2 = '1') and (reg_dst_addr_ex1_ex2 = rsrc2_addr) and (block_ex1_ex2_fwd = '0')) then
      if (reg_data_ex1_ex2 = "010") then
        operand2_sel <= "0101";
      elsif (reg_data_ex1_ex2 = "011" or reg_data_ex1_ex2 = "101") then
        operand2_sel <= "0001";
      elsif (reg_data_ex1_ex2 = "100") then
        operand2_sel <= "1000";
      end if;


    elsif ((reg_WE_ex1_ex2 = '1') and (swap_state_ex1_ex2 = "01") and (swap_addr_ex1_ex2 = rsrc2_addr)) then
      operand2_sel <= "1011";

    elsif ((reg_WE_ex2_mem = '1') and (reg_dst_addr_ex2_mem = rsrc2_addr)) then
      if (reg_data_ex2_mem = "010") then
        operand2_sel <= "0110";
      elsif (reg_data_ex2_mem = "011" or reg_data_ex2_mem = "101") then
        operand2_sel <= "0010";
      elsif (reg_data_ex2_mem = "100") then
        operand2_sel <= "1001";
      end if;


    elsif ((reg_WE_ex2_mem = '1') and (swap_state_ex2_mem = "01") and (swap_addr_ex2_mem = rsrc2_addr)) then
      operand2_sel <= "1100";

    elsif ((reg_WE_mem_wb = '1') and (reg_dst_addr_mem_wb = rsrc2_addr)) then
      if (reg_data_mem_wb = "001") then
        operand2_sel <= "0100";
      elsif (reg_data_mem_wb = "010") then
        operand2_sel <= "0111";
      elsif (reg_data_mem_wb = "011" or reg_data_mem_wb = "101") then
        operand2_sel <= "0011";
      elsif (reg_data_mem_wb = "100") then
        operand2_sel <= "1010";
      end if;

    elsif ((reg_WE_mem_wb = '1') and (swap_state_mem_wb = "01") and (swap_addr_mem_wb = rsrc2_addr)) then
      operand2_sel <= "1101";

    end if;
  end process;
end architecture;
