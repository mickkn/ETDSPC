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
    ast_sink_data    			: IN  STD_LOGIC_VECTOR(31 downto 0);
    ast_sink_ready   			: OUT STD_LOGIC                     := '0';  -- Value at startup
    ast_sink_valid  			: IN  STD_LOGIC;
	ast_sink_startofpacket  	: IN  std_logic;
	ast_sink_endofpacket 		: IN  std_logic;
	
    ast_source_data  			: OUT STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    ast_source_ready 			: IN STD_LOGIC;
    ast_source_valid 			: OUT STD_LOGIC                     := '0';
    ast_source_startofpacket	: OUT std_logic;
	ast_source_endofpacket 		: OUT std_logic;
	
	debug_state					: BUFFER STD_LOGIC_VECTOR(7 DOWNTO 0) := (others => '0'));
	
END ENTITY pixel_scan;

ARCHITECTURE beh OF pixel_scan IS

	TYPE STD_LOGIC_ARRAY IS ARRAY (91 DOWNTO 0) OF STD_LOGIC;

	--SIGNAL pixel_value_in 	: STD_LOGIC_VECTOR(31 DOWNTO 0);	--data register
	
	--INTERNAL REGISTER
	--SIGNAL data 				: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAl bar_width			: STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";
	SIGNAL bar_width_buf		: STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";
	SIGNAL state 				: STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
	SIGNAL bar1_found 			: STD_LOGIC := '0';
	SIGNAL bar2_found			: STD_LOGIC := '0';
	SIGNAL frame_counter 		: STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";
	SIGNAL bar_detect			: STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";
	SIGNAL bar_array 			: STD_LOGIC_VECTOR(91 DOWNTO 0) := (others => '0');
	
	
BEGIN
	pixel_scan: 
	PROCESS(clk)

		--STATES
		CONSTANT detect_black 	 	: STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";	--state for detecting a black frame
		CONSTANT find_bar_width  	: STD_LOGIC_VECTOR(3 DOWNTO 0) := "0001";	--state for finding the bar width
		CONSTANT build_bar_array 	: STD_LOGIC_VECTOR(3 DOWNTO 0) := "0010"; 	--state for building a array of ~95 bars (maybe less)
		CONSTANT decode_bar_array	: STD_LOGIC_VECTOR(3 DOWNTO 0) := "0011";	--state for determine L/G/R barcode
	
		--DEFINES
		CONSTANT threshold 		 	: STD_LOGIC_VECTOR(7 DOWNTO 0) := "10000000";
		
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
		--VARIABLE bar_array 			: STD_LOGIC_VECTOR(91 DOWNTO 0);
		VARIABLE digit_array		: STD_LOGIC_VECTOR(6 DOWNTO 0);
		VARIABLE digit_counter		: INTEGER := 0;
		VARIABLE bar_low			: INTEGER := 85;
		VARIABLE bar_high			: INTEGER := 91;
		VARIABLE jump_middle		: STD_LOGIC := '0';
		BEGIN
		
		--ast_sink_ready <= '1';
		
		IF ast_sink_valid = '1' THEN
			ast_sink_ready <= '1';
		END IF;
		
		IF rising_edge(clk) AND ast_sink_valid = '1' THEN
		
			CASE state IS
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
								--frame_counter <= "00000001";						--first white frame
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
				
					IF (unsigned(frame_counter) < unsigned(std_logic_vector(unsigned(bar_width)-1))) THEN				--count frames up to bar_width
						frame_counter <= std_logic_vector(unsigned(frame_counter) + 1);	--increment frame_counter
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
						frame_counter <= "00000000";									--reset frame_counter
						bar_detect <= "00000000";										--reset bar_detect
					END IF;
				
					IF (bar_counter = 0) THEN
						bar_counter := 91;
						state <= decode_bar_array;
					END IF;
					
				WHEN decode_bar_array => 
				
					report "digitcounter = " & integer'image(digit_counter);
					
					IF (digit_counter < 6) THEN				--find 12 digits
						digit_array(6 DOWNTO 0) := bar_array(bar_high DOWNTO bar_low);
						
						report "digit_array = " & integer'image(to_integer(unsigned(digit_array)));
						
						digit_counter := digit_counter + 1;
						CASE digit_array IS
							WHEN L0 =>
								report "L0";
							WHEN L1 =>
								report "L1";
							WHEN L2 =>
								report "L2";
							WHEN L3 =>
								report "L3";
							WHEN L4 =>
								report "L4";
							WHEN L5 =>
								report "L5";
							WHEN L6 =>
								report "L6";
							WHEN L7 =>
								report "L7";
							WHEN L8 =>
								report "L8";
							WHEN L9 =>
								report "L9";
							WHEN G0 =>	
								report "G0";
							WHEN G1 =>
								report "G1";
							WHEN G2 =>
								report "G2";
							WHEN G3 =>
								report "G3";
							WHEN G4 =>
								report "G4";
							WHEN G5 =>
								report "G5";
							WHEN G6 =>
								report "G6";
							WHEN G7 =>
								report "G7";
							WHEN G8 =>
								report "G8";
							WHEN G9 =>
								report "G9";
							WHEN OTHERS =>
								report "LG OTHERS";
						END CASE;
						bar_low := bar_low - 7;
						bar_high := bar_high - 7;
					ELSIF (digit_counter < 12) THEN
					
						IF(jump_middle = '0') THEN -- jump over middle 5 bars
							bar_high := bar_high - 5;
							bar_low := bar_low - 5;
							jump_middle := '1';
						END IF;
						digit_array(6 DOWNTO 0) := bar_array(bar_high DOWNTO bar_low); 
						
						report "digit_array = " & integer'image(to_integer(unsigned(digit_array)));
						
						digit_counter := digit_counter + 1;
						CASE digit_array IS
							WHEN R0 =>
								report "R0";
							WHEN R1 =>
								report "R1";
							WHEN R2 =>
								report "R2";
							WHEN R3 =>
								report "R3";
							WHEN R4 =>
								report "R4";
							WHEN R5 =>
								report "R5";
							WHEN R6 =>
								report "R6";
							WHEN R7 =>
								report "R7";
							WHEN R8 =>
								report "R8";
							WHEN R9 =>
								report "R9";
							WHEN OTHERS =>
								report "R OTHERS";
						END CASE;
						
						IF(bar_high > 9) THEN
							bar_low := bar_low - 7;
							bar_high := bar_high - 7;
						END IF;
					END IF;
					
					report "bar_high = " & integer'image(bar_high);
					report "bar_low = " & integer'image(bar_low);
				WHEN OTHERS =>
					state <= detect_black;
			END CASE;
		END IF;
	END PROCESS;
	
	decode_bars : 
	PROCESS(clk)
	BEGIN
	END PROCESS;
END beh;