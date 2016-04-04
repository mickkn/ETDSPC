library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Video_Edge_Detection is

-------------------------------------------------------------------------------
--							 Port Declarations							 --
-------------------------------------------------------------------------------
port (
	-- Clock Inputs
	CLOCK_50			: in std_logic;
	CLOCK_27			: in std_logic;
	--TD_CLK27       : in std_logic;

	-- Key SW Inputs
	KEY			  		: in std_logic_vector (3 downto 0);
	SW			   		: in std_logic_vector (17 downto 0);
	LEDR           		: out std_logic_vector (17 downto 0);
	LEDG           		: out std_logic_vector (8 downto 0);

	--  Video In
	--TD_DATA        : in std_logic_vector (7 downto 0);
	--TD_HS				: in std_logic;
	--TD_VS				: in std_logic;
	--TD_RESET			: out std_logic;
	-- Video M5D In
	GPIO_1         : inout std_logic_vector (0 to 24);
	
	-- SD Cart interface
	SD_DAT			: inout std_logic;
	SD_DAT3			: inout std_logic;
	SD_CMD         	: inout std_logic;
	SD_CLK         	: out std_logic;

	--  AV Config
	--I2C_SDAT			: inout std_logic;
	--I2C_SCLK			: out std_logic;

	--  Memory (SRAM)
	SRAM_DQ			: inout std_logic_vector (15 downto 0);
	SRAM_ADDR		: out std_logic_vector (17 downto 0);
	SRAM_CE_N		: out std_logic;
	SRAM_WE_N		: out std_logic;
	SRAM_OE_N		: out std_logic;
	SRAM_UB_N		: out std_logic;
	SRAM_LB_N		: out std_logic;
	
	--  Memory (SDRAM)
	DRAM_CLK       	: out   std_logic;
	DRAM_ADDR      	: out   std_logic_vector(11 downto 0); 		-- addr
	DRAM_BA_0      	: out   std_logic;                     		-- ba
	DRAM_BA_1      	: out   std_logic;                     		-- ba
	DRAM_CAS_N     	: out   std_logic;                                        -- cas_n
	DRAM_CKE       	: out   std_logic;                                        -- cke
	DRAM_CS_N      	: out   std_logic;                                        -- cs_n
	DRAM_DQ        	: inout std_logic_vector(15 downto 0);                    -- dq
 	DRAM_LDQM      	: out   std_logic;
	DRAM_UDQM      	: out   std_logic;
	DRAM_RAS_N     	: out   std_logic;                                        -- ras_n
	DRAM_WE_N      	: out   std_logic;                                        -- we_n
	
	--  VGA
	VGA_CLK			: out std_logic;
	VGA_HS			: out std_logic;
	VGA_VS			: out std_logic;
	VGA_BLANK		: out std_logic;
	VGA_SYNC		: out std_logic;
	VGA_R			: out std_logic_vector (9 downto 0);
	VGA_G			: out std_logic_vector (9 downto 0);
	VGA_B			: out std_logic_vector (9 downto 0);

	--  Char LCD 16x2
	LCD_ON			: out std_logic;
	LCD_BLON		: out std_logic;
	LCD_DATA       	: inout std_logic_vector (7 downto 0);
	LCD_EN			: out std_logic;
	LCD_RS			: out std_logic;
	LCD_RW			: out std_logic
	
	);
end Video_Edge_Detection;


architecture Video_Edge_Detection_rtl of Video_Edge_Detection is
	
