library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;
library std;
use std.env.all;
use std.textio.all;

entity tb_pcRegister is
  generic(N: integer := 32; gCLK_HPER: time := 10ns);
end tb_pcRegister;

architecture mixed of tb_pcRegister is

   signal CLK, reset	: std_logic := '0';
   signal s_WE		: std_logic;
   signal s_D		: std_logic_vector(N-1 downto 0);
   signal s_Q		: std_logic_vector(N-1 downto 0);

   component pcRegister is 
     port(i_CLK        : in std_logic;                          -- Clock input
       	  i_RST        : in std_logic;                          -- Reset input
       	  i_WE         : in std_logic;                          -- Write enable input
       	  i_D          : in std_logic_vector(N-1 downto 0);     -- Data value input
       	  o_Q          : out std_logic_vector(N-1 downto 0));   -- Data value output     
   end component;

begin 
   DUT0: pcRegister 
   generic map(N)
   port map(i_CLK	=> CLK,
	    i_RST	=> reset,
	    i_WE	=> s_WE,
	    i_D		=> s_D,
	    o_Q		=> s_Q);

   P_CLK: process 
   begin
      CLK <= '1';
      wait for gCLK_HPER;
      CLK <= '0';
      wait for gCLK_HPER;
   end process;

   P_TEST_CASES: process
   begin 
      wait for gCLK_HPER/2;
      reset <= '0';
      s_WE  <= '1';
      s_D   <= x"FFFFFFFF";
      wait for gCLK_HPER*2;    

      s_WE  <= '0';
      s_D   <= x"00000000";
      wait for gCLK_HPER*2; 

      s_WE  <= '1';
      s_D   <= x"F0F0F0F0";
      wait for gCLK_HPER*2; 

      s_WE  <= '1';
      s_D   <= x"0F0F0F0F";
      wait for gCLK_HPER*2; 

      reset <= '1';
      wait for gCLK_HPER*2;
      wait for gCLK_HPER*2;
   end process;
end mixed;	