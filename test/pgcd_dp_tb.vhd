library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- for math operations on std_logic_vector
use ieee.numeric_std.all;        --utilisation to_unsigned

library TP_LIB;
use TP_LIB.PGCD_DP;

entity PGCD_DP_TB is
end PGCD_DP_TB;

architecture str of PGCD_DP_TB is
    constant N : natural := 8;

    signal s_clk    : std_logic := '0';
    signal s_nrst   : std_logic := '0';
    signal s_selx   : std_logic := '0';
    signal s_sely   : std_logic := '0';
    signal s_loadx  : std_logic := '0';
    signal s_loady  : std_logic := '0';
    signal s_muxsub : std_logic := '0';
    signal s_gcd    : std_logic;
    signal s_X      : std_logic_vector(N - 1 downto 0) := std_logic_vector(to_unsigned(6, N)); -- data in
    signal s_Y      : std_logic_vector(N - 1 downto 0) := std_logic_vector(to_unsigned(9, N)); -- data in
    signal s_Q      : std_logic_vector(N - 1 downto 0);                                        -- data out
    signal s_XeqY   : std_logic;
    signal s_XgtY   : std_logic;

    component PGCD_DP is
        generic (N : natural);
        port (
            clk    : in std_logic;
            nrst   : in std_logic;
            selx   : in std_logic;
            sely   : in std_logic;
            loadx  : in std_logic;
            loady  : in std_logic;
            muxsub : in std_logic;
            gcd    : in std_logic;
            X      : in std_logic_vector(N - 1 downto 0);  -- data in
            Y      : in std_logic_vector(N - 1 downto 0);  -- data in
            Q      : out std_logic_vector(N - 1 downto 0); -- data out
            XeqY   : out std_logic;
            XgtY   : out std_logic
        );
    end component;

begin
    DUT : PGCD_DP
    generic map(N => N)
    port map(
        clk    => s_clk,
        nrst   => s_nrst,
        selx   => s_selx,
        sely   => s_sely,
        loadx  => s_loadx,
        loady  => s_loady,
        muxsub => s_muxsub,
        gcd    => s_gcd,
        X      => s_X,
        Y      => s_Y,
        Q      => s_Q,
        XeqY   => s_XeqY,
        XgtY   => s_XgtY
    );

    s_clk <= not s_clk after 5 ns;

    -- STIMULI

    s_nrst <= '0' after 10 ns, '1' after 20 ns;

    s_selx <=
    -- Etat start
    '1' after 30 ns,
    -- Etat dogcd: rien a faire à 40 ns
    -- Etat YmoinsX: rien à faire à 50 ns
    -- Etat dogcd: rien a faire à 60 ns
    -- Etat XmoinsY
    '0' after 70 ns
    -- Etat dogcd: rien a faire à 80 ns
    -- Etat fin: rien a faire à 90 ns
    ;

    s_sely <=
    -- Etat start
    '1' after 30 ns,
    -- Etat dogcd: rien a faire à 40 ns
    -- Etat YmoinsX
    '0' after 50 ns
    -- Etat dogcd: rien a faire à 60 ns
    -- Etat XmoinsY: rien à faire à 70 ns
    -- Etat dogcd: rien a faire à 80 ns
    -- Etat fin: rien a faire à 90 ns
    ;

    s_loadx <=
    -- Etat start
    '1' after 30 ns,
    -- Etat dogcd
    '0' after 40 ns,
    -- Etat YmoinsX
    '0' after 50 ns,
    -- Etat dogcd: rien a faire à 60 ns
    -- Etat XmoinsY
    '1' after 70 ns,
    -- Etat dogcd
    '0' after 80 ns
    -- Etat fin: rien a faire à 90 ns
    ;

    s_loady <=
    -- Etat start
    '1' after 30 ns,
    -- Etat dogcd
    '0' after 40 ns,
    -- Etat YmoinsX
    '1' after 50 ns,
    -- Etat dogcd
    '0' after 60 ns
    -- Etat XmoinsY: rien à faire à 70 ns
    -- Etat dogcd: rien a faire à 80 ns
    -- Etat fin: rien a faire à 90 ns
    ;

    s_muxsub <=
    -- Etat start: rien a faire à 30 ns
    -- Etat dogcd: rien a faire à 40 ns
    -- Etat YmoinsX
    '0' after 50 ns,
    -- Etat dogcd: rien a faire à 60 ns
    -- Etat XmoinsY
    '1' after 70 ns
    -- Etat dogcd: rien a faire à 80 ns
    -- Etat fin: rien a faire à 90 ns
    ;

    s_gcd <=
    -- Etat start: rien a faire à 30 ns
    -- Etat dogcd: rien a faire à 40 ns
    -- Etat YmoinsX: rien a faire à 50 ns
    -- Etat dogcd: rien a faire à 60 ns
    -- Etat XmoinsY: rien à faire à 70 ns
    -- Etat dogcd: rien a faire à 80 ns
    -- Etat fin
    '1' after 90 ns;

end str;
