library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- for math operations on std_logic_vector
use ieee.numeric_std.all;        --utilisation to_unsigned

library TP_LIB;
use TP_LIB.PGCD_DP;
use TP_LIB.PGCD;

entity PGCD_DP_FSM is
    generic (N : natural := 8);
    port (
        clk   : in std_logic;
        nrst  : in std_logic;
        start : in std_logic;
        X     : in std_logic_vector(N - 1 downto 0);  -- data in
        Y     : in std_logic_vector(N - 1 downto 0);  -- data in
        Q     : out std_logic_vector(N - 1 downto 0); -- data out
        done  : out std_logic
    );
end PGCD_DP_FSM;

architecture str of PGCD_DP_FSM is
    signal s_selx   : std_logic;
    signal s_sely   : std_logic;
    signal s_loadx  : std_logic;
    signal s_loady  : std_logic;
    signal s_muxsub : std_logic;
    signal s_XeqY   : std_logic;
    signal s_XgtY   : std_logic;
    signal s_gcd    : std_logic;

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

    component PGCD is
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
    end component;

begin
    DP : PGCD_DP
    generic map(N => N)
    port map(
        clk    => clk,
        nrst   => nrst,
        selx   => s_selx,
        sely   => s_sely,
        loadx  => s_loadx,
        loady  => s_loady,
        muxsub => s_muxsub,
        gcd    => s_gcd,
        X      => X,
        Y      => Y,
        Q      => Q,
        XeqY   => s_XeqY,
        XgtY   => s_XgtY
    );

    FSM : PGCD
    port map(
        clk    => clk,
        nrst   => nrst,
        start  => start,
        xegaly => s_xeqy,
        xsupy  => s_xgty,
        gcd    => s_gcd,
        selx   => s_selx,
        sely   => s_sely,
        muxsel => s_muxsub,
        loadx  => s_loadx,
        loady  => s_loady
    );
    done <= s_gcd;
end architecture;
