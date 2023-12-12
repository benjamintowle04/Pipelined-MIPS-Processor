-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- MIPS_Processor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a skeleton of a MIPS_Processor  
-- implementation.

-- 01/29/2019 by H3::Design created.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

use IEEE.numeric_std.all;

library work;
use work.MIPS_types.all;


entity MIPS_Processor is
  generic(N : integer := DATA_WIDTH);
  port(iCLK            : in std_logic;
       iRST            : in std_logic;
       iInstLd         : in std_logic;
       iInstAddr       : in std_logic_vector(N-1 downto 0);
       iInstExt        : in std_logic_vector(N-1 downto 0);
       oALUOut         : out std_logic_vector(N-1 downto 0)); -- TODO: Hook this up to the output of the ALU. It is important for synthesis that you have this output that can effectively be impacted by all other components so they are not optimized away.

end  MIPS_Processor;

----------------------------------------------------------------------------------------------------------------------------------------------
architecture structure of MIPS_Processor is


  --DEBUG SIGNAL
  signal s_debug_IF_InstCount : integer := -1; 
  signal s_debug_ID_InstCount : integer := -2; 
  signal s_debug_EXE_InstCount : integer := -3; 
  signal s_debug_MEM_InstCount : integer := -4; 
  signal s_debug_WB_InstCount : integer := -5; 

  -- Required data memory signals
  signal s_DMemWr       : std_logic; -- TODO: use this signal as the final active high data memory write enable signal
  signal s_DMemAddr     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory address input
  signal s_DMemData     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input
  signal s_DMemOut      : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the data memory output
 
  -- Required register file signals 
  signal s_RegWr        : std_logic; -- TODO: use this signal as the final active high write enable input to the register file
  signal s_RegWrAddr    : std_logic_vector(4 downto 0); -- TODO: use this signal as the final destination register address input
  signal s_RegWrData    : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input

  -- Required instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0); -- TODO: use this signal as your intended final instruction memory address input.
  signal s_Inst         : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the instruction signal 

  -- Required halt signal -- for simulation
  signal s_Halt         : std_logic;  -- TODO: this signal indicates to the simulation that intended program execution has completed. (Opcode: 01 0100)

  -- Required overflow signal -- for overflow exception detection
  signal s_Ovfl         : std_logic;  -- TODO: this signal indicates an overflow exception would have been initiated

  --all control signals output by control module
  signal s_ALUOp        : std_logic_vector(3 downto 0);
  signal s_ALUSrc, s_memToReg, s_RegDst, s_signed, s_addSub, s_shiftType, s_shiftDir, s_bne, s_beq, s_j, s_jal, s_jr, s_jump, s_branch, s_lui, s_ctlExt : std_logic;
  signal s_ALUBranch    : std_logic; --not a part of control module, but will be used with s_branch to determine if a conditional jump is made
  

  --signals output by the register file and into the alu
  signal s_RS   : std_logic_vector(31 downto 0);
  signal s_RT   : std_logic_vector(31 downto 0); 

  --signal carrys value that will be written back to a register 
  signal s_writeData   : std_logic_vector(31 downto 0);

  --Carrys 32 bit immediate value
  signal s_Imm   : std_logic_vector(31 downto 0);

  --Allows output of alu to connect to other signals and not just the output of the entire processor
  signal s_ALUOut   :  std_logic_vector(31 downto 0); 

  --signal to be used by jal logic within the top-level design
  signal s_pJPC     : std_logic_vector(31 downto 0);

  --dummy signal for a fetchLogic input with no implementation (ignore this) 
  signal s_pAddr    : std_logic_vector(31 downto 0)  := x"00000000";

  --R[31] for when jal is used
  signal s_r31      : std_logic_vector(4 downto 0) := "11111"; 

  signal s_RA1	: std_logic_vector(4 downto 0); 
  



  --Decode stage values
  signal ID_s_PC_Incremented : std_logic_vector(31 downto 0); 
  signal ID_s_Inst    : std_logic_vector(31 downto 0); 
  signal ID_s_memWr   : std_logic;
  signal ID_s_regWr   : std_logic; 
  signal ID_s_halt    : std_logic; 


  --Execution stage values
  signal EX_s_memWr  : std_logic;
  signal EX_s_memToReg  : std_logic;
  signal EX_s_jal  : std_logic;
  signal EX_s_regDst  : std_logic;
  signal EX_s_halt  : std_logic;
  signal EX_s_regWr  : std_logic;
  signal EX_s_ALUSrc  : std_logic;
  signal EX_s_ALUOp  : std_logic_vector(3 downto 0);
  signal EX_s_shiftType  : std_logic;
  signal EX_s_shiftDir  : std_logic;
  signal EX_s_ctlExt  : std_logic;
  signal EX_s_addSub  : std_logic;
  signal EX_s_signed  : std_logic;
  signal EX_s_lui  : std_logic;
  signal EX_s_j  : std_logic;
  signal EX_s_jr  : std_logic;
  signal EX_s_jump  : std_logic;
  signal EX_s_beq  : std_logic;
  signal EX_s_bne  : std_logic;
  signal EX_s_branch  : std_logic;
  signal EX_s_Ovfl : std_logic; 
  signal EX_s_PC_Incremented : std_logic_vector(31 downto 0);
  signal EX_s_Inst           : std_logic_vector(31 downto 0);
  signal EX_s_RSdata  : std_logic_vector(31 downto 0);
  signal EX_s_RTdata  : std_logic_vector(31 downto 0);
  signal EX_s_RSaddr  : std_logic_vector(4 downto 0); 
  signal EX_s_RTaddr  : std_logic_vector(4 downto 0); 
  signal EX_s_RDaddr  : std_logic_vector(4 downto 0);
  signal EX_s_WriteAddr : std_logic_vector(4 downto 0); 
  signal EX_s_Imm     : std_logic_vector(31 downto 0); 
  signal EX_s_shamt    : std_logic_vector(4 downto 0);


  --Memory stage values
  signal MEM_s_memToReg     : std_logic;
  signal MEM_s_jal     : std_logic;
  signal MEM_s_regDst     : std_logic;
  signal MEM_s_halt     : std_logic;
  signal MEM_s_regWr     : std_logic;
  signal MEM_s_Ovfl      : std_logic;
  signal MEM_s_pJPC      : std_logic_vector(31 downto 0);
  signal MEM_s_PC_Incremented     : std_logic_vector(31 downto 0);
  signal MEM_s_RSaddr     : std_logic_vector(4 downto 0); 
  signal MEM_s_RDaddr     : std_logic_vector(4 downto 0);
  signal MEM_s_RTaddr     : std_logic_vector(4 downto 0);
  signal MEM_s_ALUResult  : std_logic_vector(31 downto 0);
  signal MEM_s_WriteAddr  : std_logic_vector(4 downto 0); 



  --Write Back stage values
  signal WB_s_memToReg	:  std_logic;
	signal WB_s_regWr		:  std_logic;
	signal WB_s_regDst	:  std_logic;
	signal WB_s_jal       :  std_logic;
	signal WB_s_halt		:  std_logic;
  signal WB_s_pJPC    : std_logic_vector(31 downto 0);
  signal WB_s_PC_Incremented : std_logic_vector(31 downto 0); 
  signal WB_s_dMemOut  : std_logic_vector(31 downto 0);  
  signal WB_s_ALUResult  : std_logic_vector(31 downto 0);
  signal WB_s_RTaddr  : std_logic_vector(4 downto 0);
  signal WB_s_RDaddr  : std_logic_vector(4 downto 0);

  
  
  --Lalith Signals
  signal s_selectedAddr	: std_logic_vector(31 downto 0);
  signal s_pcIncrement	: std_logic_vector(31 downto 0);
  signal s_selectBr	: std_logic;
  signal s_regValsEq	: std_logic;
  signal s_brExt	: std_logic_vector(31 downto 0);
  signal s_brShift	: std_logic_vector(31 downto 0);
  signal s_brFin 	: std_logic_vector(31 downto 0);
  signal s_jumpATS	: std_logic_vector(27 downto 0);
  signal s_jFin		: std_logic_vector(31 downto 0);
  signal s_brMUXfin	: std_logic_vector(31 downto 0);
  signal s_jMUXfin	: std_logic_vector(31 downto 0);
  signal s_pcSelect : std_logic_vector(1 downto 0);
  signal s_instSelect : std_logic_vector(1 downto 0);
  signal s_instSelected : std_logic_vector(31 downto 0);
  signal s_FWDselRS : std_logic_vector(1 downto 0);
  signal s_FWDselRT : std_logic_vector(1 downto 0);
  signal s_regRS    : std_logic_vector(31 downto 0);
  signal s_regRT    : std_logic_vector(31 downto 0);
  signal s_FWDselALUA : std_logic_vector(1 downto 0);
  signal s_FWDselALUB : std_logic_vector(1 downto 0);
  signal s_FWDselJr   : std_logic_vector(1 downto 0);
  signal s_FWDselDmem : std_logic_vector(1 downto 0);
  signal s_DMemDataEX : std_logic_vector(31 downto 0);
  signal s_ALU_RS     : std_logic_vector(31 downto 0);
  signal s_ALU_RT     : std_logic_vector(31 downto 0);
  signal s_jrAddr     : std_logic_vector(31 downto 0);


  --Ben Signal 
  signal benSignal    : std_logic; 

  
  signal IFID_s_flush      : std_logic; 
  signal IDEX_s_flush      : std_logic; 
  signal EXMEM_s_flush      : std_logic; 
  signal MEMWB_s_flush      : std_logic; 

  signal IFID_s_stall      : std_logic;
  signal IDEX_s_stall : std_logic;
  signal EXMEM_s_stall : std_logic;
  signal MEMWB_s_stall : std_logic; 

  signal IFID_s_dont_stall   : std_logic; 
  signal IDEX_s_dont_stall   : std_logic; 
  signal EXMEM_s_dont_stall   : std_logic; 
  signal MEMWB_s_dont_stall   : std_logic; 

  type registers is array(0 to (2**N)-1) of std_logic_vector((2**N)-1 downto 0);
  signal s_Registers : registers;

  signal s_RT_integer  : integer; 
  signal s_RS_integer  : integer; 


