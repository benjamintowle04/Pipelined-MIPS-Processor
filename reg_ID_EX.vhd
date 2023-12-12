--Benjamin Towle
--11/1/2023
--reg_ID_EX.vhd
--File contains elements of an N bit register with dffg.vhd as a component

library IEEE;
use IEEE.std_logic_1164.all;

entity reg_ID_EX is 
   port(i_Flush		 : in std_logic;
		i_CLK        : in std_logic;                     
        i_RST        : in std_logic;                         
        i_WE         : in std_logic;

	--Control signals forwarded to next stages (input)
	i_memWr      : in std_logic;
	i_memToReg   : in std_logic;
	i_jal        : in std_logic;
	i_regDst     : in std_logic;
	i_halt       : in std_logic;
	i_regWr      : in std_logic;


	--Control signals used in Execution stage (input)
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

	--multiple-bit value inputs
	i_PC_Incremented  : in std_logic_vector(31 downto 0);
	i_Inst            : in std_logic_vector(31 downto 0);
	i_RSdata          : in std_logic_vector(31 downto 0);
	i_RTdata          : in std_logic_vector(31 downto 0);
	i_RSaddr          : in std_logic_vector(4 downto 0); 
	i_RTaddr          : in std_logic_vector(4 downto 0);
	i_RDaddr          : in std_logic_vector(4 downto 0);
	i_Imm             : in std_logic_vector(31 downto 0);
	i_shamt           : in std_logic_vector(4 downto 0); 

	--Control signals forwarded to next stages (output)
	o_memWr      : out std_logic;
	o_memToReg   : out std_logic;
	o_jal        : out std_logic;
	o_regDst     : out std_logic;
	o_halt       : out std_logic;
	o_regWr      : out std_logic;

	--Control signals used in Execution stage (output)
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

	--multiple bit value outputs
	o_PC_Incremented      : out std_logic_vector(31 downto 0);
	o_Inst                : out std_logic_vector(31 downto 0);
	o_RSdata              : out std_logic_vector(31 downto 0);
	o_RTdata              : out std_logic_vector(31 downto 0);
	o_RSaddr              : out std_logic_vector(4 downto 0); 
	o_RTaddr              : out std_logic_vector(4 downto 0);
	o_RDaddr              : out std_logic_vector(4 downto 0);
	o_Imm                 : out std_logic_vector(31 downto 0);
	o_shamt               : out std_logic_vector(4 downto 0));       
       
end reg_ID_EX;


architecture structure of reg_ID_EX is

 component dffg is 
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic;     -- Data value input
       o_Q          : out std_logic);   -- Data value output
 end component;

component nBitRegister is   
 generic (N: integer := 32);
   port(i_CLK          : in std_logic;                          -- Clock input
        i_RST        : in std_logic;                          -- Reset input
        i_WE         : in std_logic;                          -- Write enable input
        i_D          : in std_logic_vector(N-1 downto 0);     -- Data value input
        o_Q          : out std_logic_vector(N-1 downto 0));   -- Data value output
end component; 

component mux2t1_N is  
	generic(N : integer := 32);
	port(i_S          : in std_logic;
		 i_D0         : in std_logic_vector(N-1 downto 0);
		 i_D1         : in std_logic_vector(N-1 downto 0);
		 o_O          : out std_logic_vector(N-1 downto 0));
end component;

component mux2t1 is
	port(
		i_S	: in std_logic;
		i_D0	: in std_logic;
		i_D1	: in std_logic;
		o_O	: out std_logic);
end component;

signal s_memWr      : std_logic;
signal s_memToReg   : std_logic;
signal s_jal        : std_logic;
signal s_regDst     : std_logic;
signal s_halt       : std_logic;
signal s_regWr      : std_logic;
signal s_ALUSrc     : std_logic;
signal s_shiftType  : std_logic;
signal s_shiftDir   : std_logic;
signal s_ctlExt     : std_logic;
signal s_addSub     : std_logic;
signal s_signed     : std_logic;
signal s_lui        : std_logic;
signal s_j          : std_logic;
signal s_jr         : std_logic;
signal s_jump       : std_logic;
signal s_beq        : std_logic;
signal s_bne        : std_logic;
signal s_branch     : std_logic;
signal s_ALUOp      : std_logic_vector(3 downto 0);
signal s_PC_Incremented  : std_logic_vector(31 downto 0);
signal s_Inst            : std_logic_vector(31 downto 0);
signal s_RSdata          : std_logic_vector(31 downto 0);
signal s_RTdata          : std_logic_vector(31 downto 0);
signal s_RSaddr          : std_logic_vector(4 downto 0); 
signal s_RTaddr          : std_logic_vector(4 downto 0);
signal s_RDaddr          : std_logic_vector(4 downto 0);
signal s_Imm             : std_logic_vector(31 downto 0);
signal s_shamt           : std_logic_vector(4 downto 0); 


