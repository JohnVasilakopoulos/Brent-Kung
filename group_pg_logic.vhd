library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

-- Entity: Group PG Logic
entity group_pg_logic is

    generic(n: integer);

    port(Gii,Pii: in std_logic_vector(n-1 downto 0);
         C_in: in std_logic;
         C: out std_logic_vector(n-1 downto 0)
    );

end group_pg_logic;


-- Architecture of entity: Group PG Logic
architecture group_pg_logic_arch1 of group_pg_logic is


constant tree_len: integer := integer(ceil(log2(real(n))));
type upper is array(tree_len downto 0) of std_logic_vector(n-1 downto 0);
type lower is array(tree_len-1 downto 0) of std_logic_vector(n-1 downto 0);

-- Black Cell
component black_cell

    port(Gik,Pik,Gk_1j,Pk_1j: in std_logic;
         Gij,Pij: out std_logic
    );

end component;

-- Gray Cell
component gray_cell

    port(Gik,Pik,Gk_1j: in std_logic;
         Gij,Pik_out: out std_logic
    );

end component;

-- Buffers
-- 1-input 1-output buffer 
component buffer1

    port(a: in std_logic;
         b: out std_logic
    );

end component;

-- 2-input 2-output buffer 
component buffer2

    port(a,b: in std_logic;
         c,d: out std_logic
    );

end component;

-- Random Number Of Inputs
component previous_g

    generic(n: integer; m: integer);

    port(A: in std_logic_vector(n-1 downto 0);
         B: in std_logic_vector(m-1 downto 0);
         C: out std_logic_vector(n-1 downto 0);
         D: out std_logic_vector(m-1 downto 0)
    );

end component;

signal G_temp: upper;
signal P_temp: upper;
signal G: lower;

