----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.11.2021 14:58:30
-- Design Name: 
-- Module Name: lfsr - Behavioral
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

entity lfsr is
  Port (
          --set : in std_logic_vector (7 downto 0);
          --rst : in std_logic;
          clk : in std_logic;
          out_b : out std_logic_vector (2 downto 0)
  );
end lfsr;

architecture Behavioral of lfsr is

--signal feedback : std_logic;
signal out_reg : std_logic_vector (7 downto 0) := x"01";
--signal set_int : std_logic_vector (3 downto 0);
--signal rst_int : std_logic;
signal clk_int : std_logic;

begin
--feedback <= not (out_reg(3) xor out_reg(2)); 

--set <= set_int;
--set_int <= "0011";
--rst <= rst_int;
--clk <= clk_int;
 
 --out_reg <= set;
 
 
process(clk)
--variable feedback : std_logic;
--feedback <= not (out_reg(3) xor out_reg(2)); 
variable tmp : std_logic := '0';
begin 
--out_reg <= set;



 if rising_edge(clk) then
     --if (rst = '0') then 
     -- out_reg <= set;
     --out_reg( 3 downto 1) <= out_reg (2 downto 0);
     --out_reg(0) <=  not (out_reg(2) xor out_reg(3));
     
     tmp := out_reg(4) xor out_reg(3) xor out_reg(2) xor out_reg(0);
     out_reg <= tmp & out_reg(7 downto 1);
     
     end if;
  -- end if;  

     
     
end process ;        
out_b <= out_reg(7 downto 5);   

--begin
--   if ( <clock>'event and <clock> ='1') then
--      if (<reset> = '1') then
--         <reg_name> <= (others => '0');
--      elsif <clock_enable>='1' then
--         <reg_name>(3 downto 1) <= <reg_name>(2 downto 0) ;
--         <reg_name>(0) <= not(<reg_name>(4) XOR <reg_name>(3));
--      end if;
--   end if;
--end process;



end Behavioral;
