library ieee;
use ieee.std_logic_1164.all;

entity xor_i is

    port(a,b: in std_logic;
         c: out std_logic
    );

end xor_i;

architecture xor_i_arch1 of xor_i is

signal s1,s2,s3: std_logic;

begin

    s1 <= a nand b;
    s2 <= a or b;
    s3 <= s1 nand s2;
    
    c <= not s3;

end xor_i_arch1;
