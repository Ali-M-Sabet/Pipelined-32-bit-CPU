library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IFID_tb is
end IFID_tb;

architecture behavior of IFID_tb is
    signal clk : std_logic := '0';
    signal flush : std_logic := '0';
    signal write_en : std_logic := '0';
    signal predicted_T : std_logic := '0';
    signal inst : std_logic_vector(31 downto 0) := (others => '0');
    signal input_port : std_logic_vector(31 downto 0) := (others => '0');
    signal pc : std_logic_vector(11 downto 0) := (others => '0');
    signal predicted_T_out : std_logic;
    signal inst_out : std_logic_vector(31 downto 0);
    signal input_port_out : std_logic_vector(31 downto 0);
    signal pc_out : std_logic_vector(11 downto 0);

    constant CLK_PERIOD : time := 10 ns;

    procedure check32(
        signal_name : in string;
        actual : in std_logic_vector(31 downto 0);
        expected : in std_logic_vector(31 downto 0)
    ) is
    begin
        assert actual = expected
            report signal_name & " expected 0x" & to_hstring(expected) &
                    ", got 0x" & to_hstring(actual)
            severity error;
    end procedure;

    procedure check12(
        signal_name : in string;
        actual : in std_logic_vector(11 downto 0);
        expected : in std_logic_vector(11 downto 0)
    ) is
    begin
        assert actual = expected
            report signal_name & " expected 0x" & to_hstring(expected) &
                    ", got 0x" & to_hstring(actual)
            severity error;
    end procedure;

    procedure check1(
        signal_name : in string;
        actual : in std_logic;
        expected : in std_logic
    ) is
    begin
        assert actual = expected
            report signal_name & " expected " & std_logic'image(expected) &
                    ", got " & std_logic'image(actual)
            severity error;
    end procedure;
begin
    uut: entity work.IFID
        port map (
            clk => clk,
            flush => flush,
            write_en => write_en,
            predicted_T => predicted_T,
            inst => inst,
            input_port => input_port,
            pc => pc,
            predicted_T_out => predicted_T_out,
            inst_out => inst_out,
            input_port_out => input_port_out,
            pc_out => pc_out
        );

    clk_process : process
    begin
        clk <= '0'; wait for CLK_PERIOD / 2;
        clk <= '1'; wait for CLK_PERIOD / 2;
    end process;

    stim_proc : process
    begin
        wait for 1 ns;
        check32("inst_out initial", inst_out, x"00000000");
        check32("input_port initial", input_port_out, x"00000000");
        check12("pc_out initial", pc_out, "000000000000");
        check1 ("pred_T initial", predicted_T_out, '0');
        write_en <= '0';
        inst <= x"DEADBEEF";
        input_port <= x"12345678";
        pc <= "000000000010";
        predicted_T <= '1';
        wait until rising_edge(clk);
        wait for 1 ns;
        check32("inst_out (wr=0)", inst_out, x"00000000");
        check32("input_port (wr=0)", input_port_out, x"00000000");
        check12("pc_out (wr=0)", pc_out, "000000000000");
        check1 ("pred_T (wr=0)", predicted_T_out, '0');
        write_en <= '1';
        inst <= x"DEADBEEF";
        input_port <= x"12345678";
        pc <= "000000000010";
        predicted_T <= '1';
        wait until rising_edge(clk);
        wait for 1 ns;
        write_en <= '0';
        check32("inst_out (wr=1)", inst_out, x"DEADBEEF");
        check32("input_port (wr=1)", input_port_out, x"12345678");
        check12("pc_out (wr=1)", pc_out, "000000000010");
        check1 ("pred_T (wr=1)", predicted_T_out, '1');
        write_en <= '0';
        inst <= x"FFFFFFFF";
        input_port <= x"AAAAAAAA";
        pc <= "001111111111";
        wait until rising_edge(clk);
        wait for 1 ns;
        check32("inst_out held", inst_out, x"DEADBEEF");
        check32("input_port held", input_port_out, x"12345678");
        check12("pc_out held", pc_out, "000000000010");
        check1 ("pred_T held", predicted_T_out, '1');
        flush <= '1';
        write_en <= '0';
        wait until rising_edge(clk);
        wait for 1 ns;
        flush <= '0';
        check32("inst_out flushed", inst_out, x"00000000");
        check32("input_port flushed", input_port_out, x"00000000");
        check12("pc_out flushed", pc_out, "000000000000");
        check1 ("pred_T flushed", predicted_T_out, '0');

        write_en <= '1';
        inst <= x"CAFEBABE";
        input_port <= x"AABBCCDD";
        pc <= "000000000101";
        predicted_T <= '1';
        wait until rising_edge(clk);
        wait for 1 ns;

        flush <= '1';
        write_en <= '1';
        inst <= x"FFFFFFFF";
        input_port <= x"FFFFFFFF";
        pc <= "001111111111";
        predicted_T <= '1';
        wait until rising_edge(clk);
        wait for 1 ns;
        flush <= '0';
        write_en <= '0';

        check32("inst_out flush>wr", inst_out, x"00000000");
        check32("input_port flush>wr", input_port_out, x"00000000");
        check12("pc_out flush>wr", pc_out, "000000000000");
        check1 ("pred_T flush>wr", predicted_T_out, '0');
        write_en <= '1';
        inst <= x"11223344";
        input_port <= x"55667788";
        pc <= "000000001000";
        predicted_T <= '0';
        wait until rising_edge(clk);
        wait for 1 ns;
        write_en <= '0';
        check32("inst_out post-flush", inst_out, x"11223344");
        check32("input_port post-flush", input_port_out, x"55667788");
        check12("pc_out post-flush", pc_out, "000000001000");
        check1 ("pred_T post-flush", predicted_T_out, '0');
        write_en <= '1';

        inst <= x"AAAAAAAA"; pc <= "000000000001";
        wait until rising_edge(clk); wait for 1 ns;
        check32("inst cycle1", inst_out, x"AAAAAAAA");
        check12("pc cycle1", pc_out, "000000000001");

        inst <= x"BBBBBBBB"; pc <= "000000000010";
        wait until rising_edge(clk); wait for 1 ns;
        check32("inst cycle2", inst_out, x"BBBBBBBB");
        check12("pc cycle2", pc_out, "000000000010");

        inst <= x"CCCCCCCC"; pc <= "000000000011";
        wait until rising_edge(clk); wait for 1 ns;
        check32("inst cycle3", inst_out, x"CCCCCCCC");
        check12("pc cycle3", pc_out, "000000000011");

        write_en <= '0';

        report "PASS: IFID_tb";
        wait;
    end process;

end behavior;
