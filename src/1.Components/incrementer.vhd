LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;







-- Incrementer: adds one to an input value.
entity incrementer is
generic (
    N : integer := 32
);
port (
    a : in std_logic_vector(N-1 downto 0);
    result : out std_logic_vector(N-1 downto 0)
);
end incrementer;

-- Architecture block: contains the internal signals, instances, and logic for this entity.
architecture rtl of incrementer is
begin

    result <= std_logic_vector(unsigned(a) + 1);

end rtl;
