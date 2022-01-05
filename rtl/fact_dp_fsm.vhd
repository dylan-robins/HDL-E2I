library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- for math operations on std_logic_vector
use ieee.numeric_std.all;        --utilisation to_unsigned

library TP_LIB;
use TP_LIB.FACT_DP;
use TP_LIB.FACT_FSM;

entity FACT_DP_FSM is
    generic (N : natural := 8);
    port (
        clk   : in std_logic;
        nrst  : in std_logic;
        start : in std_logic;
        D     : in std_logic_vector(N - 1 downto 0);
        Q     : out std_logic_vector(N - 1 downto 0);
        done  : out std_logic
    );
end FACT_DP_FSM;

architecture str of FACT_DP_FSM is
    signal s_muxprod  : std_logic;
    signal s_prodload : std_logic;
    signal s_loadCnt  : std_logic;
    signal s_decount  : std_logic;
    signal s_output   : std_logic;
    signal s_supa1    : std_logic;

    component FACT_DP is
        generic (N : natural);
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
    end component;

    component FACT_FSM is
        port (
            clk      : in std_logic;
            nrst     : in std_logic;
            start    : in std_logic;
            supa1    : in std_logic;
            muxprod  : out std_logic;
            prodload : out std_logic;
            loadCnt  : out std_logic;
            decount  : out std_logic;
            Output   : out std_logic
        );
    end component;

begin
    DP : FACT_DP
    generic map(N => N)
    port map(
        clk      => clk,
        muxprod  => s_muxprod,
        prodload => s_prodload,
        loadCnt  => s_loadCnt,
        decount  => s_decount,
        output   => s_output,
        nRST     => nrst,
        D        => D,
        Q        => Q,
        supa1    => s_supa1
    );

    FSM : FACT_FSM
    port map(
        clk      => clk,
        nrst     => nrst,
        start    => start,
        supa1    => s_supa1,
        muxprod  => s_muxprod,
        prodload => s_prodload,
        loadCnt  => s_loadCnt,
        decount  => s_decount,
        Output   => s_output
    );

    done <= s_output;
end architecture;
