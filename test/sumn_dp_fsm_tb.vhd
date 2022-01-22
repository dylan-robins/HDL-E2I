library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; --utilisation to_unsigned

library TP_LIB;
use TP_LIB.SUMN_DP_FSM;

entity SUMN_DP_FSM_TB is
end SUMN_DP_FSM_TB;

architecture str of SUMN_DP_FSM_TB is
	constant N     : natural                          := 8;
	signal s_clk   : std_logic                        := '0';
	signal s_nrst  : std_logic                        := '1';
	signal s_start : std_logic                        := '0';
	signal s_D     : std_logic_vector(N - 1 downto 0) := std_logic_vector(to_unsigned(0, N));
	signal s_Q     : std_logic_vector(N - 1 downto 0);
	signal s_done  : std_logic;

	component SUMN_DP_FSM is
		generic (N : natural);
		port (
			clk   : in std_logic;
			nrst  : in std_logic;
			start : in std_logic;
			D     : in std_logic_vector(N - 1 downto 0);
			Q     : out std_logic_vector(N - 1 downto 0);
			done  : out std_logic
		);
	end component;

begin
	DUT : SUMN_DP_FSM
	generic map(N => N)
	port map(
		clk   => s_clk,
		nrst  => s_nrst,
		start => s_start,
		D     => s_D,
		Q     => s_Q,
		done  => s_done
	);

	s_clk <= not s_clk after 5 ns;

	-- STIMULI
	-- Test Simple
	s_D <=
	-- Calcul f(11)
	std_logic_vector(to_unsigned(11, N)) after 0 ns,
	-- Calcul f(1)
	std_logic_vector(to_unsigned(1, N)) after 260 ns,
	-- Calcul f(5)
	std_logic_vector(to_unsigned(5, N)) after 310 ns;

	s_start <=
	-- Calcul f(11)
	'1' after 20 ns, '0' after 30 ns,
	-- Calcul f(1)
	'1' after 270 ns, '0' after 280 ns,
	-- Calcul f(5)
	'1' after 330 ns, '0' after 340 ns;

	s_nrst <=
	'0' after 10 ns, '1' after 20 ns,
	'0' after 260 ns, '1' after 270 ns,
	'0' after 310 ns, '1' after 320 ns;
end str;
