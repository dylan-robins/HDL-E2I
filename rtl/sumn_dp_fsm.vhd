library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- for math operations on std_logic_vector
use ieee.numeric_std.all;        --utilisation to_unsigned

library TP_LIB;
use TP_LIB.SUMN_DP;
use TP_LIB.SUMN_FSM;

entity SUMN_DP_FSM is
    generic (N : natural := 8);
    port (
        clk   : in std_logic;
        nrst  : in std_logic;
        start : in std_logic;
        D     : in std_logic_vector(N - 1 downto 0);
        Q     : out std_logic_vector(N - 1 downto 0);
        done  : out std_logic
    );
end SUMN_DP_FSM;

architecture str of SUMN_DP_FSM is
    signal s_diff0: std_logic;
    signal s_enCnt: std_logic;
    signal s_regload: std_logic;

    component SUMN_DP is
        generic (N : natural);
        port (
            clk      : in std_logic;
            nRST     : in std_logic;
            enCnt    : in std_logic;
		    regload  : in std_logic;
            D        : in std_logic_vector(N - 1 downto 0);  -- data in
            Q        : out std_logic_vector(N - 1 downto 0); -- data out 
            diff0    : out std_logic                         -- flag N > 1  
        );
    end component;

    component SUMN_FSM is
        port (
            clk      : in std_logic;
		    nrst     : in std_logic;
		    start    : in std_logic;
		    diff0    : in std_logic;
		    enCnt    : out std_logic;
		    regload  : out std_logic
        );
    end component;

begin
    DP : SUMN_DP
    generic map(N => N)
    port map(
        clk      => clk,
        nRST     => nRST,
        enCnt    => s_enCnt,
		regload  => s_regload,
        D        => D,
        Q        => Q,
        diff0    => s_diff0            
    );

    FSM : SUMN_FSM
    port map(
        clk      => clk,
		nrst     => nRST,
		start    => start,
		diff0    => s_diff0,
		enCnt    => s_enCnt,
		regload  => s_regload
    );

    done <= not s_diff0;
end architecture;
