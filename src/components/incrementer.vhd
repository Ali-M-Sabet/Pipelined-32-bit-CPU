library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity incrementer is
    generic (N : integer := 32);
    port (
        a : in std_logic_vector(N-1 downto 0);
        result : out std_logic_vector(N-1 downto 0)
    );
end incrementer;

architecture rtl of incrementer is
begin
    -- Overflow wraps to the configured width.
    result <= std_logic_vector(unsigned(a) + 1);
end rtl;
