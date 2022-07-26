library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
--library UNISIM;
--use UNISIM.VComponents.all;

entity counter1 is
Port (
clk_in : in std_logic;
enable : in std_logic;
clk_out: out std_logic 
);
end counter1;

architecture Behavioral of counter1 is
-- segnali per debugg
--signal excountto : integer;
--signal expoints: integer;
--signal excount: integer;
begin

process (clk_in, enable)
variable c_int: std_logic := '0'; --segnale interno = clock di uscita
variable count: integer := 0; --unsigned per usare somma
variable points: integer := 0;
variable countto: integer := 7500 ; --2500

begin
if enable = '0' then
points := 0;
count := 0;
countto:=7500; --3s
end if;

clk_out <= c_int;
   if clk_in'event  and clk_in='1' then
      count := count + 1;
--    excount <= count;
      if count= countto then
        c_int := not(c_int);
        clk_out <= c_int;
        count := 0;
        points:= points +1;
--        expoints <= points;
        --velocità cresce ogni 5 punti fino ad un periodo di 1s
        --point varia su entrambi i fronti del clock di uscita 
        --quindi conto fino al doppio dei punti
            if (points=10 and countto > 2500) then 
            countto := countto - 500;  
            points := 0;
--           excountto <= countto;
            end if;
        end if;
   end if;
   
end process;

end Behavioral;
