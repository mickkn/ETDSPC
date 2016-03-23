LIBRARY IEEE,STD;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE STD.TEXTIO.ALL;

ENTITY pixel_scan IS
END pixel_scan;



ARCHITECTURE beh OF pixel_scan IS

TYPE STD_LOGIC_ARRAY IS ARRAY (94 DOWNTO 0) OF INTEGER;

SIGNAL counter	  	  : STD_LOGIC_VECTOR(15 downto 0) := X"0000";

BEGIN
file_io:
PROCESS IS
	FILE in_file          	: TEXT OPEN READ_MODE  IS "ImageIn.txt";
	FILE out_file         	: TEXT OPEN WRITE_MODE IS "out_values.txt";
	FILE bar_file         	: TEXT OPEN WRITE_MODE IS "bar_values.txt";
	
	CONSTANT pic_width 		: INTEGER := 920;		--known value
	CONSTANT pic_height		: INTEGER := 696;		--known value 
	CONSTANT w_th			: INTEGER := 200;		--white threshold
	CONSTANT b_th			: INTEGER := 50;		--black threshold 
	
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
	VARIABLE bar_array 	    : STD_LOGIC_ARRAY;
	VARIABLE start_decode 	: INTEGER := 0;
	
	VARIABLE s_value 		: INTEGER := 0;
	
	BEGIN
		-- WHILE NOT ENDFILE(in_file) LOOP 		--do this till out of data
		
			-- -- HOP NED PÅ MIDTEN/VENSTRE DEL AF BILLEDET
			
			-- READLINE(in_file, in_line);    		--one pixel starting from upper left corner
			-- READ(in_line, value);               --get first operand
			
			-- IF (init_count = 0) THEN
			
				-- IF (value < b_th) THEN				--if black
					-- IF (bar_count = 0) THEN			--first bar
						-- b_count := b_count + 1;
						-- b_found := 1;
					-- END IF;
				-- END IF;
				
				-- IF (value > w_th) THEN 				--if white
					-- IF (b_found = 1) THEN			--only when black is found
						-- b_var1 := b_count;
						-- b_count := 0;
						-- b_found := 0;				--Ready for second black bar
						-- bar_count := 1;				--First black bar logged
						-- w_found := 1;
					-- END IF;
				-- END IF;
				
				-- IF (value < b_th) THEN				--if black
					-- IF (w_found = 1) THEN			--second bar
						-- IF (b_found = 0) THEN
							-- b_count := b_count + 1;
							-- bar_count := 2;
						-- END IF;
					-- END IF;
				-- END IF;
				
				-- IF (value > w_th) THEN 				--if white
					-- IF (bar_count = 2) THEN			--only when black is found two times
						-- b_var2 := b_count;
						-- b_count := 0;
						-- b_found := 0;				--Ready for second black bar
						-- bar_count := 2;				--First black bar logged
						-- init_count := 1;
					-- END IF;
				-- END IF;
			-- END IF;
		-- END LOOP;
		
		-- IF(b_var1 = b_var2) THEN
		
		-- bar_width := b_var1;
		
		-- WRITE(out_line, bar_width);
		-- WRITELINE(out_file, out_line);  		--write line to file
		
		-- ELSE
		
		-- WRITE(out_line, err_line);
		-- WRITELINE(out_file, out_line);
		
		-- END IF;
		
		WHILE NOT ENDFILE(in_file) LOOP
		
			-- HOP NED PÅ MIDTEN/VENSTRE DEL AF BILLEDET HER 
			
			IF (start_decode = 0) THEN
				READLINE(in_file, in_line);    		--one pixel starting from upper left corner
				READ(in_line, value);               --get first operand
			END IF;
		
			IF (value < b_th) THEN					--if black
				IF (start_decode = 0) THEN
					start_decode := 1;				--start decode
				END IF;
			END IF;
			
			
			
			IF (start_decode = 1) THEN
				FOR i IN 0 TO 94 LOOP
					FOR c IN 1 TO bar_width LOOP
						IF (value < b_th) THEN
							s_value := 0;
						ELSE				-- white threshold not checked
							s_value := 1;
						END IF;
						bar := bar + s_value;
						READLINE(in_file, in_line);    		--one pixel starting from upper left corner
						READ(in_line, value);               --get first operand
					END LOOP;
				
				--bar := bar / bar_width;
				bar_array(i) := bar;
				
				WRITE(out_line, bar);
				WRITELINE(bar_file, out_line);
				
				END LOOP;
			END IF;
		END LOOP;
		
		
		
		
		ASSERT FALSE REPORT "Simulation done" SEVERITY NOTE;
		
		WAIT;  --allows the simulation to halt!
END PROCESS;
END beh;