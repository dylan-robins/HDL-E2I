library ieee;
use ieee.std_logic_1164.all;

entity COMPN is
    generic (
        N: Natural := 4
    );
    port (
        X, Y       : in std_logic_vector(N-1 downto 0);
        XeqY, XgtY : out std_logic
    );
end COMPN;

architecture dfl of COMPN is
begin
    process (X, Y)
    begin
        if X = Y
        then XeqY <= '1';
        else XeqY <= '0';
        end if;
        if X > Y
        then XgtY <= '1';
        else XgtY <= '0';
        end if;
    end process;
end architecture dfl;

