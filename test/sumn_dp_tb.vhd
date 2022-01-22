library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- for math operations on std_logic_vector
use ieee.numeric_std.all;        --utilisation to_unsigned

library TP_LIB;
use TP_LIB.SUMN_DP;

entity SUMN_DP_TB is
end SUMN_DP_TB;

architecture str of SUMN_DP_TB is
    constant N : natural := 8;

    signal s_clk           : std_logic := '0';
    signal s_nRST          : std_logic := '1';
    signal s_slow_clock    : std_logic := '1';
    signal s_slow_clock_en : std_logic := '0';
    
    signal s_enCnt      : std_logic := '0';
    signal s_regload    : std_logic := '0';
    
    signal s_D        : std_logic_vector(N - 1 downto 0) := std_logic_vector(to_unsigned(11, N));
    signal s_Q        : std_logic_vector(N - 1 downto 0);
    signal s_diff0    : std_logic;

    component SUMN_DP is
        generic (N : natural);
        port (
            clk      : in std_logic;
            nRST     : in std_logic;
            enCnt    : in std_logic;
		    regload  : in std_logic;
            D        : in std_logic_vector(N - 1 downto 0);  -- data in
            Q        : out std_logic_vector(N - 1 downto 0); -- data out 
            diff0    : out std_logic                
        );
    end component;

begin
    DUT : SUMN_DP
    generic map(N => N)
    port map(
        clk      => s_clk,
        nRST     => s_nRST,
        enCnt    => s_enCnt,
        regload  => s_regload,
        D        => s_D,
        Q        => s_Q,
        diff0    => s_diff0

    );

    s_clk <= not s_clk after 5 ns;
    s_slow_clock <= not s_slow_clock after 10 ns;
    
    -- STIMULI
    s_nRST     <= '0' after 10 ns, '1' after 20 ns;

    s_enCnt   <= s_slow_clock and s_slow_clock_en;
    s_regload <= not s_slow_clock and s_slow_clock_en;
    
    s_slow_clock_en <= '1' after 30 ns, '0' after 250 ns;
end str;
