-------------------------------------------------------------------------
-- Benjamin Towle
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_TPU_MV_Element.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for the TPU MAC unit.
--              
-- 01/03/2020 by H3::Design created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

entity tb_mux2t1 is
end tb_mux2t1;

architecture structure of tb_mux2t1 is
component mux2t1_dataflow is
  port (i_S : in std_logic;
        i_D0 : in std_logic;
        i_D1 : in std_logic;
        o_O : out std_logic);
end component;


signal s_i_S : std_logic;
signal s_i_D0  : std_logic;
signal s_i_D1   : std_logic;
signal s_o_O   : std_logic;


begin
DUT0: mux2t1_dataflow
port map(i_S     => s_i_S,
	 i_D0    => s_i_D0,
	 i_D1    => s_i_D1,
	 o_O     => s_o_O);



TEST_CASE: process
begin
   s_i_S <= '0', '1' after 40 ns;
   s_i_D0 <= '0', '1' after 20 ns, '0' after 40 ns, '1' after 60 ns;
   s_i_D1 <= '0', '1' after 10 ns, '0' after 20 ns, '1' after 30 ns, '0' after 40 ns, '1' after 50 ns, '0' after 60 ns, '1' after 70 ns;
wait for 300 ns;
end process;

end structure; 