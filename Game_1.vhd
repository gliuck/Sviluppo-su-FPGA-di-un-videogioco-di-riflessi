----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.12.2021 09:51:34
-- Design Name: 
-- Module Name: Game_1 - Behavioral
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

entity Game is
  Port (
clkg_in: in std_logic;
data_in: in std_logic_vector (2 downto 0);
btn: in std_logic_vector (2 downto 0);
game_over : out std_logic := '0';
onsw : in std_logic;
 
--Registro 3 FlipFlop
q_out : out std_logic_vector (2 downto 0) --per test
--D : in std_logic_vector (2 downto 0) -- è il mio data_in da confrontare


 );
end Game;

architecture Behavioral of Game is


--signal tasti_in :  std_logic_vector (2 downto 0);
--signal data_out :  std_logic_vector (2 downto 0);
--signal clk_int :  std_logic;
--signal g_over :  std_logic;
signal q_out_int : std_logic_vector (2 downto 0) :="000";


Component FlipFlop is Port 
(
  clk : in std_logic;
  D : in std_logic;
  Q : out std_logic
);
end component;

--signal q0, q1, q2 : std_logic;

begin

FF1 : FlipFlop port map (

clk => clkg_in,
D => data_in(0),
Q => q_out_int(0)

);

FF2 : FlipFlop port map (

clk => clkg_in,
D => data_in(1),
Q => q_out_int(1)

);

FF3 : FlipFlop port map (

clk => clkg_in,
D => data_in(2),
Q => q_out_int(2)

);

--q_out <= q_out(0) & q_out(1) & q_out(2);



q_out <= q_out_int;

process (clkg_in, onsw)

begin

--tasti_in <= btn;
--clk_int <= clkg_in;


--data_out <= data_in;
--g_over <= game_over;

--fliflopd 3 bit
-- salvo dout sul fronte negativo, 
if onsw = '1' then
if (clkg_in' event and clkg_in ='1') then
    if (q_out_int /= btn) then
--    game_over <= '0';
--    else 
    game_over <= '1';
    end if;
   end if;  
   elsif onsw='0' then
   game_over <='0'; 
end if;




--if (clk_int' event and clk_int ='1' and (data_out = tasti_in) ) then
--    game_over <= '0';
--    else
--    game_over <= '1';
-- end if;

end process;



end Behavioral;


