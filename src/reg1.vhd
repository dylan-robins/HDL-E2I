library ieee;
use ieee.std_logic_1164.all;

entity REG1 is
    port (
        CLK : in  std_logic;
        LD  : in  std_logic;
        D   : in  std_logic; -- data in
        nRST: in  std_logic;
        Q   : out std_logic  -- data out
    );
end REG1;

architecture df1 of REG1 is
begin
    process (CLK, nRST)
    begin
        if (nRST = '0')
        -- REST LOGIC
        then
            Q <= '0';
        elsif (CLK'event and CLK = '1')
        then
        if (LD = '1')
            -- LOAD LOGIC
            then
                Q <= D;
            end if;
        end if;
    end process;
end architecture df1;

