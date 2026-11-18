library ieee;
use ieee.std_logic_1164.all;

entity MEMWB is
    port (
        clk : in std_logic;
        flush : in std_logic;
        write_en : in std_logic;

        alu_res : in std_logic_vector(31 downto 0);
        rsrc1 : in std_logic_vector(31 downto 0);
        rsrc2 : in std_logic_vector(31 downto 0);
        mem_data_out : in std_logic_vector(31 downto 0);
        imm : in std_logic_vector(15 downto 0);
        reg_dst_addr : in std_logic_vector(2 downto 0);
        input_port : in std_logic_vector(31 downto 0);

        alu_op : in std_logic_vector(3 downto 0);
        reg_data : in std_logic_vector(2 downto 0);
        reg_WE : in std_logic;
        ret : in std_logic;
        SW_INTDone : in std_logic_vector(1 downto 0);
        is_load : in std_logic;
        swap_state : in std_logic_vector(1 downto 0);
        out_enable : in std_logic;
        HLT : in std_logic;

        alu_res_out : out std_logic_vector(31 downto 0) := (others => '0');
        rsrc1_out : out std_logic_vector(31 downto 0) := (others => '0');
        rsrc2_out : out std_logic_vector(31 downto 0) := (others => '0');
        mem_data_out_out : out std_logic_vector(31 downto 0) := (others => '0');
        imm_out : out std_logic_vector(15 downto 0) := (others => '0');
        reg_dst_addr_out : out std_logic_vector(2 downto 0) := (others => '0');
        input_port_out : out std_logic_vector(31 downto 0) := (others => '0');

        alu_op_out : out std_logic_vector(3 downto 0) := (others => '0');
        reg_data_out : out std_logic_vector(2 downto 0) := (others => '0');
        reg_WE_out : out std_logic := '0';
        ret_out : out std_logic := '0';
        SW_INTDone_out : out std_logic_vector(1 downto 0) := (others => '0');
        is_load_out : out std_logic := '0';
        swap_state_out : out std_logic_vector(1 downto 0) := (others => '0');
        out_enable_out : out std_logic := '0';
        HLT_out : out std_logic := '0'
    );
end entity;

architecture rtl of MEMWB is
begin
    -- Flush has priority over write_en.
    process (clk)
    begin
        if rising_edge(clk) then
            if flush = '1' then

                alu_res_out <= (others => '0');
                rsrc1_out <= (others => '0');
                rsrc2_out <= (others => '0');
                mem_data_out_out <= (others => '0');
                imm_out <= (others => '0');
                reg_dst_addr_out <= (others => '0');
                input_port_out <= (others => '0');

                alu_op_out <= (others => '0');
                reg_data_out <= (others => '0');
                reg_WE_out <= '0';
                ret_out <= '0';
                SW_INTDone_out <= (others => '0');
                is_load_out <= '0';
                swap_state_out <= (others => '0');
                out_enable_out <= '0';
                HLT_out <= '0';

            elsif write_en = '1' then

                alu_res_out <= alu_res;
                rsrc1_out <= rsrc1;
                rsrc2_out <= rsrc2;
                mem_data_out_out <= mem_data_out;
                imm_out <= imm;
                reg_dst_addr_out <= reg_dst_addr;
                input_port_out <= input_port;

                alu_op_out <= alu_op;
                reg_data_out <= reg_data;
                reg_WE_out <= reg_WE;
                ret_out <= ret;
                SW_INTDone_out <= SW_INTDone;
                is_load_out <= is_load;
                swap_state_out <= swap_state;
                out_enable_out <= out_enable;
                HLT_out <= HLT;
            end if;
        end if;
    end process;
end rtl;
