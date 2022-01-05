library ieee;
use ieee.std_logic_1164.all;

library TP_LIB;
use TP_LIB.ADD1;

entity ADDN is
    generic (N : natural := 8);
    port (
        A, B  : in std_logic_vector(N - 1 downto 0);
        S     : out std_logic_vector(N - 1 downto 0);
        C_out : out std_logic
    );
end ADDN;

architecture str of ADDN is
    component ADD1 is
        port (
            A, B, Cin : in std_logic;
            S, Cout   : out std_logic
        );
    end component;
    signal carry : std_logic_vector(N downto 0);
begin
    carry(0) <= '0';
    ADD_insts : for k in 0 to N - 1 generate
        ADD_inst : ADD1 port map(A(k), B(k), carry(k), S(k), carry(k + 1));
    end generate;
    C_out <= carry(N);
end architecture;
