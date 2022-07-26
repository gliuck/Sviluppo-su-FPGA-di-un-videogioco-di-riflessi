library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- accende il display illuminando i giusti segmenti
entity DispGame is 
Port (
input : in std_logic_vector (11 downto 0); --12 bit presi dalla memoria
clkin : in std_logic; 
seg : out std_logic_vector (2 downto 0);
an: out std_logic_vector (3 downto 0) );
end DispGame;

architecture Behavioral of DispGame is

signal s0,s1,s2,s3 : std_logic_vector (2 downto 0); --ogni segnale corrisponde ad un blocco della memoria 
signal an_int : std_logic_vector (3 downto 0);

component Counter4
port (
   clkin4 : in std_logic;
   an4: out std_logic_vector (3 downto 0)
);
end component;

begin

c1 : Counter4
port map (
clkin4=> clkin,
an4 => an_int
);
-- assegnazione segnali esterni a quelli interni
s0 <= input(2 downto 0);
s1 <= input(5 downto 3);
s2 <= input(8 downto 6);
s3 <= input(11 downto 9);	
an <= an_int;

process (an_int) --"multiplexer", i segnali an fanno da enable, passano i segmenti corrispettivi al display illuminato
begin  --not poichè 1= spento 0=acceso
   if an_int = "1110" then
      seg <= not(s0);
   elsif (an_int = "1101") then
      seg <= not(s1);
   elsif (an_int = "1011") then
      seg <= not(s2);
   elsif (an_int = "0111") then
      seg <= not(s3);
    else
      seg <= "000";
   end if;
  
end process;

end Behavioral;
