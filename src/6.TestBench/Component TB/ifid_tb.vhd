library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Testbench block: drives this module with simulation inputs and checks the expected behavior.
entity IFID_tb is
end IFID_tb;

-- Architecture block: contains the internal signals, instances, and logic for this entity.
architecture behavior of IFID_tb is

    -- Declarations block: names the internal wires, storage, constants, and submodules used below.
    component IFID
        port (
            clk             : in  std_logic;
            flush           : in  std_logic;
            write_en        : in  std_logic;
            predicted_T     : in  std_logic;
            inst            : in  std_logic_vector(31 downto 0);
            input_port      : in  std_logic_vector(31 downto 0);
            pc              : in  std_logic_vector(11 downto 0);
            predicted_T_out : out std_logic;
            inst_out        : out std_logic_vector(31 downto 0);
            input_port_out  : out std_logic_vector(31 downto 0);
            pc_out          : out std_logic_vector(11 downto 0)
        );
    end component;

    signal clk             : std_logic := '0';
    signal flush           : std_logic := '0';
    signal write_en        : std_logic := '0';
    signal predicted_T     : std_logic := '0';
    signal inst            : std_logic_vector(31 downto 0) := (others => '0');
    signal input_port      : std_logic_vector(31 downto 0) := (others => '0');
    signal pc              : std_logic_vector(11 downto 0)  := (others => '0');
    signal predicted_T_out : std_logic;
    signal inst_out        : std_logic_vector(31 downto 0);
    signal input_port_out  : std_logic_vector(31 downto 0);
    signal pc_out          : std_logic_vector(11 downto 0);

    constant CLK_PERIOD : time := 10 ns;




    procedure check32(
        signal_name : in string;
        actual      : in std_logic_vector(31 downto 0);
        expected    : in std_logic_vector(31 downto 0)
    ) is
    begin
        if actual = expected then
            report "[PASS] " & signal_name &
                   " = 0x" & integer'image(to_integer(unsigned(actual)));
        else
            report "[FAIL] " & signal_name &
                   " | expected 0x" & integer'image(to_integer(unsigned(expected))) &
                   " | got 0x"      & integer'image(to_integer(unsigned(actual)))
            severity error;
        end if;
    end procedure;

    procedure check10(
        signal_name : in string;
        actual      : in std_logic_vector(11 downto 0);
        expected    : in std_logic_vector(11 downto 0)
    ) is
    begin
        if actual = expected then
            report "[PASS] " & signal_name &
                   " = " & integer'image(to_integer(unsigned(actual)));
        else
            report "[FAIL] " & signal_name &
                   " | expected " & integer'image(to_integer(unsigned(expected))) &
                   " | got "      & integer'image(to_integer(unsigned(actual)))
            severity error;
        end if;
    end procedure;

    procedure check1(
        signal_name : in string;
        actual      : in std_logic;
        expected    : in std_logic
    ) is
    begin
        if actual = expected then
            report "[PASS] " & signal_name &
                   " = " & std_logic'image(actual);
        else
            report "[FAIL] " & signal_name &
                   " | expected " & std_logic'image(expected) &
                   " | got "      & std_logic'image(actual)
            severity error;
        end if;
    end procedure;

