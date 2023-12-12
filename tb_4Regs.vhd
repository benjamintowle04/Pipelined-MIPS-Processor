
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all; 
use ieee.numeric_std.all ;

entity tb_4Regs is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end tb_4Regs;

architecture mixed of tb_4Regs is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.


signal CLK, reset : std_logic := '0';
signal resetEXMEM : std_logic := '0';
signal resetMEMWB : std_logic := '0';
signal resetIDEX : std_logic := '0';
signal resetIFID : std_logic := '0';
constant N : integer := 32;


component reg_IF_ID is
generic(N: integer := 32);
port(
  i_Flush   : in std_logic;
  i_PCShift    : in std_logic_vector(N-1 downto 0);
  i_Inst       : in std_logic_vector(N-1 downto 0);
  i_CLK        : in std_logic;                          -- Clock input
  i_RST        : in std_logic;                          -- Reset input
  i_WE         : in std_logic;                          -- Write enable input
  o_PCShift    : out std_logic_vector(N-1 downto 0); 
  o_Inst	     : out std_logic_vector(N-1 downto 0)); 
end component;

component reg_ID_EX is
end component;

component reg_EX_MEM is
end component;

component reg_MEM_WB is
end component;

--Signals

begin
DUT0: reg_IF_ID
port map();
--------------------------------------------
DUT1: reg_ID_EX
port map();
       
-----------------------------------------------
DUT2: reg_EX_MEM
port map();
--------------------------------------------
DUT3: reg_MEM_WB
port map();
-------------------------------------------------


	






















	P_TEST_CASES: process
  	begin
  	  wait for gCLK_HPER/2;

  resetIDEX    <= '0';
      resetIFID <= '0';            
         s_WeIFID <= '1'; 
  resetMEMWB     <= '0';
       s_WEMEMWB     <= '1'; 
    resetEXMEM <= '0';          
         s_WEEXMEM <= '1';
   s_WEIDEX <= '1';
CLK <= '1';
wait for gCLK_HPER/2;

	sIn_PCShifted <= "00000000000010000101000001000000";
       	sIn_Instr <= "00000001000010000100010000100110";            
      
--------------------------------------------------------
	sIn_DMEMOutMEMWB <= "00000010001000001000010001000001";
     
        
	------------------------------------      
	sIn_ALUOutEXMEM <= "00000010001000001011110001000001";
	sIn_ADDOUT2EXMEM <=  "00000010001001111000010001000001";
	sIn_ALUisZeroEXMEM <= '0'; 

	      
     
--------------------------------------------
	sIn_ALUOp_IDEX    <= "00000010";
 
sIn_RegDst_IDEX <= "01";

sIn_MemWrite_IDEX <= '1';

 sIn_Branch_IDEX <= '1';

 sIn_BranchNE_IDEX <= '0';

     sIn_MemtoReg_IDEX <= "01";

      sIn_RegWrite_IDEX <= '1';
       
sIn_ImmOrRead_IDEX <= "01";
        
      sIn_Cin_IDEX <= '1';

 sIn_Replval_IDEX   <= "01000001";
    
  sIn_LOrRLgclOrArith_IDEX <= "01";

   sIn_ShiftCommand_IDEX <= '1';
  
   sIn_ShftAMTALU_IDEX   <= "00001";
    
    sIn_LogicalOp_IDEX <= "01";

   sIn_logicalOrArithmetic_IDEX <= '1';

   sIn_Compare_IDEX          <= '1';

    sIn_Repl_IDEX      <= '1';
 
     sIn_readA_IDEX <= "00000010001000001011110001000001";

    sIn_readB_IDEX <= "00000010001000001011110001000001";

      sIn_PCincremented_IDEX <= "00000010001000001011110001000001";
  
   sIn_SignExtendImm_IDEX <= "00000010001000001011110001000001";
    
       
       
       
       
   


     s_D   <= "00000010001000001011110001000001";
       s_Q <= "00000010001000001011110001000001";
	
	CLK <= '0';
	wait for gCLK_HPER/2; 
	wait for gCLK_HPER/2;
	resetIFID <= '1';
	s_WeIFID <= '0';
CLK <= '1';
	wait for gCLK_HPER/2; 
	wait for gCLK_HPER/2; 
	resetIDEX    <= '1';
	s_WEIDEX <= '0';
CLK <= '0';

	
	
	wait for gCLK_HPER/2; 
	wait for gCLK_HPER/2;
	resetEXMEM <= '1';
	s_WEEXMEM <= '0';
CLK <= '1';

	wait for gCLK_HPER/2; 
	wait for gCLK_HPER/2;
	resetMEMWB <= '1';
	s_WEMEMWB     <= '0';
CLK <= '0';


	wait for gCLK_HPER/2; 
	wait for gCLK_HPER/2;
	resetMEMWB <= '0';
CLK <= '1'; 	  
	wait for gCLK_HPER/2;  
	end process;
end mixed;
