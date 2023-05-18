library ieee;
use ieee.std_logic_1164.all;

entity black_cell is

    port(Gik,Pik,Gk_1j,Pk_1j: in std_logic;
         Gij,Pij: out std_logic
    );

end black_cell;

architecture black_cell_arch1 of black_cell is

signal temp: std_logic;

begin

    temp <= Pik and Gk_1j;
    Pij <= Pik and Pk_1j;
    Gij <= Gik or temp;

end black_cell_arch1;
