--Benjamin Towle
--9/25/2023
--second_datapath.vhd
--File contains elements of a simple MIPS like datapath with the register file and ALU as the components
library IEEE;
use IEEE.std_logic_1164.all;

entity second_datapath is 
  generic (N: integer := 5);
   port(i_WA     : in std_logic_vector(N-1 downto 0);
	i_CLK    : in std_logic;
	i_RST    : in std_logic;
	i_WEN    : in std_logic;
	i_RA1    : in std_logic_vector(N-1 downto 0);
	i_RA2    : in std_logic_vector(N-1 downto 0);
	i_Immediate : in std_logic_vector(15 downto 0);
	ALUSrc      : in std_logic;
	nAdd_Sub    : in std_logic;
	ext_ctl     : in std_logic;
	mem_ctl     : in std_logic;
	mem_WE      : in std_logic);   
end second_datapath; 


architecture structure of second_datapath is 

--ALU
component nBitAddSub is
  port(input_A, input_B  : in std_logic_vector(2**N-1 downto 0);
     i_Immediate       : in std_logic_vector(2**N-1 downto 0);
     nAdd_Sub    : in std_logic;
     ALUSrc      : in std_logic; 
     output_S    : out std_logic_vector(2**N-1 downto 0);
     output_C    : out std_logic);
 
end component;


--Reg File
component nBitRegFile is 
 port(  i_WA     : in std_logic_vector(N-1 downto 0);
	i_CLK    : in std_logic;
	i_RST    : in std_logic;
	i_DATA   : in std_logic_vector((2**N) - 1 downto 0);
	i_WEN    : in std_logic;
	i_RA1    : in std_logic_vector(N-1 downto 0);
	i_RA2    : in std_logic_vector(N-1 downto 0);
	o_1      : out std_logic_vector((2**N) - 1 downto 0);
	o_2      : out std_logic_vector((2**N) - 1 downto 0));   -- Data value output
end component;



--Sign/Zero Extension
component bit_width_extender is 
 port(  i_Imm16   : in std_logic_vector(15 downto 0);
	i_ctl     : in std_logic;
	o_Imm32   : out std_logic_vector(31 downto 0));  
	
end component;


--Memory module
component mem is 
generic 
(
  DATA_WIDTH : natural := 32;
  ADDR_WIDTH : natural := 10
);

port (clk		: in std_logic;
      addr	        : in std_logic_vector((ADDR_WIDTH-1) downto 0);
      data	        : in std_logic_vector((DATA_WIDTH-1) downto 0);
      we		: in std_logic := '1';
      q		        : out std_logic_vector((DATA_WIDTH -1) downto 0)
);

end component;

component mux2t1_N is
  port (i_S : in std_logic;
        i_D0 : in std_logic_vector(31 downto 0);
        i_D1 : in std_logic_vector(31 downto 0);
        o_O  : out std_logic_vector(31 downto 0));
end component;

signal s_RS   : std_logic_vector(2**N-1 downto 0); 
signal s_RT   : std_logic_vector(2**N-1 downto 0);
signal s_RD   : std_logic_vector(2**N-1 downto 0); --the data that is to be written to the specified register
signal dummy  : std_logic;  --since the carry out bit is not used by the datapath, we only need to assign it to a random signal
signal mem_out : std_logic_vector(31 downto 0);
signal ext_Imm  : std_logic_vector(31 downto 0);
signal m_ctl_result : std_logic_vector(31 downto 0); 


begin
G_RegFile : nBitRegFile
port map(i_WA       => i_WA,
	 i_CLK      => i_CLK,
	 i_RST      => i_RST,
	 i_DATA     => m_ctl_result,  
	 i_WEN      => i_WEN,
	 i_RA1      => i_RA1,
	 i_RA2      => i_RA2,
	 o_1        => s_RS,
	 o_2        => s_RT);

G_ALU: nBitAddSub
port map(input_A     => s_RS, 
	 input_B     => s_RT,
	 i_Immediate => ext_Imm, 
	 ALUSrc      => ALUSrc,
	 nAdd_Sub    => nAdd_Sub,
	 output_S   => s_RD,   
	 output_C   => dummy); 

N_Bit_Mux: mux2t1_N     --if ctl == 1, then the memory output is fed back into data (should be one when MIPS instruction is a load/store)
port map(i_S      => mem_ctl,
	 i_D0     => s_RD,
	 i_D1     => mem_out,
	 o_O      => m_ctl_result);

G_MEM: mem 
port map(clk    => i_CLK,
	 addr   => s_RD(11 downto 2), 
	 data   => s_RT,
	 we     => mem_WE,
	 q      => mem_out);

G_Ext: bit_width_extender
port map(i_Imm16  => i_Immediate,
	 i_ctl    => ext_ctl,
	 o_Imm32  => ext_Imm);
	 

end structure;

