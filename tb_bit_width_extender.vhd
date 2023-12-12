-------------------------------------------------------------------------
-- Benjamin Towle
-- Iowa State University
-------------------------------------------------------------------------
-- tb_bit_width_extender.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for 16 bit to 32 bit extender module
--              
-- 9/12/2023
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.textio.all;             -- For basic I/O

entity tb_bit_width_extender is 

end tb_bit_width_extender;

architecture structure of tb_bit_width_extender is 

component bit_width_extender is 
    port (i_Imm16   :  in std_logic_vector(15 downto 0);
	  i_ctl     :  in std_logic;
	  o_Imm32   :  out std_logic_vector(31 downto 0));
end component;

signal s_Imm16  : std_logic_vector(15 downto 0);
signal s_ctl    : std_logic;
signal s_Imm32  : std_logic_vector(31 downto 0);

begin
DUT0: bit_width_extender

port map (i_Imm16  => s_Imm16,
	  i_ctl    => s_ctl,
	  o_Imm32  => s_Imm32);


TEST_CASES: process
begin

--Expect 16 bit extension to be all 1's
s_Imm16 <= x"8000";
s_ctl   <= '1';
wait for 10 ns;

--Expect a 16 bit sign extension of all 0's
s_Imm16 <= x"0001";
s_ctl <= '1';
wait for 10 ns;

--Expect a 16 bit zero extension of all 0's
s_Imm16 <= x"0000"; 
s_ctl <= '0';
wait for 10 ns;


--Expect a 16 bit zero extension of all 0's
s_Imm16 <= x"FFFF"; 
s_ctl <= '0';
wait for 10 ns;
end process;


end structure;