--Dummy signals because questa wont compile open ports
signal dummyA : std_logic_vector(31 downto 0); 
signal dummyB : std_logic_vector(31 downto 0); 
----------------------------------------------------------------------------------------------------------------------------------------------
  
  component mem is
    generic(ADDR_WIDTH : integer;
            DATA_WIDTH : integer);
    port(clk          : in std_logic;
         addr         : in std_logic_vector((ADDR_WIDTH-1) downto 0);
         data         : in std_logic_vector((DATA_WIDTH-1) downto 0);
         we           : in std_logic := '1';
         q            : out std_logic_vector((DATA_WIDTH -1) downto 0));
    end component;

----------------------------------------------------------------------------------------------------------------------------------------------

  -- TODO: You may add any additional signals or components your implementation 
  --       requires below this comment

  component control is 
   port(i_opCode   : in std_logic_vector(5 downto 0); --MIPS instruction opcode (6 bits wide)
	i_funCode  : in std_logic_vector(5 downto 0); --MIPS instruction function code (6 bits wide) used for R-Type instructions
	o_RegDst   : out std_logic;
	o_RegWrite : out std_logic;
	o_memToReg : out std_logic;
	o_memWrite : out std_logic;
	o_ALUSrc   : out std_logic;
	o_ALUOp    : out std_logic_vector(3 downto 0);
	o_signed   : out std_logic;
	o_addSub   : out std_logic;
	o_shiftType : out std_logic;
	o_shiftDir  : out std_logic;
	o_bne       : out std_logic;
	o_beq       : out std_logic;
	o_j         : out std_logic;
	o_jr        : out std_logic;
	o_jal       : out std_logic;
	o_branch    : out std_logic;
	o_jump      : out std_logic;
	o_lui       : out std_logic;
	o_halt      : out std_logic;   --signal used to end the mips program 
	o_ctlExt    : out std_logic);
  end component;

  component nBitRegFile is 
     port(i_WA     : in std_logic_vector(4 downto 0);
	  i_CLK    : in std_logic;
	  i_RST    : in std_logic;
	  i_DATA   : in std_logic_vector(31 downto 0);
	  i_WEN    : in std_logic;
	  i_RA1    : in std_logic_vector(4 downto 0);
	  i_RA2    : in std_logic_vector(4 downto 0);
	  o_1      : out std_logic_vector(31 downto 0);
	  o_2      : out std_logic_vector(31 downto 0));   -- Data value output
  end component;

  component alu is
     port(i_RS, i_RT   : in std_logic_vector(31 downto 0);
	i_Imm              : in std_logic_vector(31 downto 0);
	i_ALUOp            : in std_logic_vector(3 downto 0);
	i_ALUSrc           : in std_logic;
	i_bne              : in std_logic;
	i_beq              : in std_logic;
	i_shiftDir         : in std_logic;
	i_shiftType        : in std_logic;
	i_shamt            : in std_logic_vector(4 downto 0);
	i_addSub           : in std_logic;
	i_signed           : in std_logic;
	i_lui              : in std_logic;
	o_result           : out std_logic_vector(31 downto 0);
	o_overflow         : out std_logic;
	o_branch           : out std_logic); 
  end component;

