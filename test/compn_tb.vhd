library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- for math operations on std_logic_vector

library TP_LIB;
use TP_LIB.COMPN;

entity COMPN_TB is
end COMPN_TB;

architecture str of COMPN_TB is
    constant c_N : natural := 4;

    signal clk : std_logic := '0';

    signal s_A, s_B : std_logic_vector(c_N - 1 downto 0) := (others => '0');

    signal s_AeqB, s_AgtB : std_logic;

    component COMPN is
        generic (
            N : natural := 4
        );
        port (
            X, Y       : in std_logic_vector(N - 1 downto 0);
            XeqY, XgtY : out std_logic
        );
    end component;

begin
    DUT : COMPN
    generic map(N => c_N) -- override la valeur de N par d�faut
    port map(
        X    => s_A,
        Y    => s_B,
        XeqY => s_AeqB,
        XgtY => s_AgtB
    );

    clk <= not clk after 5 ns;
    process (clk)
    begin
        if clk'event and clk = '1'
            then
            s_A <= s_A + 1;
        end if;
        if clk'event and clk = '1' and s_A = "1111"
            then
            s_B <= s_B + 1;
        end if;
    end process;
end str;
