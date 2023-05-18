library ieee;
use ieee.std_logic_1164.all;

-- Entity: Bitwise PG Logic
entity bit_pg_logic is

    generic(n: integer := 64);

    port(A,B:in std_logic_vector(n-1 downto 0);
         G,P: out std_logic_vector(n-1 downto 0)
    );

end bit_pg_logic;


-- Architecture of entity: Bitwise PG Logic
architecture bit_pg_logic_arch1 of bit_pg_logic is

component GP_c

    port(a,b: in std_logic;
         g,p: out std_logic
    );

end component;

begin

    GP_generate:
    for i in 0 to n-1 generate
        gp_i:
        GP_c
        port map(A(i),B(i),G(i),P(i));
    end generate;

end bit_pg_logic_arch1;