-------------------------------------------------------------------------------
--						   Parameter Declarations						  --
-------------------------------------------------------------------------------
	component SOPC_Video is
        port (
            VGA_CLK_from_the_VGA_Controller                     : out   std_logic;                                        -- CLK
            VGA_HS_from_the_VGA_Controller                      : out   std_logic;                                        -- HS
            VGA_VS_from_the_VGA_Controller                      : out   std_logic;                                        -- VS
            VGA_BLANK_from_the_VGA_Controller                   : out   std_logic;                                        -- BLANK
            VGA_SYNC_from_the_VGA_Controller                    : out   std_logic;                                        -- SYNC
            VGA_R_from_the_VGA_Controller                       : out   std_logic_vector(9 downto 0);                     -- R
            VGA_G_from_the_VGA_Controller                       : out   std_logic_vector(9 downto 0);                     -- G
            VGA_B_from_the_VGA_Controller                       : out   std_logic_vector(9 downto 0);                     -- B
            clk_0                                               : in    std_logic                     := 'X';             -- clk
            reset_n                                             : in    std_logic                     := 'X';             -- reset_n
            I2C_SDAT_to_and_from_the_AV_Config                  : inout std_logic                     := 'X';             -- SDAT
            I2C_SCLK_from_the_AV_Config                         : out   std_logic;                                        -- SCLK
            SRAM_DQ_to_and_from_the_Pixel_Buffer                : inout std_logic_vector(15 downto 0) := (others => 'X'); -- DQ
            SRAM_ADDR_from_the_Pixel_Buffer                     : out   std_logic_vector(17 downto 0);                    -- ADDR
            SRAM_LB_N_from_the_Pixel_Buffer                     : out   std_logic;                                        -- LB_N
            SRAM_UB_N_from_the_Pixel_Buffer                     : out   std_logic;                                        -- UB_N
            SRAM_CE_N_from_the_Pixel_Buffer                     : out   std_logic;                                        -- CE_N
            SRAM_OE_N_from_the_Pixel_Buffer                     : out   std_logic;                                        -- OE_N
            SRAM_WE_N_from_the_Pixel_Buffer                     : out   std_logic;                                        -- WE_N
            Video_In_Decoder_external_interface_PIXEL_CLK       : in    std_logic                     := 'X';             -- PIXEL_CLK
            Video_In_Decoder_external_interface_LINE_VALID      : in    std_logic                     := 'X';             -- LINE_VALID
            Video_In_Decoder_external_interface_FRAME_VALID     : in    std_logic                     := 'X';             -- FRAME_VALID
            Video_In_Decoder_external_interface_pixel_clk_reset : in    std_logic                     := 'X';             -- pixel_clk_reset
            Video_In_Decoder_external_interface_PIXEL_DATA      : in    std_logic_vector(11 downto 0) := (others => 'X'); -- PIXEL_DATA
            vga_clk                                             : out   std_logic;                                        -- clk
            sdram_wire_addr                                     : out   std_logic_vector(11 downto 0);                    -- addr
            sdram_wire_ba                                       : out   std_logic_vector(1 downto 0);                     -- ba
            sdram_wire_cas_n                                    : out   std_logic;                                        -- cas_n
            sdram_wire_cke                                      : out   std_logic;                                        -- cke
            sdram_wire_cs_n                                     : out   std_logic;                                        -- cs_n
            sdram_wire_dq                                       : inout std_logic_vector(15 downto 0) := (others => 'X'); -- dq
            sdram_wire_dqm                                      : out   std_logic_vector(1 downto 0);                     -- dqm
            sdram_wire_ras_n                                    : out   std_logic;                                        -- ras_n
            sdram_wire_we_n                                     : out   std_logic;                                        -- we_n
            lcd_ext_RS                                          : out   std_logic;                                        -- RS
            lcd_ext_RW                                          : out   std_logic;                                        -- RW
            lcd_ext_data                                        : inout std_logic_vector(7 downto 0)  := (others => 'X'); -- data
            lcd_ext_E                                           : out   std_logic;                                        -- E
            red_leds_ext_export                                 : out   std_logic_vector(7 downto 0);                     -- export
            green_leds_ext_export                               : out   std_logic_vector(7 downto 0);                     -- export
            switch_ext_export                                   : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- export
            altera_up_sd_card_b_SD_cmd                          : inout std_logic                     := 'X';             -- b_SD_cmd
            altera_up_sd_card_b_SD_dat                          : inout std_logic                     := 'X';             -- b_SD_dat
            altera_up_sd_card_b_SD_dat3                         : inout std_logic                     := 'X';             -- b_SD_dat3
            altera_up_sd_card_o_SD_clock                        : out   std_logic;                                        -- o_SD_clock
            sdram_clk_clk                                       : out   std_logic;                                        -- clk
            test_export                                         : out   std_logic_vector(7 downto 0)                      -- export
	  
	);                           
	end component;
