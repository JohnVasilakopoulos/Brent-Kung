library ieee;
use ieee.std_logic_1164.all;

-- Entity: Brent - Kung Adder
-- 32-bit version
entity bk32 is

    generic(n: integer := 32);

    port(A,B: in std_logic_vector(n-1 downto 0);
         C_in: in std_logic;
         C: out std_logic_vector(n-1 downto 0);
         C_out: out std_logic
    );

end bk32;


-- Architecture of entity: Brent - Kung Adder
architecture bk32_arch1 of bk32 is

-- Bitwise PG Logic
component bit_pg_logic

    generic(n: integer);

    port(A,B:in std_logic_vector(n-1 downto 0);
         G,P: out std_logic_vector(n-1 downto 0)
    );

end component;

-- Group PG Logic
component group_pg_logic

    generic(n: integer);

    port(Gii,Pii: in std_logic_vector(n-1 downto 0);
         C_in: in std_logic;
         C: out std_logic_vector(n-1 downto 0)
    );    

end component;

-- Sum Logic
component sum_logic

    generic(n: integer);

    port(P, C: in std_logic_vector(n-1 downto 0);
         S: out std_logic_vector(n-1 downto 0)
    );

end component;

-- Gray Cell
component gray_cell

    port(Gik,Pik,Gk_1j: in std_logic;
         Gij,Pik_out: out std_logic
    );

end component;

signal Gi,Pi: std_logic_vector(n-1 downto 0);
signal Carry: std_logic_vector(n-1 downto 0);
signal temp: std_logic_vector(n-1 downto 0);
signal P_temp: std_logic;

begin

    temp <= Carry(n-2 downto 0) & C_in;
    C_out <= Carry(n-1);

    Bitwise_PG_Logic_label: bit_pg_logic generic map(n) port map(A,B,Gi,Pi);

    Group_PG_Logic_label: group_pg_logic generic map(n) port map(Gi,Pi,C_in,Carry);

    Sum_Logic_label: sum_logic generic map(n) port map(Pi,temp,C);

end bk32_arch1;