----------------------------------------------------------------------------------------------------------------------------------------------
 --Fetch Logic --
  component fetchLogic is 
   port(
    i_stall : in std_logic; 
    i_CLK	: in std_logic;
	  i_RST	: in std_logic;
	  i_j	: in std_logic;
	  i_jal	: in std_logic;
	  i_jReg	: in std_logic;
	  i_jRetReg  : in std_logic_vector(31 downto 0);
	  i_br	: in std_logic;
	  i_brNE	: in std_logic;
	  i_ALU0	: in std_logic;
	  i_pAddr	: in std_logic_vector(31 downto 0);
	  i_pInst	: in std_logic_vector(31 downto 0);
	  o_nAddr	: out std_logic_vector(31 downto 0);
	  o_pJPC  : out std_logic_vector(31 downto 0));
    end component; 

  component PCdffg is 
    port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic_vector(31 downto 0);     -- Data value input
       o_Q          : out std_logic_vector(31 downto 0));   -- Data value output
  end component; 

  component comparator is 
   generic(N : integer := 32);
   port(i_A	: in std_logic_vector(N-1 downto 0);
	i_B	: in std_logic_vector(N-1 downto 0); 
	o_eq	: out std_logic);  
  end component;

  component pcRegister is 
   port(i_CLK        : in std_logic;                          -- Clock input
        i_RST        : in std_logic;                          -- Reset input
        i_WE         : in std_logic;                          -- Write enable input
        i_D          : in std_logic_vector(31 downto 0);     -- Data value input
        o_Q          : out std_logic_vector(31 downto 0));   -- Data value output
  end component; 

  --Sign/Zero Extension
  component bit_width_extender is 
   port(  i_Imm16   : in std_logic_vector(15 downto 0);
	  i_ctl     : in std_logic;
	  o_Imm32   : out std_logic_vector(31 downto 0)); 
  end component;

  component extendSign is
   port(i_sign	: in std_logic_vector(15 downto 0);
	o_sign	: out std_logic_vector(31 downto 0));
  end component;

  component shift is 
   port(i_In	: in std_logic_vector(31 downto 0);
	o_Out	: out std_logic_vector(31 downto 0)); 
  end component;

  component addToStart is
   port(i_jBits	: in std_logic_vector(27 downto 0);
	i_PCb	: in std_logic_vector(3 downto 0);
	o_Out	: out std_logic_vector(31 downto 0));
  end component;

  component addToEnd is 
   port(i_In	: in std_logic_vector(25 downto 0);
	o_Out	: out std_logic_vector(27 downto 0));
  end component; 

  component nBitAdder is
   generic(N : integer := 32); --use generics for a multiple bit input/output
   port(in_A        : in std_logic_vector(N-1 downto 0);
	in_B  	    : in std_logic_vector(N-1 downto 0);
     	in_C        : in std_logic;
     	out_S       : out std_logic_vector(N-1 downto 0);
     	out_C       : out std_logic);
  end component;

