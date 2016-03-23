LIBRARY IEEE,STD;
-- USE IEEE.STD_LOGIC_1164.ALL;
-- USE IEEE.STD_LOGIC_TEXTIO.ALL;
-- USE IEEE.STD_LOGIC_UNSIGNED.ALL;
-- USE STD.TEXTIO.ALL;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE STD.TEXTIO.ALL;
--use work.io_utils.all;

ENTITY pixel_scan_tb IS
    GENERIC (
	    image_width			: INTEGER		:= 920;   			-- Image width in pixels
	    image_height		: INTEGER       := 696;   			-- Image height in pixels
	    image_frames		: INTEGER       := 1;   			-- Number of frames in video sequence
		image_name			: string        := "ImageIn.txt"; 	-- Contains image as text hex input format
		image_outName		: string       	:= "ImageOut.txt");
END;

ARCHITECTURE bench OF pixel_scan_tb IS

	COMPONENT pixel_scan
		
	
		PORT (
		clk              			: IN  std_logic;
		reset_n          			: IN  std_logic;
			
		ast_sink_data    			: IN  std_logic_vector(31 downto 0);
		ast_sink_ready   			: OUT std_logic;
		ast_sink_valid   			: IN  std_logic;
		ast_sink_startofpacket  	: IN  std_logic;
		ast_sink_endofpacket 		: IN  std_logic;
		
		--bidirectional
		ast_source_data  			: OUT std_logic_vector(31 downto 0);
		ast_source_ready 			: IN std_logic;
		ast_source_valid 			: OUT std_logic;
		ast_source_startofpacket	: OUT std_logic;
		ast_source_endofpacket 		: OUT std_logic;
		
		debug_state					: BUFFER STD_LOGIC_VECTOR(7 DOWNTO 0));
		
	END COMPONENT;

	SIGNAL reset_n                  : std_logic                     := '1';
	SIGNAL clk                      : std_logic                     := '0';

	SIGNAL ast_sink_data            : std_logic_vector(31 DOWNTO 0) := (OTHERS => 'U');
	SIGNAL ast_sink_ready           : std_logic                     := 'U';
	SIGNAL ast_sink_valid           : std_logic                     := 'U';
	SIGNAL ast_sink_startofpacket   : std_logic                     := 'U';
	SIGNAL ast_sink_endofpacket     : std_logic                     := 'U';

	SIGNAL ast_source_data          : std_logic_vector(31 DOWNTO 0);
	SIGNAL ast_source_ready         : std_logic                     := 'U';
	SIGNAL ast_source_valid         : std_logic;
	SIGNAL ast_source_startofpacket : std_logic                     := 'U';
	SIGNAL ast_source_endofpacket   : std_logic                     := 'U';
	
	SIGNAL debug_state				: STD_LOGIC_VECTOR(7 DOWNTO 0);
	
	-- clock
	CONSTANT clockperiod  : time := 10 ns;  -- clk period time
	
	
BEGIN

	pixel_scan_ins : pixel_scan
	port map (
		clk        				=> clk,       
		reset_n          			=> reset_n,
		
		ast_source_data			=> ast_sink_data,
		ast_source_ready  		=> ast_sink_ready,
		ast_source_valid  		=> ast_sink_valid,
		ast_source_startofpacket 	=> ast_sink_startofpacket,
		ast_source_endofpacket  	=> ast_sink_endofpacket,
		
		ast_sink_data 			=> ast_source_data,
		ast_sink_ready 			=> ast_source_ready,
		ast_sink_valid 			=> ast_source_valid,
		ast_sink_startofpacket	=> ast_source_startofpacket,
		ast_sink_endofpacket	=> ast_source_endofpacket,

		debug_state				=> debug_state);
	  
	-- clock generation
	clk <= not clk after clockperiod/2;

	-- reset generation
	reset_n	<= '1', '0' AFTER 125 ns;
	
	generate_frames:
	PROCESS
	
		VARIABLE pixelcount : integer RANGE 0 TO image_width;
		VARIABLE linecount 	: integer RANGE 0 TO image_height;
		VARIABLE framecount : integer RANGE 0 TO image_frames;
		
		 -- files
		VARIABLE line		: LINE;
		VARIABLE data		: INTEGER;
		VARIABLE val		: SIGNED(31 DOWNTO 0);
		FILE videoinfile	: TEXT OPEN read_mode IS image_name;
	
	BEGIN
		-- Open simulation files
		FILE_OPEN(videoinfile, image_name);

		WAIT UNTIL reset_n = '0'; -- reset
		ast_sink_ready <= '1';
		ast_source_valid <= '0';    
		ast_source_endofpacket <= '0';
		ast_source_startofpacket <= '0';    
		WAIT FOR 3*clockperiod; -- one clock periode idle before start 

		-- Read video 
		WHILE NOT ENDFILE(videoinfile) LOOP

			FOR framecount IN image_frames-1 DOWNTO 0 LOOP -- Loop sending video frames
			
				ast_source_valid <= '1'; -- start sending valid package   
				WAIT UNTIL ast_source_ready = '1'; -- wait for ready signal
				ast_source_startofpacket <= '1'; -- start of package (frame) 
				   
				FOR linecount IN image_height-1 DOWNTO 0 LOOP
					FOR pixelcount IN image_width-1 DOWNTO 0 LOOP
					
						IF NOT ENDFILE(videoinfile) THEN
							READLINE(videoinfile, line); -- read next text line from file
							READ(line, data); -- convert decimal (10) numbers to integer value
							ast_source_data <= std_logic_vector(TO_SIGNED(data, 32)); 
								 
							IF linecount = 0 and pixelcount = 0 THEN -- last pixel in frame
								ast_source_endofpacket <= '1';
							END IF;
				  
							WAIT FOR clockperiod;
							ast_source_startofpacket <= '0';
						END IF;
						
					END LOOP; -- rows
				end loop; -- columns
				
				ast_source_endofpacket <= '0';
				ast_source_valid <= '0';
				
				wait for 3*clockperiod;
			
			end loop; -- video frames

		end loop; -- reading video file

		file_close(videoinfile);  
    
	END PROCESS;
END bench;