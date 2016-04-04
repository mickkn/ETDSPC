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
-- * This module converts video streams between RGB color formats.              *
-- *                                                                            *
-- ******************************************************************************

ENTITY SOPC_Video_video_rgb_resampler_0 IS

-- *****************************************************************************
-- *                             Generic Declarations                          *
-- *****************************************************************************
	
GENERIC (
	
	IDW	:INTEGER									:= 23;
	ODW	:INTEGER									:= 7;
	
	IEW	:INTEGER									:= 1;
	OEW	:INTEGER									:= 0;
	
	ALPHA	:STD_LOGIC_VECTOR( 9 DOWNTO  0)	:= B"1111111111"
	
);
-- *****************************************************************************
-- *                             Port Declarations                             *
-- *****************************************************************************
PORT (

	-- Inputs
	clk								:IN		STD_LOGIC;
	reset								:IN		STD_LOGIC;

	stream_in_data					:IN		STD_LOGIC_VECTOR(IDW DOWNTO  0);	
	stream_in_startofpacket		:IN		STD_LOGIC;
	stream_in_endofpacket		:IN		STD_LOGIC;
	stream_in_empty				:IN		STD_LOGIC_VECTOR(IEW DOWNTO  0);	
	stream_in_valid				:IN		STD_LOGIC;

	stream_out_ready				:IN		STD_LOGIC;

	-- Bidirectional

	-- Outputs
	stream_in_ready				:BUFFER	STD_LOGIC;

	stream_out_data				:BUFFER	STD_LOGIC_VECTOR(ODW DOWNTO  0);	
	stream_out_startofpacket	:BUFFER	STD_LOGIC;
	stream_out_endofpacket		:BUFFER	STD_LOGIC;
	stream_out_empty				:BUFFER	STD_LOGIC_VECTOR(OEW DOWNTO  0);	
	stream_out_valid				:BUFFER	STD_LOGIC

);

END SOPC_Video_video_rgb_resampler_0;

ARCHITECTURE Behaviour OF SOPC_Video_video_rgb_resampler_0 IS
-- *****************************************************************************
-- *                           Constant Declarations                           *
-- *****************************************************************************

-- *****************************************************************************
-- *                       Internal Signals Declarations                       *
-- *****************************************************************************
	
	-- Internal Wires
	SIGNAL	r					:STD_LOGIC_VECTOR( 9 DOWNTO  0);	
	SIGNAL	g					:STD_LOGIC_VECTOR( 9 DOWNTO  0);	
	SIGNAL	b					:STD_LOGIC_VECTOR( 9 DOWNTO  0);	
	SIGNAL	a					:STD_LOGIC_VECTOR( 9 DOWNTO  0);	
	
	SIGNAL	average_color	:STD_LOGIC_VECTOR(11 DOWNTO  0);	
	
	SIGNAL	converted_data	:STD_LOGIC_VECTOR(ODW DOWNTO  0);	
	
	-- Internal Registers
	
	-- State Machine Registers
	
	-- Integers
	
-- *****************************************************************************
-- *                          Component Declarations                           *
-- *****************************************************************************
BEGIN
-- *****************************************************************************
-- *                         Finite State Machine(s)                           *
-- *****************************************************************************


-- *****************************************************************************
-- *                             Sequential Logic                              *
-- *****************************************************************************

	-- Output Registers
	PROCESS (clk)
	BEGIN
		IF clk'EVENT AND clk = '1' THEN
			IF (reset = '1') THEN
				stream_out_data				<= (OTHERS => '0');
				stream_out_startofpacket	<= '0';
				stream_out_endofpacket		<= '0';
				stream_out_empty				<= (OTHERS => '0');
				stream_out_valid				<= '0';
			ELSIF ((stream_out_ready = '1') OR (stream_out_valid = '0')) THEN
				stream_out_data				<= converted_data;
				stream_out_startofpacket	<= stream_in_startofpacket;
				stream_out_endofpacket		<= stream_in_endofpacket;
			--	stream_out_empty				<= stream_in_empty;
				stream_out_empty				<= (OTHERS => '0');
				stream_out_valid				<= stream_in_valid;
			END IF;
		END IF;
	END PROCESS;


	-- Internal Registers

-- *****************************************************************************
-- *                            Combinational Logic                            *
-- *****************************************************************************

	-- Output Assignments
	stream_in_ready <= stream_out_ready OR NOT stream_out_valid;

	-- Internal Assignments
	r <= (stream_in_data(23 DOWNTO 16) & stream_in_data(23 DOWNTO 22));
	g <= (stream_in_data(15 DOWNTO  8) & stream_in_data(15 DOWNTO 14));
	b <= (stream_in_data( 7 DOWNTO  0) & stream_in_data( 7 DOWNTO  6));

	a <= ALPHA;

	average_color <= (B"00" & r) + ('0' & g & '0') + (B"00" & b);

	converted_data( 7 DOWNTO  0) <= average_color(11 DOWNTO 4);

-- *****************************************************************************
-- *                          Component Instantiations                         *
-- *****************************************************************************



END Behaviour;

