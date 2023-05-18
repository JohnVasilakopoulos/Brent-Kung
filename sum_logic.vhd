library ieee;
use ieee.std_logic_1164.all;

-- Entity: Sum Logic
entity sum_logic is
    
    generic(n: integer);

    port(P, C: in std_logic_vector(n-1 downto 0);
         S: out std_logic_vector(n-1 downto 0)
    );

end sum_logic;


-- Architecture of entity: Sum Logic
architecture sum_logic_arch1 of sum_logic is

component xor_i

    port(a,b: in std_logic;
         c: out std_logic
    );

end component;

begin

    sum_gen:
    for i in 0 to n-1 generate
        sum_i: xor_i port map(P(i),C(i),S(i));
    end generate;

end sum_logic_arch1;
