library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- for math operations on std_logic_vector
use ieee.numeric_std.all;	--utilisation to_unsigned

entity FACT is
    port (
	clk      : in std_logic;
	nrst      : in std_logic;
	
	start   : in std_logic;
	supa1   : in std_logic;
		
	muxprod  : out std_logic;
	prodload : out std_logic;
	loadCnt  : out std_logic;
	decount  : out std_logic;
	Output  : out std_logic
    );
end FACT;

architecture FACT_arch of FACT is
    type Etats is (SIdle, SStart, SProd, SDecrement, SOutput);
    signal etat_c, etat_s: Etats;
	signal s_etat_courant: std_logic_vector(3 downto 0);
    
begin
    -- PROCESS COMBINATOIRE
    process (etat_c, start, supa1)
    begin
	    case etat_c is
	        when SIdle =>
		        muxprod  <= '0';
		        prodload <= '0';
		        loadCnt  <= '0';
		        decount  <= '0';
		        Output   <= '0';
		        if (start = '1') then
		            etat_s <= SStart;
		        else
		            etat_s <= SIdle;
		        end if;
	        when SStart =>
		        muxprod  <= '1';
		        prodload <= '1';
		        loadCnt  <= '1';
		        decount  <= '0';
		        Output   <= '0';
		        if (supa1 = '1') then
		            etat_s <= SProd;
		        else
		            etat_s <= SOutput;
		        end if;
	        when SProd =>
		        muxprod  <= '0';
		        prodload <= '1';
		        loadCnt  <= '0';
		        decount  <= '0';
		        Output   <= '0';
		        etat_s   <= SDecrement;
	        when SDecrement =>
		        muxprod  <= '0';
		        prodload <= '0';
		        loadCnt  <= '0';
		        decount  <= '1';
		        Output   <= '0';
		        if (supa1 = '1') then
		            etat_s <= SProd;
		        else
		            etat_s <= SOutput;
		        end if;
	        when SOutput =>
		        muxprod  <= '0';
		        prodload <= '0';
		        loadCnt  <= '0';
		        decount  <= '0';
		        Output   <= '1';
		        etat_s <= SOutput;
	    end case;
    end process;

    -- PROCESS SEQUENTIEL
    process (clk, nrst)
    begin
	    if (nrst='0') then
	        etat_c <= SIdle;
	    elsif (clk'event and clk = '1') then
	        etat_c <= etat_s;
			s_etat_courant <= std_logic_vector(to_unsigned(Etats'POS(etat_s),s_etat_courant'length));  --Affichage de l'état du signal courant avec GHDL
	    end if;
    end process;
end architecture;

