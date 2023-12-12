-------------------------------------------------------------------------
-- Benjamin Towle
-- 
-- Iowa State University
-------------------------------------------------------------------------


-- mux2t1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Structural vhdl file of a 2 to 1 multiplexor
--
--
-- NOTES:
-- 8/31/23
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;



entity mux2t1_structural is
 port(i_S, i_D0, i_D1: in std_logic;
	o_O: out std_logic);

end mux2t1_structural;



architecture structure of mux2t1_structural is
--Define the different gates that the mux will use

component invg 
 port(i_A          : in std_logic;
      o_F          : out std_logic);
end component;


component andg2 
 port(i_A          : in std_logic;
      i_B          : in std_logic;
      o_F          : out std_logic);
end component;


component org2 
 port(i_A          : in std_logic;
      i_B          : in std_logic;
      o_F          : out std_logic);
end component;

--Define signals to map to each gate 
-- Signal to carry inverse value
signal s_N         : std_logic;
-- Signals to carry and gates
signal s_A1, s_A2   : std_logic;

begin

--!S*D0
g_inv: invg
  port MAP(i_A               => i_S,
           o_F               => s_N);

g_and1: andg2
  port MAP(i_A               => i_D0,
	   i_B		     => s_N,
           o_F               => s_A1);


--S*D1
g_and2: andg2
  port MAP(i_A               => i_D1,
	   i_B		     => i_S,
           o_F               => s_A2);

--or them all together for the output
g_or: org2
  port MAP(i_A               => s_A1,
	   i_B		     => s_A2,
           o_F               => o_O);



end structure;
