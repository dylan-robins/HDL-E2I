library ieee;
use ieee.std_logic_1164.all;

entity alarm_tb is
end alarm_tb;

architecture str of alarm_tb is
	signal clk          : std_logic := '0';
	signal s_nrst       : std_logic := '1';
	
    signal s_verrouille : std_logic := '0';
    signal s_porte      : std_logic := '0';
    signal s_force      : std_logic := '0';
    signal s_sirene     : std_logic := '0';

	component alarm is
		port(
	        clk         : in std_logic;
	        nrst        : in std_logic;
	        verrouille  : in std_logic;
	        porte       : in std_logic;
	        force       : in std_logic;
	
	        sirene      : out std_logic
		);
	end component;

begin 
	DUT:alarm
	port map(
	        clk          => clk, 
	        nrst         => s_nrst,
	        verrouille   => s_verrouille,
	        porte        => s_porte,
	        force        => s_force,
	        sirene       => s_sirene
	);

	clk <= not clk after 5 ns;
	
	-- STIMULI
	-- Test Simple
	s_verrouille <=
	    -- SAlarm_ON => SAlarm_Sonne (porte) => SAlarm_OFF
	    '1' after 10 ns, '0' after 40 ns,
	    -- SAlarm_ON => SAlarm_Sonne (force) => SAlarm_OFF
	    '1' after 50 ns, '0' after 80 ns,
	    -- SAlarm_ON => SAlarm_Sonne (force et porte) => SAlarm_OFF
	    '1' after 90 ns, '0' after 120 ns;
	s_porte  <= 
	    -- SAlarm_ON => SAlarm_Sonne (porte) => SAlarm_OFF
	    '1' after 20 ns, '0' after 30 ns,
	    -- SAlarm_ON => SAlarm_Sonne (force) => SAlarm_OFF
	    -- Rien à faire
	    -- SAlarm_ON => SAlarm_Sonne (force et porte) => SAlarm_OFF
	    '1' after 100 ns, '0' after 110 ns,
		-- Ouverture de porte (alarme coupée)
		'1' after 150 ns, '0' after 160 ns,
		-- Forçage voiture + ouverture porte (alarme coupée)
		'1' after 190 ns, '0' after 200 ns;
	s_force <=
	    -- SAlarm_ON => SAlarm_Sonne (porte) => SAlarm_OFF
	    -- Rien à faire
	    -- SAlarm_ON => SAlarm_Sonne (force) => SAlarm_OFF
	    '1' after 60 ns, '0' after 70 ns,
	    -- SAlarm_ON => SAlarm_Sonne (force et porte) => SAlarm_OFF
	    '1' after 100 ns, '0' after 110 ns,
		-- Forçage voiture (alarme coupée)
		'1' after 170 ns, '0' after 180 ns,
		-- Forçage voiture + ouverture porte (alarme coupée)
		'1' after 190 ns, '0' after 200 ns;
	end str;		