-- 32 bit mux to determine whether the memory output or alu output is writtent desired register
  component mux2t1_N is  
   generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
   port(i_S          : in std_logic;
        i_D0         : in std_logic_vector(N-1 downto 0);
        i_D1         : in std_logic_vector(N-1 downto 0);
        o_O          : out std_logic_vector(N-1 downto 0));
  end component;

-- 5 bit mux to determine which address is being written to 
  component mux2t1_5bit is 
    port(i_S          : in std_logic;
        i_D0         : in std_logic_vector(4 downto 0);
        i_D1         : in std_logic_vector(4 downto 0);
        o_O          : out std_logic_vector(4 downto 0));
  end component;

  component mux3t1_N is 
   generic(N : integer := 5); -- Generic of type integer for input/output data width. Default value is 32.
   port(i_S          : in std_logic;
	      i_jal        : in std_logic;
       	i_D0         : in std_logic_vector(N-1 downto 0);
      	i_D1         : in std_logic_vector(N-1 downto 0);
       	i_D2         : in std_logic_vector(N-1 downto 0);
       	o_O          : out std_logic_vector(N-1 downto 0));
  end component;

----------------------------------------------------------------------------------------------------------------------------------------------
--Pipelined Register components 

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
    port(
    i_Flush   : in std_logic;
    i_CLK        : in std_logic;                     
    i_RST        : in std_logic;                         
    i_WE         : in std_logic;
    i_memWr      : in std_logic;
    i_memToReg   : in std_logic;
    i_jal        : in std_logic;
    i_regDst     : in std_logic;
    i_halt       : in std_logic;
    i_regWr      : in std_logic;
    i_ALUSrc     : in std_logic;
    i_ALUOp      : in std_logic_vector(3 downto 0);
    i_shiftType  : in std_logic;
    i_shiftDir   : in std_logic;
    i_ctlExt     : in std_logic;
    i_addSub     : in std_logic;
    i_signed     : in std_logic;
    i_lui        : in std_logic;
    i_j          : in std_logic;
    i_jr         : in std_logic;
    i_jump       : in std_logic;
    i_beq        : in std_logic;
    i_bne        : in std_logic;
    i_branch     : in std_logic;
    i_PC_Incremented  : in std_logic_vector(31 downto 0);
    i_Inst            : in std_logic_vector(31 downto 0); 
    i_RSdata          : in std_logic_vector(31 downto 0);
    i_RTdata          : in std_logic_vector(31 downto 0);
    i_RSaddr          : in std_logic_vector(4 downto 0); 
    i_RTaddr          : in std_logic_vector(4 downto 0);
    i_RDaddr          : in std_logic_vector(4 downto 0);
    i_Imm             : in std_logic_vector(31 downto 0);
    i_shamt           : in std_logic_vector(4 downto 0); 
    o_memWr      : out std_logic;
    o_memToReg   : out std_logic;
    o_jal        : out std_logic;
    o_regDst     : out std_logic;
    o_halt       : out std_logic;
    o_regWr      : out std_logic;
    o_ALUSrc     : out std_logic;
    o_ALUOp      : out std_logic_vector(3 downto 0);
    o_shiftType  : out std_logic;
    o_shiftDir   : out std_logic;
    o_ctlExt     : out std_logic;
    o_addSub     : out std_logic;
    o_signed     : out std_logic;
    o_lui        : out std_logic;
    o_j          : out std_logic;
    o_jr         : out std_logic;
    o_jump       : out std_logic;
    o_beq        : out std_logic;
    o_bne        : out std_logic;
    o_branch     : out std_logic;
    o_PC_Incremented      : out std_logic_vector(31 downto 0);
    o_Inst                : out std_logic_vector(31 downto 0); 
    o_RSdata              : out std_logic_vector(31 downto 0);
    o_RTdata              : out std_logic_vector(31 downto 0);
    o_RSaddr              : out std_logic_vector(4 downto 0); 
    o_RTaddr              : out std_logic_vector(4 downto 0);
    o_RDaddr              : out std_logic_vector(4 downto 0);
    o_Imm                 : out std_logic_vector(31 downto 0);
    o_shamt               : out std_logic_vector(4 downto 0)); 
  end component; 

  component reg_EX_MEM is 
    port(
    i_Flush   : in std_logic;
    i_CLK        : in std_logic;                          -- Clock input
    i_RST        : in std_logic;                          -- Reset input
    i_WE         : in std_logic;                          -- Write enable input
    i_memWr      : in std_logic;
    i_memToReg   : in std_logic;
    i_jal        : in std_logic;
    i_regDst     : in std_logic;
    i_halt       : in std_logic;
    i_regWr      : in std_logic;
    i_Overflow   : in std_logic;
    i_pJPC       : in std_logic_vector(31 downto 0); 
    i_PC_Incremented  : in std_logic_vector(31 downto 0);
    i_RSaddr          : in std_logic_vector(4 downto 0);
    i_RDaddr          : in std_logic_vector(4 downto 0);
    i_RTaddr          : in std_logic_vector(4 downto 0);
    i_WrAddr          : in std_logic_vector(4 downto 0);
    i_RTdata          : in std_logic_vector(31 downto 0); 
    i_ALUResult       : in std_logic_vector(31 downto 0);
    o_memWr      : out std_logic;
    o_memToReg   : out std_logic;
    o_jal        : out std_logic;
    o_regDst     : out std_logic;
    o_halt       : out std_logic;
    o_regWr      : out std_logic;
    o_Overflow   : out std_logic;
    o_pJPC       : out std_logic_vector(31 downto 0); 
    o_PC_Incremented  : out std_logic_vector(31 downto 0);
    o_RSaddr          : out std_logic_vector(4 downto 0);
    o_RDaddr          : out std_logic_vector(4 downto 0);
    o_RTaddr          : out std_logic_vector(4 downto 0); 
    o_WrAddr          : out std_logic_vector(4 downto 0); 
    o_RTdata          : out std_logic_vector(31 downto 0);  
    o_ALUResult       : out std_logic_vector(31 downto 0));
  end component;

  component reg_MEM_WB is 
    generic(N: integer := 32);
    port(
         i_Flush   : in std_logic;
         i_CLK     : in std_logic;                          -- Clock input
         i_RST      : in std_logic;                          -- Reset input
         i_WE       : in std_logic;                          -- Write enable input
         i_memToReg	: in std_logic;
         i_regWr		: in std_logic;
         i_regDst	: in std_logic;
         i_jal     : in std_logic;
         i_halt		: in std_logic;
         i_Overflow : in std_logic;
         i_PC_Incremented  : in std_logic_vector(31 downto 0);
         i_pJPC     : in std_logic_vector(31 downto 0);
         i_dMemOut	: in std_logic_vector(N-1 downto 0);
         i_ALUOut	: in std_logic_vector(N-1 downto 0);
         i_RTaddr    : in std_logic_vector(4 downto 0);
         i_RDaddr    : in std_logic_vector(4 downto 0);
	 i_wrAddr    : in std_logic_vector(4 downto 0); 
         o_memToReg	: out std_logic;
         o_regWr		: out std_logic;
         o_regDst	: out std_logic;
         o_jal      : out std_logic;
         o_halt		: out std_logic; 
         o_Overflow : out std_logic;
         o_PC_Incremented  : out std_logic_vector(31 downto 0);
         o_pJPC     : out std_logic_vector(31 downto 0); 
         o_dMemOut	: out std_logic_vector(N-1 downto 0);
         o_ALUOut	: out std_logic_vector(N-1 downto 0);
         o_RTaddr     : out std_logic_vector(4 downto 0);
         o_RDaddr    : out std_logic_vector(4 downto 0);
	 o_wrAddr    : out std_logic_vector(4 downto 0));
  end component;

  component mux4t1_N is 
    generic(N : integer := 32);
    port(i_S    : in std_logic_vector(1 downto 0);
         i_D0   : in std_logic_vector(N-1 downto 0);
         i_D1   : in std_logic_vector(N-1 downto 0);
         i_D2   : in std_logic_vector(N-1 downto 0);
         i_D3   : in std_logic_vector(N-1 downto 0);
         o_O    : out std_logic_vector(N-1 downto 0));
  end component;

  component forwarding is 
    port(i_RS_IDEX	: in std_logic_vector(4 downto 0); 
		     i_RT_IDEX	: in std_logic_vector(4 downto 0);
		     i_RD_EXMEM	: in std_logic_vector(4 downto 0);
		     i_RD_MEMWB	: in std_logic_vector(4 downto 0);
		     i_RegWrEXMEM		: in std_logic;
		     i_RegWrMEMWB		: in std_logic;
         i_memWrEXMEM   : in std_logic; 
		     o_SelectALUA		: out std_logic_vector(1 downto 0);
		     o_SelectALUB		: out std_logic_vector(1 downto 0));
  end component; 

  component detectHazard is 
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

       o_IFID_stall     : out std_logic; 
		   o_IDEX_stall   : out std_logic;
		   o_EXMEM_stall   : out std_logic;
		   o_MEMWB_stall   : out std_logic;
     
		   o_IFID_flush       : out std_logic;
		   o_IDEX_flush       : out std_logic;
		   o_EXMEM_flush       : out std_logic;
		   o_MEMWB_flush       : out std_logic); 
  end component; 