begin

    uut: IFID
        port map (
            clk             => clk,
            flush           => flush,
            write_en        => write_en,
            predicted_T     => predicted_T,
            inst            => inst,
            input_port      => input_port,
            pc              => pc,
            predicted_T_out => predicted_T_out,
            inst_out        => inst_out,
            input_port_out  => input_port_out,
            pc_out          => pc_out
        );

    -- Process block: describes behavior that runs when its sensitivity signals change or a clock edge occurs.
    clk_process : process
    begin
        clk <= '0'; wait for CLK_PERIOD / 2;
        clk <= '1'; wait for CLK_PERIOD / 2;
    end process;

    -- Process block: describes behavior that runs when its sensitivity signals change or a clock edge occurs.
    stim_proc : process
    begin




        report "=== TEST 1: Initial state = 0 ===";
        wait for 1 ns;
        check32("inst_out   initial", inst_out,       x"00000000");
        check32("input_port initial", input_port_out, x"00000000");
        check10("pc_out     initial", pc_out,         "000000000000");
        check1 ("pred_T     initial", predicted_T_out, '0');




        report "=== TEST 2: write_en=0, register must not change ===";
        write_en    <= '0';
        inst        <= x"DEADBEEF";
        input_port  <= x"12345678";
        pc          <= "000000000010";
        predicted_T <= '1';
        wait until rising_edge(clk);
        wait for 1 ns;
        check32("inst_out   (wr=0)", inst_out,       x"00000000");
        check32("input_port (wr=0)", input_port_out, x"00000000");
        check10("pc_out     (wr=0)", pc_out,         "000000000000");
        check1 ("pred_T     (wr=0)", predicted_T_out, '0');




        report "=== TEST 3: write_en=1, latch all inputs ===";
        write_en    <= '1';
        inst        <= x"DEADBEEF";
        input_port  <= x"12345678";
        pc          <= "000000000010";
        predicted_T <= '1';
        wait until rising_edge(clk);
        wait for 1 ns;
        write_en <= '0';
        check32("inst_out   (wr=1)", inst_out,        x"DEADBEEF");
        check32("input_port (wr=1)", input_port_out,  x"12345678");
        check10("pc_out     (wr=1)", pc_out,          "000000000010");
        check1 ("pred_T     (wr=1)", predicted_T_out, '1');




        report "=== TEST 4: Outputs hold when write_en=0 ===";
        write_en   <= '0';
        inst       <= x"FFFFFFFF";
        input_port <= x"AAAAAAAA";
        pc         <= "001111111111";
        wait until rising_edge(clk);
        wait for 1 ns;
        check32("inst_out   held", inst_out,        x"DEADBEEF");
        check32("input_port held", input_port_out,  x"12345678");
        check10("pc_out     held", pc_out,          "000000000010");
        check1 ("pred_T     held", predicted_T_out, '1');




        report "=== TEST 5: Flush inserts NOP bubble ===";
        flush    <= '1';
        write_en <= '0';
        wait until rising_edge(clk);
        wait for 1 ns;
        flush <= '0';
        check32("inst_out   flushed", inst_out,        x"00000000");
        check32("input_port flushed", input_port_out,  x"00000000");
        check10("pc_out     flushed", pc_out,          "000000000000");
        check1 ("pred_T     flushed", predicted_T_out, '0');





        report "=== TEST 6: Flush priority over write_en ===";

        write_en    <= '1';
        inst        <= x"CAFEBABE";
        input_port  <= x"AABBCCDD";
        pc          <= "000000000101";
        predicted_T <= '1';
        wait until rising_edge(clk);
        wait for 1 ns;


        flush       <= '1';
        write_en    <= '1';
        inst        <= x"FFFFFFFF";
        input_port  <= x"FFFFFFFF";
        pc          <= "001111111111";
        predicted_T <= '1';
        wait until rising_edge(clk);
        wait for 1 ns;
        flush    <= '0';
        write_en <= '0';

        check32("inst_out   flush>wr", inst_out,        x"00000000");
        check32("input_port flush>wr", input_port_out,  x"00000000");
        check10("pc_out     flush>wr", pc_out,          "000000000000");
        check1 ("pred_T     flush>wr", predicted_T_out, '0');




        report "=== TEST 7: Normal write after flush ===";
        write_en    <= '1';
        inst        <= x"11223344";
        input_port  <= x"55667788";
        pc          <= "000000001000";
        predicted_T <= '0';
        wait until rising_edge(clk);
        wait for 1 ns;
        write_en <= '0';
        check32("inst_out   post-flush", inst_out,        x"11223344");
        check32("input_port post-flush", input_port_out,  x"55667788");
        check10("pc_out     post-flush", pc_out,          "000000001000");
        check1 ("pred_T     post-flush", predicted_T_out, '0');





        report "=== TEST 8: Consecutive writes ===";
        write_en <= '1';

        inst <= x"AAAAAAAA"; pc <= "000000000001";
        wait until rising_edge(clk); wait for 1 ns;
        check32("inst cycle1", inst_out, x"AAAAAAAA");
        check10("pc   cycle1", pc_out,  "000000000001");

        inst <= x"BBBBBBBB"; pc <= "000000000010";
        wait until rising_edge(clk); wait for 1 ns;
        check32("inst cycle2", inst_out, x"BBBBBBBB");
        check10("pc   cycle2", pc_out,  "000000000010");

        inst <= x"CCCCCCCC"; pc <= "000000000011";
        wait until rising_edge(clk); wait for 1 ns;
        check32("inst cycle3", inst_out, x"CCCCCCCC");
        check10("pc   cycle3", pc_out,  "000000000011");

        write_en <= '0';

        report "=== ALL TESTS COMPLETE ===";
        wait;
    end process;

end behavior;
