// (C) 2001-2013 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// (C) 2001-2013 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// $Id: //acds/rel/13.0sp1/ip/merlin/altera_merlin_router/altera_merlin_router.sv.terp#1 $
// $Revision: #1 $
// $Date: 2013/03/07 $
// $Author: swbranch $

// -------------------------------------------------------
// Merlin Router
//
// Asserts the appropriate one-hot encoded channel based on 
// either (a) the address or (b) the dest id. The DECODER_TYPE
// parameter controls this behaviour. 0 means address decoder,
// 1 means dest id decoder.
//
// In the case of (a), it also sets the destination id.
// -------------------------------------------------------

`timescale 1 ns / 1 ns

module SOPC_Video_addr_router_001_default_decode
  #(
     parameter DEFAULT_CHANNEL = 2,
               DEFAULT_WR_CHANNEL = -1,
               DEFAULT_RD_CHANNEL = -1,
               DEFAULT_DESTID = 12 
   )
  (output [98 - 94 : 0] default_destination_id,
   output [17-1 : 0] default_wr_channel,
   output [17-1 : 0] default_rd_channel,
   output [17-1 : 0] default_src_channel
  );

  assign default_destination_id = 
    DEFAULT_DESTID[98 - 94 : 0];

  generate begin : default_decode
    if (DEFAULT_CHANNEL == -1) begin
      assign default_src_channel = '0;
    end
    else begin
      assign default_src_channel = 17'b1 << DEFAULT_CHANNEL;
    end
  end
  endgenerate

  generate begin : default_decode_rw
    if (DEFAULT_RD_CHANNEL == -1) begin
      assign default_wr_channel = '0;
      assign default_rd_channel = '0;
    end
    else begin
      assign default_wr_channel = 17'b1 << DEFAULT_WR_CHANNEL;
      assign default_rd_channel = 17'b1 << DEFAULT_RD_CHANNEL;
    end
  end
  endgenerate

endmodule


module SOPC_Video_addr_router_001
(
    // -------------------
    // Clock & Reset
    // -------------------
    input clk,
    input reset,

    // -------------------
    // Command Sink (Input)
    // -------------------
    input                       sink_valid,
    input  [109-1 : 0]    sink_data,
    input                       sink_startofpacket,
    input                       sink_endofpacket,
    output                      sink_ready,

    // -------------------
    // Command Source (Output)
    // -------------------
    output                          src_valid,
    output reg [109-1    : 0] src_data,
    output reg [17-1 : 0] src_channel,
    output                          src_startofpacket,
    output                          src_endofpacket,
    input                           src_ready
);

    // -------------------------------------------------------
    // Local parameters and variables
    // -------------------------------------------------------
    localparam PKT_ADDR_H = 67;
    localparam PKT_ADDR_L = 36;
    localparam PKT_DEST_ID_H = 98;
    localparam PKT_DEST_ID_L = 94;
    localparam PKT_PROTECTION_H = 102;
    localparam PKT_PROTECTION_L = 100;
    localparam ST_DATA_W = 109;
    localparam ST_CHANNEL_W = 17;
    localparam DECODER_TYPE = 0;

    localparam PKT_TRANS_WRITE = 70;
    localparam PKT_TRANS_READ  = 71;

    localparam PKT_ADDR_W = PKT_ADDR_H-PKT_ADDR_L + 1;
    localparam PKT_DEST_ID_W = PKT_DEST_ID_H-PKT_DEST_ID_L + 1;



    // -------------------------------------------------------
    // Figure out the number of bits to mask off for each slave span
    // during address decoding
    // -------------------------------------------------------
    localparam PAD0 = log2ceil(64'h80000 - 64'h0); 
    localparam PAD1 = log2ceil(64'h88000 - 64'h84000); 
    localparam PAD2 = log2ceil(64'h89000 - 64'h88800); 
    localparam PAD3 = log2ceil(64'h89400 - 64'h89000); 
    localparam PAD4 = log2ceil(64'h89500 - 64'h89400); 
    localparam PAD5 = log2ceil(64'h89520 - 64'h89500); 
    localparam PAD6 = log2ceil(64'h89540 - 64'h89520); 
    localparam PAD7 = log2ceil(64'h89550 - 64'h89540); 
    localparam PAD8 = log2ceil(64'h89560 - 64'h89550); 
    localparam PAD9 = log2ceil(64'h89570 - 64'h89560); 
    localparam PAD10 = log2ceil(64'h89580 - 64'h89570); 
    localparam PAD11 = log2ceil(64'h89590 - 64'h89580); 
    localparam PAD12 = log2ceil(64'h895a0 - 64'h89590); 
    localparam PAD13 = log2ceil(64'h895b0 - 64'h895a0); 
    localparam PAD14 = log2ceil(64'h895b8 - 64'h895b0); 
    localparam PAD15 = log2ceil(64'h895c0 - 64'h895b8); 
    localparam PAD16 = log2ceil(64'h1800000 - 64'h1000000); 
    // -------------------------------------------------------
    // Work out which address bits are significant based on the
    // address range of the slaves. If the required width is too
    // large or too small, we use the address field width instead.
    // -------------------------------------------------------
    localparam ADDR_RANGE = 64'h1800000;
    localparam RANGE_ADDR_WIDTH = log2ceil(ADDR_RANGE);
    localparam OPTIMIZED_ADDR_H = (RANGE_ADDR_WIDTH > PKT_ADDR_W) ||
                                  (RANGE_ADDR_WIDTH == 0) ?
                                        PKT_ADDR_H :
                                        PKT_ADDR_L + RANGE_ADDR_WIDTH - 1;

    localparam RG = RANGE_ADDR_WIDTH-1;

      wire [PKT_ADDR_W-1 : 0] address = sink_data[OPTIMIZED_ADDR_H : PKT_ADDR_L];

    // -------------------------------------------------------
    // Pass almost everything through, untouched
    // -------------------------------------------------------
    assign sink_ready        = src_ready;
    assign src_valid         = sink_valid;
    assign src_startofpacket = sink_startofpacket;
    assign src_endofpacket   = sink_endofpacket;

    wire [PKT_DEST_ID_W-1:0] default_destid;
    wire [17-1 : 0] default_src_channel;





    SOPC_Video_addr_router_001_default_decode the_default_decode(
      .default_destination_id (default_destid),
      .default_wr_channel   (),
      .default_rd_channel   (),
      .default_src_channel  (default_src_channel)
    );

    always @* begin
        src_data    = sink_data;
        src_channel = default_src_channel;
        src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = default_destid;

        // --------------------------------------------------
        // Address Decoder
        // Sets the channel and destination ID based on the address
        // --------------------------------------------------

    // ( 0x0 .. 0x80000 )
    if ( {address[RG:PAD0],{PAD0{1'b0}}} == 25'h0   ) begin
            src_channel = 17'b00000000000001000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 6;
    end

    // ( 0x84000 .. 0x88000 )
    if ( {address[RG:PAD1],{PAD1{1'b0}}} == 25'h84000   ) begin
            src_channel = 17'b00000000000000010;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 4;
    end

    // ( 0x88800 .. 0x89000 )
    if ( {address[RG:PAD2],{PAD2{1'b0}}} == 25'h88800   ) begin
            src_channel = 17'b00000000000000001;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 3;
    end

    // ( 0x89000 .. 0x89400 )
    if ( {address[RG:PAD3],{PAD3{1'b0}}} == 25'h89000   ) begin
            src_channel = 17'b01000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 1;
    end

    // ( 0x89400 .. 0x89500 )
    if ( {address[RG:PAD4],{PAD4{1'b0}}} == 25'h89400   ) begin
            src_channel = 17'b10000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 2;
    end

    // ( 0x89500 .. 0x89520 )
    if ( {address[RG:PAD5],{PAD5{1'b0}}} == 25'h89500   ) begin
            src_channel = 17'b00000010000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 16;
    end

    // ( 0x89520 .. 0x89540 )
    if ( {address[RG:PAD6],{PAD6{1'b0}}} == 25'h89520   ) begin
            src_channel = 17'b00000001000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 15;
    end

    // ( 0x89540 .. 0x89550 )
    if ( {address[RG:PAD7],{PAD7{1'b0}}} == 25'h89540   ) begin
            src_channel = 17'b00100000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 13;
    end

    // ( 0x89550 .. 0x89560 )
    if ( {address[RG:PAD8],{PAD8{1'b0}}} == 25'h89550   ) begin
            src_channel = 17'b00010000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 8;
    end

    // ( 0x89560 .. 0x89570 )
    if ( {address[RG:PAD9],{PAD9{1'b0}}} == 25'h89560   ) begin
            src_channel = 17'b00001000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 11;
    end

    // ( 0x89570 .. 0x89580 )
    if ( {address[RG:PAD10],{PAD10{1'b0}}} == 25'h89570   ) begin
            src_channel = 17'b00000100000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 10;
    end

    // ( 0x89580 .. 0x89590 )
    if ( {address[RG:PAD11],{PAD11{1'b0}}} == 25'h89580   ) begin
            src_channel = 17'b00000000001000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 5;
    end

    // ( 0x89590 .. 0x895a0 )
    if ( {address[RG:PAD12],{PAD12{1'b0}}} == 25'h89590   ) begin
            src_channel = 17'b00000000000100000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 7;
    end

    // ( 0x895a0 .. 0x895b0 )
    if ( {address[RG:PAD13],{PAD13{1'b0}}} == 25'h895a0   ) begin
            src_channel = 17'b00000000000010000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 0;
    end

    // ( 0x895b0 .. 0x895b8 )
    if ( {address[RG:PAD14],{PAD14{1'b0}}} == 25'h895b0   ) begin
            src_channel = 17'b00000000100000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 14;
    end

    // ( 0x895b8 .. 0x895c0 )
    if ( {address[RG:PAD15],{PAD15{1'b0}}} == 25'h895b8   ) begin
            src_channel = 17'b00000000010000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 9;
    end

    // ( 0x1000000 .. 0x1800000 )
    if ( {address[RG:PAD16],{PAD16{1'b0}}} == 25'h1000000   ) begin
            src_channel = 17'b00000000000000100;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 12;
    end

end


    // --------------------------------------------------
    // Ceil(log2()) function
    // --------------------------------------------------
    function integer log2ceil;
        input reg[65:0] val;
        reg [65:0] i;

        begin
            i = 1;
            log2ceil = 0;

            while (i < val) begin
                log2ceil = log2ceil + 1;
                i = i << 1;
            end
        end
    endfunction

endmodule


