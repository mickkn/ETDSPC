LIBRARY IEEE,STD;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

ENTITY pixel_scan IS

	PORT (
  
		-- Common --
		clk              			: IN  STD_LOGIC;   -- 50MHz
		reset_n          			: IN  STD_LOGIC;
					
		-- ST Bus --			
		--ast_clk          			: IN  STD_LOGIC;
		ast_sink_data    			: IN  STD_LOGIC_VECTOR(7 downto 0);
		ast_sink_ready   			: OUT STD_LOGIC                     := '0';  -- Value at startup
		ast_sink_valid  			: IN  STD_LOGIC;
		ast_sink_startofpacket  	: IN  std_logic;
		ast_sink_endofpacket 		: IN  std_logic;
		
		ast_source_data  			: OUT STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
		ast_source_ready 			: IN STD_LOGIC;
		ast_source_valid 			: OUT STD_LOGIC                     := '0';
		ast_source_startofpacket	: OUT std_logic;
		ast_source_endofpacket 		: OUT std_logic;
		
		debug_state					: BUFFER STD_LOGIC_VECTOR(7 DOWNTO 0) := (others => '0');
	
		-- Avalon Interface
		avs_s1_clk     				: IN  STD_LOGIC;                      -- Avalon CLK
		avs_s1_reset_n 				: IN  std_logic;                      -- Avalon Reset
		avs_s1_write           		: IN  std_logic;                      -- Avalon WR
		avs_s1_read            		: IN  std_logic;                      -- Avalon RD
		avs_s1_chipselect      		: IN  std_logic;                      -- Avalon CS
		avs_s1_address         		: IN  std_logic_vector(7  DOWNTO 0);  -- Avalon address
		avs_s1_writedata       		: IN  std_logic_vector(7 DOWNTO 0);  -- Avalon WR data
		avs_s1_readdata        		: OUT std_logic_vector(7 DOWNTO 0));  -- Avalon RD data

    -- LCD something
	
END ENTITY pixel_scan;

ARCHITECTURE beh OF pixel_scan IS

	TYPE STD_LOGIC_ARRAY IS ARRAY (91 DOWNTO 0) OF STD_LOGIC;
	TYPE STD_LOGIC_VECTOR_ARRAY IS ARRAY (12 DOWNTO 0) OF STD_LOGIC_VECTOR(3 DOWNTO 0);
	TYPE INTEGER_ARRAY IS ARRAY (11 DOWNTO 0) OF INTEGER;
	
	--SIGNAL pixel_value_in 	: STD_LOGIC_VECTOR(31 DOWNTO 0);	--data register
	
	--INTERNAL REGISTER
	--SIGNAL data 				: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAl bar_width			: STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";
	SIGNAL bar_width_buf		: STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";
	SIGNAL state 				: STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
	SIGNAL bar1_found 			: STD_LOGIC := '0';
	SIGNAL bar2_found			: STD_LOGIC := '0';
	SIGNAL pixel_counter 		: STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";
	SIGNAL bar_detect			: STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";
	SIGNAL bar_array 			: STD_LOGIC_VECTOR(91 DOWNTO 0) := (others => '0');
	SIGNAL ean_number			: STD_LOGIC_VECTOR_ARRAY;
	SIGNAL data_register 		: STD_LOGIC_VECTOR(7 downto 0);
	SIGNAL mm_data_ready 		: STD_LOGIC := '0';
	SIGNAL digit_array			: STD_LOGIC_VECTOR(6 DOWNTO 0);
	