begin

--Quite a few dff generates for all the control signals here 
G_MEM_WR : dffg 
port map(i_CLK  => i_CLK,
	i_RST  => i_RST,
	i_WE   => i_WE,
	i_D    => s_memWr,
	o_Q    => o_memWr);

MUX_MEM_WR: mux2t1
	port map(i_S          => i_Flush,
		i_D0         => i_memWr,
		i_D1         => '0',
		o_O          => s_memWr);

G_MEMTOREG : dffg 
port map(i_CLK  => i_CLK,
	i_RST  => i_RST,
	i_WE   => i_WE,
	i_D    => s_memToReg,
	o_Q    => o_memToReg);

MUX_MEMTOREG: mux2t1
	port map(i_S          => i_Flush,
		i_D0         => i_memToReg,
		i_D1         => '0',
		o_O          => s_memToReg);

G_REGDST : dffg 
port map(i_CLK  => i_CLK,
   i_RST  => i_RST,
   i_WE   => i_WE,
   i_D    => s_regDst,
   o_Q    => o_regDst);

MUX_REGDST: mux2t1
   port map(i_S          => i_Flush,
	   i_D0         => i_regDst,
	   i_D1         => '0',
	   o_O          => s_regDst);

G_HALT : dffg 
port map(i_CLK  => i_CLK,
  i_RST  => i_RST,
  i_WE   => i_WE,
  i_D    => s_halt,
  o_Q    => o_halt);

MUX_HALT: mux2t1
  port map(i_S          => i_Flush,
	  i_D0         => i_halt,
	  i_D1         => '0',
	  o_O          => s_halt);

G_JAL : dffg 
 port map(i_CLK  => i_CLK,
	i_RST  => i_RST,
	i_WE   => i_WE,
	i_D    => s_jal,
	o_Q    => o_jal);

MUX_JAL: mux2t1
	port map(i_S          => i_Flush,
		i_D0         => i_jal,
		i_D1         => '0',
		o_O          => s_jal);

G_J : dffg 
 port map(i_CLK  => i_CLK,
	i_RST  => i_RST,
	i_WE   => i_WE,
	i_D    => s_j,
	o_Q    => o_j);

MUX_J: mux2t1
	port map(i_S          => i_Flush,
		i_D0         => i_j,
		i_D1         => '0',
		o_O          => s_j);

G_Jump : dffg 
port map(i_CLK  => i_CLK,
   i_RST  => i_RST,
   i_WE   => i_WE,
   i_D    => s_jump,
   o_Q    => o_jump);

MUX_JUMP: mux2t1
	port map(i_S          => i_Flush,
		i_D0         => i_jump,
		i_D1         => '0',
		o_O          => s_jump);

G_JR : dffg 
port map(i_CLK  => i_CLK,
  i_RST  => i_RST,
  i_WE   => i_WE,
  i_D    => s_jr,
  o_Q    => o_jr);

MUX_JR: mux2t1
	port map(i_S          => i_Flush,
		i_D0         => i_jr,
		i_D1         => '0',
		o_O          => s_jr);


G_BEQ : dffg 
port map(i_CLK  => i_CLK,
	i_RST  => i_RST,
	i_WE   => i_WE,
	i_D    => s_beq,
	o_Q    => o_beq);

MUX_BEQ: mux2t1
	port map(i_S          => i_Flush,
		i_D0         => i_beq,
		i_D1         => '0',
		o_O          => s_beq);

G_BNE : dffg 
port map(i_CLK  => i_CLK,
	i_RST  => i_RST,
	i_WE   => i_WE,
	i_D    => s_bne,
	o_Q    => o_bne);

