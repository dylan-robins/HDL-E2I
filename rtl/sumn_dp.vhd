library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; --utilisation to_unsigned

library TP_LIB;
use TP_LIB.REGN;
use TP_LIB.CNTR;
use TP_LIB.ADDN;

entity SUMN_DP is
    generic (N : natural := 32);
    port (
        clk      : in std_logic;
        nRST     : in std_logic;
        enCnt    : in std_logic;
		regload  : in std_logic;
        D        : in std_logic_vector(N - 1 downto 0);  -- data in
        Q        : out std_logic_vector(N - 1 downto 0); -- data out 
        diff0    : out std_logic                         -- flag N > 1
    );
end SUMN_DP;

architecture str of SUMN_DP is
    signal cntr_addn : std_logic_vector(N - 1 downto 0);
    signal reg_addn  : std_logic_vector(N - 1 downto 0);
    signal addn_reg  : std_logic_vector(N - 1 downto 0);
    signal done      : std_logic;
    signal cntr_ld   : std_logic;

    component REGN is
        generic (N : natural);
        port (
            CLK  : in std_logic;
            LD   : in std_logic;
            D    : in std_logic_vector(N - 1 downto 0); -- data in
            nRST : in std_logic;
            Q    : out std_logic_vector(N - 1 downto 0) -- data out
        );
    end component;

    component CNTR is
        generic (N : natural);
        port (
            CLK  : in std_logic;
            EN   : in std_logic := '0';                 -- enable
            UD   : in std_logic := '0';                 -- up/down: 0=incr, 1=decr
            LD   : in std_logic := '0';                 -- Preload
            nRST : in std_logic := '1';                 -- Reset (inverted)
            D    : in std_logic_vector(N - 1 downto 0); -- input data
            Q    : out std_logic_vector(N - 1 downto 0) -- output data
        );
    end component;
    
    component ADDN is
        generic (N : natural);
        port (
            A, B  : in std_logic_vector(N - 1 downto 0);
            S     : out std_logic_vector(N - 1 downto 0);
            C_out : out std_logic
        );
    end component;

begin
    -- Instanciation des composants internes:
    I_REGN : REGN
    generic map(N => N)
    port map(
        CLK  => CLK,
        LD   => regload,
        D    => addn_reg,
        nRST => nRST,
        Q    => reg_addn
    );

    I_CNTR : CNTR
    generic map(N => N)
    port map(
        CLK  => CLK,
        EN   => enCnt,
        UD   => '1',
        LD   => cntr_ld,
        nRST => nRST,
        D    => D,
        Q    => cntr_addn
    );

    I_ADDN : ADDN
    generic map(N => N)
    port map(
        A => cntr_addn,
        B => reg_addn,
        S => addn_reg,
        C_out => open
    );

    Q <= addn_reg when done = '0' else (others => 'Z');
    done <= '0' when cntr_addn = std_logic_vector(to_unsigned(0, N)) else '1';
    diff0 <= done;
    
    cntr_ld <= regload or not nRST;
end architecture;
