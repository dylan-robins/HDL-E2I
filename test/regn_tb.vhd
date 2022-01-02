library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- for math operations on std_logic_vector

library TP_LIB;
use TP_LIB.REGN;

entity REGN_TB is
end REGN_TB;

architecture str of REGN_TB is
    constant nb_bits : Natural := 8;
    
    constant zero : std_logic_vector(nb_bits-1 downto 0) := "00000000";
    constant ten  : std_logic_vector(nb_bits-1 downto 0) := "00001010";
    constant twofivefive : std_logic_vector(nb_bits-1 downto 0) := "11111111";


    signal s_clk : std_logic := '0';  

    signal s_A : std_logic_vector(nb_bits-1 downto 0) := (others => '0');
    signal s_S: std_logic_vector(nb_bits-1 downto 0);

    signal s_load : std_logic := '0';  
    signal s_reset : std_logic := '0';  

    component REGN is
        generic (N: Natural := 8);
        port(
            CLK : in  std_logic;
            LD  : in  std_logic;
            D   : in  std_logic_vector(N-1 downto 0); -- data in
            nRST: in  std_logic;
            Q   : out std_logic_vector(N-1 downto 0)  -- data out
        );
    end component;

begin 
    DUT : REGN
    port map(
        CLK  => s_clk,
        LD   => s_load,
        D    => s_A,
        nRST => s_reset,
        Q    => s_S
    );

    s_clk <= not s_clk after 5 ns;
    s_A <= ten after 20 ns, zero after 40 ns, twofivefive after 65 ns;
    s_load <= '1' after 30 ns,
              '0' after 40 ns,
              '1' after 50 ns,
              '0' after 60 ns,
              '1' after 70 ns;
    s_reset <= '1' after 5 ns, '0' after 65 ns;

end str;

