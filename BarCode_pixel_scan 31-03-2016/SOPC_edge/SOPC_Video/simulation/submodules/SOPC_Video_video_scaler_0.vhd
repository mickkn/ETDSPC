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
-- * This module scales video streams on the DE boards.                         *
-- *                                                                            *
-- ******************************************************************************

ENTITY SOPC_Video_video_scaler_0 IS

-- *****************************************************************************
-- *                             Generic Declarations                          *
-- *****************************************************************************
	
GENERIC (
	
	DW						:INTEGER									:= 23; 	-- Frame's Data Width
	EW						:INTEGER									:= 1; 	-- Frame's Empty Width
	
	WIW					:INTEGER									:= 10; 	-- Incoming frame's width's address width
	HIW					:INTEGER									:= 9; 	-- Incoming frame's height's address width
	WIDTH_IN				:INTEGER									:= 1280;
	
	WIDTH_DROP_MASK	:STD_LOGIC_VECTOR( 3 DOWNTO  0)	:= B"0101";
	HEIGHT_DROP_MASK	:STD_LOGIC_VECTOR( 3 DOWNTO  0)	:= B"1010";
	
	MH_WW					:INTEGER									:= 9; 	-- Multiply height's incoming width's address width
	MH_WIDTH_IN			:INTEGER									:= 640; 	-- Multiply height's incoming width
	MH_CW					:INTEGER									:= 0; 	-- Multiply height's counter width
	
	MW_CW					:INTEGER									:= 0	--  Multiply width's counter width
	
);
-- *****************************************************************************
-- *                             Port Declarations                             *
-- *****************************************************************************
PORT (

	-- Inputs
	clk								:IN		STD_LOGIC;
	reset								:IN		STD_LOGIC;

	stream_in_data					:IN		STD_LOGIC_VECTOR(DW DOWNTO  0);	
	stream_in_startofpacket		:IN		STD_LOGIC;
	stream_in_endofpacket		:IN		STD_LOGIC;
	stream_in_empty				:IN		STD_LOGIC_VECTOR(EW DOWNTO  0);	
	stream_in_valid				:IN		STD_LOGIC;

	stream_out_ready				:IN		STD_LOGIC;

	-- Bidirectional

	-- Outputs
	stream_in_ready				:BUFFER	STD_LOGIC;

	stream_out_data				:BUFFER	STD_LOGIC_VECTOR(DW DOWNTO  0);	
	stream_out_startofpacket	:BUFFER	STD_LOGIC;
	stream_out_endofpacket		:BUFFER	STD_LOGIC;
	stream_out_empty				:BUFFER	STD_LOGIC_VECTOR(EW DOWNTO  0);	
	stream_out_valid				:BUFFER	STD_LOGIC

);

END SOPC_Video_video_scaler_0;

ARCHITECTURE Behaviour OF SOPC_Video_video_scaler_0 IS
-- *****************************************************************************
-- *                           Constant Declarations                           *
-- *****************************************************************************

-- *****************************************************************************
-- *                       Internal Signals Declarations                       *
-- *****************************************************************************
	
	-- Internal Wires
	SIGNAL	internal_data				:STD_LOGIC_VECTOR(DW DOWNTO  0);	
	SIGNAL	internal_startofpacket	:STD_LOGIC;
	SIGNAL	internal_endofpacket		:STD_LOGIC;
	SIGNAL	internal_valid				:STD_LOGIC;
	
	SIGNAL	internal_ready				:STD_LOGIC;
	
	-- Internal Registers
	
	-- State Machine Registers
	
	-- Integers
	
-- *****************************************************************************
-- *                          Component Declarations                           *
-- *****************************************************************************
	COMPONENT altera_up_video_scaler_shrink
	GENERIC (
		DW									:INTEGER;
		WW									:INTEGER;
		HW									:INTEGER;

		WIDTH_IN							:INTEGER;

		WIDTH_DROP_MASK				:STD_LOGIC_VECTOR( 3 DOWNTO  0);
		HEIGHT_DROP_MASK				:STD_LOGIC_VECTOR( 3 DOWNTO  0)
	);
	PORT (
		-- Inputs
		clk								:IN		STD_LOGIC;
		reset								:IN		STD_LOGIC;

		stream_in_data					:IN		STD_LOGIC_VECTOR(DW DOWNTO  0);
		stream_in_startofpacket		:IN		STD_LOGIC;
		stream_in_endofpacket		:IN		STD_LOGIC;
		stream_in_valid				:IN		STD_LOGIC;


		stream_out_ready				:IN		STD_LOGIC;
	
		-- Bidirectional

		-- Outputs
		stream_in_ready				:BUFFER	STD_LOGIC;

		stream_out_data				:BUFFER	STD_LOGIC_VECTOR(DW DOWNTO  0);
		stream_out_startofpacket	:BUFFER	STD_LOGIC;
		stream_out_endofpacket		:BUFFER	STD_LOGIC;
		stream_out_valid				:BUFFER	STD_LOGIC
	);
	END COMPONENT;



BEGIN
-- *****************************************************************************
-- *                         Finite State Machine(s)                           *
-- *****************************************************************************


-- *****************************************************************************
-- *                             Sequential Logic                              *
-- *****************************************************************************

	-- Output Registers

	-- Internal Registers

-- *****************************************************************************
-- *                            Combinational Logic                            *
-- *****************************************************************************

	-- Output Assignments
	stream_out_empty <= (OTHERS => '0');

	-- Internal Assignments

-- *****************************************************************************
-- *                          Component Instantiations                         *
-- *****************************************************************************

	Shrink_Frame : altera_up_video_scaler_shrink 
	GENERIC MAP (
		DW									=> DW,
		WW									=> WIW,
		HW									=> HIW,

		WIDTH_IN							=> WIDTH_IN,

		WIDTH_DROP_MASK				=> WIDTH_DROP_MASK,
		HEIGHT_DROP_MASK				=> HEIGHT_DROP_MASK
	)
	PORT MAP (
		-- Inputs
		clk								=> clk,
		reset								=> reset,
	
		stream_in_data					=> stream_in_data,
		stream_in_startofpacket		=> stream_in_startofpacket,
		stream_in_endofpacket		=> stream_in_endofpacket,
		stream_in_valid				=> stream_in_valid,
	
		stream_out_ready				=> stream_out_ready,
		
		-- Bidirectional
	
		-- Outputs
		stream_in_ready				=> stream_in_ready,
	
		stream_out_data				=> stream_out_data,
		stream_out_startofpacket	=> stream_out_startofpacket,
		stream_out_endofpacket		=> stream_out_endofpacket,
		stream_out_valid				=> stream_out_valid
	);




END Behaviour;

