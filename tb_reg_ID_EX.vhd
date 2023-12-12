--Benjamin Towle
--10/8/2023
--tb_ID_EX.vhd
--Test bench for the alu.vhd module

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.textio.all;             -- For basic I/O

entity tb_ID_EX is 
generic (
    N : integer := 5;
    gCLK_HPER : time := 50 ns);
end tb_ID_EX;

architecture structure of tb_ID_EX is 
constant cCLK_PER  : time := gCLK_HPER * 2;

component reg_ID_EX is 
port(i_CLK        : in std_logic;                     
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

	--32-Bit and 3-bit value inputs
	i_PC_Incremented  : in std_logic_vector(31 downto 0);
	i_RSdata          : in std_logic_vector(31 downto 0);
	i_RTdata          : in std_logic_vector(31 downto 0);
	i_RTaddr          : in std_logic_vector(3 downto 0);
	i_RDaddr          : in std_logic_vector(3 downto 0);
	i_Imm             : in std_logic_vector(31 downto 0);

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

	--32-Bit and 3-bit value outputs
	o_PC_Incremented      : out std_logic_vector(31 downto 0);
	o_RSdata              : out std_logic_vector(31 downto 0);
	o_RTdata              : out std_logic_vector(31 downto 0);
	o_RTaddr              : out std_logic_vector(3 downto 0);
	o_RDaddr              : out std_logic_vector(3 downto 0);
	o_Imm                 : out std_logic_vector(31 downto 0)); 
end component;


signal s_CLK        :  std_logic;                     
signal s_RST        :  std_logic;                         
signal s_WE         :  std_logic;
signal s_memWr      :  std_logic;
signal s_memToReg   :  std_logic;
signal s_jal        :  std_logic;
signal s_regDst     :  std_logic;
signal s_halt       :  std_logic;
signal s_regWr      :  std_logic;
signal s_ALUSrc     :  std_logic;
signal s_ALUOp      :  std_logic_vector(3 downto 0);
signal s_shiftType  :  std_logic;
signal s_shiftDir   :  std_logic;
signal s_ctlExt     :  std_logic;
signal s_addSub     :  std_logic;
signal s_signed     :  std_logic;
signal s_lui        :  std_logic;
signal s_j          :  std_logic;
signal s_jr         :  std_logic;
signal s_jump       :  std_logic;
signal s_beq        :  std_logic;
signal s_bne        :  std_logic;
signal s_branch     :  std_logic;
signal s_PC_Incremented  :  std_logic_vector(31 downto 0);
signal s_RSdata          :  std_logic_vector(31 downto 0);
signal s_RTdata          :  std_logic_vector(31 downto 0);
signal s_RTaddr          :  std_logic_vector(3 downto 0);
signal s_RDaddr          :  std_logic_vector(3 downto 0);
signal s_Imm             :  std_logic_vector(31 downto 0);


signal so_memWr      :  std_logic;
signal so_memToReg   :  std_logic;
signal so_jal        :  std_logic;
signal so_regDst     :  std_logic;
signal so_halt       :  std_logic;
signal so_regWr      :  std_logic;
signal so_ALUSrc     :  std_logic;
signal so_ALUOp      :  std_logic_vector(3 downto 0);
signal so_shiftType  :  std_logic;
signal so_shiftDir   :  std_logic;
signal so_ctlExt     :  std_logic;
signal so_addSub     :  std_logic;
signal so_signed     :  std_logic;
signal so_lui        :  std_logic;
signal so_j          :  std_logic;
signal so_jr         :  std_logic;
signal so_jump       :  std_logic;
signal so_beq        :  std_logic;
signal so_bne        :  std_logic;
signal so_branch     :  std_logic;
signal so_PC_Incremented      :  std_logic_vector(31 downto 0);
signal so_RSdata              :  std_logic_vector(31 downto 0);
signal so_RTdata              :  std_logic_vector(31 downto 0);
signal so_RTaddr              :  std_logic_vector(3 downto 0);
signal so_RDaddr              :  std_logic_vector(3 downto 0);
signal so_Imm                 :  std_logic_vector(31 downto 0); 




begin
DUT0: reg_ID_EX

