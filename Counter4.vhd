
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; -- serve per segnali  Unsigned

library UNISIM;
use UNISIM.VComponents.all;

entity Counter4 is --conta la sequenza 1110-1101-1011-0111 per accendere an
Port ( 
clkin4 : in std_logic;
an4: out std_logic_vector (3 downto 0)
);
end Counter4;


architecture Behavioral of Counter4 is
signal count: unsigned (3 downto 0) := "1110"; -- è unsigned per poi usare comando rol
begin

process (clkin4)
begin
   if (clkin4'event and clkin4 = '1') then --sul fronte di salita del clock
         count <= count rol 1;   --esegue shift dei bit del segnale count
      end if;
end process;

-- assegno alle uscite an il corrente valore di count
-- an4 <= count; no perche uno è std_logic_vector l'altro unsigned
an4(0)<=count(0);
an4(1)<=count(1);
an4(2)<=count(2);
an4(3)<=count(3);
end Behavioral;
