--Benjamin Towle & Lalith Vattyam
--11/1/2023
--reg_IF_ID.vhd
--File contains elements of an N bit register with dffg.vhd as a component

library IEEE;
use IEEE.std_logic_1164.all;

entity reg_IF_ID is 
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

end reg_IF_ID;

architecture structure of reg_IF_ID is

 component dffg is 
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic;     -- Data value input
       o_Q          : out std_logic);   -- Data value output
 end component;

 component nBitRegister is 
  generic (N: integer := 32);
   port(i_CLK        : in std_logic;                          -- Clock input
        i_RST        : in std_logic;                          -- Reset input
        i_WE         : in std_logic;                          -- Write enable input
        i_D          : in std_logic_vector(N-1 downto 0);     -- Data value input
        o_Q          : out std_logic_vector(N-1 downto 0));   -- Data value output
 end component;

 component pcRegister is 
  port(i_CLK        : in std_logic;                          -- Clock input
       i_RST        : in std_logic;                          -- Reset input
       i_WE         : in std_logic;                          -- Write enable input
       i_D          : in std_logic_vector(31 downto 0);     -- Data value input
       o_Q          : out std_logic_vector(31 downto 0));   -- Data value output
 end component; 

 component mux2t1_N is  
     generic(N : integer := 32);
     port(i_S          : in std_logic;
          i_D0         : in std_logic_vector(N-1 downto 0);
          i_D1         : in std_logic_vector(N-1 downto 0);
          o_O          : out std_logic_vector(N-1 downto 0));
 end component;
  

 signal s_PCShift    : std_logic_vector(31 downto 0);
 signal s_Inst       : std_logic_vector(31 downto 0);



begin

--G_Register: for i in 0 to 31 generate
--DFF: dffg
-- port map(  i_CLK   => i_CLK,
--            i_RST   => i_RST,
--            i_WE    => i_WE,
--            i_D     => i_D(i),
--            o_Q     => o_Q(i));

--end generate G_Register;

RegPCShift: pcRegister 
  port map(i_CLK	=> i_CLK,
	   i_RST 	=> i_RST,
   	   i_WE		=> i_WE,
	   i_D		=> s_PCShift,
	   o_Q		=> o_PCShift);

MUX_PCShift: mux2t1_N
     generic map(N => 32)
     port map(i_S          => i_Flush,
          i_D0         => i_PCShift,
          i_D1         => x"00000000",
          o_O          => s_PCShift);


 RegInstr: nBitRegister
   generic map(N => 32) 
   port map(i_CLK	=> i_CLK,
	    i_RST 	=> i_RST,
   	    i_WE	=> i_WE,
	    i_D		=> s_Inst,
	    o_Q		=> o_Inst);
 
MUX_Instr: mux2t1_N
     generic map(N => 32)
     port map(i_S          => i_Flush,
          i_D0         => i_Inst,
          i_D1         => x"00000000",
          o_O          => s_Inst);

end structure;
