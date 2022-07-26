----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.11.2021 17:55:22
-- Design Name: 
-- Module Name: Controller - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity Controller is
 Port (
 
  onswitch : in std_logic;
  game_over_signal : in std_logic;
  enable : out std_logic :='0'

  );
end Controller;

architecture Behavioral of Controller is

--signal en_int : std_logic;

begin

enable <= onswitch and not (game_over_signal);
--process (onswitch, game_over_signal)

--begin

--if onswitch'event and onswitch='1'then
--enable <= '1';
--if onswitch = '0' then
--enable <= '0';
--if game_over_signal = '1' then
--enable <= '0';
--enable <= en_int;

-- if(onswitch = '1' and game_over_signal = '0') then  --allora gioco
--      enable <= '1';
      
-- elsif(onswitch = '1' and game_over_signal = '1')  then  --non gioco --reset segnali per lfsr?
--      enable <= '0';
        
-- elsif(onswitch = '0' and game_over_signal = '1') then  -- stop gioco    --reset lfsr
--   enable <= '0';   
 
--  elsif(onswitch = '0' and game_over_signal = '0') then  -- stop gioco     
--     enable <= '0';    
--  end if;   
--   end if;
--   end if;
   
--end process;


end Behavioral;
