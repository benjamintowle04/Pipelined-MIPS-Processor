-------------------------------------------------------------------------
-- Benjamin Towle
-- Iowa State University
-------------------------------------------------------------------------
-- tb_first_datapath.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for the first datapath File
--              
-- 9/20/2023

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.textio.all;             -- For basic I/O

entity tb_first_datapath is
 
 generic (
    N : integer := 5;
    gCLK_HPER : time := 50 ns);

end tb_first_datapath;



architecture structure of tb_first_datapath is 

-- Calculate the clock period as twice the half-period
constant cCLK_PER  : time := gCLK_HPER * 2;

component first_datapath is 
   generic (N: integer := 5);
   port(i_WA     : in std_logic_vector(N-1 downto 0);
	i_CLK    : in std_logic;
	i_RST    : in std_logic;
	i_WEN    : in std_logic;
	i_RA1    : in std_logic_vector(N-1 downto 0);
	i_RA2    : in std_logic_vector(N-1 downto 0);
	i_Immediate : in std_logic_vector((2**N) - 1 downto 0);
	ALUSrc      : in std_logic;
	nAdd_Sub    : in std_logic); 
end component;

signal s_CLK	   : std_logic;
signal s_WA	   : std_logic_vector(N-1 downto 0);
signal s_RST	   : std_logic;
signal s_WEN	   : std_logic;
signal s_RA1	   : std_logic_vector(N-1 downto 0);
signal s_RA2	   : std_logic_vector(N-1 downto 0);
signal s_Immediate : std_logic_vector(2**N-1 downto 0);
signal s_ALUSrc	   : std_logic;
signal s_nAdd_Sub  : std_logic;


begin
DUT0: first_datapath
port map (i_WA   => s_WA,
	  i_CLK  => s_CLK,
	  i_RST  => s_RST,
	  i_WEN  => s_WEN,
	  i_RA1  => s_RA1,
	  i_RA2  => s_RA2,
	  i_Immediate    => s_Immediate,
	  ALUSrc    => s_ALUSrc,
	  nAdd_Sub  => s_nAdd_Sub);


  --This first process is to setup the clock for the test bench
  --Cycle starts low then goes high
  P_CLK: process
  begin
    s_CLK <= '0';        
    wait for gCLK_HPER; 
    s_CLK <= '1';        
    wait for gCLK_HPER; 
  end process;


TEST_CASE: process
begin

--Reset values
s_WA  <= "00001";
s_RST <= '1';
s_WEN <= '0';
s_RA1 <= "00000";
s_RA2 <= "00000";
s_Immediate <= x"00000001";
s_ALUSrc <= '1';
s_nAdd_Sub <= '0';
wait for cCLK_PER;

--addi $1, $0, 1
s_WA  <= "00001";
s_RST <= '0';
s_WEN <= '1';
s_RA1 <= "00000";
s_RA2 <= "00000";
s_Immediate <= x"00000001";
s_ALUSrc <= '1';
s_nAdd_Sub <= '0';
wait for cCLK_PER;


--addi $2, $0, 2
s_WA  <= "00010";
s_RST <= '0';
s_WEN <= '1';
s_RA1 <= "00000";
s_RA2 <= "00000";
s_Immediate <= x"00000002";
s_ALUSrc <= '1';
s_nAdd_Sub <= '0';
wait for cCLK_PER;


--addi $3, $0, 3
s_WA  <= "00011";
s_RST <= '0';
s_WEN <= '1';
s_RA1 <= "00000";
s_RA2 <= "00000";
s_Immediate <= x"00000003";
s_ALUSrc <= '1';
s_nAdd_Sub <= '0';
wait for cCLK_PER;


--addi $4, $0, 4
s_WA  <= "00100";
s_RST <= '0';
s_WEN <= '1';
s_RA1 <= "00000";
s_RA2 <= "00000";
s_Immediate <= x"00000004";
s_ALUSrc <= '1';
s_nAdd_Sub <= '0';
wait for cCLK_PER;


--addi $5, $0, 5
s_WA  <= "00101";
s_RST <= '0';
s_WEN <= '1';
s_RA1 <= "00000";
s_RA2 <= "00000";
s_Immediate <= x"00000005";
s_ALUSrc <= '1';
s_nAdd_Sub <= '0';
wait for cCLK_PER;


--addi $6, $0, 6
s_WA  <= "00110";
s_RST <= '0';
s_WEN <= '1';
s_RA1 <= "00000";
s_RA2 <= "00000";
s_Immediate <= x"00000006";
s_ALUSrc <= '1';
s_nAdd_Sub <= '0';
wait for cCLK_PER;


