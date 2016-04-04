LIBRARY IEEE,STD;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
USE ieee.std_logic_misc.all;

ENTITY pixel_scan IS

	PORT (
		-- Common --
		clk              			: IN  STD_LOGIC;   -- 50MHz
		reset_n          			: IN  STD_LOGIC;
					
		-- ST Bus --			
		--ast_clk          			: IN  STD_LOGIC;
		ast_sink_data    			: IN  STD_LOGIC_VECTOR(7 downto 0);
		ast_sink_ready   			: OUT STD_LOGIC := '0';  
		ast_sink_valid  			: IN  STD_LOGIC;
		ast_sink_startofpacket  	: IN  std_logic;
		ast_sink_endofpacket 		: IN  std_logic;
		
		ast_source_data  			: BUFFER STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
		ast_source_ready 			: IN STD_LOGIC;
		ast_source_valid 			: BUFFER STD_LOGIC := '0';
		ast_source_startofpacket	: BUFFER std_logic;
		ast_source_endofpacket 		: BUFFER std_logic;
		
		restart						: IN STD_LOGIC;
		debug_state					: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		
	
		-- Avalon Interface
		avs_s1_clk     				: IN  STD_LOGIC;                      	-- Avalon CLK
		avs_s1_reset_n 				: IN  std_logic;                      	-- Avalon Reset
		avs_s1_write           		: IN  std_logic;                      	-- Avalon WR
		avs_s1_read            		: IN  std_logic;                      	-- Avalon RD
		avs_s1_chipselect      		: IN  std_logic;                      	-- Avalon CS
		avs_s1_address         		: IN  std_logic_vector(7  DOWNTO 0); 	-- Avalon address
		avs_s1_writedata       		: IN  std_logic_vector(7 DOWNTO 0);  	-- Avalon WR data
		avs_s1_readdata        		: OUT std_logic_vector(7 DOWNTO 0) 		-- Avalon RD data
	); 
	
END ENTITY pixel_scan;

ARCHITECTURE beh OF pixel_scan IS

	TYPE STD_LOGIC_ARRAY 		IS ARRAY (91 DOWNTO 0) OF STD_LOGIC;
	TYPE STD_LOGIC_VECTOR_ARRAY IS ARRAY (12 DOWNTO 0) OF STD_LOGIC_VECTOR(3 DOWNTO 0);
	TYPE INTEGER_ARRAY 			IS ARRAY (11 DOWNTO 0) OF INTEGER;
	
	--INTERNAL REGISTER
	SIGNAl bar_width			: STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";
	SIGNAL bar_width_buf		: STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";
	SIGNAL bar1_found 			: STD_LOGIC := '0';
	SIGNAL bar2_found			: STD_LOGIC := '0';
	SIGNAL pixel_counter 		: STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";
	SIGNAL bar_detect			: STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";
	SIGNAL bar_array 			: STD_LOGIC_VECTOR(91 DOWNTO 0) := (others => '0');
	SIGNAL ean_number			: STD_LOGIC_VECTOR_ARRAY;
	SIGNAL ean_number_debug		: STD_LOGIC_VECTOR_ARRAY;
	SIGNAL data_register 		: STD_LOGIC_VECTOR(7 downto 0);
	SIGNAL mm_data_ready 		: STD_LOGIC := '0';
	SIGNAL digit_array			: STD_LOGIC_VECTOR(6 DOWNTO 0) := (others => '0');
	
	SIGNAL start_bits			: STD_LOGIC := '1';
	SIGNAL ean_counter			: STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
	
	--STATES
	TYPE STATE_TYPE IS (wait_state,
						detect_black,
						find_bar_width,
						build_bar_array,
						decode_bar_array,
						build_ean,
						done);
						
	SIGNAL state 		: STATE_TYPE;

