library ieee;
use ieee.std_logic_1164.all;

entity REG1 is
    port (
        CLK  : in std_logic;
        LD   : in std_logic;
        D    : in std_logic; -- data in
        nRST : in std_logic;
        Q    : out std_logic -- data out
    );
end REG1;

architecture df1 of REG1 is
    signal buf : std_logic := '0';
begin
    process (CLK, nRST)
    begin
        if (nRST = '0') then
            -- RESET LOGIC
            buf <= '0';
        elsif (CLK'event and CLK = '1') then
            if (LD = '1') then
                -- LOAD LOGIC
                buf <= D;
            else
                buf <= buf;
            end if;
        else
            buf <= buf;
        end if;
    end process;

    Q <= buf;
end architecture df1;
