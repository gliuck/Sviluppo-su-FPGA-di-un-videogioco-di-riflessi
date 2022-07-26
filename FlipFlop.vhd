----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.12.2021 16:19:58
-- Design Name: 
-- Module Name: FlipFlop - Behavioral
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

entity FlipFlop is
  Port (
   clk : in std_logic;
   D : in std_logic;
   Q : out std_logic
  
   );
end FlipFlop;

architecture Behavioral of FlipFlop is

begin

process(clk)
  begin
     if (clk'event and clk='0') then
      Q <= D;
      
     end if;
     end process;
end Behavioral;