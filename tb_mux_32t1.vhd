-------------------------------------------------------------------------
-- Benjamin Towle
-- Iowa State University
-------------------------------------------------------------------------
-- tb_mux_32t1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for the 32 bit 32 to 1 multiplexor.
--              
-- 9/12/2023
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.textio.all;             -- For basic I/O

entity tb_mux_32t1 is
 generic(N : integer := 5);
end tb_mux_32t1;

architecture structure of tb_mux_32t1 is

component mux_32t1 is
 port(i_S          : in std_logic_vector(N-1 downto 0);

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

--Maps to each input/output of the 32 to 1 mux component
signal s_i_S : std_logic_vector(N-1 downto 0);
signal s_i_D0  : std_logic_vector((2**N)-1 downto 0);
signal s_i_D1   : std_logic_vector((2**N)-1 downto 0);
signal s_i_D2  : std_logic_vector((2**N)-1 downto 0);
signal s_i_D3   : std_logic_vector((2**N)-1 downto 0);
signal s_i_D4   : std_logic_vector((2**N)-1 downto 0);
signal s_i_D5  : std_logic_vector((2**N)-1 downto 0);
signal s_i_D6   : std_logic_vector((2**N)-1 downto 0);
signal s_i_D7  : std_logic_vector((2**N)-1 downto 0);
signal s_i_D8   : std_logic_vector((2**N)-1 downto 0);
signal s_i_D9  : std_logic_vector((2**N)-1 downto 0);
signal s_i_D10   : std_logic_vector((2**N)-1 downto 0);
signal s_i_D11  : std_logic_vector((2**N)-1 downto 0);
signal s_i_D12   : std_logic_vector((2**N)-1 downto 0);
signal s_i_D13  : std_logic_vector((2**N)-1 downto 0);
signal s_i_D14   : std_logic_vector((2**N)-1 downto 0);
signal s_i_D15  : std_logic_vector((2**N)-1 downto 0);
signal s_i_D16   : std_logic_vector((2**N)-1 downto 0);
signal s_i_D17  : std_logic_vector((2**N)-1 downto 0);
signal s_i_D18   : std_logic_vector((2**N)-1 downto 0);
signal s_i_D19  : std_logic_vector((2**N)-1 downto 0);
signal s_i_D20   : std_logic_vector((2**N)-1 downto 0);
signal s_i_D21  : std_logic_vector((2**N)-1 downto 0);
signal s_i_D22   : std_logic_vector((2**N)-1 downto 0);
signal s_i_D23  : std_logic_vector((2**N)-1 downto 0);
signal s_i_D24   : std_logic_vector((2**N)-1 downto 0);
signal s_i_D25  : std_logic_vector((2**N)-1 downto 0);
signal s_i_D26   : std_logic_vector((2**N)-1 downto 0);
signal s_i_D27  : std_logic_vector((2**N)-1 downto 0);
signal s_i_D28   : std_logic_vector((2**N)-1 downto 0);
signal s_i_D29  : std_logic_vector((2**N)-1 downto 0);
signal s_i_D30   : std_logic_vector((2**N)-1 downto 0);
signal s_i_D31  : std_logic_vector((2**N)-1 downto 0);
signal s_o_O   : std_logic_vector((2**N)-1 downto 0);

begin
DUT0: mux_32t1
port map(i_S      => s_i_S,

	 i_D0     => s_i_D0,
	 i_D1     => s_i_D1,
 	 i_D2     => s_i_D2,
	 i_D3     => s_i_D3,
	 i_D4     => s_i_D4,
	 i_D5     => s_i_D5,
 	 i_D6     => s_i_D6,
	 i_D7     => s_i_D7,
	 i_D8     => s_i_D8,
	 i_D9     => s_i_D9,
	 i_D10    => s_i_D10,
 	 i_D11    => s_i_D11,
	 i_D12    => s_i_D12,
	 i_D13    => s_i_D13,
	 i_D14    => s_i_D14,
 	 i_D15    => s_i_D15,
	 i_D16    => s_i_D16,
	 i_D17    => s_i_D17,
	 i_D18    => s_i_D18,
 	 i_D19    => s_i_D19,
	 i_D20    => s_i_D20,
	 i_D21    => s_i_D21,
	 i_D22    => s_i_D22,
 	 i_D23    => s_i_D23,
	 i_D24    => s_i_D24,
	 i_D25    => s_i_D25,
	 i_D26    => s_i_D26,
 	 i_D27    => s_i_D27,
	 i_D28    => s_i_D28,
	 i_D29    => s_i_D29,
	 i_D30    => s_i_D30,
 	 i_D31    => s_i_D31,
	
	 o_O      => s_o_O);



TEST_CASE_1: process
begin
 --To make testing simpler, I am assigning hex values that look identical to the variable names
 s_i_S <= "11100";

 s_i_D0  <= x"000000D0";  
 s_i_D1  <= x"000000D1";
 s_i_D2  <= x"000000D2";  
 s_i_D3  <= x"000000D3";
 s_i_D4  <= x"000000D4";  
 s_i_D5  <= x"000000D5";
 s_i_D6  <= x"000000D6";  
 s_i_D7  <= x"000000D7";
 s_i_D8  <= x"000000D8";  
 s_i_D9  <= x"000000D9";
 s_i_D10 <= x"00000D10";  
 s_i_D11 <= x"00000D11";
 s_i_D12 <= x"00000D12";  
 s_i_D13 <= x"00000D13";
 s_i_D14 <= x"00000D14";  
 s_i_D15 <= x"00000D15";
 s_i_D16 <= x"00000D16";  
 s_i_D17 <= x"00000D17";
 s_i_D18 <= x"00000D18";  
 s_i_D19 <= x"00000D19";
 s_i_D20 <= x"00000D20";  
 s_i_D21 <= x"00000D21";
 s_i_D22 <= x"00000D22";  
 s_i_D23 <= x"00000D23";
 s_i_D24 <= x"00000D24";  
 s_i_D25 <= x"00000D25";
 s_i_D26 <= x"00000D26";  
 s_i_D27 <= x"00000D27";
 s_i_D28 <= x"00000D28";  
 s_i_D29 <= x"00000D29";
 s_i_D30 <= x"00000D30";  
 s_i_D31 <= x"00000D31";
wait for 100 ns;  --Expect o_O to take on the D28 input

s_i_S <= "10101";
wait for 100 ns; --Expect o_O to take on the D21 input

s_i_S <= "00000";
wait for 100 ns; --Expect o_O to take on the D0 input

s_i_S <= "11111";
wait for 100 ns; --Expect o_O to take on the D31 input


end process;


end structure;