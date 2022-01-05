library ieee;
use ieee.std_logic_1164.all;

library TP_LIB;
use TP_LIB.FACT_FSM;

entity FACT_FSM_TB is
end FACT_FSM_TB;

architecture str of FACT_FSM_TB is
	signal clk        : std_logic := '0';
	signal s_nrst     : std_logic := '1';
	signal s_start    : std_logic := '0';
	signal s_supa1    : std_logic := '0';
	signal s_muxprod  : std_logic := '0';
	signal s_prodload : std_logic := '0';
	signal s_loadCnt  : std_logic := '0';
	signal s_decount  : std_logic := '0';
	signal s_Output   : std_logic := '0';

	component FACT_FSM is
		port (
			clk      : in std_logic;
			nrst     : in std_logic;
			start    : in std_logic;
			supa1    : in std_logic;
			muxprod  : out std_logic;
			prodload : out std_logic;
			loadCnt  : out std_logic;
			decount  : out std_logic;
			Output   : out std_logic
		);
	end component;

begin
	DUT : FACT_FSM
	port map(
		clk      => clk,
		nrst     => s_nrst,
		start    => s_start,
		supa1    => s_supa1,
		muxprod  => s_muxprod,
		prodload => s_prodload,
		loadCnt  => s_loadCnt,
		decount  => s_decount,
		Output   => s_output
	);

	clk <= not clk after 5 ns;

	-- STIMULI
	-- Test Simple
	s_start <=
		-- Idle => Start => Output
		'1' after 10 ns, '0' after 20 ns,
		-- Idle => Start => Prod => Decrement => Output
		'1' after 60 ns, '0' after 70 ns;
	s_supa1 <=
		-- Idle => Start => Output
		-- Rien à faire
		-- Idle => Start => Prod => Decrement => Output
		'1' after 70 ns, '0' after 100 ns;
	s_nrst <=
		'0' after 40 ns, '1' after 50 ns;
end str;
