LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_misc.all;

-- ******************************************************************************
-- * License Agreement                                                          *
-- *                                                                            *
-- * Copyright (c) 1991-2013 Altera Corporation, San Jose, California, USA.     *
-- * All rights reserved.                                                       *
-- *                                                                            *
-- * Any megafunction design, and related net list (encrypted or decrypted),    *
-- *  support information, device programming or simulation file, and any other *
-- *  associated documentation or information provided by Altera or a partner   *
-- *  under Altera's Megafunction Partnership Program may be used only to       *
-- *  program PLD devices (but not masked PLD devices) from Altera.  Any other  *
-- *  use of such megafunction design, net list, support information, device    *
-- *  programming or simulation file, or any other related documentation or     *
-- *  information is prohibited for any other purpose, including, but not       *
-- *  limited to modification, reverse engineering, de-compiling, or use with   *
-- *  any other silicon devices, unless such use is explicitly licensed under   *
-- *  a separate agreement with Altera or a megafunction partner.  Title to     *
-- *  the intellectual property, including patents, copyrights, trademarks,     *
-- *  trade secrets, or maskworks, embodied in any such megafunction design,    *
-- *  net list, support information, device programming or simulation file, or  *
-- *  any other related documentation or information provided by Altera or a    *
-- *  megafunction partner, remains with Altera, the megafunction partner, or   *
-- *  their respective licensors.  No other licenses, including any licenses    *
-- *  needed under any third party's intellectual property, are provided herein.*
-- *  Copying or modifying any file, or portion thereof, to which this notice   *
-- *  is attached violates this copyright.                                      *
-- *                                                                            *
-- * THIS FILE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR    *
-- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,   *
-- * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL    *
-- * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER *
-- * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING    *
-- * FROM, OUT OF OR IN CONNECTION WITH THIS FILE OR THE USE OR OTHER DEALINGS  *
-- * IN THIS FILE.                                                              *
-- *                                                                            *
-- * This agreement shall be governed in all respects by the laws of the State  *
-- *  of California and by the laws of the United States of America.            *
-- *                                                                            *
-- ******************************************************************************

-- ******************************************************************************
-- *                                                                            *
-- * This module sends and receives data from the audio's and TV in's           *
-- *  control registers for the chips on Altera's DE2 board. Plus, it can       *
-- *  send and receive data from the TRDB_DC2 and TRDB_LCM add-on modules.      *
-- *                                                                            *
-- ******************************************************************************

ENTITY SOPC_Video_AV_Config IS

-- *****************************************************************************
-- *                             Generic Declarations                          *
-- *****************************************************************************
	

-- *****************************************************************************
-- *                             Port Declarations                             *
-- *****************************************************************************
PORT (
	-- Inputs
	clk			:IN		STD_LOGIC;
	reset			:IN		STD_LOGIC;

	address		:IN		STD_LOGIC_VECTOR( 1 DOWNTO  0);	
	byteenable	:IN		STD_LOGIC_VECTOR( 3 DOWNTO  0);	
	read			:IN		STD_LOGIC;
	write			:IN		STD_LOGIC;
	writedata	:IN		STD_LOGIC_VECTOR(31 DOWNTO  0);	


	-- Bidirectionals
	I2C_SDAT		:INOUT	STD_LOGIC;

	-- Outputs
	readdata		:BUFFER	STD_LOGIC_VECTOR(31 DOWNTO  0);	
	waitrequest	:BUFFER	STD_LOGIC;
	irq			:BUFFER	STD_LOGIC;

	I2C_SCEN		:BUFFER	STD_LOGIC;
	I2C_SCLK		:BUFFER	STD_LOGIC

);

END SOPC_Video_AV_Config;

