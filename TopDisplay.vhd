library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity TopDisplay is
Port ( 
nreset: in std_logic; --reset memoria quando 0
clkg_in: in std_logic; --clock di gioco
clkd_in: in std_logic; -- clock  per diplay
datain: in std_logic_vector (2 downto 0):="000"; -- 3 bit da generatore numeri casuali
dataout: out std_logic_vector (2 downto 0):="000"; --3 bit per confronto con input utente
seg: out std_logic_vector(2 downto 0); -- bit controllo segmenti 0,6,3
an: out std_logic_vector(3 downto 0)-- bit controllo an
);
end TopDisplay;

architecture Behavioral of TopDisplay is

signal clk_int_1, clk_int_2 : std_logic;
signal data_int: std_logic_vector( 11 downto 0);
signal nseg: std_logic_vector (2 downto 0);

component DispGame --componente che c
port (
input : in std_logic_vector (11 downto 0);
clkin : in std_logic;
seg : out std_logic_vector (2 downto 0);
an: out std_logic_vector (3 downto 0)
);
end component;

component Mem --Memoria 4x3 con salvati i dati da visualizzare a schermo
Port (
 clk_in : in std_logic;
 nreset : in std_logic;
 data_in : in std_logic_vector(2 downto 0);
 data_out : out std_logic_vector (11 downto 0)
 );
end component;


begin
clk_int_1 <= clkg_in;
clk_int_2 <= clkd_in;
dataout <= data_int (2 downto 0); 

I1 : DispGame
port map (
input =>data_int, 
clkin =>clk_int_2,
seg => seg, 
an => an   
);

I2 : Mem
port map (
clk_in => clk_int_1, 
nreset => nreset, 
data_in => datain, 
data_out => data_int   
);

end Behavioral;