begin

     G_temp(0) <= Gii(n-1 downto 1) & ( Gii(0) or (Pii(0) and C_in) ); 
     P_temp(0) <= Pii;
     G(0) <= G_temp(tree_len);

     C <= G(tree_len-1);

    --Upper Part

    upper_generate:
    for j in 1 to tree_len generate

        buffer_j_upper: 
        buffer2 
        port map(G_temp(j-1)(integer(2**(real(j-1)))-1),
                 P_temp(j-1)(integer(2**(real(j-1)))-1),
                 G_temp(tree_len)(integer(2**(real(j-1)))-1),
                 P_temp(tree_len)(integer(2**(real(j-1)))-1));

        gray_cell_j_upper: 
        gray_cell 
        port map(G_temp(j-1)(integer( 2 ** ( real(j) ) )-1),
                 P_temp(j-1)(integer( 2 ** ( real(j) ) )-1),
                 G_temp(j-1)(integer( 2 ** ( real(j-1) ) )-1),
                 G_temp(j)(integer( 2 ** ( real(j) ) )-1),
                 P_temp(j)(integer( 2 ** ( real(j) ) )-1));


        branch_j_upper:
        for i in 1 to ( n/integer(2**real(j))-1 ) generate 

            black_cell_i: 
            black_cell 
            port map(G_temp(j-1)((i+1)*(integer( 2 ** real(j) ))-1),
                     P_temp(j-1)((i+1)*(integer( 2 ** real(j) ))-1),
                     G_temp(j-1)((i+1)*(integer( 2 ** real(j) ))-1-integer( 2 ** real(j-1) )),
                     P_temp(j-1)((i+1)*(integer( 2 ** real(j) ))-1-integer( 2 ** real(j-1) )),
                     G_temp(j)((i+1)*(integer( 2 ** real(j) ))-1),
                     P_temp(j)((i+1)*(integer( 2 ** real(j) ))-1));
            
            buffer_i: 
            buffer2 
            port map(G_temp(j-1)((i+1)*(integer( 2 ** real(j) ))-1-integer( 2 ** real(j-1) )),
                     P_temp(j-1)((i+1)*(integer( 2 ** real(j) ))-1-integer( 2 ** real(j-1) )),
                     G_temp(tree_len)((i+1)*(integer( 2 ** real(j) ))-1-integer( 2 ** real(j-1) )),
                     P_temp(tree_len)((i+1)*(integer( 2 ** real(j) ))-1-integer( 2 ** real(j-1) )));

        end generate;
        
    end generate;
    

    -- Lower Part

    lower_generate:
    for j in 1 to tree_len-1 generate
    
        gray_cell_j_lower: 
        gray_cell 
        port map(G_temp(tree_len)(integer( 2 ** (real(tree_len-j)) )+integer( 2 ** (real(tree_len-j-1)) )-1),
                 P_temp(tree_len)(integer( 2 ** (real(tree_len-j)) )+integer( 2 ** (real(tree_len-j-1)) )-1),
                 G_temp(tree_len)(integer( 2 ** (real(tree_len-j)) )-1),
                 G(j)(integer( 2 ** (real(tree_len-j)) )+integer( 2 ** (real(tree_len-j-1)) )-1));

        buffer_j_lower: 
        buffer1 
        port map(G(j-1)(integer( 2 ** (real(j)) )-1),
                 G(tree_len-1)(integer( 2 ** (real(j)) )-1));

        previous_g_j:
        previous_g
        generic map( integer( 2 ** real(tree_len-1-j) ), 
                     integer( 2**real(tree_len-1-j) )+integer( 2**real(tree_len-j) )-1 )
        port map(G(j-1)(integer( 2 ** (real(tree_len-j)) )+integer( 2 ** (real(tree_len-j-1)) )-1+integer( 2 ** (real(tree_len-1-j)) )
                        downto integer( 2 ** (real(tree_len-j)) )+integer( 2 ** (real(tree_len-j-1)) )),
                 G(j-1)(integer( 2 ** (real(tree_len-j)) )+integer( 2 ** (real(tree_len-j-1)) )-2 downto 0),
                 G(j)(integer( 2 ** (real(tree_len-j)) )+integer( 2 ** (real(tree_len-j-1)) )-1+integer( 2 ** (real(tree_len-1-j)) )
                        downto integer( 2 ** (real(tree_len-j)) )+integer( 2 ** (real(tree_len-j-1)) )),
                 G(j)(integer( 2 ** (real(tree_len-j)) )+integer( 2 ** (real(tree_len-j-1)) )-2 downto 0));


        branch_j_lower:
        for i in 0 to integer( 2 ** (real(j)) )-3 generate
        
            gray_cell_i_lower: 
            gray_cell 
            port map(G(j-1)(integer( 2 ** (real(tree_len-j-1)) )+i*integer( 2 ** (real(tree_len-j)) )+integer( 2 ** (real(tree_len-j+1)) )-1),
                     P_temp(tree_len)(integer( 2 ** (real(tree_len-j-1)) )+i*integer( 2 ** (real(tree_len-j)) )+integer( 2 ** (real(tree_len-j+1)) )-1),
                     G(j-1)(i*integer( 2 ** (real(tree_len-j)) )+integer( 2 ** (real(tree_len-j+1)) )-1),
                     G(j)(integer( 2 ** (real(tree_len-j-1)) )+i*integer( 2 ** (real(tree_len-j)) )+integer( 2 ** (real(tree_len-j+1)) )-1));

            bufferO_i_lower:
            buffer1
            port map(G(j-1)(i*integer( 2 ** (real(tree_len-j)) )+integer( 2 ** (real(tree_len-j+1)) )-1),
                     G(j)(i*integer( 2 ** (real(tree_len-j)) )+integer( 2 ** (real(tree_len-j+1)) )-1));

            previous_g_i:
            previous_g
            generic map(integer( 2 ** real(tree_len-j-1) ),
                        integer( 2 ** real(tree_len-j-1) ))
            port map(G(j-1)(integer( 2 ** (real(tree_len-j-1)) )+i*integer( 2 ** (real(tree_len-j)) )+integer( 2 ** (real(tree_len-j+1)) )-1+integer( 2 ** real(tree_len-j-1) ) 
                            downto integer( 2 ** (real(tree_len-j-1)) )+i*integer( 2 ** (real(tree_len-j)) )+integer( 2 ** (real(tree_len-j+1)) )),
                     G(j-1)(integer( 2 ** (real(tree_len-j-1)) )+i*integer( 2 ** (real(tree_len-j)) )+integer( 2 ** (real(tree_len-j+1)) )-2 
                            downto integer( 2 ** (real(tree_len-j-1)) )+i*integer( 2 ** (real(tree_len-j)) )+integer( 2 ** (real(tree_len-j+1)) )-1-integer( 2 ** real(tree_len-j-1) )),
                     G(j)(integer( 2 ** (real(tree_len-j-1)) )+i*integer( 2 ** (real(tree_len-j)) )+integer( 2 ** (real(tree_len-j+1)) )-1+integer( 2 ** real(tree_len-j-1) ) 
                            downto integer( 2 ** (real(tree_len-j-1)) )+i*integer( 2 ** (real(tree_len-j)) )+integer( 2 ** (real(tree_len-j+1)) )),
                     G(j)(integer( 2 ** (real(tree_len-j-1)) )+i*integer( 2 ** (real(tree_len-j)) )+integer( 2 ** (real(tree_len-j+1)) )-2 
                            downto integer( 2 ** (real(tree_len-j-1)) )+i*integer( 2 ** (real(tree_len-j)) )+integer( 2 ** (real(tree_len-j+1)) )-1-integer( 2 ** real(tree_len-j-1) )));

        end generate;

    end generate;

end group_pg_logic_arch1;
