library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Mem is
 Port (
 clk_in : in std_logic;
 nreset : in std_logic;
 data_in : in std_logic_vector(2 downto 0);
 data_out : out std_logic_vector (11 downto 0) :="000000000000"
 );
end Mem;

architecture Behavioral of Mem is
signal sout : std_logic_vector(11 downto 0);
begin

process (clk_in, nreset) --genero uno shift register (ogni registro a 3-bit)
variable a0,a1,a2,a3 : std_logic_vector(2 downto 0) :="000";
begin
if nreset='0' then
a0 := "000";
    a1 := "000";
    a2 := "000";
    a3 := "000";
   else
if (clk_in' event and clk_in = '1') then 
    a3 := a2;
    a2 := a1;
    a1 := a0;
    a0 := data_in; 

    end if;
end if;
sout <= a0 & a1 & a2 & a3; -- concateno per avere un unico vettore di uscita
end process;
data_out <= sout; --per assegnare uscite a segnale interno

end Behavioral;
