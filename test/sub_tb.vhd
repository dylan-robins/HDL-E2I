library ieee;
use ieee.std_logic_1164.all;
library TP_LIB;
use TP_LIB.SUB1;

entity SUB_TB is
end SUB_TB;

architecture str of SUB_TB is
    signal sA, sB, sCin : std_logic := '0';
    signal sCout, s_s   : std_logic;
    component SUB1 is
        port (
            A, B, Cin : in std_logic;
            S, Cout   : out std_logic
        );
    end component;

begin
    DUT : SUB1 port map(
        A    => sA,
        B    => sB,
        Cin  => SCin,
        S    => s_s,
        Cout => SCout
    );
    sA   <= '1' after 40 ns;
    sB   <= '1' after 20 ns, '0' after 40 ns, '1' after 60 ns;
    SCin <= not Scin after 10 ns;
end str;
