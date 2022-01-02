library ieee;
use ieee.std_logic_1164.all;

entity SUB1 is
    port (
        A, B, Cin : in  std_logic;
        S, Cout   : out std_logic
    );
end SUB1;

architecture dfl of SUB1 is
begin
    S <= A xor B xor Cin;
    Cout <= (B and Cin) or ((not A) and B) or ((not A) and Cin);
end architecture dfl;


