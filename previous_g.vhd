library ieee;
use ieee.std_logic_1164.all;

entity previous_g is

    generic(n: integer; m: integer);

    port(A: in std_logic_vector(n-1 downto 0);
         B: in std_logic_vector(m-1 downto 0);
         C: out std_logic_vector(n-1 downto 0);
         D: out std_logic_vector(m-1 downto 0)
    );

end previous_g;

architecture previous_g_arch1 of previous_g is

begin

    C <= A;
    D <= B;

end previous_g_arch1;