----------------------------------------------------------------------------------------------------------------------------------------------

begin 
  s_DMemAddr <= MEM_s_ALUResult; 
  IFID_s_dont_stall <= not(IFID_s_stall); 
  IDEX_s_dont_stall <= not(IDEX_s_stall); 
  EXMEM_s_dont_stall <= not(EXMEM_s_stall); 
  MEMWB_s_dont_stall <= not(MEMWB_s_stall); 
 

  -- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
      iInstAddr when others;


  debug_process: process(iCLK)
  begin
    if rising_edge(iCLK) then
      s_debug_IF_InstCount <= s_debug_IF_InstCount + 1;
      s_debug_ID_InstCount <= s_debug_ID_InstCount + 1;
      s_debug_EXE_InstCount <= s_debug_EXE_InstCount + 1;
      s_debug_MEM_InstCount <= s_debug_MEM_InstCount + 1;
      s_debug_WB_InstCount <= s_debug_WB_InstCount + 1;
    end if;
  end process debug_process;

  IMem: mem
    generic map(ADDR_WIDTH => 10,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_IMemAddr(11 downto 2),
             data => iInstExt,
             we   => iInstLd,
             q    => s_Inst);
  
  DMem: mem
    generic map(ADDR_WIDTH => 10,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_DMemAddr(11 downto 2),
             data => s_DMemData,
             we   => s_DMemWr,
             q    => s_DMemOut);

  -- TODO: Ensure that s_Halt is connected to an output control signal produced from decoding the Halt instruction (Opcode: 01 0100) --DONE
  -- TODO: Ensure that s_Ovfl is connected to the overflow output of your ALU --DONE

  -- TODO: Implement the rest of your processor below this comment! 
