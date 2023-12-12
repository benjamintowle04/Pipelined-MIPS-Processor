library IEEE;
use IEEE.std_logic_1164.all;

entity detectHazard is 
   port(i_RS_IDEX  : in std_logic_vector(4 downto 0); 
   		i_RT_IDEX  : in std_logic_vector(4 downto 0); 
		i_RT_IFID  : in std_logic_vector(4 downto 0); 
		i_RS_IFID  : in std_logic_vector(4 downto 0); 


   		i_RD_EXMEM  : in std_logic_vector(4 downto 0); 
   		i_RD_MEMWB  : in std_logic_vector(4 downto 0); 
		i_RD_IDEX   : in std_logic_vector(4 downto 0); 

   		i_RegWrEXMEM  : in std_logic;           
   		i_RegWrMEMWB  : in std_logic;
		i_RegWrIDEX   : in std_logic; 
		i_ALUBranch   : in std_logic; 
		i_jump        : in std_logic; 

		o_IFID_stall       : out std_logic; 
		o_IDEX_stall   : out std_logic;
		o_EXMEM_stall   : out std_logic;
		o_MEMWB_stall   : out std_logic;

		o_IFID_flush       : out std_logic;
		o_IDEX_flush       : out std_logic;
		o_EXMEM_flush       : out std_logic;
		o_MEMWB_flush       : out std_logic); 
end detectHazard;

architecture mixed of detectHazard is 
begin 

--   --stall assuming no forwarding
--     o_IFID_stall <= '1' when ((i_RegWrEXMEM = '1' and i_RD_EXMEM /= "00000" and i_RD_EXMEM = i_RS_IDEX)
-- 						or (i_RegWrEXMEM = '1' and i_RD_EXMEM /= "00000" and i_RD_EXMEM = i_RT_IDEX)) else
					
-- 					'1' when ((i_RegWrIDEX ='1' and i_RD_IDEX/= "00000" and i_RD_IDEX = i_RT_IFID) 
-- 						or   (i_RegWrIDEX ='1' and i_RD_IDEX/= "00000" and i_RD_IDEX = i_RS_IFID)) else
						
-- 				  '1' when  (((i_RegWrMEMWB = '1' and i_RD_MEMWB /= "00000" and i_RD_MEMWB = i_RS_IDEX))
-- 					or ((i_RegWrMEMWB = '1' and i_RD_MEMWB /= "00000" and i_RD_MEMWB = i_RT_IDEX))) else 

-- 				  '1' when ((i_RegWrEXMEM = '1' and i_RD_EXMEM /= "00000" and i_RD_EXMEM = i_RS_IFID)
-- 					or (i_RegWrEXMEM = '1' and i_RD_EXMEM /= "00000" and i_RD_EXMEM = i_RT_IFID)) else 
					
-- 				  '1' when  (((i_RegWrMEMWB = '1' and i_RD_MEMWB /= "00000" and i_RD_MEMWB = i_RS_IFID))
-- 					or ((i_RegWrMEMWB = '1' and i_RD_MEMWB /= "00000" and i_RD_MEMWB = i_RT_IFID))) else 
					
-- 				  '0';  


--   --flush assuming no forwarding
-- 	o_IDEX_flush <= '1' when ((i_RegWrEXMEM = '1' and i_RD_EXMEM /= "00000" and i_RD_EXMEM = i_RS_IDEX)
-- 						or (i_RegWrEXMEM = '1' and i_RD_EXMEM /= "00000" and i_RD_EXMEM = i_RT_IDEX)) else
					
-- 					'1' when ((i_RegWrIDEX ='1' and i_RD_IDEX/= "00000" and i_RD_IDEX = i_RT_IFID) 
-- 						or   (i_RegWrIDEX ='1' and i_RD_IDEX/= "00000" and i_RD_IDEX = i_RS_IFID)) else
						
-- 				  '1' when  (((i_RegWrMEMWB = '1' and i_RD_MEMWB /= "00000" and i_RD_MEMWB = i_RS_IDEX))
-- 					or ((i_RegWrMEMWB = '1' and i_RD_MEMWB /= "00000" and i_RD_MEMWB = i_RT_IDEX))) else 

-- 				  '1' when ((i_RegWrEXMEM = '1' and i_RD_EXMEM /= "00000" and i_RD_EXMEM = i_RS_IFID)
-- 					or (i_RegWrEXMEM = '1' and i_RD_EXMEM /= "00000" and i_RD_EXMEM = i_RT_IFID)) else 
					
-- 				  '1' when  (((i_RegWrMEMWB = '1' and i_RD_MEMWB /= "00000" and i_RD_MEMWB = i_RS_IFID))
-- 					or ((i_RegWrMEMWB = '1' and i_RD_MEMWB /= "00000" and i_RD_MEMWB = i_RT_IFID))) else 
					
-- 				  '0';  


--stall assuming forwarding 
o_IFID_stall <=   '1' when ((i_RegWrIDEX ='1' and i_RD_IDEX /= "00000" and i_RD_IDEX = i_RT_IFID) 
						or   (i_RegWrIDEX ='1' and i_RD_IDEX /= "00000" and i_RD_IDEX = i_RS_IFID)) else

				  '1' when ((i_RegWrEXMEM = '1' and i_RD_EXMEM /= "00000" and i_RD_EXMEM = i_RS_IFID)
					or (i_RegWrEXMEM = '1' and i_RD_EXMEM /= "00000" and i_RD_EXMEM = i_RT_IFID)) else 
					
				--   '1' when  (((i_RegWrMEMWB = '1' and i_RD_MEMWB /= "00000" and i_RD_MEMWB = i_RS_IFID))
				-- 	or ((i_RegWrMEMWB = '1' and i_RD_MEMWB /= "00000" and i_RD_MEMWB = i_RT_IFID))) else 
					
				  '0'; 


--flush assuming forwarding
o_IDEX_flush <=   '1' when ((i_RegWrIDEX ='1' and i_RD_IDEX/= "00000" and i_RD_IDEX = i_RT_IFID) 
						or   (i_RegWrIDEX ='1' and i_RD_IDEX/= "00000" and i_RD_IDEX = i_RS_IFID)) else

				  '1' when ((i_RegWrEXMEM = '1' and i_RD_EXMEM /= "00000" and i_RD_EXMEM = i_RS_IFID)
					or (i_RegWrEXMEM = '1' and i_RD_EXMEM /= "00000" and i_RD_EXMEM = i_RT_IFID)) else 
					
				--   '1' when  (((i_RegWrMEMWB = '1' and i_RD_MEMWB /= "00000" and i_RD_MEMWB = i_RS_IFID))
				-- 	or ((i_RegWrMEMWB = '1' and i_RD_MEMWB /= "00000" and i_RD_MEMWB = i_RT_IFID))) else 
					
				  '0'; 



  --Sugma signals 
	o_EXMEM_stall <= '0';
	o_MEMWB_stall <= '0';
	o_IDEX_stall <= '0';
	o_EXMEM_flush <= '0';
	o_MEMWB_flush <= '0';



 --Control hazard case for flush
  o_IFID_flush <= '1' when (i_jump = '1' or i_ALUBranch = '1') else 
	 	  		  '0'; 

end mixed;