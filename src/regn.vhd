library ieee;
use ieee.std_logic_1164.all;

library TP_LIB;
use TP_LIB.REG1;

entity REGN is
    generic (N : natural := 8);
    port (
        CLK  : in std_logic;
        LD   : in std_logic;
        D    : in std_logic_vector(N - 1 downto 0); -- data in
        nRST : in std_logic;
        Q    : out std_logic_vector(N - 1 downto 0) -- data out
    );
end REGN;

architecture str of REGN is
    component REG1 is
        port (
            CLK  : in std_logic;
            LD   : in std_logic;
            D    : in std_logic; -- data in
            nRST : in std_logic;
            Q    : out std_logic -- data out
        );
    end component;
begin
    REG_insts : for k in 0 to N - 1 generate
        REG_inst : REG1 port map(CLK, LD, D(k), nRST, Q(k));
    end generate;
end architecture;
