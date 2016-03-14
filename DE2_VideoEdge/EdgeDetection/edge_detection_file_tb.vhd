library IEEE;
use IEEE.Std_logic_1164.all;
use std.textio.all;
use ieee.numeric_std.all;
use work.io_utils.all;

entity edge_detection_file_tb is
    GENERIC (
	     image_width	:INTEGER								:= 272;   -- Image width in pixels
	     image_height:INTEGER        := 265;   -- Image height in pixels
	     --image_width	:INTEGER								:= 720; -- Image width in pixels
	     --image_height:INTEGER        := 20;  -- Image height in pixels
	     image_frames:INTEGER        := 1;   -- Number of frames in video sequence
       image_name: string          := "ImageIn.txt"; -- Contains image as text hex input format
       image_outName: string       := "ImageOut.txt"
    );
end;

architecture bench of edge_detection_file_tb is

  component altera_up_avalon_video_edge_detection
    GENERIC (
	     WIDTH	:INTEGER									:= 720 -- Image width in pixels
    );
    -- *****************************************************************************
    -- *                             Port Declarations                             *
    -- *****************************************************************************
    PORT (
	     -- Inputs
	     clk					          :IN		STD_LOGIC;
	     reset					        :IN		STD_LOGIC;

	     in_data				       :IN		STD_LOGIC_VECTOR( 7 DOWNTO  0);	
	     in_startofpacket	 :IN		STD_LOGIC;
	     in_endofpacket		  :IN		STD_LOGIC;
	     in_valid				      :IN		STD_LOGIC;

	     out_ready			      :IN		STD_LOGIC;

	     bypass            :IN      STD_LOGIC;

	     
	     -- Outputs
	     in_ready				      :BUFFER	STD_LOGIC;

	     out_data				      :BUFFER	STD_LOGIC_VECTOR( 7 DOWNTO  0);	
	     out_startofpacket	:BUFFER	STD_LOGIC;
	     out_endofpacket	  :BUFFER	STD_LOGIC;
	     out_valid			      :BUFFER	STD_LOGIC
    );
  end component;

  signal reset                    : std_logic                     := '1';
  signal clk                      : std_logic                     := '0';
  signal bypass                   : std_logic                     := '0';
  signal ast_sink_data            : std_logic_vector(7 downto 0) := (others => 'U');
  signal ast_sink_ready           : std_logic                     := 'U';
  signal ast_sink_valid           : std_logic                     := 'U';
  signal ast_sink_startofpacket   : std_logic                     := 'U';
  signal ast_sink_endofpacket     : std_logic                     := 'U';
  signal ast_source_data          : std_logic_vector(7 downto 0);
  signal ast_source_ready         : std_logic                     := 'U';
  signal ast_source_valid         : std_logic;
  signal ast_source_startofpacket : std_logic                     := 'U';
  signal ast_source_endofpacket   : std_logic                     := 'U';

  -- clock
  constant clockperiod  : time := 10 ns;  -- clk period time
  
begin

  edge_detection_inst : altera_up_avalon_video_edge_detection
    generic map (
      WIDTH => image_width)
    port map (
      clk                 => clk,       --48KHz Clock
      reset               => reset,
      out_data            => ast_sink_data,
      out_ready           => ast_sink_ready,
      out_valid           => ast_sink_valid,
      out_startofpacket   => ast_sink_startofpacket,
      out_endofpacket     => ast_sink_endofpacket,
      
      bypass              => bypass,

      in_data             => ast_source_data,
      in_ready            => ast_source_ready,
      in_valid            => ast_source_valid,
      in_startofpacket    => ast_source_startofpacket,
      in_endofpacket      => ast_source_endofpacket);

  -- clock generation
  clk <= not clk after clockperiod/2;

  -- reset generation
  reset         <= '1', '0' after 125 ns;
  bypass <= '0';

  -----------------------------------------------------------------------------
  -- This is an example of a test bench process that 
  -- simulates an interface easily, but is absolutely
  -- not synthesizable
  -- It creates a stream of video data to the ST bus
  -----------------------------------------------------------------------------
  genVideoSTData : process
    variable pixelcount : integer range 0 to image_width;
    variable linecount : integer range 0 to image_height;
    variable framecount : integer range 0 to image_frames;
     -- files
    variable line: LINE;
    variable data: integer;
    variable val: signed(31 downto 0);
    file videoinfile: TEXT open read_mode is image_name;
 begin

    -- Open simulation files
    file_open(videoinfile, image_name);

    wait until reset = '0'; -- reset
    ast_sink_ready <= '1';
    ast_source_valid <= '0';    
    ast_source_endofpacket <= '0';
    ast_source_startofpacket <= '0';    
    wait for 3*clockperiod; -- one clock periode idle before start 
    
    -- Read video 
    while not endfile(videoinfile) loop
  
      for framecount in image_frames-1 downto 0 loop -- Loop sending video frames
        
        ast_source_valid <= '1'; -- start sending valid package   
        wait until ast_source_ready = '1'; -- wait for ready signal
        ast_source_startofpacket <= '1'; -- start of package (frame) 
           
        for pixelcount in image_width-1 downto 0 loop
          for linecount in image_height-1 downto 0 loop
            
            if not endfile(videoinfile) then
              readline(videoinfile, line); -- read next text line from file
              --read(line, data, 16); -- convert hex (16) numbers to integer value
              read(line, data, 10); -- convert decimal (10) numbers to integer value
              ast_source_data <= std_logic_vector(TO_SIGNED(data, 8)); -- convert to audio 8 bit 
                     
              if linecount = 0 and pixelcount = 0 then -- last pixel in frame
                ast_source_endofpacket <= '1';
              end if;
      
              wait for clockperiod;
              ast_source_startofpacket <= '0';
            end if;
            
          end loop; -- rows
        end loop; -- columns
        
    
        ast_source_endofpacket <= '0';
        ast_source_valid <= '0';
        
        wait for 3*clockperiod;
        
      end loop; -- video frames
  
    end loop; -- reading video file

    file_close(videoinfile);  
    
  end process;

-------------------------------------------------------------------------------
-- Monitor process
-- Does nothing but wait
-------------------------------------------------------------------------------
  monitor : process
    variable line: LINE;
    variable data: integer;
    file videooutfile: TEXT open write_mode is image_outName;
  begin

    -- Create simulation files    
    file_open(videooutfile, image_outName);
    
    wait until reset = '0';
    
    -- Wait to receive one frame of video
    wait until ast_sink_startofpacket = '1';
    wait until clk = '1';
    wait until clk = '0';
    while ast_sink_valid = '1' loop
      data := TO_INTEGER(signed(ast_sink_data));
      write(line, data, right, 0, decimal); -- convert to decimal numbers
      -- Frame pixels stored in file
      writeline(videooutfile, line); -- read next text line from file
      wait until clk = '1';
      wait until clk = '0';
    end loop;

    file_close(videooutfile);  
    
    wait;
  end process;

end;  -- Architecture


-------------------------------------------------------------------------------
-- Functional simulation of iis/st-bus bridge
-------------------------------------------------------------------------------
configuration video_file_sim_cfg of edge_detection_file_tb is    -- config name of arch
  for bench                                            -- TB architecture name
    for edge_detection_inst : altera_up_avalon_video_edge_detection             -- For the specific instance
      use entity work.altera_up_avalon_video_edge_detection(Behaviour);         -- use its "Behaviour" arch
    end for;
  end for;
end video_file_sim_cfg;


-------------------------------------------------------------------------------

