library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- for math operations on std_logic_vector
use ieee.numeric_std.all;        --utilisation to_unsigned

entity alarm is
	port (
		clk        : in std_logic;
		nrst       : in std_logic;
		verrouille : in std_logic;
		porte      : in std_logic;
		force      : in std_logic;
		sirene     : out std_logic
	);
end alarm;

architecture alarm_arch of alarm is
	type Etats is (SAlarm_ON, SAlarm_OFF, SAlarm_Sonne);
	signal etat_c, etat_s : Etats;
	signal s_etat_courant : std_logic_vector(3 downto 0);

begin
	-- PROCESS COMBINATOIRE
	process (etat_c, verrouille, porte, force)
	begin
		case etat_c is
			when SAlarm_ON =>
				sirene <= '0';
				if (porte = '1' or force = '1') then
					etat_s <= SAlarm_Sonne;
				elsif (verrouille = '0') then
					etat_s <= SAlarm_OFF;
				else
					etat_s <= SAlarm_ON;
				end if;
			when SAlarm_OFF =>
				sirene <= '0';
				if (verrouille = '1') then
					etat_s <= SAlarm_ON;
				else
					etat_s <= SAlarm_OFF;
				end if;
			when SAlarm_Sonne =>
				sirene <= '1';
				if (verrouille = '0') then
					etat_s <= SAlarm_OFF;
				else
					etat_s <= SAlarm_Sonne;
				end if;
		end case;
	end process;

	-- PROCESS SEQUENTIEL
	process (clk, nrst)
	begin
		if (nrst = '0') then
			etat_c <= SAlarm_OFF;
		elsif (clk'event and clk = '1') then
			etat_c         <= etat_s;
			s_etat_courant <= std_logic_vector(to_unsigned(Etats'POS(etat_s), s_etat_courant'length)); --Affichage de l'état du signal courant avec GHDL
		end if;
	end process;
end architecture;
