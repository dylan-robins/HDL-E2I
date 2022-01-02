library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- for math operations on std_logic_vector

library TP_LIB;
use TP_LIB.MULTN;

entity MULTN_TB is
end MULTN_TB;

architecture str of MULTN_TB is
    constant c_N : Natural := 4; 

    signal clk : std_logic := '0';  

    signal s_A, s_B : std_logic_vector(c_N-1 downto 0) := (others=>'0');
    signal s_S: std_logic_vector(2*c_N-1 downto 0);

    component MULTN is
        generic (N: Natural := 8);
        port(
            OpA, OpB: in  std_logic_vector(N-1 downto 0);
            Res: out std_logic_vector(2*N-1 downto 0)
        );
    end component;

begin 
    DUT:MULTN
    generic map (N => c_N) -- override la valeur de N par défaut
    port map(
        OpA => s_A,
        OpB => s_B,
        Res => s_S
    );

    clk <= not clk after 5 ns;
    process (clk)
    begin
        if clk'event and clk = '1'
        then
            s_A <= s_A + 1;
        end if;
        if clk'event and clk = '1' and s_A = "1111"
        then
            s_B <= s_B +1;
        end if;
    end process;
end str;        


