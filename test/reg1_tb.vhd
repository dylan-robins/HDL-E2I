library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- for math operations on std_logic_vector

library TP_LIB;
use TP_LIB.REG1;

entity REG1_TB is
end REG1_TB;

architecture str of REG1_TB is
    signal s_clk : std_logic := '0';  

    signal s_A : std_logic := '0';
    signal s_S: std_logic;

    signal s_load : std_logic := '0';  
    signal s_reset : std_logic := '0';  

    component REG1 is
        port(
            CLK : in  std_logic;
            LD  : in  std_logic;
            D   : in  std_logic; -- data in
            nRST: in  std_logic;
            Q   : out std_logic  -- data out
        );
    end component;

begin 
    DUT : REG1
    port map(
        CLK  => s_clk,
        LD   => s_load,
        D    => s_A,
        nRST => s_reset,
        Q    => s_S
    );

    s_clk <= not s_clk after 5 ns;
    s_A <= '1' after 20 ns, '0' after 40 ns, '1' after 65 ns;
    s_load <= '1' after 30 ns,
              '0' after 40 ns,
              '1' after 50 ns,
              '0' after 60 ns,
              '1' after 70 ns;
    s_reset <= '1' after 5 ns, '0' after 65 ns;

end str;