-- Internal Registers

   signal video_data : std_logic_vector (11 downto 0);
-- State Machine Registers

  -- Interface to video processing module
  signal video_clk                  : std_logic;
  signal video_reset                : std_logic;
  signal video_sink_data            : std_logic_vector(7 downto 0);
  signal video_sink_startofpacket   : std_logic;
  signal video_sink_endofpacket     : std_logic;
  signal video_sink_valid           : std_logic;
  signal video_sink_ready           : std_logic;
  signal video_source_data          : std_logic_vector(7 downto 0);
  signal video_source_startofpacket : std_logic;
  signal video_source_endofpacket   : std_logic;
  signal video_source_valid         : std_logic;
  signal video_source_ready         : std_logic;  

	-- Set true to use MyMult
  constant USE_EXT_FILTER : boolean := false;



begin

	
-------------------------------------------------------------------------------
--						 Finite State Machine(s)						   --
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
--							 Sequential Logic							  --
-------------------------------------------------------------------------------
	
-------------------------------------------------------------------------------
--							Combinational Logic							--
-------------------------------------------------------------------------------

   video_data <= GPIO_1(1) & GPIO_1(3 to 13); -- Video data from Camera
	GPIO_1(17) <= KEY(1); -- Reset of Camera
	GPIO_1(19) <= SW(1); -- Trigger of Camera
	
	
	
	LCD_ON <= '1';
	LCD_BLON <= '1';

-- TD_RESET   <= '1';

-------------------------------------------------------------------------------
--							  Internal Modules							 --
-------------------------------------------------------------------------------

