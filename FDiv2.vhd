----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.11.2021 19:56:40
-- Design Name: 
-- Module Name: FDiv2 - Behavioral
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

entity FDiv2 is
Port ( 
clk_in : in std_logic;
clk_out : out std_logic
);
end FDiv2;

architecture Behavioral of FDiv2 is

begin
process (clk_in)
variable c_int: std_logic := '0';
variable count: integer := 0;
begin
clk_out <= c_int;
   if clk_in='1' and clk_in'event then
      count := count + 1;
      
      if count=500 then --uscita 5 kHz
        c_int := not(c_int);
        clk_out <= c_int;
        count := 0;
   end if;
   end if;
   
end process;

end Behavioral;
