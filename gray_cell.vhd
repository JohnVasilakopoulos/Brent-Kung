library ieee;
use ieee.std_logic_1164.all;

entity gray_cell is

    port(Gik,Pik,Gk_1j: in std_logic;
         Gij,Pik_out: out std_logic
    );

end gray_cell;

architecture gray_cell_arch1 of gray_cell is

signal temp: std_logic;

begin

    temp <= Pik and Gk_1j;
    Gij <= Gik or temp;
    Pik_out <= Pik;

end gray_cell_arch1;