ARCHITECTURE Behaviour OF SOPC_Video_AV_Config IS
-- *****************************************************************************
-- *                           Constant Declarations                           *
-- *****************************************************************************
		
	CONSTANT	DW								:INTEGER									:= 35;	-- Serial protocol's datawidth
	
	CONSTANT	CFG_TYPE						:STD_LOGIC_VECTOR(7 DOWNTO 0)		:= B"00010001";
	
	CONSTANT	READ_MASK					:STD_LOGIC_VECTOR(26 DOWNTO 0)	:= B"00000000" & '1' & B"11111111" & '0' & B"00000000" & '1';
	CONSTANT	WRITE_MASK					:STD_LOGIC_VECTOR(26 DOWNTO 0)	:= B"00000000" & '1' & B"00000000" & '1' & B"00000000" & '1';
	
	CONSTANT	RESTART_COUNTER			:STD_LOGIC_VECTOR(4 DOWNTO 0)		:= (0 => '1', 3 => '1', OTHERS => '0'); -- (SBCW DOWNTO 0)
	
	-- Auto init parameters
	CONSTANT	AIRS							:INTEGER									:= 25;	-- Auto Init ROM's size
	CONSTANT	AIAW							:INTEGER									:= 4;		-- Auto Init ROM's address width 
	
	CONSTANT	D5M_COLUMN_SIZE			:STD_LOGIC_VECTOR(15 DOWNTO  0)	:= B"0000101000011111";
	CONSTANT	D5M_ROW_SIZE				:STD_LOGIC_VECTOR(15 DOWNTO  0)	:= B"0000011110010111";
	CONSTANT	D5M_COLUMN_BIN				:STD_LOGIC_VECTOR(15 DOWNTO  0)	:= B"0000000000000000";
	CONSTANT	D5M_ROW_BIN					:STD_LOGIC_VECTOR(15 DOWNTO  0)	:= B"0000000000000000";
	
	-- Serial Bus Controller parameters

	CONSTANT	SBCW							:INTEGER									:= 5;		-- Serial bus counter's width
	CONSTANT	SCCW							:INTEGER									:= 11;		-- Slow clock's counter's width
	
	
	-- States for finite state machine
	TYPE State_Type IS (	STATE_0_IDLE,
								STATE_1_PRE_WRITE,
								STATE_2_WRITE_TRANSFER,
								STATE_3_POST_WRITE,
								STATE_4_PRE_READ,
								STATE_5_READ_TRANSFER,
								STATE_6_POST_READ
							);
	
-- *****************************************************************************
-- *                       Internal Signals Declarations                       *
-- *****************************************************************************
	-- Internal Wires
	SIGNAL	internal_reset						:STD_LOGIC;
	
	--  Auto init signals
	SIGNAL	rom_address							:STD_LOGIC_VECTOR(AIAW DOWNTO 0);	
	SIGNAL	rom_data								:STD_LOGIC_VECTOR(DW DOWNTO  0);	
	SIGNAL	ack									:STD_LOGIC;
	
	SIGNAL	auto_init_data						:STD_LOGIC_VECTOR(DW DOWNTO  0);	
	SIGNAL	auto_init_transfer_en			:STD_LOGIC;
	SIGNAL	auto_init_complete				:STD_LOGIC;
	SIGNAL	auto_init_error					:STD_LOGIC;
	
	--  Serial controller signals
	SIGNAL	transfer_mask						:STD_LOGIC_VECTOR(DW DOWNTO  0);	
	SIGNAL	data_to_controller				:STD_LOGIC_VECTOR(DW DOWNTO  0);	
	SIGNAL	data_to_controller_on_restart	:STD_LOGIC_VECTOR(DW DOWNTO  0);	
	SIGNAL	data_from_controller				:STD_LOGIC_VECTOR(DW DOWNTO  0);	
	
	SIGNAL	start_transfer						:STD_LOGIC;
	
	SIGNAL	transfer_complete					:STD_LOGIC;
	
	-- Internal Registers
	SIGNAL	control_reg							:STD_LOGIC_VECTOR(31 DOWNTO  0);	
	SIGNAL	address_reg							:STD_LOGIC_VECTOR(31 DOWNTO  0);	
	SIGNAL	data_reg								:STD_LOGIC_VECTOR(31 DOWNTO  0);	
	
	SIGNAL	start_external_transfer			:STD_LOGIC;
	SIGNAL	external_read_transfer			:STD_LOGIC;
	SIGNAL	address_for_transfer				:STD_LOGIC_VECTOR( 7 DOWNTO  0);	
	
	-- State Machine Registers
	SIGNAL	ns_serial_transfer				: State_Type;	
	SIGNAL	s_serial_transfer					: State_Type;	
	
