-------------------------------------------------------------------------
-- Benjamin Towle
-- Iowa State University
-------------------------------------------------------------------------
-- tb_nBitRegister.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for the nBitRegister unit.
--              
-- 9/11/2023
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.textio.all;  

entity tb_nBitRegister is 
   --Method for instantiating multiple generic statements in one entity
   generic (
    N : integer := 32;
    gCLK_HPER : time := 50 ns);
end tb_nBitRegister;



architecture behavior of tb_nBitRegister is
-- Calculate the clock period as twice the half-period
constant cCLK_PER  : time := gCLK_HPER * 2;


component nBitRegister is 
 port(  i_CLK        : in std_logic;                          -- Clock input
        i_RST        : in std_logic;                          -- Reset input
        i_WE         : in std_logic;                          -- Write enable input
        i_D          : in std_logic_vector(N-1 downto 0);     -- Data value input
        o_Q          : out std_logic_vector(N-1 downto 0));   -- Data value output
end component;

signal s_i_CLK  : std_logic;
signal s_i_RST  : std_logic;
signal s_i_WE  : std_logic;
signal s_i_D  : std_logic_vector(N-1 downto 0);
signal s_o_Q  : std_logic_vector(N-1 downto 0);

begin 
DUT0: nBitRegister
port map(i_CLK     => s_i_CLK,
	 i_RST    => s_i_RST,
	 i_WE    => s_i_WE,
	 i_D     => s_i_D,
	 o_Q     => s_o_Q);

  --This first process is to setup the clock for the test bench
  --Cycle starts low then goes high
  P_CLK: process
  begin
    s_i_CLK <= '0';        
    wait for gCLK_HPER; 
    s_i_CLK <= '1';        
    wait for gCLK_HPER; 
  end process;

  -- Testbench process  
  P_TB: process
  begin
    -- Reset the FF
    s_i_RST <= '1';
    s_i_WE  <= '0';
    s_i_D   <= x"00000000";
    wait for cCLK_PER;

    -- Store '50'
    s_i_RST <= '0';
    s_i_WE  <= '1';
    s_i_D   <= x"00000032";
    wait for cCLK_PER;  

    -- Keep '50'
    s_i_RST <= '0';
    s_i_WE  <= '0';
    s_i_D   <= x"00000000";
    wait for cCLK_PER;  

    -- Store '76'    
    s_i_RST <= '0';
    s_i_WE  <= '1';
    s_i_D   <= x"0000004C";
    wait for cCLK_PER;  

    -- Keep '76'
    s_i_RST <= '0';
    s_i_WE  <= '0';
    s_i_D   <= x"0000004C";
    wait for cCLK_PER;  

    wait;
  end process;






end behavior;

