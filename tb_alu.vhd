--Benjamin Towle
--10/8/2023
--tb_alu.vhd
--Test bench for the alu.vhd module

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.textio.all;             -- For basic I/O

entity tb_alu is 
end tb_alu;

architecture structure of tb_alu is 
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

signal	s_RS               : std_logic_vector(31 downto 0); 
signal	s_RT               : std_logic_vector(31 downto 0);
signal	s_Imm              : std_logic_vector(31 downto 0);
signal	s_ALUOp            : std_logic_vector(3 downto 0);
signal	s_ALUSrc           : std_logic;
signal	s_bne              : std_logic;
signal	s_beq              : std_logic;
signal	s_shiftDir         : std_logic;
signal	s_shiftType        : std_logic;
signal	s_shamt            : std_logic_vector(4 downto 0);
signal	s_addSub           : std_logic;
signal	s_signed           : std_logic;
signal	s_result           : std_logic_vector(31 downto 0);
signal	s_overflow         : std_logic;
signal	s_branch           : std_logic; 
signal  s_lui              : std_logic;


begin
DUT0: alu

port map(i_RS  => s_RS,
	 i_RT  => s_RT,
	 i_Imm => s_Imm,
	 i_ALUOp => s_ALUOp,
	 i_ALUSrc => s_ALUSrc,
	 i_bne    => s_bne,
	 i_beq    => s_beq,
	 i_shiftDir => s_shiftDir,
	 i_shiftType => s_shiftType,
	 i_shamt     => s_shamt,
	 i_addSub    => s_addSub,
	 i_signed    => s_signed,
	 i_lui       => s_lui,
	 o_result    => s_result,
	 o_overflow  => s_overflow,
	 o_branch    => s_branch);


TEST_CASES: process
begin 

--and
s_RS <= x"ABC12300";
s_RT <= x"00000000";
s_Imm <= x"FFFFFFFF";
s_ALUOp <= "0011";
s_ALUSrc <= '0';
s_bne <= '0';
s_beq <= '0';
s_shiftDir <= '0';
s_shiftType <= '0';
s_shamt <= "00000";
s_addSub <= '0';
s_signed <= '0';
s_lui <= '0';
wait for 50 ns;
--Expect result = x"00000000"


--or 
s_RS <= x"ABC12300";
s_RT <= x"00000000";
s_Imm <= x"FFFFFFFF";
s_ALUOp <= "0111";
s_ALUSrc <= '0';
s_bne <= '0';
s_beq <= '0';
s_shiftDir <= '0';
s_shiftType <= '0';
s_shamt <= "00000";
s_addSub <= '0';
s_signed <= '0';
s_lui <= '0';
wait for 50 ns;
--expect result = x"ABC12300"


--xor
s_RS <= x"ABC12300";
s_RT <= x"00000000";
s_Imm <= x"FFFFFFFF";
s_ALUOp <= "0110";
s_ALUSrc <= '0';
s_bne <= '0';
s_beq <= '0';
s_shiftDir <= '0';
s_shiftType <= '0';
s_shamt <= "00000";
s_addSub <= '0';
s_signed <= '0';
s_lui <= '0';
wait for 50 ns;
--Expect all bits of o_result to be inverted


--nor
s_RS <= x"ABC12300";
s_RT <= x"FFFFFFFF";
s_Imm <= x"00000000";
s_ALUOp <= "0101";
s_ALUSrc <= '0';
s_bne <= '0';
s_beq <= '0';
s_shiftDir <= '0';
s_shiftType <= '0';
s_shamt <= "00000";
s_addSub <= '0';
s_signed <= '0';
s_lui <= '0';
wait for 50 ns;
--Expect result = x"00000000"


--beq (branch)
s_RS <= x"00000008";
s_RT <= x"00000008";
s_Imm <= x"FFFFFFFF";
s_ALUOp <= "0000";
s_ALUSrc <= '0';
s_bne <= '0';
s_beq <= '1';
s_shiftDir <= '0';
s_shiftType <= '0';
s_shamt <= "00000";
s_addSub <= '0';
s_signed <= '0';
s_lui <= '0';
wait for 50 ns;
--Expect result = x"00000000" (not written to a register), branch = '1'


