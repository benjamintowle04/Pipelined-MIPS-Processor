--Benjamin Towle
--9/11/2023
--nBitDecoder.vhd
--File contains elements of a 5 to 32 decoder which is to be used to implement a register file

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity nBitDecoder is 
   generic (N: integer := 5);
   port(i_A  : in std_logic_vector(N-1 downto 0);
	o_Q  : out std_logic_vector((2**N) - 1 downto 0));
end nBitDecoder;

architecture dataflow of nBitDecoder is
begin

G_NBit_Decoder: for i in 0 to (2**N)-1 generate
  o_Q(i) <= '1' when (i_A = i) else 
	    '0';
end generate G_NBit_Decoder;

end dataflow;

