
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.all;


entity tb_reg_EX_MEM is
  generic(gCLK_HPER   : time := 10 ns);
end tb_reg_EX_MEM;

architecture structural of tb_reg_EX_MEM is

component reg_EX_MEM is
    port(i_CLK        : in std_logic;                          -- Clock input
        i_RST        : in std_logic;                          -- Reset input
        i_WE         : in std_logic;                          -- Write enable input

    --INPUTS
	    --Control signals used by the MEM stage (input)
        i_memWr      : in std_logic;

        --Control signals forwarded to WB stage (input)
        i_memToReg   : in std_logic;
        i_jal        : in std_logic;
        i_regDst     : in std_logic;
        i_halt       : in std_logic;
        i_regWr      : in std_logic;

        --32-bit and 3-bit inputs
        i_PC_Incremented  : in std_logic_vector(31 downto 0);
        i_RDaddr          : in std_logic_vector(3 downto 0);
        i_RTaddr          : in std_logic_vector(3 downto 0);
        i_RTdata          : in std_logic_vector(31 downto 0); 
        i_ALUResult       : in std_logic_vector(31 downto 0);

    --OUTPUTS
        --Control signals used by the MEM stage (output)
        o_memWr      : out std_logic;

        --Control signals forwarded to WB stage (output)
        o_memToReg   : out std_logic;
        o_jal        : out std_logic;
        o_regDst     : out std_logic;
        o_halt       : out std_logic;
        o_regWr      : out std_logic;

        --32-bit and 4-bit outputs
        o_PC_Incremented  : out std_logic_vector(31 downto 0);
        o_RDaddr          : out std_logic_vector(3 downto 0);
        o_RTaddr          : out std_logic_vector(3 downto 0); 
        o_RTdata          : out std_logic_vector(31 downto 0);  
        o_ALUResult       : out std_logic_vector(31 downto 0));
end component;

signal CLK : std_logic := '0';

-- TODO: change input and output signals as needed.
signal s_i_shamt    : std_logic_vector(4 downto 0) := (others => '0');

  
signal s_i_RST        : std_logic := '0'; 
signal s_i_WE         : std_logic := '0';  
signal s_i_memWr      : std_logic := '0';
signal s_i_memToReg   : std_logic := '0';
signal s_i_jal        : std_logic := '0';
signal s_i_regDst     : std_logic := '0';
signal s_i_halt       : std_logic := '0';
signal s_i_regWr      : std_logic := '0';
signal s_i_PC_Incremented  : std_logic_vector(31 downto 0) := (others => '0');
signal s_i_RDaddr          : std_logic_vector(3 downto 0) := (others => '0');
signal s_i_RTaddr          : std_logic_vector(3 downto 0) := (others => '0');
signal s_i_RTdata          : std_logic_vector(31 downto 0) := (others => '0'); 
signal s_i_ALUResult       : std_logic_vector(31 downto 0) := (others => '0');
signal s_o_memWr      : std_logic := '0';
signal s_o_memToReg   : std_logic := '0';
signal s_o_jal        : std_logic := '0';
signal s_o_regDst     : std_logic := '0';
signal s_o_halt       : std_logic := '0';
signal s_o_regWr      : std_logic := '0';
signal s_o_PC_Incremented  : std_logic_vector(31 downto 0) := (others => '0');
signal s_o_RDaddr          : std_logic_vector(3 downto 0) := (others => '0');
signal s_o_RTaddr          : std_logic_vector(3 downto 0) := (others => '0'); 
signal s_o_RTdata          : std_logic_vector(31 downto 0) := (others => '0');  
signal s_o_ALUResult       : std_logic_vector(31 downto 0) := (others => '0');

begin

  DUT0: reg_EX_MEM
  port map(
    i_CLK => CLK,
    i_RST => s_i_RST,
    i_WE => s_i_WE,
    i_memWr => s_i_memWr,
    i_memToReg => s_i_memToReg,
    i_jal => s_i_jal,
    i_regDst => s_i_regDst,
    i_halt => s_i_halt,
    i_regWr => s_i_regWr,
    i_PC_Incremented => s_i_PC_Incremented,
    i_RDaddr => s_i_RDaddr,
    i_RTaddr => s_i_RTaddr,
    i_RTdata => s_i_RTdata,
    i_ALUResult => s_i_ALUResult,
    o_memWr => s_o_memWr,
    o_memToReg => s_o_memToReg,
    o_jal => s_o_jal,
    o_regDst => s_o_regDst,
    o_halt => s_o_halt,
    o_regWr => s_o_regWr,
    o_PC_Incremented => s_o_PC_Incremented,
    o_RDaddr => s_o_RDaddr,
    o_RTaddr => s_o_RTaddr,
    o_RTdata => s_o_RTdata,
    o_ALUResult => s_o_ALUResult
	);
  
  --This first process is to setup the clock for the test bench
  P_CLK: process
  begin
    CLK <= '1';         -- clock starts at 1
    wait for gCLK_HPER; -- after half a cycle
    CLK <= '0';         -- clock becomes a 0 (negative edge)
    wait for gCLK_HPER; -- after half a cycle, process begins evaluation again
  end process;

  
  P_TC: process
  begin
    wait for gCLK_HPER*3;

	for i in 0 to 10 loop 
		s_i_shamt <= std_logic_vector(to_unsigned(i, s_i_shamt'length));
        s_i_RST <= '0';
        s_i_WE <= '1';
        s_i_memWr <= '0';
        s_i_memToReg <= '0';
        s_i_jal <= '0';
        s_i_regDst <= '0';
        s_i_halt <= '0';
        s_i_regWr <= '0';
        s_i_PC_Incremented <= std_logic_vector(to_unsigned(i, s_i_PC_Incremented'length));
        s_i_RDaddr <= std_logic_vector(to_unsigned(i + 1, s_i_RDaddr'length));
        s_i_RTaddr <= std_logic_vector(to_unsigned(i + 2, s_i_RTaddr'length));
        s_i_RTdata <= std_logic_vector(to_unsigned(i + 3, s_i_RTdata'length));
        s_i_ALUResult <= std_logic_vector(to_unsigned(i + 4, s_i_ALUResult'length));
		wait for gCLK_HPER*2;
	end loop;

    s_i_memWr <= '1';
    s_i_memToReg <= '1';
    s_i_jal <= '0';
    s_i_regDst <= '0';
    s_i_halt <= '0';
    s_i_regWr <= '0';
    wait for gCLK_HPER*2;

    s_i_memWr <= '0';
    s_i_memToReg <= '0';
    s_i_jal <= '1';
    s_i_regDst <= '1';
    s_i_halt <= '1';
    s_i_regWr <= '1';
    wait for gCLK_HPER*2;

    s_i_memWr <= '1';
    s_i_memToReg <= '1';
    s_i_jal <= '0';
    s_i_regDst <= '1';
    s_i_halt <= '0';
    s_i_regWr <= '1';
    wait for gCLK_HPER*2;

  end process;

end structural;