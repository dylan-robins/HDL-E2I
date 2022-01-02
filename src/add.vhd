library ieee;
use ieee.std_logic_1164.all;

entity ADD1 is
    port (
        A, B, Cin : in  std_logic;
        S, Cout   : out std_logic
    );
end ADD1;

architecture df1 of ADD1 is
begin
    S <= A xor B xor Cin;
    Cout <= (A and B) or (A and Cin) or (B and Cin);
end architecture df1;
