-- (C) 2021 Samuel Leitenmaier (University of Applied Sciences Augsburg/Starkstrom Augsburg)

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;
use ieee.math_real.all;

library work;


entity ENDAT_TB is
end ENDAT_TB;

-- Behavioural testbench architecture
architecture BEHAVIORAL of ENDAT_TB is

-- Component declaration
-- Side of racecar
component master
   port (-- local clock
 	clk: in std_logic;
 	rst: in std_logic;

 	-- generated clock for slave
	-- fdiv divides CLK_FREQ
	ma_fdiv: in unsigned;
	ma_clk: out std_logic;

	-- master out, slave in
	mosi: out std_logic;
	miso: in std_logic;

	-- gate to drive output (1 to drive it)
	gate: out std_logic;

	-- data from slave, and data length
	data: out std_logic_vector;
	len: in unsigned;

	-- encoder type
	enc_type: in integer;

	-- ssi specific control registers
	ssi_flags: in std_logic_vector;
	ssi_delay_fdiv: in unsigned
); end component;

-- Side of Motor
component slave
   port (-- local clock
 	clk: in std_logic;
 	rst: in std_logic;

	 -- master clock and data
 	ma_clk: in std_logic;
 	miso: out std_logic;
 	mosi: in std_logic;
 	gate: out std_logic;

 	-- data and length
 	data: in std_logic_vector;
 	len: in unsigned;

 	-- encoder type
 	enc_type: in integer;

 	-- ssi specific control registers
 	ssi_flags: in std_logic_vector

); end component;

-- Configuration with generic mapping
for u_master: master use entity work.master(absenc_master_rtl)
  generic map (10000000, TRUE, FALSE, FALSE); --activate used encoder [Endat]

for u_slave: slave use entity work.slave(absenc_slave_rtl)
  generic map (10000000, TRUE, FALSE, FALSE); --activate used encoder [Endat]

-- Clock period
constant period: time := 10 ns;
-- Freq Divider
constant ma_fdiv: unsigned(15 downto 0) := "0000000011001000";
-- Encoder Type for Endat 
constant enc_type: integer := 0; 

-- Signals
signal clk, rst, ma_clk, mosi, miso, gate, down, up: std_logic;
signal ssi_delay_fdiv, len: unsigned(31 downto 0);
signal sdata,s_tmpdata, mdata, ssi_flags: std_logic_vector(31 downto 0);

begin


  -- Instantiate master to read from absolute encoder slave
  u_master : master port map (
	clk => clk,
	rst => rst,
	
	ma_fdiv => ma_fdiv,
	ma_clk => ma_clk,
	
	mosi => mosi,
	miso => miso,
	
	gate => gate,

	data => mdata,
	len => len,

	enc_type => enc_type,

	ssi_flags => ssi_flags,
	ssi_delay_fdiv => ssi_delay_fdiv	
    
  );

  -- Instantiate dummy slave for absolute motor encoder
  u_slave : slave port map (
	clk => clk,
	rst => rst,
	
	ma_clk => ma_clk,

	mosi => mosi,
	miso => miso,
	
	gate => gate,

	data => sdata,
	len => len,

	enc_type => enc_type,

	ssi_flags => ssi_flags   
  );

  -- Process for applying patterns
  process

    -- Helper procedure to perform one clock cycle...
    procedure run_cycle is
    begin
   	  clk <= '0';
      wait for period / 2;
      clk <= '1';
      wait for period / 2;
    end procedure;

  begin

  	sdata <= "00000000000000000000000000000011";
  	s_tmpdata <= "00000000000000000000000000000011";
  	len <= "00000000000000000000000000010010";
  	run_cycle;
  	rst <= '1';
  	run_cycle;
  	rst <= '0'; -- -> RST is high active
  	for n in 1 to 100 loop
  		for j in 1 to 5000 loop
			run_cycle;
		end loop;
		sdata <= "00000000000000100100100100010011";
	end loop;
	rst <= '0';


   -- Print when simualtion is finisheds
   assert false report "Simulation finished" severity note;
   wait;

  end process;

end BEHAVIORAL;

