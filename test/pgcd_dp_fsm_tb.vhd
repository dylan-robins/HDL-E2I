library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; --utilisation to_unsigned

library TP_LIB;
use TP_LIB.PGCD_DP_FSM;

entity PGCD_DP_FSM_TB is
end PGCD_DP_FSM_TB;

architecture str of PGCD_DP_FSM_TB is
	constant N     : natural                          := 8;
	signal s_clk   : std_logic                        := '0';
	signal s_nrst  : std_logic                        := '1';
	signal s_start : std_logic                        := '0';
	signal s_X     : std_logic_vector(N - 1 downto 0) := std_logic_vector(to_unsigned(0, N));
	signal s_Y     : std_logic_vector(N - 1 downto 0) := std_logic_vector(to_unsigned(0, N));
	signal s_Q     : std_logic_vector(N - 1 downto 0);
	signal s_done  : std_logic;

	component PGCD_DP_FSM is
		generic (N : natural := 8);
		port (
			clk   : in std_logic;
			nrst  : in std_logic;
			start : in std_logic;
			X     : in std_logic_vector(N - 1 downto 0);  -- data in
			Y     : in std_logic_vector(N - 1 downto 0);  -- data in
			Q     : out std_logic_vector(N - 1 downto 0); -- data out
			done  : out std_logic
		);
	end component;

begin
	DUT : PGCD_DP_FSM
	generic map(N => N)
	port map(
		clk   => s_clk,
		nrst  => s_nrst,
		start => s_start,
		X     => s_X,
		Y     => s_Y,
		Q     => s_Q,
		done  => s_done
	);

	s_clk <= not s_clk after 5 ns;

	-- STIMULI
	-- Test Simple
	s_X <=
	-- Calcul PGCD(6, 9)
	std_logic_vector(to_unsigned(6, N)) after 0 ns,
	-- Calcul PGCD(250, 225)
	std_logic_vector(to_unsigned(250, N)) after 80 ns;

	s_Y <=
	-- Calcul PGCD(6, 9)
	std_logic_vector(to_unsigned(9, N)) after 0 ns,
	-- Calcul PGCD(250, 225)
	std_logic_vector(to_unsigned(225, N)) after 80 ns;

	s_start <=
	-- Calcul PGCD(6, 9)
	'1' after 10 ns, '0' after 20 ns,
	-- Calcul PGCD(250, 225)
	'1' after 100 ns, '0' after 110 ns;

	s_nrst <=
	'0' after 90 ns, '1' after 100 ns;

end str;
