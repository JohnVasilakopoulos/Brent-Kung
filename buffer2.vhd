library ieee;
use ieee.std_logic_1164.all;

entity buffer2 is

    port(a,b: in std_logic;
         c,d: out std_logic
    );

end buffer2;

architecture buffer2_arch1 of buffer2 is

begin

    c <= a;
    d <= b;

end buffer2_arch1;