MUX_BNE: mux2t1
	port map(i_S          => i_Flush,
		i_D0         => i_bne,
		i_D1         => '0',
		o_O          => s_bne);

G_BRANCH : dffg 
port map(i_CLK  => i_CLK,
	i_RST  => i_RST,
	i_WE   => i_WE,
	i_D    => s_branch,
	o_Q    => o_branch);

MUX_BRANCH: mux2t1
	port map(i_S          => i_Flush,
		i_D0         => i_branch,
		i_D1         => '0',
		o_O          => s_branch);

G_REG_WR : dffg 
port map(i_CLK  => i_CLK,
	i_RST  => i_RST,
	i_WE   => i_WE,
	i_D    => s_regWr,
	o_Q    => o_regWr);

MUX_REG_WR: mux2t1
	port map(i_S          => i_Flush,
		i_D0         => i_regWr,
		i_D1         => '0',
		o_O          => s_regWr);

G_ALU_SRC : dffg 
port map(i_CLK  => i_CLK,
	i_RST  => i_RST,
	i_WE   => i_WE,
	i_D    => s_ALUSrc,
	o_Q    => o_ALUSrc);

MUX_ALU_SRC: mux2t1
	port map(i_S          => i_Flush,
		i_D0         => i_ALUSrc,
		i_D1         => '0',
		o_O          => s_ALUSrc);
		


G_SHIFT_TYPE : dffg 
port map(i_CLK  => i_CLK,
	i_RST  => i_RST,
	i_WE   => i_WE,
	i_D    => s_shiftType,
	o_Q    => o_shiftType);

MUX_SHIFT_TYPE: mux2t1
	port map(i_S          => i_Flush,
		i_D0         => i_shiftType,
		i_D1         => '0',
		o_O          => s_shiftType);

G_SHIFT_DIR : dffg 
port map(i_CLK  => i_CLK,
	i_RST  => i_RST,
	i_WE   => i_WE,
	i_D    => s_shiftDir,
	o_Q    => o_shiftDir);


MUX_SHIFT_DIR: mux2t1
	port map(i_S          => i_Flush,
		i_D0         => i_shiftDir,
		i_D1         => '0',
		o_O          => s_shiftDir);

G_CTL_EXT : dffg 
port map(i_CLK  => i_CLK,
	i_RST  => i_RST,
	i_WE   => i_WE,
	i_D    => s_ctlExt,
	o_Q    => o_ctlExt);

MUX_CTL_EXT: mux2t1
	port map(i_S          => i_Flush,
		i_D0         => i_ctlExt,
		i_D1         => '0',
		o_O          => s_ctlExt);

G_ADDSUB : dffg 
port map(i_CLK  => i_CLK,
	i_RST  => i_RST,
	i_WE   => i_WE,
	i_D    => s_addSub,
	o_Q    => o_addSub);

MUX_ADDSUB: mux2t1
	port map(i_S          => i_Flush,
		i_D0         => i_addSub,
		i_D1         => '0',
		o_O          => s_addSub);

G_SIGNED : dffg 
port map(i_CLK  => i_CLK,
	i_RST  => i_RST,
	i_WE   => i_WE,
	i_D    => s_signed,
	o_Q    => o_signed);

MUX_SIGNED: mux2t1
	port map(i_S          => i_Flush,
		i_D0         => i_signed,
		i_D1         => '0',
		o_O          => s_signed);

G_LUI : dffg 
port map(i_CLK  => i_CLK,
	i_RST  => i_RST,
	i_WE   => i_WE,
	i_D    => s_lui,
	o_Q    => o_lui);

MUX_LUI: mux2t1
	port map(i_S          => i_Flush,
		i_D0         => i_lui,
		i_D1         => '0',
		o_O          => s_lui);



--32 bit registers stored here


G_ALU_OP : nBitRegister
	generic map (N  => 4)
	port map(i_CLK  => i_CLK,
		i_RST  => i_RST,
		i_WE   => i_WE,
		i_D    => s_ALUOp,
		o_Q    => o_ALUOp);

MUX_ALU_OP: mux2t1_N
	generic map(N => 4)
	port map(i_S          => i_Flush,
			i_D0         => i_ALUOp,
			i_D1         => x"0",
			o_O          => s_ALUOp);


