library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- for math operations on std_logic_vector
use ieee.numeric_std.all;	--utilisation to_unsigned


entity CAFE is
    port (
	clk      : in std_logic;
	rst      : in std_logic;
	
	cinq_in  : in std_logic;
	dix_in   : in std_logic;
	vingt_in : in std_logic;
	
	cafe     : out std_logic;
	cinq_out : out std_logic;
	dix_out  : out std_logic
    );
end CAFE;

architecture CAFE_arch of cafe is
    type Etats is (S0, S5, S10, S15, S20, S25, S30, S35);
    signal etat_c, etat_s: Etats;
	signal s_etat_courant: std_logic_vector(3 downto 0);
    
begin
    -- PROCESS COMBINATOIRE
    process (etat_c, cinq_in, dix_in, vingt_in)
    begin
	    case etat_c is
	        when S0 =>
		        cafe     <= '0';
		        cinq_out <= '0';
		        dix_out  <= '0';
		        if (cinq_in = '1') then
		            etat_s <= S5;
		        elsif (dix_in = '1') then
		            etat_s <= S10;
		        elsif (vingt_in = '1') then
		            etat_s <= S20;
		        else
		            etat_s <= S0;
		    end if;
	        when S5 =>
		        cafe     <= '0';
		        cinq_out <= '0';
		        dix_out  <= '0';
		        if (cinq_in = '1') then
		            etat_s <= S10;
		        elsif (dix_in = '1') then
		            etat_s <= S15;
		        elsif (vingt_in = '1') then
		            etat_s <= S25;
		        else
		            etat_s <= S5;
		        end if;
	        when S10 =>
		        cafe     <= '0';
		        cinq_out <= '0';
		        dix_out  <= '0';
		        if (cinq_in = '1') then
		            etat_s <= S15;
		        elsif (dix_in = '1') then
		            etat_s <= S20;
		        elsif (vingt_in = '1') then
		            etat_s <= S30;
		        else
		            etat_s <= S10;
		        end if;
	        when S15 =>
		        cafe     <= '0';
		        cinq_out <= '0';
		        dix_out  <= '0';
		        if (cinq_in = '1') then
		            etat_s <= S20;
		        elsif (dix_in = '1') then
		            etat_s <= S25;
		        elsif (vingt_in = '1') then
		            etat_s <= S35;
		        else
		            etat_s <= S15;
		        end if;
	        when S20 =>
		        cafe     <= '1';
		        cinq_out <= '0';
		        dix_out  <= '0';
		        etat_s <= S0;
	        when S25 =>
		        cafe     <= '1';
		        cinq_out <= '1';
		        dix_out  <= '0';
		        etat_s <= S0;
	        when S30 =>
		        cafe     <= '1';
		        cinq_out <= '0';
		        dix_out  <= '1';
		        etat_s <= S0;
	        when S35 =>
		        cafe     <= '1';
		        cinq_out <= '1';
		        dix_out  <= '1';
		        etat_s <= S0;
	    end case;
    end process;

    -- PROCESS SEQUENTIEL
    process (clk, rst)
    begin
	    if (rst='1') then
	        etat_c <= S0;
	    elsif (clk'event and clk = '1') then
	        etat_c <= etat_s;
			s_etat_courant <= std_logic_vector(to_unsigned(Etats'POS(etat_s),s_etat_courant'length));  --Affichage de l'état du signal courant avec GHDL
	    end if;
    end process;
end architecture;

