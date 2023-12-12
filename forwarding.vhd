library IEEE; 
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity forwarding is 
   port(i_RS_IDEX	: in std_logic_vector(4 downto 0); 
		i_RT_IDEX	: in std_logic_vector(4 downto 0);
		i_RD_EXMEM	: in std_logic_vector(4 downto 0);
		i_RD_MEMWB	: in std_logic_vector(4 downto 0);
		i_RegWrEXMEM		: in std_logic;
		i_RegWrMEMWB		: in std_logic;
		i_memWrEXMEM        : in std_logic;
		o_SelectALUA		: out std_logic_vector(1 downto 0);
		o_SelectALUB		: out std_logic_vector(1 downto 0));
end forwarding;

architecture mixed of forwarding is
begin
	o_SelectAlUA  <=	"01" when ((i_RS_IDEX = i_RD_EXMEM) and (i_RegWrEXMEM = '1') and (i_RD_EXMEM /= "00000")) else 
		        		"10" when ((i_RS_IDEX = i_RD_MEMWB) and (i_RegWrMEMWB = '1') and (i_RD_MEMWB /= "00000")) else
		        		"00";

   	o_SelectALUB  <= 	"01" when ((i_RT_IDEX = i_RD_EXMEM) and (i_RegWrEXMEM = '1') and (i_RD_EXMEM /= "00000")) else 
						"10" when ((i_RT_IDEX = i_RD_MEMWB) and (i_RegWrMEMWB = '1') and (i_RD_MEMWB /= "00000")) else
						"11" when ((i_RT_IDEX = i_RD_EXMEM) and (i_memWrEXMEM = '1') and (i_RD_EXMEM /= "00000")) else
						"00";

				  
end mixed;