-- *****************************************************************************
-- *                          Component Declarations                           *
-- *****************************************************************************
	COMPONENT altera_up_av_config_auto_init
	GENERIC (	
		ROM_SIZE					:INTEGER;
		AW							:INTEGER;
		DW							:INTEGER
	);
	PORT (
		-- Inputs
		clk						:IN		STD_LOGIC;
		reset						:IN		STD_LOGIC;

		clear_error				:IN		STD_LOGIC;

		ack						:IN		STD_LOGIC;
		transfer_complete		:IN		STD_LOGIC;

		rom_data					:IN		STD_LOGIC_VECTOR(DW DOWNTO  0);

		-- Bidirectionals

		-- Outputs
		data_out					:BUFFER	STD_LOGIC_VECTOR(DW DOWNTO  0);
		transfer_data			:BUFFER	STD_LOGIC;

		rom_address				:BUFFER	STD_LOGIC_VECTOR(AIAW DOWNTO 0);
	
		auto_init_complete	:BUFFER	STD_LOGIC;
		auto_init_error		:BUFFER	STD_LOGIC
	);
	END COMPONENT;

	COMPONENT altera_up_av_config_auto_init_d5m
	GENERIC (
		D5M_COLUMN_SIZE	:STD_LOGIC_VECTOR(15 DOWNTO 0);
		D5M_ROW_SIZE		:STD_LOGIC_VECTOR(15 DOWNTO 0);
		D5M_COLUMN_BIN		:STD_LOGIC_VECTOR(15 DOWNTO 0);
		D5M_ROW_BIN			:STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
	PORT (
		-- Inputs
		rom_address	:IN		STD_LOGIC_VECTOR(AIAW DOWNTO 0);

		exposure		:IN		STD_LOGIC_VECTOR(15 DOWNTO  0);	
		-- Bidirectionals

		-- Outputs
		rom_data		:BUFFER	STD_LOGIC_VECTOR(DW DOWNTO  0)
	);
	END COMPONENT;

	COMPONENT altera_up_av_config_serial_bus_controller
	GENERIC (
		DW								:INTEGER;
		CW								:INTEGER;
		SCCW							:INTEGER
	);
	PORT (
		-- Inputs
		clk							:IN		STD_LOGIC;
		reset							:IN		STD_LOGIC;

		start_transfer				:IN		STD_LOGIC;

		data_in						:IN		STD_LOGIC_VECTOR(DW DOWNTO  0);
		transfer_mask				:IN		STD_LOGIC_VECTOR(DW DOWNTO  0);

		restart_counter			:IN		STD_LOGIC_VECTOR(SBCW DOWNTO 0);
		restart_data_in			:IN		STD_LOGIC_VECTOR(DW DOWNTO  0);
		restart_transfer_mask	:IN		STD_LOGIC_VECTOR(26 DOWNTO 0);

		-- Bidirectionals
		serial_data					:INOUT	STD_LOGIC;

		-- Outputs
		serial_clk					:BUFFER	STD_LOGIC;
		serial_en					:BUFFER	STD_LOGIC;

		data_out						:BUFFER	STD_LOGIC_VECTOR(DW DOWNTO  0);
		transfer_complete			:BUFFER	STD_LOGIC
	);
	END COMPONENT;

BEGIN
-- *****************************************************************************
-- *                         Finite State Machine(s)                           *
-- *****************************************************************************

	PROCESS (clk)
	BEGIN
		IF clk'EVENT AND clk = '1' THEN
			IF (internal_reset = '1') THEN
				s_serial_transfer <= STATE_0_IDLE;
			ELSE
				s_serial_transfer <= ns_serial_transfer;
			END IF;
		END IF;
	END PROCESS;


	PROCESS (ns_serial_transfer, s_serial_transfer, transfer_complete, 
				auto_init_complete, write, address, read, control_reg)
	BEGIN
		-- Defaults
		ns_serial_transfer <= STATE_0_IDLE;
	
	   CASE (s_serial_transfer) IS
		WHEN STATE_0_IDLE =>
			IF ((transfer_complete = '1') OR (auto_init_complete = '0')) THEN
				ns_serial_transfer <= STATE_0_IDLE;
			ELSIF ((write = '1') AND (address = B"11")) THEN
				ns_serial_transfer <= STATE_1_PRE_WRITE;
			ELSIF ((read = '1') AND (address = B"11")) THEN
				ns_serial_transfer <= STATE_4_PRE_READ;
			ELSE
				ns_serial_transfer <= STATE_0_IDLE;
			END IF;
		WHEN STATE_1_PRE_WRITE =>
			ns_serial_transfer <= STATE_2_WRITE_TRANSFER;
		WHEN STATE_2_WRITE_TRANSFER =>
			IF (transfer_complete = '1') THEN
				ns_serial_transfer <= STATE_3_POST_WRITE;
			ELSE
				ns_serial_transfer <= STATE_2_WRITE_TRANSFER;
			END IF;
		WHEN STATE_3_POST_WRITE =>
			ns_serial_transfer <= STATE_0_IDLE;
		WHEN STATE_4_PRE_READ =>
			ns_serial_transfer <= STATE_5_READ_TRANSFER;
		WHEN STATE_5_READ_TRANSFER =>
			IF (transfer_complete = '1') THEN
				ns_serial_transfer <= STATE_6_POST_READ;
			ELSE
				ns_serial_transfer <= STATE_5_READ_TRANSFER;
			END IF;
		WHEN STATE_6_POST_READ =>
			ns_serial_transfer <= STATE_0_IDLE;
		WHEN OTHERS =>
			ns_serial_transfer <= STATE_0_IDLE;
		END CASE;
	END PROCESS;


-- *****************************************************************************
-- *                             Sequential Logic                              *
-- *****************************************************************************

	-- Output regsiters
	PROCESS (clk)
	BEGIN
		IF clk'EVENT AND clk = '1' THEN
			IF (internal_reset = '1') THEN
				readdata		<= B"00000000000000000000000000000000";
			ELSIF (read = '1') THEN
				IF (address = B"00") THEN
					readdata	<= control_reg;
				ELSIF (address = B"01") THEN
					readdata	<= B"00000000" & CFG_TYPE & B"0000000" & 
									(auto_init_complete AND NOT auto_init_error) & B"000000" & 
									(NOT start_external_transfer AND auto_init_complete) & 
									ack;
				ELSIF (address = B"10") THEN
					readdata	<= address_reg;
				ELSE
					readdata	<= B"0000000000000000" & 
									data_from_controller(17 DOWNTO 10) & 
									data_from_controller( 8 DOWNTO  1);
				END IF;
			END IF;
		END IF;
	END PROCESS;


	-- Internal regsiters
	PROCESS (clk)
	BEGIN
		IF clk'EVENT AND clk = '1' THEN
			IF (internal_reset = '1') THEN
				control_reg					<= B"00000000000000000000000000000000";
				address_reg					<= B"00000000000000000000000000000000";
				data_reg						<= B"00000000000000000000000000000000";
			
			ELSIF ((write = '1') AND (waitrequest = '0')) THEN
				-- Write to control register
				IF ((address = B"00") AND (byteenable(0) = '1')) THEN
					control_reg( 2 DOWNTO  1)	<= writedata( 2 DOWNTO  1);
	
			-- Write to address register
			END IF;
				IF ((address = B"10") AND (byteenable(0) = '1')) THEN
					address_reg( 7 DOWNTO  0)	<= writedata( 7 DOWNTO  0);
	
			-- Write to data register
			END IF;
				IF ((address = B"11") AND (byteenable(0) = '1')) THEN
					data_reg( 7 DOWNTO  0)		<= writedata( 7 DOWNTO  0);
			END IF;
				IF ((address = B"11") AND (byteenable(1) = '1')) THEN
					data_reg(15 DOWNTO  8)		<= writedata(15 DOWNTO  8);
			END IF;
				IF ((address = B"11") AND (byteenable(2) = '1')) THEN
					data_reg(23 DOWNTO 16)		<= writedata(23 DOWNTO 16);
			END IF;
				IF ((address = B"11") AND (byteenable(3) = '1')) THEN
					data_reg(31 DOWNTO 24)		<= writedata(31 DOWNTO 24);
				END IF;
			END IF;
		END IF;
	END PROCESS;


	PROCESS (clk)
	BEGIN
		IF clk'EVENT AND clk = '1' THEN
			IF (internal_reset = '1') THEN
				start_external_transfer <= '0';
				external_read_transfer	<= '0';
				address_for_transfer		<= B"00000000";
			ELSIF (transfer_complete = '1') THEN
				start_external_transfer <= '0';
				external_read_transfer	<= '0';
				address_for_transfer		<= B"00000000";
			ELSIF (s_serial_transfer = STATE_1_PRE_WRITE) THEN
				start_external_transfer <= '1';
				external_read_transfer	<= '0';
				address_for_transfer		<= address_reg(7 DOWNTO 0);
			ELSIF (s_serial_transfer = STATE_4_PRE_READ) THEN
				start_external_transfer <= '1';
				external_read_transfer	<= '1';
				address_for_transfer		<= address_reg(7 DOWNTO 0);
			END IF;
		END IF;
	END PROCESS;


-- *****************************************************************************
-- *                            Combinational Logic                            *
-- *****************************************************************************

	-- Output Assignments
	waitrequest <= '1' WHEN
		((address = B"11") AND (write = '1') AND (s_serial_transfer /= STATE_1_PRE_WRITE)) OR 
		((address = B"11") AND (read = '1')  AND (s_serial_transfer /= STATE_6_POST_READ))
		ELSE '0';
	irq <= '1' WHEN (control_reg(1) = '1') AND (start_external_transfer = '0') AND (auto_init_complete = '1');

	-- Internal Assignments
	internal_reset <= '1' WHEN (reset = '1') OR 
			((address = B"00") AND (write = '1') AND (byteenable(0) = '1') AND (writedata(0) = '1'))
			ELSE '0';


	--  Signals to the serial controller
	transfer_mask <= WRITE_MASK;

	data_to_controller <= 
			auto_init_data WHEN (auto_init_complete = '0') ELSE 
				B"10111010" & '0' & 
				address_for_transfer(7 DOWNTO 0) & external_read_transfer & 
				data_reg(15 DOWNTO 8) & '0' & 
				data_reg( 7 DOWNTO 0) & '0';

	data_to_controller_on_restart <= B"10111011" & '0' & B"00000000" & '0' & B"00000000" & '0' & B"00000000" & '0';
			

	start_transfer <= start_external_transfer WHEN (auto_init_complete = '1') ELSE auto_init_transfer_en;

	--  Signals from the serial controller
	ack <= data_from_controller(27) OR 
						data_from_controller(18) OR 
						data_from_controller( 9) OR 
						data_from_controller( 0);

-- *****************************************************************************
-- *                          Component Instantiations                         *
-- *****************************************************************************

	AV_Config_Auto_Init : altera_up_av_config_auto_init 
	GENERIC MAP (	
		ROM_SIZE					=> AIRS,
		AW							=> AIAW,
		DW							=> DW
	)
	PORT MAP (
		-- Inputs
		clk						=> clk,
		reset						=> internal_reset,
	
		clear_error				=> '0',
	
		ack						=> ack,
		transfer_complete		=> transfer_complete,
	
		rom_data					=> rom_data,
	
		-- Bidirectionals
	
		-- Outputs
		data_out					=> auto_init_data,
		transfer_data			=> auto_init_transfer_en,
	
		rom_address				=> rom_address,
		
		auto_init_complete	=> auto_init_complete,
		auto_init_error		=> auto_init_error
	);

	Auto_Init_D5M_ROM : altera_up_av_config_auto_init_d5m 
	GENERIC MAP (
		D5M_COLUMN_SIZE	=> D5M_COLUMN_SIZE,
		D5M_ROW_SIZE		=> D5M_ROW_SIZE,
		D5M_COLUMN_BIN		=> D5M_COLUMN_BIN,
		D5M_ROW_BIN			=> D5M_ROW_BIN
	)
	PORT MAP (

		-- Inputs
		rom_address	=> rom_address,
	
		exposure	=> B"0000011111000000",
		-- Bidirectionals
	
		-- Outputs
		rom_data		=> rom_data
	);


	Serial_Bus_Controller : altera_up_av_config_serial_bus_controller 
	GENERIC MAP (
		DW								=> DW,
		CW								=> SBCW,
		SCCW							=> SCCW
	)
	PORT MAP (
		-- Inputs
		clk							=> clk,
		reset							=> internal_reset,
	
		start_transfer				=> start_transfer,
	
		data_in						=> data_to_controller,
		transfer_mask				=> transfer_mask,
	
		restart_counter			=> RESTART_COUNTER,
		restart_data_in			=> data_to_controller_on_restart,
		restart_transfer_mask	=> READ_MASK,
	
		-- Bidirectionals
		serial_data					=> I2C_SDAT,
	
		-- Outputs
		serial_clk					=> I2C_SCLK,
		serial_en					=> I2C_SCEN,
	
		data_out						=> data_from_controller,
		transfer_complete			=> transfer_complete
	);


END Behaviour;