BEGIN

	pixel_scan: 
	PROCESS(clk)
		
		--DEFINES
		CONSTANT threshold 		 	: STD_LOGIC_VECTOR(7 DOWNTO 0) := "10101010";
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
		
		CONSTANT bar_low			: INTEGER_ARRAY := (3,10,17,24,31,38,50,57,64,71,78,85);			
		CONSTANT bar_high			: INTEGER_ARRAY := (9,16,23,30,37,44,56,63,70,77,84,91);					
		VARIABLE jump_middle		: STD_LOGIC := '0';
		VARIABLE LG_code			: STD_LOGIC_VECTOR(5 DOWNTO 0);
		
		VARIABLE pixel_value 		: INTEGER := 0;	--black and white
		VARIABLE pic_mid_counter 	: INTEGER := 153500;
		
	BEGIN
		
		IF rising_edge(clk) THEN
		
			IF restart = '0' THEN
				state <= wait_state;
				mm_data_ready <= '0';
			END IF;
		
			IF ast_sink_valid = '1' THEN
				ast_sink_ready <= '1';
			END IF;
		
			CASE state IS
			
				WHEN wait_state =>															--wait state for start of packet (frame/picture) [upper left corner]
					debug_state <= "10000001";												--set red led
					IF ast_sink_startofpacket = '1' THEN									--change state upon start of packet
						state <= detect_black;
					END IF;
					
				WHEN detect_black =>														--detect black
					debug_state <= "10000010";												--set red led
					IF (unsigned(ast_sink_data) < unsigned(threshold)) THEN					--if black
						state <= find_bar_width; 											--black frame detected -> change state
						bar_width_buf <= std_logic_vector(unsigned(bar_width_buf) + 1);		--count a black pixel
					END IF;
					
				WHEN find_bar_width =>														--determine bar width
					debug_state <= "10000100";												--set red led
					--find first bar width
					IF bar1_found = '0' THEN
						IF (unsigned(ast_sink_data) > unsigned(threshold)) THEN 			--if white
							bar_width <= bar_width_buf;										--move counted value to bar_width
							bar_width_buf <= X"00";											--reset buf counter
							bar1_found <= '1';												--first bar_width found							
						ELSE 
							bar_width_buf <= std_logic_vector(unsigned(bar_width_buf) + 1);	--count black pixels
						END IF;
					--compare second bar width with first
					ELSE
						IF (unsigned(ast_sink_data) > unsigned(threshold)) THEN 			--first white bar and after second black bar
							IF (bar_width = bar_width_buf) THEN								--compare bars
								state <= build_bar_array ;	 								--change state if they match
							ELSIF (unsigned(bar_width_buf) > 0) THEN						--if some black found and the bar width's don't match
								state <= wait_state;										--restart to wait_state 
							END IF;
						ELSE 																--if black
							bar_width_buf <= std_logic_vector(unsigned(bar_width_buf) + 1);	--count black pixels for bar2
						END IF;
					END IF;
					
				WHEN build_bar_array =>	--build array of 92 bars 95-3(start)
					debug_state <= "10001000";													--set red led
					IF (unsigned(pixel_counter) < unsigned(std_logic_vector(unsigned(bar_width)-1))) THEN	--count pixels up to bar_width
						pixel_counter <= std_logic_vector(unsigned(pixel_counter) + 1);			--increment pixel_counter
						pixel_value := pixel_value + to_integer(unsigned(ast_sink_data));		--make pixel value from 8-bit data
					ELSE	--when pixels = bar_width
						pixel_value := pixel_value / to_integer(unsigned(bar_width));			--take average of pixel value
						IF (pixel_value > to_integer(unsigned(threshold))) THEN					--if the average is above threshold
							bar_array(bar_counter) <= '1';										--put 1 in bar_array on bar_counter position (as white)
						ELSE
							bar_array(bar_counter) <= '0';										--put 0 in bar_array for black
						END IF;
						bar_counter := bar_counter - 1;											--decrement bar_counter
						pixel_counter <= "00000000";											--reset pixel_counter
						pixel_value := 0;														--reset pixel value
					END IF;
				
					IF (bar_counter = 0) THEN													--if array is full
						bar_counter := 91;														--reset array
						state <= decode_bar_array;												--change state
					END IF;
					
				WHEN decode_bar_array => 
					debug_state <= "10010000";										--set red led
					IF (digit_counter < 7) THEN										--find first 6 digits
						digit_array(0) <= bar_array(bar_high(digit_counter)-6);		--fill up digit_array from bar_array
						digit_array(1) <= bar_array(bar_high(digit_counter)-5);
						digit_array(2) <= bar_array(bar_high(digit_counter)-4);
						digit_array(3) <= bar_array(bar_high(digit_counter)-3);
						digit_array(4) <= bar_array(bar_high(digit_counter)-2);
						digit_array(5) <= bar_array(bar_high(digit_counter)-1);
						digit_array(6) <= bar_array(bar_high(digit_counter));
						
							CASE digit_array IS										--decode first 6 digits
								WHEN L0 =>
									LG_code(6-digit_counter) := L_bool;
									ean_number(digit_counter) <= "0000";
								WHEN L1 =>
									LG_code(6-digit_counter) := L_bool;
									ean_number(digit_counter) <= "0001";
								WHEN L2 =>
									LG_code(6-digit_counter) := L_bool;
									ean_number(digit_counter) <= "0010";
								WHEN L3 =>
									LG_code(6-digit_counter) := L_bool;
									ean_number(digit_counter) <= "0011";
								WHEN L4 =>
									LG_code(6-digit_counter) := L_bool;
									ean_number(digit_counter) <= "0100";
								WHEN L5 =>
									LG_code(6-digit_counter) := L_bool;
									ean_number(digit_counter) <= "0101";
								WHEN L6 =>
									LG_code(6-digit_counter) := L_bool;
									ean_number(digit_counter) <= "0110";
								WHEN L7 =>
									LG_code(6-digit_counter) := L_bool;
									ean_number(digit_counter) <= "0111";
								WHEN L8 =>
									LG_code(6-digit_counter) := L_bool;
									ean_number(digit_counter) <= "1000";
								WHEN L9 =>
									LG_code(6-digit_counter) := L_bool;
									ean_number(digit_counter) <= "1001";
								WHEN G0 =>	
									LG_code(6-digit_counter) := G_bool;
									ean_number(digit_counter) <= "0000";
								WHEN G1 =>
									LG_code(6-digit_counter) := G_bool;
									ean_number(digit_counter) <= "0001";
								WHEN G2 =>
									LG_code(6-digit_counter) := G_bool;
									ean_number(digit_counter) <= "0010";
								WHEN G3 =>
									LG_code(6-digit_counter) := G_bool;
									ean_number(digit_counter) <= "0011";
								WHEN G4 =>
									LG_code(6-digit_counter) := G_bool;
									ean_number(digit_counter) <= "0100";
								WHEN G5 =>
									LG_code(6-digit_counter) := G_bool;
									ean_number(digit_counter) <= "0101";
								WHEN G6 =>
									LG_code(6-digit_counter) := G_bool;
									ean_number(digit_counter) <= "0110";
								WHEN G7 =>
									LG_code(6-digit_counter) := G_bool;
									ean_number(digit_counter) <= "0111";
								WHEN G8 =>
									LG_code(6-digit_counter) := G_bool;
									ean_number(digit_counter) <= "1000";
								WHEN G9 =>
									LG_code(6-digit_counter) := G_bool;
									ean_number(digit_counter) <= "1001";
								WHEN OTHERS =>
									report "LG OTHERS";
							END CASE;
						
						digit_counter := digit_counter + 1;
						
					ELSIF (digit_counter < 13) THEN										--decode last 6 digits
						
						IF (digit_counter < 12) THEN 
							digit_array(0) <= bar_array(bar_high(digit_counter)-6);
							digit_array(1) <= bar_array(bar_high(digit_counter)-5);
							digit_array(2) <= bar_array(bar_high(digit_counter)-4);
							digit_array(3) <= bar_array(bar_high(digit_counter)-3);
							digit_array(4) <= bar_array(bar_high(digit_counter)-2);
							digit_array(5) <= bar_array(bar_high(digit_counter)-1);
							digit_array(6) <= bar_array(bar_high(digit_counter));
						END IF;
						
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
						
						digit_counter := digit_counter + 1;
					
					ELSE
						state <= build_ean;								--change state
					
					END IF;
				
				WHEN build_ean =>							--build up the first digit from
					debug_state <= "10100000";
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
					state <= done;
					
				WHEN done =>
					
					debug_state <= "11000000";	--set red led
					
				WHEN OTHERS =>
					state <= wait_state;
			END CASE;
		END IF;
	END PROCESS;
	
		ean_number_debug(0) <=  "1001";
		ean_number_debug(1) <=  "1000";
		ean_number_debug(2) <=  "0111";
		ean_number_debug(3) <=  "0110";
		ean_number_debug(4) <=  "0101";
		ean_number_debug(5) <=  "0100";
		ean_number_debug(6) <=  "0011";
		ean_number_debug(7) <=  "0100";
		ean_number_debug(8) <=  "0011";
		ean_number_debug(9) <=  "0010";
		ean_number_debug(10) <= "0001";
		ean_number_debug(11) <= "0000";
		ean_number_debug(12) <= "0000";
	
	PROCESS(avs_s1_read) --sensitivity list
	BEGIN
		IF avs_s1_read = '0' THEN
			IF (mm_data_ready = '1') THEN					--When EAN number is ready
			
				IF (start_bits = '1') THEN					--if first time
					avs_s1_readdata <= "10000000";			--a data read different from 0xFF
					start_bits <= '0';						
				ELSE
					avs_s1_readdata <= "0000" & ean_number_debug(to_integer(unsigned(ean_counter)));	--put EAN number data in readdata 
					IF (ean_counter = "1100") THEN
						ean_counter <= "0000";															--reset ean_counter
					ELSE
						ean_counter <= std_logic_vector(unsigned(ean_counter) + 1);						--increment counter						
					END IF;
				END IF;
				
			ELSE
				ean_counter <= "0000";
				avs_s1_readdata <= X"FF";
				start_bits <= '1';
			END IF;
		END IF;
	END PROCESS;
	
	--Pixel pass through to VGA monitor output
	ast_source_startofpacket <= ast_sink_startofpacket;
	ast_source_endofpacket <= ast_sink_endofpacket;
	ast_source_data <= ast_sink_data;
	ast_source_valid <= ast_sink_valid;
	
END beh;