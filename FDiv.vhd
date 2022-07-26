library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity FDiv is
Port (
clk_fd : in std_logic;
enable : in std_logic;
clkout1 : out std_logic;
clkout2: out std_logic
);
end FDiv;

architecture Behavioral of FDiv is


component counter1
Port (
clk_in : in std_logic;
enable: in std_logic;
clk_out : out std_logic
);

end component;

component counter2
Port (
clk_in : in std_logic;
clk_out: out std_logic
);

end component;

begin

C1 : counter1
port map (
clk_in => clk_fd ,
enable => enable, 
clk_out => clkout1
);

C2 : counter2
port map (
clk_in => clk_fd , 
clk_out => clkout2
);

end Behavioral;
