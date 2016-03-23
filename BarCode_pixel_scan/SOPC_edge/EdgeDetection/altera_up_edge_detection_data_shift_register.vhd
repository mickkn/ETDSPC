LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY altera_mf;
USE altera_mf.all;

ENTITY altera_up_edge_detection_data_shift_register IS
 	GENERIC (
 	  SIZE : integer := 720;
 	  DW : integer := 10
  ); 
	PORT
	(
		clken		  : IN STD_LOGIC := '1';
		clock		  : IN STD_LOGIC ;
		shiftin		: IN STD_LOGIC_VECTOR (DW-1 DOWNTO 0);
		shiftout	: OUT STD_LOGIC_VECTOR (DW-1 DOWNTO 0);
		taps		   : OUT STD_LOGIC_VECTOR (DW-1 DOWNTO 0)
	);
END altera_up_edge_detection_data_shift_register;


ARCHITECTURE SYN OF altera_up_edge_detection_data_shift_register IS

	SIGNAL sub_wire0	: STD_LOGIC_VECTOR (DW-1 DOWNTO 0);
	SIGNAL sub_wire1	: STD_LOGIC_VECTOR (DW-1 DOWNTO 0);

	COMPONENT altshift_taps
	GENERIC (
		intended_device_family		: STRING;
		lpm_hint		: STRING;	  
		lpm_type		: STRING;
		number_of_taps		: NATURAL;
		tap_distance		: NATURAL;
		width		: NATURAL
	);
	PORT (
			clock	: IN STD_LOGIC;
			clken	: IN STD_LOGIC;
			shiftin	: IN  STD_LOGIC_VECTOR (DW-1 DOWNTO 0);
			taps	: OUT STD_LOGIC_VECTOR (DW-1 DOWNTO 0);
			shiftout	: OUT STD_LOGIC_VECTOR (DW-1 DOWNTO 0)
	);
	END COMPONENT;

BEGIN
	shiftout    <= sub_wire0(DW-1 DOWNTO 0);
	taps    <= sub_wire1(DW-1 DOWNTO 0);

	altshift_taps_component : altshift_taps
	GENERIC MAP (
		intended_device_family => "Cyclone II",
		lpm_hint => "RAM_BLOCK_TYPE=M4K",
		lpm_type => "altshift_taps",
		number_of_taps => 1,
		tap_distance => SIZE,
		width => DW
	)
	PORT MAP (
		clken => clken,
		clock => clock,
		shiftin => shiftin,
		taps => sub_wire1,
		shiftout => sub_wire0
	);

END SYN;
