library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- for math operations on std_logic_vector

entity cafe_tb is
end cafe_tb;

architecture str of cafe_tb is
	signal clk : std_logic := '0';
	signal s_rst : std_logic := '0';
	
    signal s_cinq_in  : std_logic := '0';
    signal s_dix_in   : std_logic := '0';
    signal s_vingt_in : std_logic := '0';
	
    signal s_cafe     : std_logic := '0';
    signal s_cinq_out : std_logic := '0';
    signal s_dix_out  : std_logic := '0';

	component CAFE is
		port(
	        clk      : in std_logic;
	        rst      : in std_logic;
	
	        cinq_in  : in std_logic;
	        dix_in   : in std_logic;
	        vingt_in : in std_logic;
	
	        cafe     : out std_logic;
	        cinq_out : out std_logic;
	        dix_out  : out std_logic
		);
	end component;

begin 
	DUT:CAFE
	port map(
	        clk      => clk,
	        rst      => s_rst,
	
	        cinq_in  => s_cinq_in,
	        dix_in   => s_dix_in,
	        vingt_in => s_vingt_in,
	
	        cafe     => s_cafe,
	        cinq_out => s_cinq_out,
	        dix_out  => s_dix_out
	);

	clk <= not clk after 5 ns;
	
	-- STIMULI
	-- Test Simple
	s_cinq_in <=
	    -- Stimuli de base
	    '1' after 10 ns, '0' after 50 ns,
	    -- Débordement 5+10+10
	    '1' after 150 ns, '0' after 160 ns,
	    -- Débordement 5+20
	    '1' after 190 ns, '0' after 200 ns,
	    -- Débordement 5+10+20
	    '1' after 220 ns, '0' after 230 ns;
	    -- Débordement 10+20
	    -- Rien à faire
	s_dix_in  <=
	    -- Stimuli de base
	    '1' after 70 ns, '0' after 90 ns, 
	    -- Débordement 5+10+10
        '1' after 160 ns, '0' after 180 ns,
	    -- Débordement 5+20
	    -- Rien a faire
	    -- Débordement 5+10+20
	    '1' after 230 ns, '0' after 240 ns,
	    -- Débordement 10+20
	    '1' after 270 ns, '0' after 280 ns;
	    
	s_vingt_in  <=
	    -- Stimuli de base
	    '1' after 110 ns, '0' after 120 ns,
	    -- Débordement 5+10+10
	    -- Rien a faire
	    -- Débordement 5+20
	    '1' after 200 ns, '0' after 210 ns,
	    -- Débordement 5+10+20
	    '1' after 240 ns, '0' after 250 ns,
	    -- Débordement 10+20
	    '1' after 280 ns, '0' after 290 ns;
	
end str;		
