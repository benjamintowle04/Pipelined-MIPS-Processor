--Benjamin Towle
--9/14/2023
--nBitRegFile.vhd
--File contains elements of an N bit register file with nBitRegister.vhd, mux_32t1.vhd, and nBitDecoder.vhd as the components

library IEEE;
use IEEE.std_logic_1164.all;

entity nBitRegFile is 
   generic (N: integer := 5);
   port(i_WA     : in std_logic_vector(N-1 downto 0);
	i_CLK    : in std_logic;
	i_RST    : in std_logic;
	i_DATA   : in std_logic_vector((2**N) - 1 downto 0);
	i_WEN    : in std_logic;
	i_RA1    : in std_logic_vector(N-1 downto 0);
	i_RA2    : in std_logic_vector(N-1 downto 0);
	o_1      : out std_logic_vector((2**N) - 1 downto 0);
	o_2      : out std_logic_vector((2**N) - 1 downto 0));   -- Data value output

end nBitRegFile;



architecture structure of nBitRegFile is 

component nBitDecoder is 
   port(i_A  : in std_logic_vector(N-1 downto 0);
	o_Q  : out std_logic_vector((2**N) - 1 downto 0));
end component;


component nBitRegister is 
   port(i_CLK        : in std_logic;                          -- Clock input
        i_RST        : in std_logic;                          -- Reset input
        i_WE         : in std_logic;                          -- Write enable input
        i_D          : in std_logic_vector((2**N)-1 downto 0);     -- Data value input
        o_Q          : out std_logic_vector((2**N)-1 downto 0));   -- Data value output
end component; 


component mux_32t1 is
 
port( i_S          : in std_logic_vector(N-1 downto 0);

      i_D0         : in std_logic_vector((2**N)-1 downto 0);
      i_D1         : in std_logic_vector((2**N)-1 downto 0);
      i_D2         : in std_logic_vector((2**N)-1 downto 0);
      i_D3         : in std_logic_vector((2**N)-1 downto 0);
      i_D4         : in std_logic_vector((2**N)-1 downto 0);
      i_D5         : in std_logic_vector((2**N)-1 downto 0);
      i_D6         : in std_logic_vector((2**N)-1 downto 0);
      i_D7         : in std_logic_vector((2**N)-1 downto 0);
      i_D8         : in std_logic_vector((2**N)-1 downto 0);
      i_D9         : in std_logic_vector((2**N)-1 downto 0);
      i_D10        : in std_logic_vector((2**N)-1 downto 0);
      i_D11        : in std_logic_vector((2**N)-1 downto 0);
      i_D12        : in std_logic_vector((2**N)-1 downto 0);
      i_D13        : in std_logic_vector((2**N)-1 downto 0);
      i_D14        : in std_logic_vector((2**N)-1 downto 0);
      i_D15        : in std_logic_vector((2**N)-1 downto 0);
      i_D16        : in std_logic_vector((2**N)-1 downto 0);
      i_D17        : in std_logic_vector((2**N)-1 downto 0);
      i_D18        : in std_logic_vector((2**N)-1 downto 0);
      i_D19        : in std_logic_vector((2**N)-1 downto 0);
      i_D20        : in std_logic_vector((2**N)-1 downto 0);
      i_D21        : in std_logic_vector((2**N)-1 downto 0);
      i_D22        : in std_logic_vector((2**N)-1 downto 0);
      i_D23        : in std_logic_vector((2**N)-1 downto 0);
      i_D24        : in std_logic_vector((2**N)-1 downto 0);
      i_D25        : in std_logic_vector((2**N)-1 downto 0);
      i_D26        : in std_logic_vector((2**N)-1 downto 0);
      i_D27        : in std_logic_vector((2**N)-1 downto 0);
      i_D28        : in std_logic_vector((2**N)-1 downto 0);
      i_D29        : in std_logic_vector((2**N)-1 downto 0);
      i_D30        : in std_logic_vector((2**N)-1 downto 0);
      i_D31        : in std_logic_vector((2**N)-1 downto 0);

      o_O          : out std_logic_vector((2**N)-1  downto 0));
end component; 


component andg2 is 
  port(i_A         : in std_logic;
       i_B         : in std_logic;
       o_F         : out std_logic);
end component;