--beq (don't branch)
s_RS <= x"00000008";
s_RT <= x"00000005";
s_Imm <= x"FFFFFFFF";
s_ALUOp <= "0000";
s_ALUSrc <= '0';
s_bne <= '0';
s_beq <= '1';
s_shiftDir <= '0';
s_shiftType <= '0';
s_shamt <= "00000";
s_addSub <= '0';
s_signed <= '0';
s_lui <= '0';
wait for 50 ns;
--Expect result = x"00000000" (not written to a register), branch = '0'


--bne (branch)
s_RS <= x"00000008";
s_RT <= x"00000005";
s_Imm <= x"FFFFFFFF";
s_ALUOp <= "0000";
s_ALUSrc <= '0';
s_bne <= '1';
s_beq <= '0';
s_shiftDir <= '0';
s_shiftType <= '0';
s_shamt <= "00000";
s_addSub <= '0';
s_signed <= '0';
s_lui <= '0';
wait for 50 ns;
--Expect result = x"00000000" (not written to a register), branch = '1'


--bne (don't branch)
s_RS <= x"00000008";
s_RT <= x"00000008";
s_Imm <= x"FFFFFFFF";
s_ALUOp <= "0000";
s_ALUSrc <= '0';
s_bne <= '1';
s_beq <= '0';
s_shiftDir <= '0';
s_shiftType <= '0';
s_shamt <= "00000";
s_addSub <= '0';
s_signed <= '0';
s_lui <= '0';
wait for 50 ns;
--Expect result = x"00000000" (not written to a register), branch = '0'



--subu
s_RS <= x"00080000";
s_RT <= x"00000001";
s_Imm <= x"FFFFFFFF";
s_ALUOp <= "0010";
s_ALUSrc <= '0';
s_bne <= '0';
s_beq <= '0';
s_shiftDir <= '0';
s_shiftType <= '0';
s_shamt <= "00000";
s_addSub <= '1';
s_signed <= '1';
s_lui <= '0';
wait for 50 ns;
--Expect result = x"00000004"


--ori
s_RS <= x"ABC12300";
s_RT <= x"00000000";
s_Imm <= x"FFFFFFFF";
s_ALUOp <= "0111";
s_ALUSrc <= '1';
s_bne <= '0';
s_beq <= '0';
s_shiftDir <= '0';
s_shiftType <= '0';
s_shamt <= "00000";
s_addSub <= '0';
s_signed <= '0';
s_lui <= '0';
wait for 50 ns;
--expect result = x"FFFFFFFF"




--add
s_RS <= x"7FFFFFFF";
s_RT <= x"00000001";
s_Imm <= x"00000008";
s_ALUOp <= "0010";
s_ALUSrc <= '0';
s_bne <= '0';
s_beq <= '0';
s_shiftDir <= '0';
s_shiftType <= '0';
s_shamt <= "00000";
s_addSub <= '0';
s_signed <= '1';
s_lui <= '0';
wait for 50 ns;
--Expect result = x"80000000" and overflow flag should be set to 1


--addu
s_RS <= x"7FFFFFFF";
s_RT <= x"00000001";
s_Imm <= x"00000008";
s_ALUOp <= "0010";
s_ALUSrc <= '0';
s_bne <= '0';
s_beq <= '0';
s_shiftDir <= '0';
s_shiftType <= '0';
s_shamt <= "00000";
s_addSub <= '0';
s_signed <= '0';
s_lui <= '0';
wait for 50 ns;
--Expect result = x"80000000" and overflow flag should not be raised


--addi
s_RS <= x"00000004";
s_RT <= x"00000000";
s_Imm <= x"00000008";
s_ALUOp <= "0010";
s_ALUSrc <= '1';
s_bne <= '0';
s_beq <= '0';
s_shiftDir <= '0';
s_shiftType <= '0';
s_shamt <= "00000";
s_addSub <= '0';
s_signed <= '1';
s_lui <= '0';
wait for 50 ns;
--Expect result = x"0000000C"


--subu
s_RS <= x"00000008";
s_RT <= x"00000004";
s_Imm <= x"FFFFFFFF";
s_ALUOp <= "0010";
s_ALUSrc <= '0';
s_bne <= '0';
s_beq <= '0';
s_shiftDir <= '0';
s_shiftType <= '0';
s_shamt <= "00000";
s_addSub <= '1';
s_signed <= '0';
s_lui <= '0';
wait for 50 ns;
--Expect result = x"00000004"



--sll 
s_RS <= x"00000000";
s_RT <= x"0000FFFF";
s_Imm <= x"FFFFFFFF";
s_ALUOp <= "1001";
s_ALUSrc <= '0';
s_bne <= '0';
s_beq <= '0';
s_shiftDir <= '1';
s_shiftType <= '0';
s_shamt <= "00001";
s_addSub <= '0';
s_signed <= '0';
s_lui <= '0';
wait for 50 ns;
--Expect result = x"0001FFFE" 

--srl 
s_RS <= x"00000000";
s_RT <= x"FFFF0000";
s_Imm <= x"FFFFFFFF";
s_ALUOp <= "1001";
s_ALUSrc <= '0';
s_bne <= '0';
s_beq <= '0';
s_shiftDir <= '0';
s_shiftType <= '0';
s_shamt <= "00001";
s_addSub <= '0';
s_signed <= '0';
s_lui <= '0';
wait for 50 ns;
--Expect result = x"7FFF8000" 


--sra 
s_RS <= x"00000000";
s_RT <= x"FFFF0000";
s_Imm <= x"FFFFFFFF";
s_ALUOp <= "1001";
s_ALUSrc <= '0';
s_bne <= '0';
s_beq <= '0';
s_shiftDir <= '0';
s_shiftType <= '1';
s_shamt <= "00001";
s_addSub <= '0';
s_signed <= '0';
s_lui <= '0';
wait for 50 ns;
--Expect result = x"FFFF8000" 


--lui 
s_RS <= x"00000000";
s_RT <= x"00000000";
s_Imm <= x"0000FFFF";
s_ALUOp <= "1001";
s_ALUSrc <= '1';
s_bne <= '0';
s_beq <= '0';
s_shiftDir <= '1';
s_shiftType <= '0';
s_shamt <= "00001";
s_addSub <= '0';
s_signed <= '0';
s_lui <= '1';
wait for 50 ns;
--Expect result = x"FFFF0000" 


--lui 
s_RS <= x"00000000";
s_RT <= x"00000000";
s_Imm <= x"00000004";
s_ALUOp <= "1001";
s_ALUSrc <= '1';
s_bne <= '0';
s_beq <= '0';
s_shiftDir <= '1';
s_shiftType <= '0';
s_shamt <= "00001";
s_addSub <= '0';
s_signed <= '0';
s_lui <= '1';
wait for 50 ns;
--Expect result = x"00040000" 


--slt (true case)
s_RS <= x"00000008";
s_RT <= x"00000009";
s_Imm <= x"00000008";
s_ALUOp <= "1000";
s_ALUSrc <= '0';
s_bne <= '0';
s_beq <= '0';
s_shiftDir <= '0';
s_shiftType <= '0';
s_shamt <= "00000";
s_addSub <= '0';
s_signed <= '1';
s_lui <= '0';
wait for 50 ns;
--Expect result = x"00000001"


--slt (false case)
s_RS <= x"00000009";
s_RT <= x"00000008";
s_Imm <= x"00000008";
s_ALUOp <= "1000";
s_ALUSrc <= '0';
s_bne <= '0';
s_beq <= '0';
s_shiftDir <= '0';
s_shiftType <= '0';
s_shamt <= "00000";
s_addSub <= '0';
s_signed <= '1';
s_lui <= '0';
wait for 50 ns;
--Expect result = x"00000000"


--slti (edgy case)
s_RS <= x"00000009";
s_RT <= x"0000000C";
s_Imm <= x"00000009";
s_ALUOp <= "1000";
s_ALUSrc <= '1';
s_bne <= '0';
s_beq <= '0';
s_shiftDir <= '0';
s_shiftType <= '0';
s_shamt <= "00000";
s_addSub <= '0';
s_signed <= '1';
s_lui <= '0';
wait for 50 ns;
--Expect result = x"00000000"

end process;

end structure;