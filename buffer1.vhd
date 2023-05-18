library ieee;
use ieee.std_logic_1164.all;

entity buffer1 is

    port(a: in std_logic;
         b: out std_logic
    );

end buffer1;

architecture buffer1_arch1 of buffer1 is

begin

    b <= a;

end buffer1_arch1;
