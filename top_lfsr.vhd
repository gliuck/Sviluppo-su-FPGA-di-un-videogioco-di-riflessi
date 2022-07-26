----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.11.2021 17:35:21
-- Design Name: 
-- Module Name: top_lfsr - Behavioral
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

entity top_lfsr is
  Port ( 
  
  --reset : in std_logic;
  clock : in std_logic;
  out_lfsr : out std_logic_vector(2 downto 0)
  
  );
  
end top_lfsr;

architecture Behavioral of top_lfsr is

component lfsr 
port (

    --set : in std_logic_vector (7 downto 0);
   -- rst : in std_logic;
    clk : in std_logic;
    out_b : out std_logic_vector (2 downto 0)

);
end component;

--signal set_1 : std_logic_vector (7 downto 0) := x"01";
--signal set_2 : std_logic_vector (7 downto 0) := x"10";
--signal set_3 : std_logic_vector (7 downto 0) := x"11";




begin

lfsr_1 : lfsr port map(

--set => set_1,
--rst => reset,
clk => clock,
out_b => out_lfsr

);

--lfsr_2 : lfsr port map(

----set => set_2,
--rst => reset,
--clk => clock,
--out_b => out_lfsr(1)

--);

--lfsr_3 : lfsr port map(

----set => set_3,
--rst => reset,
--clk => clock,
--out_b => out_lfsr(2)


end Behavioral;
