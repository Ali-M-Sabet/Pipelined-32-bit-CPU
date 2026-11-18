library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory_program_tb is
end entity;

architecture behavior of memory_program_tb is
    signal clk : std_logic := '0';
    signal mem_write_en : std_logic := '0';
    signal mem_addr : std_logic_vector(11 downto 0) := (others => '0');
    signal mem_data_in : std_logic_vector(31 downto 0) := (others => '0');
    signal mem_data_out : std_logic_vector(31 downto 0);

    constant CLK_PERIOD : time := 10 ns;

    procedure check_word(
        signal addr_sig : out std_logic_vector(11 downto 0);
        signal data_sig : in std_logic_vector(31 downto 0);
        constant addr : in natural;
        constant expect : in std_logic_vector(31 downto 0)
    ) is
    begin
        addr_sig <= std_logic_vector(to_unsigned(addr, 12));
        wait for 1 ns;
        assert data_sig = expect
            report "program.mem mismatch at address " & integer'image(addr)
            severity error;
    end procedure;
begin
    dut : entity work.memory
        port map (
            clk => clk,
            mem_write_en => mem_write_en,
            mem_addr => mem_addr,
            mem_data_in => mem_data_in,
            mem_data_out => mem_data_out
        );

    clk_process : process
    begin
        clk <= '0'; wait for CLK_PERIOD / 2;
        clk <= '1'; wait for CLK_PERIOD / 2;
    end process;

    stim_proc : process
    begin
        check_word(mem_addr, mem_data_out, 16#000#, x"00000300");

        check_word(mem_addr, mem_data_out, 16#300#, x"19000000");
        check_word(mem_addr, mem_data_out, 16#301#, x"19800000");
        check_word(mem_addr, mem_data_out, 16#302#, x"1A000000");
        check_word(mem_addr, mem_data_out, 16#303#, x"3C800005");
        check_word(mem_addr, mem_data_out, 16#304#, x"34100000");
        check_word(mem_addr, mem_data_out, 16#305#, x"34200000");
        check_word(mem_addr, mem_data_out, 16#306#, x"38800000");
        check_word(mem_addr, mem_data_out, 16#307#, x"39000000");
        check_word(mem_addr, mem_data_out, 16#308#, x"26A20000");
        check_word(mem_addr, mem_data_out, 16#309#, x"1A800000");
        check_word(mem_addr, mem_data_out, 16#30A#, x"442A0200");
        check_word(mem_addr, mem_data_out, 16#30B#, x"441A0201");
        check_word(mem_addr, mem_data_out, 16#30C#, x"41D00201");
        check_word(mem_addr, mem_data_out, 16#30D#, x"42500200");
        check_word(mem_addr, mem_data_out, 16#30E#, x"26C60000");
        check_word(mem_addr, mem_data_out, 16#30F#, x"1A800000");
        check_word(mem_addr, mem_data_out, 16#310#, x"19000000");
        check_word(mem_addr, mem_data_out, 16#311#, x"44440200");
        check_word(mem_addr, mem_data_out, 16#312#, x"41D00201");
        check_word(mem_addr, mem_data_out, 16#313#, x"41300200");
        check_word(mem_addr, mem_data_out, 16#314#, x"25260000");
        check_word(mem_addr, mem_data_out, 16#315#, x"14100000");

        report "PASS: memory_program_tb";
        wait;
    end process;
end architecture;
