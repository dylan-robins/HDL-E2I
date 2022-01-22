library ieee;
use ieee.std_logic_1164.all;

library TP_LIB;
use TP_LIB.SUMN_FSM;

entity SUMN_FSM_TB is
end SUMN_FSM_TB;

architecture str of SUMN_FSM_TB is
    signal clk        : std_logic := '0';
    signal s_nrst     : std_logic := '1';
    signal s_start    : std_logic := '0';
    signal s_diff0    : std_logic := '0';
    signal s_enCnt    : std_logic := '0';
    signal s_regload  : std_logic := '0';

	component SUMN_FSM is
		port (
            clk      : in std_logic;
            nrst     : in std_logic;
            start    : in std_logic;
            diff0    : in std_logic;
            enCnt    : out std_logic;
            regload  : out std_logic
		);
	end component;

begin
	DUT : SUMN_FSM
	port map(

		clk     => clk,
		nrst    => s_nrst,
		start   => s_start,
		diff0   => s_diff0,
		enCnt   => s_enCnt,
		regload => s_regload
	);

	clk <= not clk after 5 ns;

	-- STIMULI
	-- Test Simple
	s_start <=
		-- Idle  => Output
        '1' after 10 ns, '0' after 20 ns,
		-- Idle  => Add => Decrement => Add => Decrement => Output
        '1' after 50 ns, '0' after 60 ns;
	s_diff0 <=
		-- Idle => Output: Nothing to do
		-- Idle  => Add => Decrement => Add => Decrement => Output
        '1' after 50 ns, '0' after 80 ns;
	s_nrst <= '0' after 30 ns, '1' after 40 ns;
end str;
