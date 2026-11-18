library ieee;
use ieee.std_logic_1164.all;

entity interrupt_handler is
    port (
        clk : in std_logic;
        rst : in std_logic;
        hw_interrupt : in std_logic;
        interrupt_done : in std_logic;
        interrupt_request : out std_logic
    );
end entity;

architecture rtl of interrupt_handler is
    type state_type is (IDLE, SEND_REQ, WAIT_DONE);
    signal state : state_type;
begin
    process (clk, rst)
    begin
        if rst = '1' then
            state <= IDLE;
        elsif rising_edge(clk) then
            case state is
                when IDLE =>
                    if hw_interrupt = '1' then
                        state <= SEND_REQ;
                    end if;
                when SEND_REQ =>
                    state <= WAIT_DONE;
                when WAIT_DONE =>
                    if interrupt_done = '1' then
                        state <= IDLE;
                    end if;
            end case;
        end if;
    end process;

    -- Pulse once, then wait for RTI before accepting another request.
    interrupt_request <= '1' when state = SEND_REQ else '0';
end architecture;
