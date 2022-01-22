library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- for math operations on std_logic_vector
use ieee.numeric_std.all;        --utilisation to_unsigned

entity SUMN_FSM is
	port (
		clk      : in std_logic;
		nrst     : in std_logic;
		start    : in std_logic;
		diff0    : in std_logic;
		enCnt    : out std_logic;
		regload  : out std_logic
	);
end SUMN_FSM;

architecture SUMN_arch of SUMN_FSM is
	type Etats is (SIdle, SAdd, SDecrement, SOutput);
	signal etat_c, etat_s : Etats;

begin
	-- PROCESS COMBINATOIRE
	process (etat_c, start, diff0)
	begin
		case etat_c is
			when SIdle =>
				enCnt   <= '0';
				regload <= '0';
				if (start = '1') then
                    if (diff0 = '1') then
    					etat_s <= SAdd;
                    else
    					etat_s <= SOutput;
                    end if;
				else
					etat_s <= SIdle;
				end if;
			when SAdd =>
				enCnt   <= '0';
				regload <= '1';

				etat_s   <= SDecrement;
			when SDecrement =>
				regload <= '0';
                if (diff0 = '1') then
    				enCnt <= '1';
                else
                    enCnt <= '0';
                end if;

				if (diff0 = '1') then
					etat_s <= SAdd;
				else
					etat_s <= SOutput;
				end if;
			when SOutput =>
				enCnt   <= '0';
				regload <= '0';

				etat_s   <= SOutput;
		end case;
	end process;

	-- PROCESS SEQUENTIEL
	process (clk, nrst)
	begin
		if (nrst = '0') then
			etat_c <= SIdle;
			elsif (clk'event and clk = '1') then
			etat_c         <= etat_s;
		end if;
	end process;
end architecture;
