library ieee;
use ieee.std_logic_1164.all;

library TP_LIB;
use TP_LIB.PGCD;

entity PGCD_tb is
end PGCD_tb;

architecture str of PGCD_tb is
	signal clk      : std_logic := '0';
	signal s_nrst   : std_logic := '1';
	signal s_start  : std_logic := '0';
	signal s_xegaly : std_logic := '0';
	signal s_xsupy  : std_logic := '0';
	signal s_gcd    : std_logic := '0';
	signal s_selx   : std_logic := '0';
	signal s_sely   : std_logic := '0';
	signal s_muxsel : std_logic := '0';
	signal s_loadx  : std_logic := '0';
	signal s_loady  : std_logic := '0';

	component PGCD is
		port (
			clk    : in std_logic;
			nrst   : in std_logic;
			start  : in std_logic;
			xegaly : in std_logic;
			xsupy  : in std_logic;
			gcd    : out std_logic;
			selx   : out std_logic;
			sely   : out std_logic;
			muxsel : out std_logic;
			loadx  : out std_logic;
			loady  : out std_logic
		);
	end component;

begin
	DUT : PGCD
	port map(
		clk    => clk,
		nrst   => s_nrst,
		start  => s_start,
		xegaly => s_xegaly,
		xsupy  => s_xsupy,
		gcd    => s_gcd,
		selx   => s_selx,
		sely   => s_sely,
		muxsel => s_muxsel,
		loadx  => s_loadx,
		loady  => s_loady
	);

	clk <= not clk after 5 ns;

	-- STIMULI
	-- Test Simple
	s_start <=
		-- SStart => SDoGCD => SFin
		'1' after 10 ns, '0' after 20 ns,
		-- SStart => SDoGCD => SXmoinsY => SDoGCD => => SYmoinsX => SDoGCD => SFin
		'1' after 50 ns, '0' after 60 ns;
	s_xegaly <=
		-- SStart => SDoGCD => SFin
		'1' after 20 ns, '0' after 30 ns,
		-- SStart => SDoGCD => SXmoinsY => SDoGCD => => SYmoinsX => SDoGCD => SFin
		'1' after 100 ns, '0' after 110 ns;
	s_xsupy <=
		-- SStart => SDoGCD => SFin
		'0' after 40 ns, '1' after 50 ns,
		-- SStart => SDoGCD => SXmoinsY => SDoGCD => => SYmoinsX => SDoGCD => SFin
		'1' after 60 ns, '0' after 70 ns;
	s_nrst <=
		-- SStart => SDoGCD => SFin
		'0' after 40 ns, '1' after 50 ns;
end str;