G_PC_PLUS_4 : nBitRegister
generic map (N  => 32)
port map(i_CLK  => i_CLK,
	 i_RST  => i_RST,
	 i_WE   => i_WE,
	 i_D    => s_PC_Incremented,
	 o_Q    => o_PC_Incremented);

MUX_PC_PLUS_4: mux2t1_N
	generic map(N => 32)
	port map(i_S          => i_Flush,
		i_D0         => i_PC_Incremented,
		i_D1         => x"00000000",
		o_O          => s_PC_Incremented);

G_Inst : nBitRegister
generic map (N  => 32)
port map(i_CLK  => i_CLK,
		 i_RST  => i_RST,
	 	 i_WE   => i_WE,
		 i_D    => s_Inst,
		 o_Q    => o_Inst);


MUX_INST: mux2t1_N
	generic map(N => 32)
	port map(i_S          => i_Flush,
		i_D0         => i_Inst,
		i_D1         => x"00000000",
		o_O          => s_Inst);

G_RS_DATA : nBitRegister
generic map (N  => 32)
port map(i_CLK  => i_CLK,
	 i_RST  => i_RST,
	 i_WE   => i_WE,
	 i_D    => s_RSdata,
	 o_Q    => o_RSdata);

MUX_RS_DATA: mux2t1_N
	generic map(N => 32)
	port map(i_S          => i_Flush,
		i_D0         => i_RSdata,
		i_D1         => x"00000000",
		o_O          => s_RSdata);

G_RT_DATA : nBitRegister
generic map (N  => 32)
port map(i_CLK  => i_CLK,
	 i_RST  => i_RST,
	 i_WE   => i_WE,
	 i_D    => s_RTdata,
	 o_Q    => o_RTdata);

MUX_RT_DATA: mux2t1_N
	generic map(N => 32)
	port map(i_S          => i_Flush,
		i_D0         => i_RTdata,
		i_D1         => x"00000000",
		o_O          => s_RTdata);

G_RT_ADDR : nBitRegister
generic map (N  => 5)
port map(i_CLK  => i_CLK,
	 i_RST  => i_RST,
	 i_WE   => i_WE,
	 i_D    => s_RTaddr,
	 o_Q    => o_RTaddr);

MUX_RT_ADDR: mux2t1_N
	generic map(N => 5)
	port map(i_S          => i_Flush,
		i_D0         => i_RTaddr,
		i_D1         => b"00000",
		o_O          => s_RTaddr);

G_RS_ADDR : nBitRegister
generic map (N  => 5)
port map(i_CLK  => i_CLK,
	 i_RST  => i_RST,
	 i_WE   => i_WE,
	 i_D    => s_RSaddr,
	 o_Q    => o_RSaddr);

MUX_RS_ADDR: mux2t1_N
	generic map(N => 5)
	port map(i_S          => i_Flush,
		i_D0         => i_RSaddr,
		i_D1         => b"00000",
		o_O          => s_RSaddr);


G_RD_ADDR : nBitRegister
generic map (N  => 5)
port map(i_CLK  => i_CLK,
	 i_RST  => i_RST,
	 i_WE   => i_WE,
	 i_D    => s_RDaddr,
	 o_Q    => o_RDaddr);


MUX_RD_ADDR: mux2t1_N
	generic map(N => 5)
	port map(i_S          => i_Flush,
		i_D0         => i_RDaddr,
		i_D1         => b"00000",
		o_O          => s_RDaddr);

G_Imm : nBitRegister
generic map (N  => 32)
port map(i_CLK  => i_CLK,
	 i_RST  => i_RST,
	 i_WE   => i_WE,
	 i_D    => s_Imm,
	 o_Q    => o_Imm);


MUX_Imm: mux2t1_N
	generic map(N => 32)
	port map(i_S          => i_Flush,
		i_D0         => i_Imm,
		i_D1         => x"00000000",
		o_O          => s_Imm);


G_SHAMT : nBitRegister
generic map (N  => 5)
port map(i_CLK  => i_CLK,
	  i_RST  => i_RST,
	  i_WE   => i_WE,
	  i_D    => s_shamt,
	  o_Q    => o_shamt);


MUX_SHAMT: mux2t1_N
	generic map(N => 5)
	port map(i_S          => i_Flush,
		i_D0         => i_shamt,
		i_D1         => b"00000",
		o_O          => s_shamt);
  

end structure;