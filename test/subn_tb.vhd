library ieee;
use ieee.std_logic_1164.all; -- for std_logic types
use ieee.std_logic_unsigned.all; -- for math operations on std_logic_vector


library TP_LIB;
use TP_LIB.SUBN;

entity SUBN_TB is
end SUBN_TB;

architecture str of SUBN_TB is
    constant c_N : Natural := 4; 
    constant c_clk_period : Time := 20 ns; 

    signal clk: std_logic := '0';

    signal s_A, s_B : std_logic_vector(c_N-1 downto 0) := (others=>'0');
    signal s_S: std_logic_vector(c_N-1 downto 0);
    signal s_C_out : std_logic;

    component SUBN is
        generic (N: Natural := 8);
        port(
            A, B: in  std_logic_vector(N-1 downto 0);
            S   : out std_logic_vector(N-1 downto 0);
            C_out: out std_logic
        );
    end component;

begin 
    DUT:SUBN
	generic map (N => c_N) -- override la valeur de N par défaut
    port map(
        A    => s_A,
        B    => s_B,
        S    => s_S,
        C_out => S_C_out
    );

    clk <= not clk after 5 ns;
    process (clk)
    begin
        if clk'event and clk = '1'
        then
            s_A <= s_A + 1;
		    if s_A = (s_A'range => '1')
        then
            s_B <= s_B +1;
    		end if;
        end if;
    end process;
end str;        