signal s_W         : std_logic_vector((2**N)-1 downto 0); --Decoder outputs to and gates
signal and_results : std_logic_vector((2**N)-1 downto 0); --Outputs to be used as write enable inputs for each register

type registers is array(0 to 31) of std_logic_vector(31 downto 0); 
signal s_Registers : registers;


begin 

G_DECODE: nBitDecoder 
  port map (i_A  => i_WA,
	    o_Q  => s_W);


GENERATE_ANDS: for i in 0 to (2**N)-1 generate
G_ANDS: andg2
  port map (i_A  => s_W(i),
	    i_B  => i_WEN,
	    o_F  => and_results(i));

end generate GENERATE_ANDS;

--Special case for the $0 register
G_REG_0: nBitRegister
port map (i_CLK  => i_CLK,
	  i_RST  => i_RST,
	  i_WE   => '1',
	  i_D    => x"00000000",
	  o_Q    => s_Registers(0));


GENERATE_REG: for i in 1 to (2**N)-1 generate
G_REG: nBitRegister
 port map (i_CLK  => i_CLK,
	   i_RST  => i_RST,
	   i_WE   => and_results(i),
	   i_D    => i_DATA,
	   o_Q    => s_Registers(i));

end generate GENERATE_REG;


G_MUX1: mux_32t1
port map (i_S  => i_RA1,
	  
	  i_D0 => s_Registers(0),
	  i_D1 => s_Registers(1),
	  i_D2 => s_Registers(2),
	  i_D3 => s_Registers(3),
	  i_D4 => s_Registers(4),
	  i_D5 => s_Registers(5),
	  i_D6 => s_Registers(6),
	  i_D7 => s_Registers(7),
	  i_D8 => s_Registers(8),
	  i_D9 => s_Registers(9),
	  i_D10 => s_Registers(10),
	  i_D11 => s_Registers(11),
	  i_D12 => s_Registers(12),
	  i_D13 => s_Registers(13),
	  i_D14 => s_Registers(14),
	  i_D15 => s_Registers(15),
	  i_D16 => s_Registers(16),
	  i_D17 => s_Registers(17),
	  i_D18 => s_Registers(18),
	  i_D19 => s_Registers(19),
	  i_D20 => s_Registers(20),
	  i_D21 => s_Registers(21),
	  i_D22 => s_Registers(22),
	  i_D23 => s_Registers(23),
	  i_D24 => s_Registers(24),
	  i_D25 => s_Registers(25),
	  i_D26 => s_Registers(26),
	  i_D27 => s_Registers(27),
	  i_D28 => s_Registers(28),
	  i_D29 => s_Registers(29),
	  i_D30 => s_Registers(30),
	  i_D31 => s_Registers(31),

	  o_O  => o_1); 



G_MUX2: mux_32t1
port map (i_S  => i_RA2,
	  
	  i_D0 => s_Registers(0),
	  i_D1 => s_Registers(1),
	  i_D2 => s_Registers(2),
	  i_D3 => s_Registers(3),
	  i_D4 => s_Registers(4),
	  i_D5 => s_Registers(5),
	  i_D6 => s_Registers(6),
	  i_D7 => s_Registers(7),
	  i_D8 => s_Registers(8),
	  i_D9 => s_Registers(9),
	  i_D10 => s_Registers(10),
	  i_D11 => s_Registers(11),
	  i_D12 => s_Registers(12),
	  i_D13 => s_Registers(13),
	  i_D14 => s_Registers(14),
	  i_D15 => s_Registers(15),
	  i_D16 => s_Registers(16),
	  i_D17 => s_Registers(17),
	  i_D18 => s_Registers(18),
	  i_D19 => s_Registers(19),
	  i_D20 => s_Registers(20),
	  i_D21 => s_Registers(21),
	  i_D22 => s_Registers(22),
	  i_D23 => s_Registers(23),
	  i_D24 => s_Registers(24),
	  i_D25 => s_Registers(25),
	  i_D26 => s_Registers(26),
	  i_D27 => s_Registers(27),
	  i_D28 => s_Registers(28),
	  i_D29 => s_Registers(29),
	  i_D30 => s_Registers(30),
	  i_D31 => s_Registers(31),

	  o_O  => o_2); 



end structure;