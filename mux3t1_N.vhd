-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- mux2t1_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an N-bit wide 2:1
-- mux using structural VHDL, generics, and generate statements.
--
--
-- NOTES:
-- 1/6/20 by H3::Created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity mux3t1_N is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_S          : in std_logic;
       i_jal        : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0); --R[rt]
       i_D1         : in std_logic_vector(N-1 downto 0); --R[rd]
       i_D2         : in std_logic_vector(N-1 downto 0); -- R[31] 
       o_O          : out std_logic_vector(N-1 downto 0));

end mux3t1_N;

architecture behavioral of mux3t1_N is
  begin
  process(i_S, i_jal, i_D0, i_D1, i_D2)
  begin
  
  if i_jal = '1' then 
   o_O  <= i_D2;
   
  elsif i_S = '0' then 
   o_O <= i_D0;

  else  
   o_O <= i_D1; 

  end if; 
end process;
  
end behavioral;
