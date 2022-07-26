----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.11.2021 15:09:16
-- Design Name: 
-- Module Name: Top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Top is
Port (
clk: in std_logic;
ledgo: out std_logic;
onsw: in std_logic;
an: out std_logic_vector (3 downto 0);
seg: out std_logic_vector (2 downto 0);
Alto : out std_logic_vector (3 downto 0):= "1111"; --segnale alto per evitare sfarfallio segmenti non usati
AltoDot : out std_logic:= '1'; --segnale alto per evitare sfarfallio segmenti non usati
btn: in std_logic_vector (2 downto 0)
 );
end Top;

architecture Behavioral of Top is

component Clock
port (
clk_in : in std_logic;
clk_game : out std_logic;
clk_display : out std_logic;
enable: in std_logic
);
end component;

component TopDisplay
port (
nreset: in std_logic;
clkg_in: in std_logic;
clkd_in: in std_logic;
datain: in std_logic_vector (2 downto 0);
dataout: out std_logic_vector (2 downto 0);
an: out std_logic_vector (3 downto 0);
seg: out std_logic_vector (2 downto 0)
);
end component;

component top_lfsr
port (
   clock: in std_logic;
   out_lfsr: out std_logic_vector (2 downto 0)
);
end component;

component Game
port (
clkg_in: in std_logic;
data_in: in std_logic_vector (2 downto 0);
btn: in std_logic_vector (2 downto 0);
onsw: in std_logic;
game_over: out std_logic  
);
end component;

component Top_Controller
port (
sw :in std_logic;
game_over : in std_logic;
en : out std_logic
--enable 1=gioco  0=GameOver
   
);
end component;
			
signal clg, cld, enable_int,  game_over_signal_int : std_logic;	
signal game_data, random_data : std_logic_vector (2 downto 0);			
begin


TD : TopDisplay
port map (
   clkg_in => clg,
   clkd_in=> cld,
   an => an,
   seg => seg,
   datain => random_data,
   dataout => game_data,
   nreset => enable_int
);

CLK1 : Clock
port map (
   clk_in => clk,
   clk_game =>clg,
   clk_display => cld,
   enable => enable_int 
);

RanG : top_lfsr
port map (
   clock =>  clg,
   out_lfsr => random_data
);

CTRL : Top_Controller
port map (
   sw => onsw,
   en => enable_int,
   game_over => game_over_signal_int
);

Game1 : Game
port map (
   clkg_in =>  clg,
data_in =>  game_data,
btn =>  btn,
onsw => onsw,
game_over =>  game_over_signal_int 
);

ledgo <= not(enable_int); --led indica il GameOver
end Behavioral;
