library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- for math operations on std_logic_vector

library TP_LIB;
use TP_LIB.CNTR;

entity CNTR_TB is
end CNTR_TB;

architecture str of CNTR_TB is
    constant nb_bits : Natural := 8; 

    signal s_clk : std_logic := '1';

    signal s_datain   : std_logic_vector(nb_bits-1 downto 0) := "00001010";
    signal s_dataout  : std_logic_vector(nb_bits-1 downto 0);
    signal s_load     : std_logic := '0';
    signal s_nrst     : std_logic := '1';
    signal s_enable   : std_logic := '1';
    signal s_updown   : std_logic := '0';

    component CNTR is
        generic (
            N: Natural := 8
        );
        port (
            CLK : in  std_logic;
            EN  : in  std_logic := '0'; -- enable
            UD  : in  std_logic := '0'; -- up/down: 0=incr, 1=decr
            LD  : in  std_logic := '0'; -- Preload
            nRST: in  std_logic := '1'; -- Reset (inverted)
            D   : in  std_logic_vector(N-1 downto 0);  -- input data
            Q   : out std_logic_vector(N-1 downto 0) -- output data
        );
    end component;

begin 
    DUT:CNTR
    generic map (N => nb_bits) -- override la valeur de N par d�faut
    port map(
        CLK => s_clk,
        EN  => s_enable,
        UD  => s_updown,
        LD  => s_load,
        nRST=> s_nrst,
        D   => s_datain,
        Q   => s_dataout
    );

    s_clk <= not s_clk after 5 ns;

    -- STIMULI GENERATION - START AT 20 ns
    s_load   <= '1' after 50 ns, '0' after 60 ns;
    s_nrst   <= '0' after 50 ns, '1' after 60 ns, '0' after 80 ns;
    s_enable <= '0' after 70 ns;
    s_updown <= '1' after 35 ns;
end str;        


