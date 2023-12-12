--Benjamin Towle
--9/30/2023
--tb_nBitXor.vhd
--Test bench for the nBitXor.vhd module

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.textio.all;             -- For basic I/O

entity tb_nBitXor is 
end tb_nBitXor;

architecture structure of tb_nBitXor is 


component nBitXor is 
port(i_A          : in std_logic_vector(31 downto 0);
       i_B          : in std_logic_vector(31 downto 0);
       o_F          : out std_logic_vector(31 downto 0));
end component;

signal s_A  : std_logic_vector(31 downto 0);
signal s_B  : std_logic_vector(31 downto 0);
signal s_F  : std_logic_vector(31 downto 0);

begin
DUT0: nBitXor

port map(i_A => s_A,
	 i_B => s_B,
	 o_F => s_F);

TEST_CASES: process
begin 

s_A <= x"FFFFFFFF";
s_B <= x"00000000";
wait for 50 ns;

s_A <= x"F0F0F0F0";
s_B <= x"0F0F0F0F";
wait for 50 ns;

s_A <= x"ABCDEF12";
s_B <= x"FEDCBA21";
wait for 50 ns;

end process;


end structure;