---------------------------------------------------------------------------------------------------------------------
  
  Hazard_Detection: detectHazard
  port map 
  (
    i_RS_IDEX => EX_s_RSaddr,
    i_RT_IDEX => EX_s_RTaddr,
    i_RT_IFID => ID_s_Inst(20 downto 16),
    i_RS_IFID => ID_s_Inst(25 downto 21),
    i_RD_EXMEM => MEM_s_WriteAddr,
    i_RD_MEMWB => s_RegWrAddr,
    i_RD_IDEX => EX_s_WriteAddr,
    i_RegWrEXMEM => MEM_s_regWr,   
    i_RegWrMEMWB  => s_RegWr,
    i_RegWrIDEX  => EX_s_regWr,
    i_ALUBranch   =>  benSignal,
    i_jump        =>  s_jump,       
    o_IFID_stall       =>  IFID_s_stall, 
    o_IDEX_stall       =>  IDEX_s_stall,      
    o_EXMEM_stall       =>  EXMEM_s_stall,      
    o_MEMWB_stall       =>  MEMWB_s_stall,      
    o_IFID_flush       =>  IFID_s_flush, 
    o_IDEX_flush      =>  IDEX_s_flush,      
    o_EXMEM_flush       =>  EXMEM_s_flush,      
    o_MEMWB_flush       =>  MEMWB_s_flush
  ); 

  Forwarding_Unit: forwarding
  port map(i_RS_IDEX	=> EX_s_RSaddr,
           i_RT_IDEX	=> EX_s_RTaddr,
           i_RD_EXMEM	=> MEM_s_WriteAddr,
           i_RD_MEMWB	=> s_RegWrAddr,
           i_RegWrEXMEM		=> MEM_s_regWr,
           i_RegWrMEMWB		=> s_RegWr,
           i_memWrEXMEM   => s_DMemWr,
           o_SelectALUA		=> s_FWDselALUA,
           o_SelectALUB		=> s_FWDselALUB);

  ALU_FWD_RS_Selection: mux4t1_N
  generic map(N => 32)
    port map(i_S   => s_FWDselALUA,
             i_D0  => EX_s_RSdata,
             i_D1  => MEM_s_ALUResult,
             i_D2  => s_RegWrData,
             i_D3  => dummyA,
             o_O   => s_ALU_RS);

  ALU_FWD_RT_Selection: mux4t1_N
  generic map(N => 32)
    port map(i_S   => s_FWDselALUB,
            i_D0  => EX_s_RTdata,
            i_D1  => MEM_s_ALUResult,
            i_D2  => s_RegWrData,
            i_D3  => s_DMemData,
            o_O   => s_ALU_RT);

---------------------------------------------------------------------------------------------------------------------
  CTL: control 
    port map(i_opCode  => ID_s_Inst(31 downto 26),
	     i_funCode => ID_s_Inst(5 downto 0),
	     o_RegDst  => s_RegDst,
	     o_RegWrite => ID_s_regWr, 
	     o_memToReg => s_memToReg,
	     o_memWrite => ID_s_memWr,
	     o_ALUSrc   => s_ALUSrc,
	     o_ALUOp    => s_ALUOp,
	     o_signed   => s_signed,
	     o_addSub   => s_addSub,
	     o_shiftType => s_shiftType,
	     o_shiftDir  => s_shiftDir,
	     o_bne       => s_bne,
	     o_beq       => s_beq,
	     o_j         => s_j,
	     o_jal       => s_jal,
	     o_jr        => s_jr,
	     o_branch    => s_branch,
	     o_jump      => s_jump,
	     o_lui       => s_lui,
	     o_halt      => ID_s_halt,
	     o_ctlExt    => s_ctlExt);

  MUX_REGDST: mux3t1_N  --determining which register we will write our data to 
    generic map(N => 5)
    port map(i_S    => EX_s_regDst,
	     i_jal  => EX_s_jal,
	     i_D0   => EX_s_RTaddr,
	     i_D1   => EX_s_RDaddr,
	     i_D2   => s_r31,
	     o_O    => EX_s_WriteAddr);


  MUX_MEMTOREG: mux3t1_N --determines whether alu output or data memory output is written back to register
   generic map(N => 32) 
   port map(i_S => WB_s_memToReg,
	    i_jal   => WB_s_jal,
	    i_D0     => WB_s_ALUResult,
	    i_D1     => WB_s_dMemOut,
	    i_D2     => WB_s_PC_Incremented,   
	    o_O      => s_RegWrData);

  
  REGFILE: nBitRegFile
   port map(i_WA       => s_RegWrAddr,
	    i_CLK      => not iCLK,
	    i_RST      => iRST,
	    i_DATA     => s_RegWrData,  
	    i_WEN      => s_RegWr,
	    i_RA1      => ID_s_Inst(25 downto 21), --rs address
	    i_RA2      => ID_s_Inst(20 downto 16), --rt address
	    o_1        => s_RS,
	    o_2        => s_RT);
   
   CompareRegisterOutputs: comparator
     generic map(N => 32) 
     port map(i_A	=> s_RS,
	      i_B	=> s_RT,
	      o_eq	=> s_regValsEq);

   --TODO: Figure this out with Lalith
   RegSrcMux: mux2t1_N
   generic map(N => 5)
   port map(i_S          => s_jr,
     	    i_D0         => ID_s_Inst(25 downto 21),
            i_D1         => s_r31,
            o_O          => s_RA1);
 

  EXTENDER: bit_width_extender
    port map(i_Imm16  => ID_s_Inst(15 downto 0), 
	     i_ctl    => s_ctlExt, 
	     o_Imm32  => s_Imm);
	     


  G_ALU: alu
   port map(i_RS  => s_ALU_RS, 
	    i_RT  => s_ALU_RT, 
	    i_Imm => EX_s_Imm, 
	    i_ALUOp => EX_s_ALUOp,
	    i_ALUSrc  => EX_s_ALUSrc,
	    i_bne   => EX_s_bne,
	    i_beq   => EX_s_beq,
	    i_shiftDir => EX_s_shiftDir,
	    i_shiftType => EX_s_shiftType,
	    i_shamt    => EX_s_shamt, 
	    i_addSub   => EX_s_addSub,
	    i_signed   => EX_s_signed,
	    i_lui      => EX_s_lui,
	    o_result   => s_ALUOut,   
	    o_overflow => EX_s_Ovfl,
	    o_branch   => s_ALUBranch);

