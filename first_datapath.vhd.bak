--Benjamin Towle
--9/19/2023
--first_datapath.vhd
--File contains elements of a simple MIPS like datapath with the register file and ALU as the components
library IEEE;
use IEEE.std_logic_1164.all;

entity first_datapath is 
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
end first_datapath; 

architecture structure of first_datapath is 

--ALU
component nBitAddSub is
  port(input_A, input_B  : in std_logic_vector(2**N-1 downto 0);
     i_Immediate       : in std_logic_vector(2**N-1 downto 0);
     nAdd_Sub    : in std_logic;
     ALUSrc      : in std_logic; 
     output_S    : out std_logic_vector(2**N-1 downto 0);
     output_C    : out std_logic);
 
end component;


component nBitRegFile is 
 port(i_WA     : in std_logic_vector(N-1 downto 0);
	i_CLK    : in std_logic;
	i_RST    : in std_logic;
	i_DATA   : in std_logic_vector((2**N) - 1 downto 0);
	i_WEN    : in std_logic;
	i_RA1    : in std_logic_vector(N-1 downto 0);
	i_RA2    : in std_logic_vector(N-1 downto 0);
	o_1      : out std_logic_vector((2**N) - 1 downto 0);
	o_2      : out std_logic_vector((2**N) - 1 downto 0));   -- Data value output
end component;


signal s_RS   : std_logic_vector(2**N-1 downto 0); 
signal s_RT   : std_logic_vector(2**N-1 downto 0);
signal s_RD   : std_logic_vector(2**N-1 downto 0); --the data that is to be written to the specified register
signal dummy  : std_logic;  --since the carry out bit is not used by the datapath, we only need to assign it to a random signal

begin 
G_RegFile : nBitRegFile
port map(i_WA       => i_WA,
	 i_CLK      => i_CLK,
	 i_RST      => i_RST,
	 i_DATA     => s_RD,
	 i_WEN      => i_WEN,
	 i_RA1      => i_RA1,
	 i_RA2      => i_RA2,
	 o_1        => s_RS,
	 o_2        => s_RT);


G_ALU: nBitAddSub
port map(input_A     => s_RS, 
	 input_B     => s_RT,
	 i_Immediate => i_Immediate,
	 ALUSrc      => ALUSrc,
	 nAdd_Sub    => nAdd_Sub,
	 output_S   => s_RD,
	 output_C   => dummy); 




end structure; 