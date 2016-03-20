LIBRARY IEEE,STD;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE STD.TEXTIO.ALL;

ENTITY pixel_scan IS
END pixel_scan;

ARCHITECTURE beh OF pixel_scan IS

TYPE STD_LOGIC_ARRAY IS ARRAY (94 DOWNTO 0) OF STD_LOGIC;
--TYPE STD_LOGIC_VECTOR_ARRAY IS ARRAY (94 DOWNTO 0) OF STD_LOGIC_VECTOR;
TYPE STD_LOGIC_VECTOR_ARRAY IS ARRAY (12 DOWNTO 0) OF STD_LOGIC_VECTOR(3 DOWNTO 0);

SIGNAL counter	  	  : STD_LOGIC_VECTOR(15 downto 0) := X"0000";

BEGIN
file_io:
PROCESS IS
	FILE in_file          	: TEXT OPEN READ_MODE  IS "ImageIn.txt";
	FILE out_file         	: TEXT OPEN WRITE_MODE IS "out_values.txt";
	FILE bar_file         	: TEXT OPEN WRITE_MODE IS "bar_values.txt";
	FILE digit_file         : TEXT OPEN WRITE_MODE IS "digit_values.txt";
	FILE ean_file 			: TEXT OPEN WRITE_MODE IS "ean_values.txt";
	FILE ean_final			: TEXT OPEN WRITE_MODE IS "EAN_FINAL_VALUE.txt";
	
	CONSTANT pic_width 		: INTEGER := 920;		--known value
	CONSTANT pic_height		: INTEGER := 696;		--known value 
	CONSTANT w_th			: INTEGER := 128;		--white threshold
	CONSTANT b_th			: INTEGER := 128;		--black threshold 
	CONSTANT total_bars		: INTEGER := 95;		--number of bars
	CONSTANT L 				: CHARACTER := 'L';
	CONSTANT L_bool 		: STD_LOGIC := '0';
	CONSTANT G 				: CHARACTER := 'G';
	CONSTANT G_bool			: STD_LOGIC := '1';
	CONSTANT R 				: CHARACTER := 'R';	
	
	-- Blue bar

	CONSTANT L1 : std_logic_vector (6 downto 0) := "1100110";
	CONSTANT L2 : std_logic_vector (6 downto 0) := "1101100";
	CONSTANT L3 : std_logic_vector (6 downto 0) := "1000010";
	CONSTANT L4 : std_logic_vector (6 downto 0) := "1011100";
	CONSTANT L5 : std_logic_vector (6 downto 0) := "1001110";
	CONSTANT L6 : std_logic_vector (6 downto 0) := "1010000";
	CONSTANT L7 : std_logic_vector (6 downto 0) := "1000100";
	CONSTANT L8 : std_logic_vector (6 downto 0) := "1001000";
	CONSTANT L9 : std_logic_vector (6 downto 0) := "1110100";
	CONSTANT L0 : std_logic_vector (6 downto 0) := "1110010";

	-- Red bar

	CONSTANT R1 : std_logic_vector (6 downto 0) := "0011001";
	CONSTANT R2 : std_logic_vector (6 downto 0) := "0010011";
	CONSTANT R3 : std_logic_vector (6 downto 0) := "0111101";
	CONSTANT R4 : std_logic_vector (6 downto 0) := "0100011";
	CONSTANT R5 : std_logic_vector (6 downto 0) := "0110001";
	CONSTANT R6 : std_logic_vector (6 downto 0) := "0101111";
	CONSTANT R7 : std_logic_vector (6 downto 0) := "0111011";
	CONSTANT R8 : std_logic_vector (6 downto 0) := "0110111";
	CONSTANT R9 : std_logic_vector (6 downto 0) := "0001011";
	CONSTANT R0 : std_logic_vector (6 downto 0) := "0001101";

	-- Green bar NOT TO BE USED NOW!

	CONSTANT G1 : std_logic_vector (6 downto 0) := "1001100";
	CONSTANT G2 : std_logic_vector (6 downto 0) := "1100100";
	CONSTANT G3 : std_logic_vector (6 downto 0) := "1011110";
	CONSTANT G4 : std_logic_vector (6 downto 0) := "1100010";
	CONSTANT G5 : std_logic_vector (6 downto 0) := "1000110";
	CONSTANT G6 : std_logic_vector (6 downto 0) := "1111010";
	CONSTANT G7 : std_logic_vector (6 downto 0) := "1101110";
	CONSTANT G8 : std_logic_vector (6 downto 0) := "1110110";
	CONSTANT G9 : std_logic_vector (6 downto 0) := "1101000";
	CONSTANT G0 : std_logic_vector (6 downto 0) := "1011000";
	
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
	
	VARIABLE black 			: INTEGER := 0;
	VARIABLE white 			: INTEGER := 1;
	
	VARIABLE out_line     	: LINE;
	VARIABLE in_line      	: LINE;
	VARIABLE err_line 		: INTEGER := 666;
	VARIABLE value        	: INTEGER := 0;
	VARIABLE count 		  	: INTEGER := 0;
	VARIABLE b_count 		: INTEGER := 0;
	VARIABLE w_count 		: INTEGER := 0;
	VARIABLE bar_width 		: INTEGER := 0;
	VARIABLE b_found 		: INTEGER := 0;
	VARIABLE b_var1			: INTEGER := 0;
	VARIABLE b_var2 		: INTEGER := 0;
	VARIABLE bar_count 		: INTEGER := 0;
	VARIABLE w_found  		: INTEGER := 0;
	VARIABLE init_count 	: INTEGER := 0;
	VARIABLE bar			: INTEGER := 0;
	VARIABLE bar_array 		: STD_LOGIC_VECTOR (94 DOWNTO 0);
	VARIABLE bar_array_cnt 	: INTEGER := 0;
	VARIABLE start_decode 	: INTEGER := 0;
	
	VARIABLE s_value 		: INTEGER := 0;
	
	VARIABLE barwidth_found : INTEGER := 0;
	VARIABLE start_pos_reached : INTEGER := 0;
	VARIABLE start_pos_count : INTEGER := 0;
	
	VARIABLE bar_width_counter : INTEGER := 0;
	
	VARIABLE bar_value 		: INTEGER := 0;
	
	VARIABLE digit_array 	: STD_LOGIC_VECTOR (0 TO 6);
	VARIABLE digit_cnt 		: INTEGER := 0;
	VARIABLE digit_13 		: INTEGER := 0;
	
	VARIABLE LG_code		: STD_LOGIC_VECTOR(0 TO 5);
	VARIABLE EAN_NUMBER 	: STD_LOGIC_VECTOR_ARRAY;
	
	BEGIN
		WHILE NOT ENDFILE(in_file) LOOP 		--do this till out of data
		
			-- HOP NED PÅ MIDTEN/VENSTRE DEL AF BILLEDET
			
			READLINE(in_file, in_line);    		--one pixel starting from upper left corner
			READ(in_line, value);               --get first operand
			
			IF (start_pos_reached = 0) THEN
			
				IF (value < b_th) THEN				--if black
					IF (bar_count = 0) THEN			--first bar
						b_count := b_count + 1;
						b_found := 1;
					END IF;
				END IF;
				
				IF (value > w_th) THEN 				--if white
					IF (b_found = 1) THEN			--only when black is found
						b_var1 := b_count;
						b_count := 0;
						b_found := 0;				--Ready for second black bar
						bar_count := 1;				--First black bar logged
						w_found := 1;
					END IF;
				END IF;
				
				IF (value < b_th) THEN				--if black
					IF (w_found = 1) THEN			--second bar
						IF (b_found = 0) THEN
							b_count := b_count + 1;
							bar_count := 2;
						END IF;
					END IF;
				END IF;
				
				IF (value > w_th) THEN 					--if white
					IF (barwidth_found = 0) THEN
						IF (bar_count = 2) THEN			--only when black is found two times
							b_var2 := b_count;
							b_count := 0;
							b_found := 0;				--Ready for second black bar
							bar_count := 2;				--First black bar logged
							init_count := 1;
							barwidth_found := 1;
						
							IF(b_var1 = b_var2) THEN
				
								bar_width := b_var1;
						
								WRITE(out_line, bar_width);
								WRITELINE(out_file, out_line);  		--write line to file
						
							ELSE
						
								WRITE(out_line, err_line);
								WRITELINE(out_file, out_line);
						
							END IF;
						END IF;
					END IF;
					
					IF(barwidth_found = 1) THEN
						start_pos_count := start_pos_count + 1;
					END IF;
					
					IF(start_pos_count = bar_width-1) THEN
						start_pos_reached := 1;
					END IF;
					
				END IF;
			END IF;	

			bar_array(0) := '1';		--First white bar (always white)
			
			IF (start_pos_reached = 1) THEN
				IF (value < b_th) THEN
					s_value := 0;
				ELSE
					s_value := 1;
				END IF;
				
				bar_value := bar_value + s_value;		-- 0 or 8 for black or white
			
				bar_width_counter := bar_width_counter + 1; -- count up
			
				IF (bar_width_counter = bar_width) THEN
					IF (bar_array_cnt < total_bars-5) THEN		--jump over first 3 bars
						IF (bar_value > 0) THEN
							bar_array(bar_array_cnt+1) := '1';	--prevent array place 0
							WRITE(out_line, white);
							WRITELINE(bar_file, out_line);  		--write line to file
						ELSE
							bar_array(bar_array_cnt+1) := '0';	--prevent array place 0 
							WRITE(out_line, black);
							WRITELINE(bar_file, out_line);  		--write line to file
						END IF;
						
						bar_width_counter := 0;
						bar_array_cnt := bar_array_cnt + 1;
						
					END IF;
				END IF;
				
				bar_value := 0;		--reset bar value
			
			END IF;
			
		END LOOP;
		
		--ONE LINE IS NOW READ OUT IN BAR_ARRAY ONLY THE LAST 91 BARS
		
		--DIGIT DECODING
		
		FOR i IN 0 TO 5 LOOP		--first 6 digits
			FOR c IN 0 TO 6 LOOP
				digit_array(c) := bar_array(digit_cnt);
				digit_cnt := digit_cnt + 1;
			END LOOP;
			
			CASE digit_array IS
				WHEN L0 =>
					EAN_NUMBER(i+1) := "0000";
					LG_code(i) := L_bool;
					WRITE(out_line, 0);
					WRITELINE(digit_file, out_line);
					WRITE(out_line, L);
					WRITELINE(ean_file, out_line);
				WHEN L1 =>
					EAN_NUMBER(i+1) := "0001";
					LG_code(i) := L_bool;
					WRITE(out_line, 1);
					WRITELINE(digit_file, out_line);
					WRITE(out_line, L);
					WRITELINE(ean_file, out_line);
				WHEN L2 =>
					EAN_NUMBER(i+1) := "0010";
					LG_code(i) := L_bool;
					WRITE(out_line, 2);
					WRITELINE(digit_file, out_line);
					WRITE(out_line, L);
					WRITELINE(ean_file, out_line);
				WHEN L3 =>
					EAN_NUMBER(i+1) := "0011";
					LG_code(i) := L_bool;
					WRITE(out_line, 3);
					WRITELINE(digit_file, out_line);
					WRITE(out_line, L);
					WRITELINE(ean_file, out_line);
				WHEN L4 =>
					EAN_NUMBER(i+1) := "0100";
					LG_code(i) := L_bool;
					WRITE(out_line, 4);
					WRITELINE(digit_file, out_line);
					WRITE(out_line, L);
					WRITELINE(ean_file, out_line);
				WHEN L5 =>
					EAN_NUMBER(i+1) := "0101";
					LG_code(i) := L_bool;
					WRITE(out_line, 5);
					WRITELINE(digit_file, out_line);
					WRITE(out_line, L);
					WRITELINE(ean_file, out_line);
				WHEN L6 =>
					EAN_NUMBER(i+1) := "0110";
					LG_code(i) := L_bool;
					WRITE(out_line, 6);
					WRITELINE(digit_file, out_line);
					WRITE(out_line, L);
					WRITELINE(ean_file, out_line);
				WHEN L7 =>
					EAN_NUMBER(i+1) := "0111";
					LG_code(i) := L_bool;
					WRITE(out_line, 7);
					WRITELINE(digit_file, out_line);
					WRITE(out_line, L);
					WRITELINE(ean_file, out_line);
				WHEN L8 =>
					EAN_NUMBER(i+1) := "1000";
					LG_code(i) := L_bool;
					WRITE(out_line, 8);
					WRITELINE(digit_file, out_line);
					WRITE(out_line, L);
					WRITELINE(ean_file, out_line);
				WHEN L9 =>
					EAN_NUMBER(i+1) := "1001";
					LG_code(i) := L_bool;
					WRITE(out_line, 9);
					WRITELINE(digit_file, out_line);
					WRITE(out_line, L);
					WRITELINE(ean_file, out_line);
				WHEN G0 =>
					EAN_NUMBER(i+1) := "0000";
					LG_code(i) := G_bool;
					WRITE(out_line, 0);
					WRITELINE(digit_file, out_line);
					WRITE(out_line, G);
					WRITELINE(ean_file, out_line);
				WHEN G1 =>
					EAN_NUMBER(i+1) := "0001";
					LG_code(i) := G_bool;
					WRITE(out_line, 1);
					WRITELINE(digit_file, out_line);
					WRITE(out_line, G);
					WRITELINE(ean_file, out_line);
				WHEN G2 =>
					EAN_NUMBER(i+1) := "0010";
					LG_code(i) := G_bool;
					WRITE(out_line, 2);
					WRITELINE(digit_file, out_line);
					WRITE(out_line, G);
					WRITELINE(ean_file, out_line);
				WHEN G3 =>
					EAN_NUMBER(i+1) := "0011";
					LG_code(i) := G_bool;
					WRITE(out_line, 3);
					WRITELINE(digit_file, out_line);
					WRITE(out_line, G);
					WRITELINE(ean_file, out_line);
				WHEN G4 =>
					EAN_NUMBER(i+1) := "0100";
					LG_code(i) := G_bool;
					WRITE(out_line, 4);
					WRITELINE(digit_file, out_line);
					WRITE(out_line, G);
					WRITELINE(ean_file, out_line);
				WHEN G5 =>
					EAN_NUMBER(i+1) := "0101";
					LG_code(i) := G_bool;
					WRITE(out_line, 5);
					WRITELINE(digit_file, out_line);
					WRITE(out_line, G);
					WRITELINE(ean_file, out_line);
				WHEN G6 =>
					EAN_NUMBER(i+1) := "0110";
					LG_code(i) := G_bool;
					WRITE(out_line, 6);
					WRITELINE(digit_file, out_line);
					WRITE(out_line, G);
					WRITELINE(ean_file, out_line);
				WHEN G7 =>
					EAN_NUMBER(i+1) := "0111";
					LG_code(i) := G_bool;
					WRITE(out_line, 7);
					WRITELINE(digit_file, out_line);
					WRITE(out_line, G);
					WRITELINE(ean_file, out_line);
				WHEN G8 =>
					EAN_NUMBER(i+1) := "1000";
					LG_code(i) := G_bool;
					WRITE(out_line, 8);
					WRITELINE(digit_file, out_line);
					WRITE(out_line, G);
					WRITELINE(ean_file, out_line);
				WHEN G9 =>
					EAN_NUMBER(i+1) := "1001";
					LG_code(i) := G_bool;
					WRITE(out_line, 9);
					WRITELINE(digit_file, out_line);
					WRITE(out_line, G);
					WRITELINE(ean_file, out_line);
				WHEN OTHERS =>
					WRITE(out_line, err_line);
					WRITELINE(digit_file, out_line);
					WRITE(out_line, G);
					WRITELINE(ean_file, out_line);
			END CASE;
		END LOOP;
		
		digit_cnt := 0;
		
		FOR i IN 0 TO 5 LOOP		--last 6 digits
			FOR c IN 0 TO 6 LOOP
				digit_array(c) := bar_array(digit_cnt+47);
				digit_cnt := digit_cnt + 1;
			END LOOP;
			
			CASE digit_array IS
				WHEN R0 =>
					EAN_NUMBER(i+7) := "0000";
					WRITE(out_line, 0);
					WRITELINE(digit_file, out_line);
					WRITE(out_line, R);
					WRITELINE(ean_file, out_line);
				WHEN R1 =>
					EAN_NUMBER(i+7) := "0001";
					WRITE(out_line, 1);
					WRITELINE(digit_file, out_line);
					WRITE(out_line, R);
					WRITELINE(ean_file, out_line);
				WHEN R2 =>
					EAN_NUMBER(i+7) := "0010";
					WRITE(out_line, 2);
					WRITELINE(digit_file, out_line);
					WRITE(out_line, R);
					WRITELINE(ean_file, out_line);
				WHEN R3 =>
					EAN_NUMBER(i+7) := "0011";
					WRITE(out_line, 3);
					WRITELINE(digit_file, out_line);
					WRITE(out_line, R);
					WRITELINE(ean_file, out_line);
				WHEN R4 =>
					EAN_NUMBER(i+7) := "0100";
					WRITE(out_line, 4);
					WRITELINE(digit_file, out_line);
					WRITE(out_line, R);
					WRITELINE(ean_file, out_line);
				WHEN R5 =>
					EAN_NUMBER(i+7) := "0101";
					WRITE(out_line, 5);
					WRITELINE(digit_file, out_line);
					WRITE(out_line, R);
					WRITELINE(ean_file, out_line);
				WHEN R6 =>
					EAN_NUMBER(i+7) := "0110";
					WRITE(out_line, 6);
					WRITELINE(digit_file, out_line);
					WRITE(out_line, R);
					WRITELINE(ean_file, out_line);
				WHEN R7 =>
					EAN_NUMBER(i+7) := "0111";
					WRITE(out_line, 7);
					WRITELINE(digit_file, out_line);
					WRITE(out_line, R);
					WRITELINE(ean_file, out_line);
				WHEN R8 =>
					EAN_NUMBER(i+7) := "1000";
					WRITE(out_line, 8);
					WRITELINE(digit_file, out_line);
					WRITE(out_line, R);
					WRITELINE(ean_file, out_line);
				WHEN R9 =>
					EAN_NUMBER(i+7) := "1001";
					WRITE(out_line, 9);
					WRITELINE(digit_file, out_line);
					WRITE(out_line, R);
					WRITELINE(ean_file, out_line);
				WHEN OTHERS =>
					WRITE(out_line, err_line);
					WRITELINE(digit_file, out_line);
			END CASE;
		END LOOP;
		
		-- FIRST DIGIT L/G DECODING
		
		CASE LG_code IS
			WHEN dig_0 =>
				EAN_NUMBER(0) := "0000";
				WRITE(out_line, 0);
				WRITELINE(ean_final, out_line);
			WHEN dig_1 =>
				EAN_NUMBER(0) := "0001";
				WRITE(out_line, 1);
				WRITELINE(ean_final, out_line);
			WHEN dig_2 =>
				EAN_NUMBER(0) := "0010";
				WRITE(out_line, 2);
				WRITELINE(ean_final, out_line);
			WHEN dig_3 =>
				EAN_NUMBER(0) := "0011";
				WRITE(out_line, 3);
				WRITELINE(ean_final, out_line);
			WHEN dig_4 =>
				EAN_NUMBER(0) := "0100";
				WRITE(out_line, 4);
				WRITELINE(ean_final, out_line);
			WHEN dig_5 =>
				EAN_NUMBER(0) := "0101";
				WRITE(out_line, 5);
				WRITELINE(ean_final, out_line);
			WHEN dig_6 =>
				EAN_NUMBER(0) := "0110";
				WRITE(out_line, 6);
				WRITELINE(ean_final, out_line);
			WHEN dig_7 =>
				EAN_NUMBER(0) := "0111";
				WRITE(out_line, 7);
				WRITELINE(ean_final, out_line);
			WHEN dig_8 =>
				EAN_NUMBER(0) := "1000";
				WRITE(out_line, 8);
				WRITELINE(ean_final, out_line);
			WHEN dig_9 =>
				EAN_NUMBER(0) := "1001";
				WRITE(out_line, 9);
				WRITELINE(ean_final, out_line);
			WHEN OTHERS =>
				WRITE(out_line, err_line);
				WRITELINE(ean_final, out_line);
		END CASE;
		
		ASSERT FALSE REPORT "Simulation done" SEVERITY NOTE;
		
		FOR i IN 0 TO 12 LOOP
			WRITE(out_line, EAN_NUMBER(i));
			WRITELINE(ean_final, out_line);
		END LOOP;
		
		WAIT;  --allows the simulation to halt!
END PROCESS;
END beh;