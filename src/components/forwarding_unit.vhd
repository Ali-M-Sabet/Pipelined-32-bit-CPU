library ieee;
use ieee.std_logic_1164.all;

entity forwarding_unit is
    port (
        rsrc1_addr : in std_logic_vector(2 downto 0);
        rsrc2_addr : in std_logic_vector(2 downto 0);
        swap_state : in std_logic_vector(1 downto 0);

        reg_WE_ex1_ex2 : in std_logic;
        reg_dst_addr_ex1_ex2 : in std_logic_vector(2 downto 0);
        reg_data_ex1_ex2 : in std_logic_vector(2 downto 0);
        swap_state_ex1_ex2 : in std_logic_vector(1 downto 0);
        swap_addr_ex1_ex2 : in std_logic_vector(2 downto 0);

        reg_data_ex2_mem : in std_logic_vector(2 downto 0);
        reg_dst_addr_ex2_mem : in std_logic_vector(2 downto 0);
        reg_WE_ex2_mem : in std_logic;
        swap_state_ex2_mem : in std_logic_vector(1 downto 0);
        swap_addr_ex2_mem : in std_logic_vector(2 downto 0);

        reg_WE_mem_wb : in std_logic;
        reg_dst_addr_mem_wb : in std_logic_vector(2 downto 0);
        reg_data_mem_wb : in std_logic_vector(2 downto 0);
        swap_state_mem_wb : in std_logic_vector(1 downto 0);
        swap_addr_mem_wb : in std_logic_vector(2 downto 0);

        operand1_sel : out std_logic_vector(3 downto 0);
        operand2_sel : out std_logic_vector(3 downto 0)
    );
end entity;

architecture rtl of forwarding_unit is
begin
    process (all)
    begin
        -- EX1/EX2 has priority, followed by EX2/MEM and MEM/WB.
        operand1_sel <= (others => '0');
        operand2_sel <= (others => '0');

        -- Skip the first SWAP result during its second phase.
        if ((reg_WE_ex1_ex2 = '1') and (reg_dst_addr_ex1_ex2 = rsrc1_addr) and (swap_state /= "10")) then
            case reg_data_ex1_ex2 is
                when "010" => operand1_sel <= "0101"; -- Immediate
                when "011" | "101" => operand1_sel <= "0001"; -- ALU result
                when "100" => operand1_sel <= "1000"; -- Input port
                    when others => null;
            end case;

        elsif ((reg_WE_ex1_ex2 = '1') and (swap_state_ex1_ex2 = "01") and (swap_addr_ex1_ex2 = rsrc1_addr)) then
            operand1_sel <= "1011"; -- SWAP second destination

                elsif ((reg_WE_ex2_mem = '1') and (reg_dst_addr_ex2_mem = rsrc1_addr)) then
                case reg_data_ex2_mem is
                when "010" => operand1_sel <= "0110";
                when "011" | "101" => operand1_sel <= "0010";
                when "100" => operand1_sel <= "1001";
                when others => null;
            end case;

        elsif ((reg_WE_ex2_mem = '1') and (swap_state_ex2_mem = "01") and (swap_addr_ex2_mem = rsrc1_addr)) then
            operand1_sel <= "1100";

        elsif ((reg_WE_mem_wb = '1') and (reg_dst_addr_mem_wb = rsrc1_addr)) then
            case reg_data_mem_wb is
                when "001" => operand1_sel <= "0100";
                when "010" => operand1_sel <= "0111";
                when "011" | "101" => operand1_sel <= "0011";
                when "100" => operand1_sel <= "1010";
                when others => null;
            end case;

        elsif ((reg_WE_mem_wb = '1') and (swap_state_mem_wb = "01") and (swap_addr_mem_wb = rsrc1_addr)) then
            operand1_sel <= "1101";
        end if;

        if ((reg_WE_ex1_ex2 = '1') and (reg_dst_addr_ex1_ex2 = rsrc2_addr) and (swap_state /= "10")) then
            case reg_data_ex1_ex2 is
                when "010" => operand2_sel <= "0101";
                when "011" | "101" => operand2_sel <= "0001";
                when "100" => operand2_sel <= "1000";
                when others => null;
            end case;

        elsif ((reg_WE_ex1_ex2 = '1') and (swap_state_ex1_ex2 = "01") and (swap_addr_ex1_ex2 = rsrc2_addr)) then
            operand2_sel <= "1011";

        elsif ((reg_WE_ex2_mem = '1') and (reg_dst_addr_ex2_mem = rsrc2_addr)) then
            case reg_data_ex2_mem is
                when "010" => operand2_sel <= "0110";
                when "011" | "101" => operand2_sel <= "0010";
                when "100" => operand2_sel <= "1001";
                when others => null;
            end case;

        elsif ((reg_WE_ex2_mem = '1') and (swap_state_ex2_mem = "01") and (swap_addr_ex2_mem = rsrc2_addr)) then
            operand2_sel <= "1100";

        elsif ((reg_WE_mem_wb = '1') and (reg_dst_addr_mem_wb = rsrc2_addr)) then
            case reg_data_mem_wb is
                when "001" => operand2_sel <= "0100";
                when "010" => operand2_sel <= "0111";
                when "011" | "101" => operand2_sel <= "0011";
                when "100" => operand2_sel <= "1010";
                when others => null;
            end case;

        elsif ((reg_WE_mem_wb = '1') and (swap_state_mem_wb = "01") and (swap_addr_mem_wb = rsrc2_addr)) then
            operand2_sel <= "1101";
        end if;
    end process;
end architecture;
