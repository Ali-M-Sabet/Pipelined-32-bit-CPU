library ieee;
  use ieee.std_logic_1164.all;

-- Interrupt handler: remembers a hardware interrupt request until the processor finishes handling it.
entity interrupt_handler is
  port (
    clk               : in  std_logic;
    rst               : in  std_logic;
    hw_interrupt      : in  std_logic;
    interrupt_done    : in  std_logic;
    interrupt_request : out std_logic
  );
end entity;

-- Architecture block: contains the internal signals, instances, and logic for this entity.
architecture rtl of interrupt_handler is
  -- Declarations block: names the internal wires, storage, constants, and submodules used below.
  type state_type is (IDLE, SEND_REQ, WAIT_DONE);
  signal state, next_state : state_type;

begin

  -- Process block: describes behavior that runs when its sensitivity signals change or a clock edge occurs.
  update_state_process: process (clk, rst)
  begin
    if rst = '1' then
      state <= IDLE;
    elsif rising_edge(clk) then
      state <= next_state;
    end if;
  end process;

  -- Process block: describes behavior that runs when its sensitivity signals change or a clock edge occurs.
  next_state_process: process (state, hw_interrupt, interrupt_done)
  begin
    -- Case block: chooses behavior for the current operation/control value.
    case state is
      when IDLE =>
        if hw_interrupt = '1' then
          next_state <= SEND_REQ;
        else
          next_state <= IDLE;
        end if;

      when SEND_REQ =>
        next_state <= WAIT_DONE;

      when WAIT_DONE =>
        if interrupt_done = '1' then
          next_state <= IDLE;
        else
          next_state <= WAIT_DONE;
        end if;

      when others =>
        next_state <= IDLE;
    end case;
  end process;

  -- Process block: describes behavior that runs when its sensitivity signals change or a clock edge occurs.
  output_process: process (state)
  begin
    -- Case block: chooses behavior for the current operation/control value.
    case state is
      when SEND_REQ =>
        interrupt_request <= '1';
      when others =>
        interrupt_request <= '0';
    end case;
  end process;
end architecture;
