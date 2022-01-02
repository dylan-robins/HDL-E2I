library ieee;
use ieee.std_logic_1164.all;

entity MUX2v1 is
    generic (
        N: Natural := 4
    );
    port (
        D0, D1: in  std_logic_vector(N-1 downto 0);
        ctrl: in std_logic;
        S   : out std_logic_vector(N-1 downto 0)
    );
end MUX2v1;

architecture dfl of MUX2v1 is
begin

    S <= D0 when (ctrl = '0') else D1;

end architecture dfl;


