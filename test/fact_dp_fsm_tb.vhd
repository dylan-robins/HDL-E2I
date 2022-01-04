library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; --utilisation to_unsigned

library TP_LIB;
use TP_LIB.FACT_DP_FSM;

entity FACT_DP_FSM_TB is
end FACT_DP_FSM_TB;

architecture str of FACT_DP_FSM_TB is
	constant N     : natural                          := 8;
	signal s_clk   : std_logic                        := '0';
	signal s_nrst  : std_logic                        := '1';
	signal s_start : std_logic                        := '0';
	signal s_D     : std_logic_vector(N - 1 downto 0) := std_logic_vector(to_unsigned(0, N));
	signal s_Q     : std_logic_vector(N - 1 downto 0);
	signal s_done  : std_logic;

	component FACT_DP_FSM is
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
	DUT : FACT_DP_FSM
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
	-- Calcul fact(1)
	std_logic_vector(to_unsigned(1, N)) after 0 ns,
	-- Calcul fact(3)
	std_logic_vector(to_unsigned(3, N)) after 40 ns,
	-- Calcul fact(5)
	std_logic_vector(to_unsigned(5, N)) after 130 ns;

	s_start <=
	-- Calcul fact(1)
	'1' after 10 ns, '0' after 20 ns,
	-- Calcul fact(3)
	'1' after 40 ns, '0' after 50 ns,
	-- Calcul fact(3)
	'1' after 130 ns, '0' after 140 ns;

	s_nrst <=
	-- Entre fact(1) et fact(3)
	'0' after 30 ns, '1' after 40 ns,
	-- Entre fact(3) et fact(5)
	'0' after 120 ns, '1' after 130 ns;
end str;
