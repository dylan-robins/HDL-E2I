library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; --utilisation to_unsigned

library TP_LIB;
use TP_LIB.REGN;
use TP_LIB.MUX2v1;
use TP_LIB.SUBN;
use TP_LIB.COMPN;

entity PGCD_DP is
    generic (N : natural := 32);
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
end PGCD_DP;

architecture str of PGCD_DP is
    signal s_mux_X_out : std_logic_vector(N - 1 downto 0);
    signal s_mux_Y_out : std_logic_vector(N - 1 downto 0);
    signal s_regX_out  : std_logic_vector(N - 1 downto 0);
    signal s_regY_out  : std_logic_vector(N - 1 downto 0);
    signal s_sub_inA   : std_logic_vector(N - 1 downto 0);
    signal s_sub_inB   : std_logic_vector(N - 1 downto 0);
    signal s_sub_out   : std_logic_vector(N - 1 downto 0);

    component REGN is
        generic (N : natural);
        port (
            CLK  : in std_logic;
            LD   : in std_logic;
            D    : in std_logic_vector(N - 1 downto 0); -- data in
            nRST : in std_logic;
            Q    : out std_logic_vector(N - 1 downto 0) -- data out
        );
    end component;

    component MUX2v1 is
        generic (N : natural);
        port (
            D0, D1 : in std_logic_vector(N - 1 downto 0);
            ctrl   : in std_logic;
            S      : out std_logic_vector(N - 1 downto 0)
        );
    end component;

    component COMPN is
        generic (N : natural);
        port (
            X, Y       : in std_logic_vector(N - 1 downto 0);
            XeqY, XgtY : out std_logic
        );
    end component;

    component SUBN is
        generic (N : natural);
        port (
            A, B  : in std_logic_vector(N - 1 downto 0);
            S     : out std_logic_vector(N - 1 downto 0);
            C_out : out std_logic
        );
    end component;

begin
    -- Instanciation des composants internes:
    I_REGN_X : REGN
    generic map(N => N)
    port map(
        CLK  => clk,
        LD   => loadx,
        D    => s_mux_X_out,
        nRST => nrst,
        Q    => s_regX_out
    );
    I_REGN_Y : REGN
    generic map(N => N)
    port map(
        CLK  => clk,
        LD   => loady,
        D    => s_mux_Y_out,
        nRST => nrst,
        Q    => s_regY_out
    );

    I_MUX_reg_X : MUX2v1
    generic map(N => N)
    port map(
        D0   => s_sub_out,
        D1   => X,
        ctrl => selx,
        S    => s_mux_X_out
    );
    I_MUX_reg_Y : MUX2v1
    generic map(N => N)
    port map(
        D0   => s_sub_out,
        D1   => Y,
        ctrl => sely,
        S    => s_mux_Y_out
    );
    I_MUX_sub_A : MUX2v1
    generic map(N => N)
    port map(
        D0   => s_regX_out,
        D1   => s_regY_out,
        ctrl => not muxsub,
        S    => s_sub_inA
    );
    I_MUX_sub_B : MUX2v1
    generic map(N => N)
    port map(
        D0   => s_regX_out,
        D1   => s_regY_out,
        ctrl => muxsub,
        S    => s_sub_inB
    );

    I_COMPN : COMPN
    generic map(N => N)
    port map(
        X    => s_regX_out,
        Y    => s_regY_out,
        XeqY => XeqY,
        XgtY => XgtY
    );

    I_SUBN : SUBN
    generic map(N => N)
    port map(
        A     => s_sub_inA,
        B     => s_sub_inB,
        S     => s_sub_out,
        C_out => open
    );

    Q <= s_regX_out when gcd = '1' else
    (others => 'Z');
end architecture;
