library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Write-back stage: passes final results and control signals back toward the register file.
entity wb_stage is
    port (

        HLT             : in std_logic;
        out_enable      : in std_logic;
        is_load         : in std_logic;
        SW_INTDone      : in std_logic_vector(1 downto 0);
        ret             : in std_logic;
        reg_WE          : in std_logic;
        reg_data        : in std_logic_vector(2 downto 0);
        alu_op          : in std_logic_vector(3 downto 0);

        alu_res         : in std_logic_vector(31 downto 0);
        rsrc1           : in std_logic_vector(31 downto 0);
        mem_data_out    : in std_logic_vector(31 downto 0);
        imm             : in std_logic_vector(15 downto 0);
        reg_dst_addr    : in std_logic_vector(2 downto 0);
        input_port      : in std_logic_vector(31 downto 0);


        HLT_out         : out std_logic;


        out_enable_out  : out std_logic;
        output_port_data: out std_logic_vector(31 downto 0);


        SW_INTDone_out  : out std_logic_vector(1 downto 0);
        ret_out         : out std_logic;


        is_load_out      : out std_logic;
        reg_WE_out       : out std_logic;
        reg_data_out     : out std_logic_vector(2 downto 0);
        alu_op_out       : out std_logic_vector(3 downto 0);
        reg_dst_addr_out : out std_logic_vector(2 downto 0);


        alu_res_out      : out std_logic_vector(31 downto 0);
        rsrc1_out        : out std_logic_vector(31 downto 0);
        mem_data_out_out : out std_logic_vector(31 downto 0);
        imm_out          : out std_logic_vector(15 downto 0);
        input_port_out   : out std_logic_vector(31 downto 0)
    );
end entity wb_stage;

-- Architecture block: contains the internal signals, instances, and logic for this entity.
architecture rtl of wb_stage is
begin

    HLT_out <= HLT;

    out_enable_out   <= out_enable;
    output_port_data <= rsrc1;

    SW_INTDone_out <= SW_INTDone;
    ret_out        <= ret;

    is_load_out      <= is_load;
    reg_WE_out       <= reg_WE;
    reg_data_out     <= reg_data;
    alu_op_out       <= alu_op;
    reg_dst_addr_out <= reg_dst_addr;

    alu_res_out      <= alu_res;
    rsrc1_out        <= rsrc1;
    mem_data_out_out <= mem_data_out;
    imm_out          <= imm;
    input_port_out   <= input_port;

end architecture rtl;