--addi $7, $0, 7
s_WA  <= "00111";
s_RST <= '0';
s_WEN <= '1';
s_RA1 <= "00000";
s_RA2 <= "00000";
s_Immediate <= x"00000007";
s_ALUSrc <= '1';
s_nAdd_Sub <= '0';
wait for cCLK_PER;


--addi $8, $0, 8
s_WA  <= "01000";
s_RST <= '0';
s_WEN <= '1';
s_RA1 <= "00000";
s_RA2 <= "00000";
s_Immediate <= x"00000008";
s_ALUSrc <= '1';
s_nAdd_Sub <= '0';
wait for cCLK_PER;


--addi $9, $0, 9
s_WA  <= "01001";
s_RST <= '0';
s_WEN <= '1';
s_RA1 <= "00000";
s_RA2 <= "00000";
s_Immediate <= x"00000009";
s_ALUSrc <= '1';
s_nAdd_Sub <= '0';
wait for cCLK_PER;


--addi $10, $0, 10
s_WA  <= "01010";
s_RST <= '0';
s_WEN <= '1';
s_RA1 <= "00000";
s_RA2 <= "00000";
s_Immediate <= x"0000000A";
s_ALUSrc <= '1';
s_nAdd_Sub <= '0';
wait for cCLK_PER;


--add $11, $1, $2
s_WA  <= "01011";
s_RST <= '0';
s_WEN <= '1';
s_RA1 <= "00001";
s_RA2 <= "00010";
s_Immediate <= x"00000000";
s_ALUSrc <= '0';
s_nAdd_Sub <= '0';
wait for cCLK_PER;


--sub $12, $11, $3
s_WA  <= "01100";
s_RST <= '0';
s_WEN <= '1';
s_RA1 <= "01011";
s_RA2 <= "00011";
s_Immediate <= x"00000000";
s_ALUSrc <= '0';
s_nAdd_Sub <= '1';
wait for cCLK_PER;


--add $13, $12, $4
s_WA  <= "01101";
s_RST <= '0';
s_WEN <= '1';
s_RA1 <= "01100";
s_RA2 <= "00100";
s_Immediate <= x"00000000";
s_ALUSrc <= '0';
s_nAdd_Sub <= '0';
wait for cCLK_PER;


--sub $14, $13, $5
s_WA  <= "01110";
s_RST <= '0';
s_WEN <= '1';
s_RA1 <= "01101";
s_RA2 <= "00101";
s_Immediate <= x"00000000";
s_ALUSrc <= '0';
s_nAdd_Sub <= '1';
wait for cCLK_PER;


--add $15, $14, $6
s_WA  <= "01111";
s_RST <= '0';
s_WEN <= '1';
s_RA1 <= "01110";
s_RA2 <= "00110";
s_Immediate <= x"00000000";
s_ALUSrc <= '0';
s_nAdd_Sub <= '0';
wait for cCLK_PER;


--sub $16, $15, $7
s_WA  <= "10000";
s_RST <= '0';
s_WEN <= '1';
s_RA1 <= "01111";
s_RA2 <= "00111";
s_Immediate <= x"00000000";
s_ALUSrc <= '0';
s_nAdd_Sub <= '1';
wait for cCLK_PER;


--add $17, $16, $8
s_WA  <= "10001";
s_RST <= '0';
s_WEN <= '1';
s_RA1 <= "10000";
s_RA2 <= "01000";
s_Immediate <= x"00000000";
s_ALUSrc <= '0';
s_nAdd_Sub <= '0';
wait for cCLK_PER;


--sub $18, $17, $9
s_WA  <= "10010";
s_RST <= '0';
s_WEN <= '1';
s_RA1 <= "10001";
s_RA2 <= "01001";
s_Immediate <= x"00000000";
s_ALUSrc <= '0';
s_nAdd_Sub <= '1';
wait for cCLK_PER;


--add $19, $18, $10
s_WA  <= "10011";
s_RST <= '0';
s_WEN <= '1';
s_RA1 <= "10010";
s_RA2 <= "01010";
s_Immediate <= x"00000000";
s_ALUSrc <= '0';
s_nAdd_Sub <= '0';
wait for cCLK_PER;


--addi $20, $0, -35
s_WA  <= "10100";
s_RST <= '0';
s_WEN <= '1';
s_RA1 <= "00000";
s_RA2 <= "00000";
s_Immediate <= x"FFFFFFDD";
s_ALUSrc <= '1';
s_nAdd_Sub <= '0';
wait for cCLK_PER;


--add $21, $19, $20
s_WA  <= "10101";
s_RST <= '0';
s_WEN <= '1';
s_RA1 <= "10011";
s_RA2 <= "10100";
s_Immediate <= x"00000000";
s_ALUSrc <= '0';
s_nAdd_Sub <= '0';
wait for cCLK_PER;


end process;



end structure;