port map(
    i_CLK => s_CLK,
    i_RST => s_RST,
    i_WE => s_WE,
    i_memWr => s_memWr,
    i_memToReg => s_memToReg,
    i_jal => s_jal,
    i_regDst => s_regDst,
    i_halt => s_halt,
    i_regWr => s_regWr,
    i_ALUSrc => s_ALUSrc,
    i_ALUOp => s_ALUOp,
    i_shiftType => s_shiftType,
    i_shiftDir => s_shiftDir,
    i_ctlExt => s_ctlExt,
    i_addSub => s_addSub,
    i_signed => s_addSub,
    i_lui => s_lui,
    i_j => s_j,
    i_jr => s_jr,
    i_jump => s_jump,
    i_beq => s_beq,
    i_bne => s_bne,
    i_branch => s_branch,
    i_PC_Incremented  => s_PC_Incremented,
 	i_RSdata  =>  s_RSdata,      
	i_RTdata    =>  s_RTdata,    
	i_RTaddr   =>    s_RTaddr,   
	i_RDaddr  =>   s_RDaddr,     
	i_Imm    =>     s_Imm,   

    o_memWr => so_memWr, 
    o_memToReg => so_memToReg, 
    o_jal => so_jal, 
    o_regDst => so_regDst, 
    o_halt => so_halt, 
    o_regWr => so_regWr, 
    o_ALUSrc => so_ALUSrc, 
    o_ALUOp => so_ALUOp, 
    o_shiftType => so_shiftType, 
    o_shiftDir => so_shiftDir, 
    o_ctlExt => so_ctlExt, 
    o_addSub => so_addSub, 
    o_signed => so_signed, 
    o_lui => so_lui, 
    o_j => so_j, 
    o_jr => so_jr, 
    o_jump => so_jump, 
    o_beq => so_beq, 
    o_bne => so_bne, 
    o_branch => so_branch, 
    o_PC_Incremented => so_PC_Incremented, 
    o_RSdata => so_RSdata, 
    o_RTdata => so_RTdata, 
    o_RTaddr => so_RTaddr, 
    o_RDaddr => so_RDaddr, 
    o_Imm => so_Imm);


P_CLK: process
begin
  s_CLK <= '0';        
  wait for gCLK_HPER; 
  s_CLK <= '1';        
  wait for gCLK_HPER; 
end process;


TEST_CASES: process
begin 

--Random shit
s_RST <= '0';
s_WE <= '1'; 
s_memWr <= '1'; 
s_memToReg <= '0'; 
s_jal <= '0'; 
s_regDst <= '1'; 
s_halt <= '0'; 
s_regWr <= '0'; 
s_ALUSrc <= '1'; 
s_ALUOp <= "0011";
s_shiftType <= '0'; 
s_shiftDir <= '1'; 
s_ctlExt <= '0'; 
s_addSub <= '1'; 
s_signed <= '0'; 
s_lui <= '0'; 
s_j <= '0'; 
s_jr <= '1'; 
s_jump <= '0'; 
s_beq <= '0'; 
s_bne <= '0'; 
s_branch <= '0'; 
s_PC_Incremented <= x"AAAAAAAA"; 
s_RSdata <= x"40000000"; 
s_RTdata <= x"00000000"; 
s_RTaddr <= "1111";
s_RDaddr <= "1100";
s_Imm <= x"00000000";
wait for cCLK_PER;


--Random shit
s_RST <= '0';
s_WE <= '1'; 
s_memWr <= '1'; 
s_memToReg <= '0'; 
s_jal <= '0'; 
s_regDst <= '1'; 
s_halt <= '0'; 
s_regWr <= '0'; 
s_ALUSrc <= '1'; 
s_ALUOp <= "0000";
s_shiftType <= '0'; 
s_shiftDir <= '1'; 
s_ctlExt <= '1'; 
s_addSub <= '0'; 
s_signed <= '0'; 
s_lui <= '0'; 
s_j <= '1'; 
s_jr <= '0'; 
s_jump <= '0'; 
s_beq <= '0'; 
s_bne <= '1'; 
s_branch <= '0'; 
s_PC_Incremented <= x"12345678"; 
s_RSdata <= x"40000000"; 
s_RTdata <= x"00000000"; 
s_RTaddr <= "1111";
s_RDaddr <= "1100";
s_Imm <= x"FFFF0000";
wait for cCLK_PER;


end process;

end structure;