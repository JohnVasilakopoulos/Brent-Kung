library ieee;
use ieee.std_logic_1164.all;

entity GP_c is

    port(a,b: in std_logic;
         g,p: out std_logic
    );

end GP_c;

architecture GP_c_arch1 of GP_c is

signal s1: std_logic;
signal s2: std_logic;
signal s3: std_logic;

begin

    s1 <= a nand b;
    s2 <= a or b;
    s3 <= s1 nand s2;
    
    g <= not s1;
    p <= not s3;

end GP_c_arch1;
