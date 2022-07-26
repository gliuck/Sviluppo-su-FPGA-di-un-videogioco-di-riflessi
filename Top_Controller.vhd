----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.11.2021 18:51:55
-- Design Name: 
-- Module Name: Top_Controller - Behavioral
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

entity Top_Controller is
  Port (
  
  sw :in std_logic;
  game_over : in std_logic;
  en : out std_logic
  
   );
end Top_Controller;

architecture Behavioral of Top_Controller is

component Controller port (

onswitch : in std_logic;
game_over_signal : in std_logic;
enable : out std_logic

);
end component;

begin

Controller_1 : Controller port map(

onswitch => sw,
game_over_signal => game_over,
enable => en

);

end Behavioral;
