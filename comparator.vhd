library IEEE;
use IEEE.std_logic_1164.all;

entity comparator is 
generic(N : integer := 32);
   port(i_A	: in std_logic_vector(N-1 downto 0);
	i_B	: in std_logic_vector(N-1 downto 0); 
	o_eq	: out std_logic);
end comparator; 

architecture mixed of comparator is 
begin 
   check0: o_eq <= '1' when i_A = i_B else '0';
end mixed;