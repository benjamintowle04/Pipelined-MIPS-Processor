library IEEE;
use IEEE.std_logic_1164.all;

entity onesComp is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_Num          : in std_logic_vector(N-1 downto 0);
       o_Num          : out std_logic_vector(N-1 downto 0));

end onesComp; 

architecture structure of onesComp is 

--The only component we will need for this unit
 component invg 
  port(i_A          : in std_logic;
       o_F          : out std_logic);
 end component;

begin
G_NBit_OnesComp: for i in 0 to N-1 generate

 g_inv: invg
  port MAP(i_A               => i_Num(i),
           o_F               => o_Num(i));

end generate G_NBit_OnesComp;



end structure;
