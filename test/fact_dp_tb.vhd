library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- for math operations on std_logic_vector
use ieee.numeric_std.all;        --utilisation to_unsigned

library TP_LIB;
use TP_LIB.FACT_DP;

entity FACT_DATAPATH_TB is
end FACT_DATAPATH_TB;

architecture str of FACT_DATAPATH_TB is
    constant N : natural := 8;

    signal s_clk      : std_logic                        := '0';
    signal s_muxprod  : std_logic                        := '0';
    signal s_prodload : std_logic                        := '0';
    signal s_loadCnt  : std_logic                        := '0';
    signal s_decount  : std_logic                        := '0';
    signal s_output   : std_logic                        := '0';
    signal s_nRST     : std_logic                        := '1';
    signal s_D        : std_logic_vector(N - 1 downto 0) := std_logic_vector(to_unsigned(3, N));
    signal s_Q        : std_logic_vector(N - 1 downto 0);
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

begin
    DUT : FACT_DP
    generic map(N => N)
    port map(
        clk      => s_clk,
        muxprod  => s_muxprod,
        prodload => s_prodload,
        loadCnt  => s_loadCnt,
        decount  => s_decount,
        output   => s_output,
        nRST     => s_nRST,
        D        => s_D,
        Q        => s_Q,
        supa1    => s_supa1

    );

    s_clk <= not s_clk after 5 ns;

    -- STIMULI
    s_nRST     <= '0' after 10 ns, '1' after 20 ns;
    s_muxprod  <= '1' after 30 ns, '0' after 40 ns;
    s_prodload <= '1' after 30 ns, '0' after 50 ns, '1' after 60 ns, '0' after 70 ns;
    s_loadCnt  <= '1' after 30 ns, '0' after 42 ns;
    s_decount  <= '1' after 50 ns, '0' after 60 ns, '1' after 70 ns, '0' after 80 ns;
    s_output   <= '1' after 80 ns, '0' after 90 ns;
end str;
