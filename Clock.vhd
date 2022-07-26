library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity Clock is
Port ( 
clk_in : in std_logic;
clk_game : out std_logic;
clk_display : out std_logic;
enable: in std_logic
);
end Clock;

architecture Behavioral of Clock is
signal clk_5MHz, clk_5kHz,  clkg, clkd, locked, clk_5MHz_locked: std_logic;
signal enable_int: std_logic;

component FDiv
port (
clk_fd : in std_logic;
enable : in std_logic;
clkout1 : out std_logic;
clkout2: out std_logic
);
end component;

component FDiv2
port (
clk_in : in std_logic;
clk_out : out std_logic
);
end component;

component CLKWiz
port (
clk_in1 : in std_logic;
--power_down : in std_logic;
clk_out1 : out std_logic;
locked: out std_logic
);
end component;

begin

--enable_int <= not (enable);
clk_game <= clkg; 
clk_display <= clkd; 
clk_5MHz_locked <= clk_5Mhz and locked;
Div3 : FDiv
port map (
clk_fd => clk_5kHz,
enable => enable,
clkout1 => clkg,
clkout2 => clkd
);

Div2 : FDiv2
port map (
clk_in => clk_5MHz_locked,
clk_out => clk_5kHz
);

Div1 : CLKWiz
port map (
clk_in1 => clk_in,
--power_down => enable_int,
clk_out1 =>clk_5MHz,
locked => locked
);

end Behavioral;