BEGIN
	pixel_scan: 
	PROCESS(clk)

		--STATES
		CONSTANT wait_state 		: STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";   --state for wait for frame start
		CONSTANT detect_black 	 	: STD_LOGIC_VECTOR(3 DOWNTO 0) := "0001";	--state for detecting a black frame
		CONSTANT find_bar_width  	: STD_LOGIC_VECTOR(3 DOWNTO 0) := "0010";	--state for finding the bar width
		CONSTANT build_bar_array 	: STD_LOGIC_VECTOR(3 DOWNTO 0) := "0011"; 	--state for building a array of ~95 bars (maybe less)
		CONSTANT decode_bar_array	: STD_LOGIC_VECTOR(3 DOWNTO 0) := "0100";	--state for determine L/G/R barcode
		CONSTANT build_ean			: STD_LOGIC_VECTOR(3 DOWNTO 0) := "0101";	--state for building the full 13 digit EAN number
		CONSTANT checksum			: STD_LOGIC_VECTOR(3 DOWNTO 0) := "0110"; 	--state for checking the checksum
		
		--DEFINES
		CONSTANT threshold 		 	: STD_LOGIC_VECTOR(7 DOWNTO 0) := "10000000";
		CONSTANT L_bool				: STD_LOGIC := '0';
		CONSTANT G_bool				: STD_LOGIC := '1';
		
		--BLUE BAR
		CONSTANT L1 : STD_LOGIC_VECTOR (6 DOWNTO 0) := "1100110";
		CONSTANT L2 : STD_LOGIC_VECTOR (6 DOWNTO 0) := "1101100";
		CONSTANT L3 : STD_LOGIC_VECTOR (6 DOWNTO 0) := "1000010";
		CONSTANT L4 : STD_LOGIC_VECTOR (6 DOWNTO 0) := "1011100";
		CONSTANT L5 : STD_LOGIC_VECTOR (6 DOWNTO 0) := "1001110";
		CONSTANT L6 : STD_LOGIC_VECTOR (6 DOWNTO 0) := "1010000";
		CONSTANT L7 : STD_LOGIC_VECTOR (6 DOWNTO 0) := "1000100";
		CONSTANT L8 : STD_LOGIC_VECTOR (6 DOWNTO 0) := "1001000";
		CONSTANT L9 : STD_LOGIC_VECTOR (6 DOWNTO 0) := "1110100";
		CONSTANT L0 : STD_LOGIC_VECTOR (6 DOWNTO 0) := "1110010";
                                          
		--RED BAR                         
		CONSTANT R1 : STD_LOGIC_VECTOR (6 DOWNTO 0) := "0011001";
		CONSTANT R2 : STD_LOGIC_VECTOR (6 DOWNTO 0) := "0010011";
		CONSTANT R3 : STD_LOGIC_VECTOR (6 DOWNTO 0) := "0111101";
		CONSTANT R4 : STD_LOGIC_VECTOR (6 DOWNTO 0) := "0100011";
		CONSTANT R5 : STD_LOGIC_VECTOR (6 DOWNTO 0) := "0110001";
		CONSTANT R6 : STD_LOGIC_VECTOR (6 DOWNTO 0) := "0101111";
		CONSTANT R7 : STD_LOGIC_VECTOR (6 DOWNTO 0) := "0111011";
		CONSTANT R8 : STD_LOGIC_VECTOR (6 DOWNTO 0) := "0110111";
		CONSTANT R9 : STD_LOGIC_VECTOR (6 DOWNTO 0) := "0001011";
		CONSTANT R0 : STD_LOGIC_VECTOR (6 DOWNTO 0) := "0001101";

		--GREEN BAR
		CONSTANT G1 : STD_LOGIC_VECTOR (6 DOWNTO 0) := "1001100";
		CONSTANT G2 : STD_LOGIC_VECTOR (6 DOWNTO 0) := "1100100";
		CONSTANT G3 : STD_LOGIC_VECTOR (6 DOWNTO 0) := "1011110";
		CONSTANT G4 : STD_LOGIC_VECTOR (6 DOWNTO 0) := "1100010";
		CONSTANT G5 : STD_LOGIC_VECTOR (6 DOWNTO 0) := "1000110";
		CONSTANT G6 : STD_LOGIC_VECTOR (6 DOWNTO 0) := "1111010";
		CONSTANT G7 : STD_LOGIC_VECTOR (6 DOWNTO 0) := "1101110";
		CONSTANT G8 : STD_LOGIC_VECTOR (6 DOWNTO 0) := "1110110";
		CONSTANT G9 : STD_LOGIC_VECTOR (6 DOWNTO 0) := "1101000";
		CONSTANT G0 : STD_LOGIC_VECTOR (6 DOWNTO 0) := "1011000";
		
		--DIGIT VALUES
		CONSTANT dig_0 : STD_LOGIC_VECTOR(5 DOWNTO 0) := "000000";
		CONSTANT dig_1 : STD_LOGIC_VECTOR(5 DOWNTO 0) := "001011";
		CONSTANT dig_2 : STD_LOGIC_VECTOR(5 DOWNTO 0) := "001101";
		CONSTANT dig_3 : STD_LOGIC_VECTOR(5 DOWNTO 0) := "001110";
		CONSTANT dig_4 : STD_LOGIC_VECTOR(5 DOWNTO 0) := "010011";
		CONSTANT dig_5 : STD_LOGIC_VECTOR(5 DOWNTO 0) := "011001";
		CONSTANT dig_6 : STD_LOGIC_VECTOR(5 DOWNTO 0) := "011100";
		CONSTANT dig_7 : STD_LOGIC_VECTOR(5 DOWNTO 0) := "010101";
		CONSTANT dig_8 : STD_LOGIC_VECTOR(5 DOWNTO 0) := "010110";
		CONSTANT dig_9 : STD_LOGIC_VECTOR(5 DOWNTO 0) := "011010";
		
		--VARIABLES
		VARIABLE bar_counter 		: INTEGER := 91;
		VARIABLE digit_counter		: INTEGER := 0;
		
		VARIABLE bar_low			: INTEGER_ARRAY := (82,75,68,61,54,47,35,28,21,14, 7,0);--(0, 7,14,21,28,35,47,54,61,68,75,82);--(3,10,17,24,31,38,50,57,64,71,78,85); --(85,78,71,64,57,50,38,31,24,17,10,3);
		VARIABLE bar_high			: INTEGER_ARRAY := (88,81,74,67,60,53,41,34,27,20,13,6);--(6,13,20,27,34,41,53,60,67,74,81,88);--(9,16,23,30,37,44,56,63,70,77,84,91); --(91,84,77,70,63,56,44,37,30,23,16,9);
		VARIABLE jump_middle		: STD_LOGIC := '0';
		VARIABLE LG_code			: STD_LOGIC_VECTOR(5 DOWNTO 0);
		
		
		BEGIN
		
		
		
		IF rising_edge(clk) THEN
		
			IF ast_sink_valid = '1' THEN
				ast_sink_ready <= '1';
			END IF;
		
			CASE state IS
			
				WHEN wait_state =>
					IF ast_sink_startofpacket = '1' THEN
						state <= detect_black;
					END IF;
				WHEN detect_black =>	--detect black
				
					IF (unsigned(ast_sink_data) < unsigned(threshold)) THEN		--if black
						state <= find_bar_width; 								--black frame detected -> change state
						bar_width_buf <= std_logic_vector(unsigned(bar_width_buf) + 1);
					END IF;
					
				WHEN find_bar_width =>	--determine bar width
				
					--find first bar width
					IF bar1_found = '0' THEN
						IF (unsigned(ast_sink_data) > unsigned(threshold)) THEN 	--if white
							bar_width <= bar_width_buf;								--move counted value to bar_width
							bar_width_buf <= X"00";									--reset buf counter
							bar1_found <= '1';										--first bar_width found							
						ELSE 
							bar_width_buf <= std_logic_vector(unsigned(bar_width_buf) + 1);	--count black frames
						END IF;
					--compare second bar width with first
					ELSE
						IF (unsigned(ast_sink_data) > unsigned(threshold)) THEN 	--if white, two bars found
							
							IF (bar_width = bar_width_buf) THEN						--compare bars
								bar2_found <= '1';	
								--pixel_counter <= "00000001";						--first white frame
								--bar_detect <= "00000001";							--detected
								state <= build_bar_array ;	 						--change state
							ELSE
								--LAVE ERROR HANDLING
							END IF;
						ELSE 
							bar_width_buf <= std_logic_vector(unsigned(bar_width_buf) + 1);	--count black frames
						END IF;
					END IF;
					
				WHEN build_bar_array =>		--build array of 92 bars 95-3(start)
				
					IF (unsigned(pixel_counter) < unsigned(std_logic_vector(unsigned(bar_width)-1))) THEN				--count frames up to bar_width
						pixel_counter <= std_logic_vector(unsigned(pixel_counter) + 1);	--increment pixel_counter
						--count white or do nothing
						IF (unsigned(ast_sink_data) > unsigned(threshold)) THEN			--if white
							bar_detect <= std_logic_vector(unsigned(bar_detect) + 1);	--increment bar_detect
						END IF;
					ELSE	--when frames == bar_width
						IF (unsigned(bar_detect) > "0000") THEN									--look on bar_detect, if over 0 it's white
							bar_array(bar_counter) <= '1';								--put 1 in bar_array on bar_counter position
						ELSE
							bar_array(bar_counter) <= '0';								--put 0 in bar_array for black
						END IF;
						report "BarCounter = " & integer'image(bar_counter);
						--report "barArray(barCounter) = " & std_logic'image(bar_array(bar_counter));
						bar_counter := bar_counter - 1;									--increment bar_counter
						pixel_counter <= "00000000";									--reset pixel_counter
						bar_detect <= "00000000";										--reset bar_detect
					END IF;
				
					IF (bar_counter = 0) THEN
						bar_counter := 91;
						state <= decode_bar_array;
					END IF;
					
				WHEN decode_bar_array => 
				
					report "digitcounter = " & integer'image(digit_counter);
					
					IF (digit_counter < 6) THEN				--find first 6 digits
						
						digit_array <= bar_array(bar_high(digit_counter) DOWNTO bar_low(digit_counter));
						
						digit_counter := digit_counter + 1;
						CASE digit_array IS
							WHEN L0 =>
								LG_code(6-digit_counter) := L_bool;
								ean_number(digit_counter) <= "0000";
								report "L0";
							WHEN L1 =>
								LG_code(6-digit_counter) := L_bool;
								ean_number(digit_counter) <= "0001";
								report "L1";
							WHEN L2 =>
								LG_code(6-digit_counter) := L_bool;
								ean_number(digit_counter) <= "0010";
								report "L2";
							WHEN L3 =>
								LG_code(6-digit_counter) := L_bool;
								ean_number(digit_counter) <= "0011";
								report "L3";
							WHEN L4 =>
								LG_code(6-digit_counter) := L_bool;
								ean_number(digit_counter) <= "0100";
								report "L4";
							WHEN L5 =>
								LG_code(6-digit_counter) := L_bool;
								ean_number(digit_counter) <= "0101";
								report "L5";
							WHEN L6 =>
								LG_code(6-digit_counter) := L_bool;
								ean_number(digit_counter) <= "0110";
								report "L6";
							WHEN L7 =>
								LG_code(6-digit_counter) := L_bool;
								ean_number(digit_counter) <= "0111";
								report "L7";
							WHEN L8 =>
								LG_code(6-digit_counter) := L_bool;
								ean_number(digit_counter) <= "1000";
								report "L8";
							WHEN L9 =>
								LG_code(6-digit_counter) := L_bool;
								ean_number(digit_counter) <= "1001";
								report "L9";
							WHEN G0 =>	
								LG_code(6-digit_counter) := G_bool;
								ean_number(digit_counter) <= "0000";
								report "G0";
							WHEN G1 =>
								LG_code(6-digit_counter) := G_bool;
								ean_number(digit_counter) <= "0001";
								report "G1";
							WHEN G2 =>
								LG_code(6-digit_counter) := G_bool;
								ean_number(digit_counter) <= "0010";
								report "G2";
							WHEN G3 =>
								LG_code(6-digit_counter) := G_bool;
								ean_number(digit_counter) <= "0011";
								report "G3";
							WHEN G4 =>
								LG_code(6-digit_counter) := G_bool;
								ean_number(digit_counter) <= "0100";
								report "G4";
							WHEN G5 =>
								LG_code(6-digit_counter) := G_bool;
								ean_number(digit_counter) <= "0101";
								report "G5";
							WHEN G6 =>
								LG_code(6-digit_counter) := G_bool;
								ean_number(digit_counter) <= "0110";
								report "G6";
							WHEN G7 =>
								LG_code(6-digit_counter) := G_bool;
								ean_number(digit_counter) <= "0111";
								report "G7";
							WHEN G8 =>
								LG_code(6-digit_counter) := G_bool;
								ean_number(digit_counter) <= "1000";
								report "G8";
							WHEN G9 =>
								LG_code(6-digit_counter) := G_bool;
								ean_number(digit_counter) <= "1001";
								report "G9";
							WHEN OTHERS =>
								report "LG OTHERS";
						END CASE;
						--bar_low := bar_low - 7;
						--bar_high := bar_high - 7;
					ELSIF (digit_counter < 12) THEN
					
						IF(jump_middle = '0') THEN -- jump over middle 5 bars
							--bar_high := bar_high - 5;
							--bar_low := bar_low - 5;
							jump_middle := '1';
						END IF;
						digit_array(6 DOWNTO 0) <= bar_array(bar_high(digit_counter) DOWNTO bar_low(digit_counter)); 
						
						report "digit_array = " & integer'image(to_integer(unsigned(digit_array)));
						
						digit_counter := digit_counter + 1;
						CASE digit_array IS
							WHEN R0 =>
								ean_number(digit_counter) <= "0000";
								report "R0";
							WHEN R1 =>
								ean_number(digit_counter) <= "0001";
								report "R1";
							WHEN R2 =>
								ean_number(digit_counter) <= "0010";
								report "R2";
							WHEN R3 =>
								ean_number(digit_counter) <= "0011";
								report "R3";
							WHEN R4 =>
								ean_number(digit_counter) <= "0100";
								report "R4";
							WHEN R5 =>
								ean_number(digit_counter) <= "0101";
								report "R5";
							WHEN R6 =>
								ean_number(digit_counter) <= "0110";
								report "R6";
							WHEN R7 =>
								ean_number(digit_counter) <= "0111";
								report "R7";
							WHEN R8 =>
								ean_number(digit_counter) <= "1000";
								report "R8";
							WHEN R9 =>
								ean_number(digit_counter) <= "1001";
								report "R9";
							WHEN OTHERS =>
								report "R OTHERS";
						END CASE;
						
						-- IF(bar_high() > 9) THEN
							-- bar_low := bar_low - 7;
							-- bar_high := bar_high - 7;
						-- END IF;
					ELSE
						state <= build_ean;
					END IF;
					
					--report "bar_high = " & integer'image(bar_high);
					--report "bar_low = " & integer'image(bar_low);
				
				WHEN build_ean =>
				
					CASE LG_code IS
						WHEN dig_0 =>
							ean_number(0) <= "0000";
						WHEN dig_1 =>
							ean_number(0) <= "0001";
						WHEN dig_2 =>
							ean_number(0) <= "0010";
						WHEN dig_3 =>
							ean_number(0) <= "0011";
						WHEN dig_4 =>
							ean_number(0) <= "0100";
						WHEN dig_5 =>
							ean_number(0) <= "0101";
						WHEN dig_6 =>
							ean_number(0) <= "0110";
						WHEN dig_7 =>
							ean_number(0) <= "0111";
						WHEN dig_8 =>
							ean_number(0) <= "1000";
						WHEN dig_9 =>
							ean_number(0) <= "1001";
						WHEN OTHERS =>
							report "LG_code OTHERS";
					END CASE;
					
					--Ready data for MM bus !!
					mm_data_ready <= '1';
					state <= checksum;	--TEST
					
				WHEN checksum =>
					
				WHEN OTHERS =>
					state <= detect_black;
			END CASE;
		END IF;
	END PROCESS;
	
	PROCESS(avs_s1_clk) --sensitivity list
	
		VARIABLE ean_counter 		: INTEGER := 0;
	
		BEGIN
			IF rising_edge(avs_s1_clk) THEN
				IF (mm_data_ready = '1') THEN
					IF (avs_s1_read = '0') THEN	--send new data
					--report "IF EAN_NUMBER IS READY, SEND TO MM BUS 1 NUMBER AT A TIME";
						--avs_s1_readdata <= "0000" & ean_number(ean_counter);
						report "ean_number(ean_counter) = " & integer'image(to_integer(unsigned(ean_number(ean_counter))));
						ean_counter := ean_counter + 1;
						IF (ean_counter = 12) THEN
							ean_counter := 0;
						END IF;
					END IF;
				END IF;
			END IF;
	END PROCESS;
	
END beh;