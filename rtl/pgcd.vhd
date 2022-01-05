library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- for math operations on std_logic_vector
use ieee.numeric_std.all;        --utilisation to_unsigned

entity PGCD is
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
end PGCD;

architecture PGCD_arch of PGCD is
	type Etats is (SStart, SDoGCD, SFin, SXmoinsY, SYmoinsX);
	signal etat_c, etat_s : Etats;
	signal s_etat_courant : std_logic_vector(3 downto 0);

begin
	-- PROCESS COMBINATOIRE
	process (etat_c, start, xegaly, xsupy)
	begin
		case etat_c is
			when SStart =>
				selx   <= '1';
				sely   <= '1';
				loadx  <= '1';
				loady  <= '1';
				muxsel <= '-'; -- '-' = don't care
				gcd    <= '0';
				if (start = '1') then
					etat_s <= SDoGCD;
				else
					etat_s <= SStart;
				end if;
			when SDoGCD =>
				selx   <= '-';
				sely   <= '-';
				loadx  <= '0';
				loady  <= '0';
				muxsel <= '-'; -- '-' = don't care
				gcd    <= '0';
				if (xegaly = '1') then
					etat_s <= SFin;
				else
					if (xsupy = '1') then
						etat_s <= SXmoinsY;
					else
						etat_s <= SYmoinsX;
					end if;
				end if;
			when SFin =>
				selx   <= '-';
				sely   <= '-';
				loadx  <= '0';
				loady  <= '0';
				muxsel <= '-'; -- '-' = don't care
				gcd    <= '1';
				etat_s <= SFin;
			when SXmoinsY =>
				selx   <= '0';
				sely   <= '-';
				loadx  <= '1';
				loady  <= '0';
				muxsel <= '1'; -- '-' = don't care
				gcd    <= '0';
				etat_s <= SDoGCD;
			when SYmoinsX =>
				selx   <= '-';
				sely   <= '0';
				loadx  <= '0';
				loady  <= '1';
				muxsel <= '0'; -- '-' = don't care
				gcd    <= '0';
				etat_s <= SDoGCD;
		end case;
	end process;

	-- PROCESS SEQUENTIEL
	process (clk, nrst)
	begin
		if (nrst = '0') then
			etat_c <= SStart;
		elsif (clk'event and clk = '1') then
			etat_c         <= etat_s;
			s_etat_courant <= std_logic_vector(to_unsigned(Etats'POS(etat_s), s_etat_courant'length)); --Affichage de l'état du signal courant avec GHDL
		end if;
	end process;
end architecture;
