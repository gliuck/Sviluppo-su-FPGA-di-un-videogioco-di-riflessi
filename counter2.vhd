----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.11.2021 16:59:12
-- Design Name: 
-- Module Name: counter2 - Behavioral
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
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity counter2 is
Port (
clk_in : in std_logic;
clk_out: out std_logic 
);
end counter2;

architecture Behavioral of counter2 is

begin

process (clk_in)
variable c_int: std_logic := '0';
variable count: integer:= 0;
begin
clk_out <= c_int;
   if clk_in='1' and clk_in'event then
      count := count + 1;
      
      if count=17 then
        c_int := not(c_int);
        clk_out <= c_int;
        count := 0;
   end if;
   end if;
   
end process;
end Behavioral;
