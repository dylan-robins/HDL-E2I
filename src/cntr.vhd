library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity CNTR is
	generic (
		N : natural := 8
	);
	port (
		CLK  : in std_logic;
		EN   : in std_logic := '0';                 -- enable
		UD   : in std_logic := '0';                 -- up/down: 0=incr, 1=decr
		LD   : in std_logic := '0';                 -- Preload
		nRST : in std_logic := '1';                 -- Reset (inverted)
		D    : in std_logic_vector(N - 1 downto 0); -- input data
		Q    : out std_logic_vector(N - 1 downto 0) -- output data
	);
end CNTR;

architecture dfl of CNTR is
	-- Internal counter buffer
	signal counter : std_logic_vector(N - 1 downto 0);
begin
	-- Map output to internal counter buffer
	Q <= counter;

	process (CLK, nRST)
	begin
		if (nRST = '0')
			then
			if (LD = '1')
				then
				-- PRELOAD LOGIC
				counter <= D;
			else
				-- RESET LOGIC
				counter <= (others => '0');
			end if;
		elsif (CLK'event and CLK = '1')
			-- COUNTER LOGIC
			then
			-- only run counter if EN is '1'
			if (EN = '1')
				then
				if (UD = '0')
					then
					counter <= counter + '1';
				else
					counter <= counter - '1';
				end if;
			else
				counter <= counter;
			end if;
		else
			counter <= counter;
		end if;
	end process;
end architecture dfl;