-------------------------------------------------------------------------------------------------------------------------------

  benSignal <= ((s_regValsEq and s_beq) or (not(s_regValsEq) and s_bne));
  G_FETCH: fetchLogic
    port map(
       i_stall => IFID_s_stall,
       i_CLK  => iCLK, 
	     i_RST  => iRST, 
	     i_j    => s_jump,
	     i_jal  => s_jal,
	     i_jReg => s_jr,
	     i_jRetReg => s_RS,
	     i_br    => s_beq,
	     i_brNE  => s_bne,
	     i_ALU0  => benSignal,
	     i_pAddr => s_IMemAddr,  --redundant (doesn't drive anything within FetchLogic)
	     i_pInst => ID_s_Inst,  --Not sure if this should be ID_s_Inst or not
	     o_nAddr => s_NextInstAddr,   
	     o_pJPC  => s_pcIncrement);   --idk ab this yet

 --PC: pcRegister 
  --port map(i_CLK  => iCLK,
	   --i_RST  => iRST,
	    --i_WE  => '1',
	    --i_D   => s_selectedAddr,
	   -- o_Q   => s_NextInstAddr);

 ----PC_Increment: nBitAdder
 -- --port map(in_A	  => X"00000004",
--	   in_B   => s_NextInstAddr,
 --    	   in_C   => '0',   
 --   	   out_S  => s_pcIncrement,  
 --    	   out_C  => open);
 
 --s_regValsEq can possibly be replaced with s_ALUBranch
   

 --SignExtend_Branch: extendSign 
 -- port map(i_sign  => ID_s_Inst(15 downto 0),
 --	   o_sign  => s_brExt);
--
 --Branch_Shift: shift
 -- port map(i_In	=> s_brExt,
--	   o_Out => s_brShift);
--
 --Branch_Calculate: nBitAdder
 -- port map(in_A	  => s_brShift,	
--	   in_B   => ID_s_PC_Incremented,
 --    	   in_C   => '0',   
 --   	   out_S  => s_brFin,  
 --    	   out_C  => open);
--
 --Jump_aTe: addToEnd 
 -- port map(i_In	=> ID_s_Inst(25 downto 0), --TODO: add EX_s_Inst for execution stage instruction signal
--	   o_Out => s_jumpATS); 
--
 --Jump_aTs: addToStart 
 --  port map(i_jBits   => s_jumpATS,
--	    i_PCb     => ID_s_PC_Incremented(31 downto 28),
--	    o_Out     => s_jFin);
--
 --Branch_Select: mux2t1_N
 -- generic map(N => 32)
 -- port map(i_S	=> s_selectBr,
--	   i_D0 => s_pcIncrement,
--	   i_D1 => s_brFin,
--	   o_O 	=> s_brMUXfin);
--
 --Jump_Select: mux2t1_N
 -- generic map(N => 32) 
 -- port map(i_S	=> s_jump,
--	   i_D0 => s_brMUXfin,
--	   i_D1 => s_jFin,
--	   o_O 	=> s_jMUXfin);
--
 --RA_Select: mux2t1_N
 -- generic map(N => 32)
 -- port map(i_S	=> s_jr,
--	   i_D0 => s_jMUXfin,
--	   i_D1 => s_RS,
--	   o_O 	=> s_selectedAddr);
--
-------------------------------------------------------------------------------------------------------------------------------

 G_IF_ID: reg_IF_ID
   port map(
      i_Flush => IFID_s_flush,
      i_CLK   => iCLK,
	    i_RST   => iRST,
	    i_WE    => IFID_s_dont_stall,
	    i_PCShift => s_pcIncrement,
	    i_Inst    => s_Inst,  
      o_PCShift => ID_s_PC_Incremented,
      o_Inst    => ID_s_Inst);



  G_ID_EX: reg_ID_EX
   port map(
            i_Flush => IDEX_s_flush,
            i_CLK   => iCLK,
            i_RST   => iRST,
            i_WE    => IDEX_s_dont_stall,

            i_memWr => ID_s_memWr,
            i_memToReg => s_memToReg,
            i_jal => s_jal,
            i_regDst => s_RegDst,
            i_halt => ID_s_halt,
            i_regWr => ID_s_regWr,
            i_ALUSrc => s_ALUSrc,
            i_ALUOp => s_ALUOp,
            i_shiftType => s_shiftType,
            i_shiftDir => s_shiftDir,
            i_ctlExt => s_ctlExt,
            i_addSub => s_addSub,
            i_signed => s_signed,
            i_lui => s_lui,
            i_j => s_j,
            i_jr => s_jr,
            i_jump => s_jump,
            i_beq => s_beq,
            i_bne => s_bne,
            i_branch => s_branch,
            i_PC_Incremented => ID_s_PC_Incremented,
            i_Inst           => ID_s_Inst,
            i_RSdata => s_RS,
            i_RTdata => s_RT,
            i_RSaddr => ID_s_Inst(25 downto 21),
            i_RTaddr => ID_s_Inst(20 downto 16),
            i_RDaddr => ID_s_Inst(15 downto 11),
            i_Imm => s_Imm,
            i_shamt => ID_s_inst(10 downto 6),
            

            o_memWr => EX_s_memWr, 
            o_memToReg => EX_s_memToReg, 
            o_jal => EX_s_jal, 
            o_regDst => EX_s_regDst, 
            o_halt => EX_s_halt, 
            o_regWr => EX_s_regWr, 
            o_ALUSrc => EX_s_ALUSrc, 
            o_ALUOp => EX_s_ALUOp, 
            o_shiftType => EX_s_shiftType, 
            o_shiftDir => EX_s_shiftDir, 
            o_ctlExt => EX_s_ctlExt, 
            o_addSub => EX_s_addSub, 
            o_signed => EX_s_signed, 
            o_lui => EX_s_lui, 
            o_j => EX_s_j, 
            o_jr => EX_s_jr, 
            o_jump => EX_s_jump, 
            o_beq => EX_s_beq, 
            o_bne => EX_s_bne, 
            o_branch => EX_s_branch, 
            o_PC_Incremented => EX_s_PC_Incremented,
            o_Inst         => EX_s_Inst, 
            o_RSdata => EX_s_RSdata, 
            o_RTdata => EX_s_RTdata, 
            o_RSaddr => EX_s_RSaddr,
            o_RTaddr => EX_s_RTaddr, 
            o_RDaddr => EX_S_RDaddr, 
            o_Imm => EX_s_Imm,
            o_shamt => EX_s_shamt);

  --TODO: Add ctl signals for each stage so that the same signal isn't assigned to i/o
  G_EX_MEM: reg_EX_MEM
  port map(
          i_Flush => EXMEM_s_flush,
          i_CLK => iCLK,
          i_RST => iRST,
          i_WE => EXMEM_s_dont_stall,
          i_memWr => EX_s_memWr,
          i_memToReg => EX_s_memToReg,
          i_jal => EX_s_jal,
          i_regDst => EX_s_regDst,
          i_halt => EX_s_halt,
          i_regWr => EX_s_regWr,
          i_Overflow => EX_s_Ovfl,
          i_pJPC => s_pJPC,
          i_PC_Incremented => EX_s_PC_Incremented,
          i_RSaddr => EX_s_RSaddr,
          i_RDaddr => EX_s_RDaddr,
          i_RTaddr => EX_s_RTaddr,
          i_WrAddr => EX_s_WriteAddr,
          i_RTdata => s_ALU_RT,
          i_ALUResult => s_ALUOut,

          o_memWr => s_DMemWr,
          o_memToReg => MEM_s_memToReg,
          o_jal => MEM_s_jal,
          o_regDst => MEM_s_regDst,
          o_halt => MEM_s_halt,
          o_regWr => MEM_s_regWr,
          o_Overflow  => MEM_s_Ovfl,
          o_pJPC    => MEM_s_pJPC,
          o_PC_Incremented => MEM_s_PC_Incremented,
          o_RSaddr  => MEM_s_RSaddr,
          o_RDaddr => MEM_s_RDaddr,
          o_RTaddr => MEM_s_RTaddr,
          o_WrAddr => MEM_s_WriteAddr,
          o_RTdata => s_DMemData,
          o_ALUResult => MEM_s_ALUResult);



  G_MEM_WB: reg_MEM_WB
    port map( 
          i_Flush => MEMWB_s_flush,
          i_CLK => iCLK,
          i_RST => iRST,
          i_WE => MEMWB_s_dont_stall,
	        i_memToReg => MEM_s_memToReg,
          i_regWr =>  MEM_s_regWr,
          i_regDst => MEM_s_regDst,
          i_jal =>    MEM_s_jal,
          i_halt =>  MEM_s_halt,
          i_Overflow => MEM_s_Ovfl,
          i_pJPC   => MEM_s_pJPC,  --redundant
          i_PC_Incremented => MEM_s_PC_Incremented,
          i_dMemOut => s_DMemOut,
          i_ALUOut => MEM_s_ALUResult,
          i_RTaddr => MEM_s_RTaddr,
          i_RDaddr => MEM_s_RDaddr,
          i_wrAddr => MEM_s_WriteAddr,
          o_memToReg => WB_s_memToReg,
          o_regWr => s_RegWr,
          o_regDst => WB_s_regDst,
          o_jal => WB_s_jal,
          o_halt => s_Halt,
          o_Overflow => s_Ovfl,
          o_pJPC   => WB_s_pJPC, 
          o_PC_Incremented => WB_s_PC_Incremented,
          o_dMemOut => WB_s_dMemOut,
          o_ALUOut => WB_s_ALUResult,
          o_RTaddr => WB_s_RTaddr,
          o_RDaddr => WB_s_RDaddr,
          o_wrAddr => s_RegWrAddr

  );
	     
   oALUOut <= WB_s_ALUResult;
 
end structure;