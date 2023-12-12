library IEEE;
use IEEE.std_logic_1164.all;

entity mux4t1 is
    port(i_S    : in std_logic_vector(1 downto 0);
         i_D0   : in std_logic;
         i_D1   : in std_logic;
         i_D2   : in std_logic;
         i_D3   : in std_logic;
         o_O    : out std_logic);
end entity;

architecture behavioral of mux4t1 is 
begin 
    o_O <= i_D0 when i_S = "00" else
           i_D1 when i_S = "01" else
           i_D2 when i_S = "10" else
           i_D3 when i_S = "11";
end behavioral;