library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; --utilisation to_unsigned

library TP_LIB;
use TP_LIB.REGN;
use TP_LIB.CNTR;
use TP_LIB.MULTN;
use TP_LIB.COMPN;
use TP_LIB.MUX2v1;

entity FACT_DATAPATH is
    generic (N : natural := 32);
    port (
        clk      : in std_logic;
        muxprod  : in std_logic;
        prodload : in std_logic;
        loadCnt  : in std_logic;
        decount  : in std_logic;
        output   : in std_logic;
        nRST     : in std_logic;
        D        : in std_logic_vector(N - 1 downto 0);  -- data in
        Q        : out std_logic_vector(N - 1 downto 0); -- data out
        supa1    : out std_logic                         -- flag N > 1
    );
end FACT_DATAPATH;

architecture str of FACT_DATAPATH is
    signal cntr_mult : std_logic_vector(N - 1 downto 0);
    signal reg_mult  : std_logic_vector(N - 1 downto 0);
    signal mult_mux  : std_logic_vector(2 * N - 1 downto 0);
    signal mux_reg   : std_logic_vector(N - 1 downto 0);
    signal cntr_nrst : std_logic;

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

    component CNTR is
        generic (N : natural);
        port (
            CLK  : in std_logic;
            EN   : in std_logic := '0';                 -- enable
            UD   : in std_logic := '0';                 -- up/down: 0=incr, 1=decr
            LD   : in std_logic := '0';                 -- Preload
            nRST : in std_logic := '1';                 -- Reset (inverted)
            D    : in std_logic_vector(N - 1 downto 0); -- input data
            Q    : out std_logic_vector(N - 1 downto 0) -- output data
        );
    end component;

    component MULTN is
        generic (N : natural);
        port (
            OpA, OpB : in std_logic_vector(N - 1 downto 0);
            Res      : out std_logic_vector(2 * N - 1 downto 0)
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

begin
    -- Instanciation des composants internes:
    I_REGN : REGN
    generic map(N => N)
    port map(
        CLK  => CLK,
        LD   => prodload,
        D    => mux_reg,
        nRST => nRST,
        Q    => reg_mult
    );

    I_CNTR : CNTR
    generic map(N => N)
    port map(
        CLK  => CLK,
        EN   => decount,
        UD   => '1',
        LD   => loadCnt,
        nRST => cntr_nrst,
        D    => D,
        Q    => cntr_mult
    );

    I_MULTN : MULTN
    generic map(N => N)
    port map(
        OpA => cntr_mult,
        OpB => reg_mult,
        Res => mult_mux
    );

    I_MUX : MUX2v1
    generic map(N => N)
    port map(
        D0   => mult_mux(N - 1 downto 0),
        D1   => std_logic_vector(to_unsigned(1, N)),
        ctrl => muxprod,
        S    => mux_reg
    );

    I_COMPN : COMPN
    generic map(N => N)
    port map(
        X    => cntr_mult,
        Y    => std_logic_vector(to_unsigned(1, N)),
        XeqY => open,
        XgtY => supa1
    );

    Q <= reg_mult when output = '1' else
    (others => 'Z');
    cntr_nrst <= nrst and not loadCnt;
end architecture;