NiosVideo : SOPC_Video port map(
	clk_0											=>	CLOCK_50,
	reset_n										=>	KEY(0),

	-- the_Pixel_Buffer
	SRAM_DQ_to_and_from_the_Pixel_Buffer =>SRAM_DQ,
	SRAM_ADDR_from_the_Pixel_Buffer		=>SRAM_ADDR,
	SRAM_LB_N_from_the_Pixel_Buffer		=>SRAM_LB_N,
	SRAM_UB_N_from_the_Pixel_Buffer		=>SRAM_UB_N,
	SRAM_CE_N_from_the_Pixel_Buffer		=>SRAM_CE_N,
	SRAM_OE_N_from_the_Pixel_Buffer		=>SRAM_OE_N,
	SRAM_WE_N_from_the_Pixel_Buffer		=>SRAM_WE_N,

	--TEST
	test_export => LEDR(7 DOWNTO 0),
	
	-- the_Video_In_Decoder
	--TD_CLK27_to_the_Video_In_Decoder		=>CLOCK_27,
	--TD_DATA_to_the_Video_In_Decoder		=>TD_DATA,
	--TD_HS_to_the_Video_In_Decoder			=>TD_HS,
	   --TD_RESET_from_the_Video_In_Decoder	=>,
	--TD_VS_to_the_Video_In_Decoder			=>TD_VS,
	
	-- the_Video IN M5D
	Video_In_Decoder_external_interface_PIXEL_CLK   => GPIO_1(0),    -- Video pixel clk
	Video_In_Decoder_external_interface_LINE_VALID  => GPIO_1(21),   -- New line from Camera                                  .LINE_VALID
	Video_In_Decoder_external_interface_FRAME_VALID => GPIO_1(22),   -- New frame from Camera                                   .FRAME_VALID
	Video_In_Decoder_external_interface_PIXEL_DATA  => video_data,   -- Video data from Camera                                   .PIXEL_DATA
 
	-- the_AV_Config
	--I2C_SCLK_from_the_AV_Config			=>I2C_SCLK,
	--I2C_SDAT_to_and_from_the_AV_Config	=>I2C_SDAT,
	I2C_SCLK_from_the_AV_Config				=>GPIO_1(24),
	I2C_SDAT_to_and_from_the_AV_Config		=>GPIO_1(23),

	-- the_vga_controller
	VGA_CLK_from_the_VGA_Controller			=>VGA_CLK,
	VGA_HS_from_the_VGA_Controller			=>VGA_HS,
	VGA_VS_from_the_VGA_Controller			=>VGA_VS,
	VGA_BLANK_from_the_VGA_Controller		=>VGA_BLANK,
	VGA_SYNC_from_the_VGA_Controller		=>VGA_SYNC,
	VGA_R_from_the_VGA_Controller			=>VGA_R,
	VGA_G_from_the_VGA_Controller			=>VGA_G,
	VGA_B_from_the_VGA_Controller			=>VGA_B,
	vga_clk => GPIO_1(16),
	--bypass_export => SW(0),
	
	sdram_wire_addr                     => DRAM_ADDR,                                 --                          sdram_wire.addr
	sdram_wire_ba(1)                    => DRAM_BA_1,                   --                                    .ba
	sdram_wire_ba(0)                    => DRAM_BA_0,                   --                                    .ba
	sdram_wire_cas_n                    => DRAM_CAS_N,                                --                                    .cas_n
	sdram_wire_cke                      => DRAM_CKE,                                  --                                    .cke
	sdram_wire_cs_n                     => DRAM_CS_N,                                 --                                    .cs_n
	sdram_wire_dq                       => DRAM_DQ,                                   --                                    .dq
	sdram_wire_dqm(1)                   => DRAM_UDQM,                   --                                    .dqm
	sdram_wire_dqm(0)                   => DRAM_LDQM,                   --                                    .dqm
	sdram_wire_ras_n                    => DRAM_RAS_N,                                --                                    .ras_n
	sdram_wire_we_n                     => DRAM_WE_N,                                 --                                    .we_n

	lcd_ext_data                        => LCD_DATA,                                  --                             lcd_ext.data
	lcd_ext_E                           => LCD_EN,                                    --                                    .E
	lcd_ext_RS                          => LCD_RS,                                    --                                    .RS
	lcd_ext_RW                          => LCD_RW,                                    --                                    .RW

	--red_leds_ext_export                 => LEDR(7 downto 0),                          --                        red_leds_ext.export
	green_leds_ext_export               => LEDG(7 downto 0),                          --                      green_leds_ext.export
	switch_ext_export                   => SW(9 downto 2),                           --                          switch_ext.export

	altera_up_sd_card_b_SD_cmd          => SD_CMD,                      --                   altera_up_sd_card.b_SD_cmd
	altera_up_sd_card_b_SD_dat          => SD_DAT,                      --                                    .b_SD_dat
	altera_up_sd_card_b_SD_dat3         => SD_DAT3,                     --                                    .b_SD_dat3
	altera_up_sd_card_o_SD_clock        => SD_CLK,                     --                                    .o_SD_clock
    sdram_clk_clk                       => DRAM_CLK
	-- st_bus_clk                   => video_clk,
    -- st_bus_reset                 => video_reset,
    -- st_bus_sink_data             => video_sink_data,
    -- st_bus_sink_startofpacket    => video_sink_startofpacket,
    -- st_bus_sink_endofpacket      => video_sink_endofpacket,
    -- st_bus_sink_valid            => video_sink_valid,
    -- st_bus_sink_ready            => video_sink_ready,       
    -- st_bus_source_data           => video_source_data,      
    -- st_bus_source_startofpacket  => video_source_startofpacket,
    -- st_bus_source_endofpacket    => video_source_endofpacket,  
    -- st_bus_source_valid          => video_source_valid,
    -- st_bus_source_ready          => video_source_ready  
);


  -- GenExtVideoProcessor : if (USE_EXT_FILTER = true) generate
	
  -- video_processing_1: entity work.altera_up_avalon_video_edge_detection
    -- generic map (
      -- WIDTH => 640)
    -- port map (
      -- clk               => video_clk,
      -- reset             => video_reset,
      -- in_data           => video_source_data,
      -- in_startofpacket  => video_source_startofpacket,
      -- in_endofpacket    => video_source_endofpacket,
      -- in_valid          => video_source_valid,
      -- out_ready         => video_sink_ready,       
      -- bypass            => SW(0),
      -- in_ready          => video_source_ready,
      -- out_data          => video_sink_data,      
      -- out_startofpacket => video_sink_startofpacket,
      -- out_endofpacket   => video_sink_endofpacket,  
      -- out_valid         => video_sink_valid
	 -- );                    

  -- end generate;


end Video_Edge_Detection_rtl;