library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- for math operations on std_logic_vector

library TP_LIB;
use TP_LIB.MUX2v1;

entity MUX2v1_TB is
end MUX2v1_TB;

architecture str of MUX2v1_TB is
    constant c_N : natural := 4;

    signal clk : std_logic := '0';

    -- entrées du mux
    signal s_A : std_logic_vector(c_N - 1 downto 0) := (others => '0');
    signal s_B : std_logic_vector(c_N - 1 downto 0) := (others => '1');
    -- sorties du mux
    signal s_S : std_logic_vector(c_N - 1 downto 0);

    component MUX2v1 is
        generic (N : natural := 8);
        port (
            D0, D1 : in std_logic_vector(N - 1 downto 0);
            ctrl   : in std_logic;
            S      : out std_logic_vector(N - 1 downto 0)
        );
    end component;

begin
    DUT : MUX2v1
    generic map(N => c_N) -- override la valeur de N par d�faut
    port map(
        D0   => s_A,
        D1   => s_B,
        ctrl => clk,
        S    => s_S
    );

    clk <= not clk after 5 ns;
end str;
