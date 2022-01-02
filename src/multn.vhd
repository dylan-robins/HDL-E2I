library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity MULTN is
    generic (
        N: Natural := 4
    );
    port (
        OpA, OpB: in  std_logic_vector(N-1 downto 0);
        Res: out std_logic_vector(2*N-1 downto 0)
    );
end MULTN;

architecture dfl of MULTN is
begin
    Res <= OpA * OpB;
end architecture dfl;

