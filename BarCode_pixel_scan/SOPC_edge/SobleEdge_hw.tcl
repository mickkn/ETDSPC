# TCL File Generated by Component Editor 13.0sp1
# Fri Mar 13 15:13:39 CET 2015
# DO NOT MODIFY


# 
# SobleEdge "SobleEdge" v1.0
# KBE 2015.03.13.15:13:39
# Soble edge detection video filter
# 

# 
# request TCL package from ACDS 13.1
# 
package require -exact qsys 13.1


# 
# module SobleEdge
# 
set_module_property DESCRIPTION "Soble edge detection video filter"
set_module_property NAME SobleEdge
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP IHA
set_module_property AUTHOR KBE
set_module_property DISPLAY_NAME SobleEdge
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property ANALYZE_HDL AUTO
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL altera_up_avalon_video_edge_detection
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
add_fileset_file altera_up_avalon_video_edge_detection.vhd VHDL PATH EdgeDetection/altera_up_avalon_video_edge_detection.vhd TOP_LEVEL_FILE
add_fileset_file altera_up_edge_detection_data_shift_register.vhd VHDL PATH EdgeDetection/altera_up_edge_detection_data_shift_register.vhd
add_fileset_file altera_up_edge_detection_gaussian_smoothing_filter.vhd VHDL PATH EdgeDetection/altera_up_edge_detection_gaussian_smoothing_filter.vhd
add_fileset_file altera_up_edge_detection_hysteresis.vhd VHDL PATH EdgeDetection/altera_up_edge_detection_hysteresis.vhd
add_fileset_file altera_up_edge_detection_nonmaximum_suppression.vhd VHDL PATH EdgeDetection/altera_up_edge_detection_nonmaximum_suppression.vhd
add_fileset_file altera_up_edge_detection_pixel_info_shift_register.vhd VHDL PATH EdgeDetection/altera_up_edge_detection_pixel_info_shift_register.vhd
add_fileset_file altera_up_edge_detection_sobel_operator.vhd VHDL PATH EdgeDetection/altera_up_edge_detection_sobel_operator.vhd


# 
# parameters
# 
add_parameter WIDTH INTEGER 640
set_parameter_property WIDTH DEFAULT_VALUE 640
set_parameter_property WIDTH DISPLAY_NAME WIDTH
set_parameter_property WIDTH TYPE INTEGER
set_parameter_property WIDTH UNITS None
set_parameter_property WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property WIDTH HDL_PARAMETER true


# 
# display items
# 


# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock clockRate 0
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock SVD_ADDRESS_GROUP ""

add_interface_port clock clk clk Input 1


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset reset reset Input 1


# 
# connection point avalon_streaming_sink_1
# 
add_interface avalon_streaming_sink_1 avalon_streaming end
set_interface_property avalon_streaming_sink_1 associatedClock clock
set_interface_property avalon_streaming_sink_1 associatedReset reset
set_interface_property avalon_streaming_sink_1 dataBitsPerSymbol 8
set_interface_property avalon_streaming_sink_1 errorDescriptor ""
set_interface_property avalon_streaming_sink_1 firstSymbolInHighOrderBits true
set_interface_property avalon_streaming_sink_1 maxChannel 0
set_interface_property avalon_streaming_sink_1 readyLatency 0
set_interface_property avalon_streaming_sink_1 ENABLED true
set_interface_property avalon_streaming_sink_1 EXPORT_OF ""
set_interface_property avalon_streaming_sink_1 PORT_NAME_MAP ""
set_interface_property avalon_streaming_sink_1 SVD_ADDRESS_GROUP ""

add_interface_port avalon_streaming_sink_1 in_data data Input 8
add_interface_port avalon_streaming_sink_1 in_startofpacket startofpacket Input 1
add_interface_port avalon_streaming_sink_1 in_endofpacket endofpacket Input 1
add_interface_port avalon_streaming_sink_1 in_valid valid Input 1
add_interface_port avalon_streaming_sink_1 in_ready ready Output 1


# 
# connection point avalon_streaming_source_1
# 
add_interface avalon_streaming_source_1 avalon_streaming start
set_interface_property avalon_streaming_source_1 associatedClock clock
set_interface_property avalon_streaming_source_1 associatedReset reset
set_interface_property avalon_streaming_source_1 dataBitsPerSymbol 8
set_interface_property avalon_streaming_source_1 errorDescriptor ""
set_interface_property avalon_streaming_source_1 firstSymbolInHighOrderBits true
set_interface_property avalon_streaming_source_1 maxChannel 0
set_interface_property avalon_streaming_source_1 readyLatency 0
set_interface_property avalon_streaming_source_1 ENABLED true
set_interface_property avalon_streaming_source_1 EXPORT_OF ""
set_interface_property avalon_streaming_source_1 PORT_NAME_MAP ""
set_interface_property avalon_streaming_source_1 SVD_ADDRESS_GROUP ""

add_interface_port avalon_streaming_source_1 out_ready ready Input 1
add_interface_port avalon_streaming_source_1 out_data data Output 8
add_interface_port avalon_streaming_source_1 out_startofpacket startofpacket Output 1
add_interface_port avalon_streaming_source_1 out_endofpacket endofpacket Output 1
add_interface_port avalon_streaming_source_1 out_valid valid Output 1


# 
# connection point conduit_end
# 
add_interface conduit_end conduit end
set_interface_property conduit_end associatedClock clock
set_interface_property conduit_end associatedReset reset
set_interface_property conduit_end ENABLED true
set_interface_property conduit_end EXPORT_OF ""
set_interface_property conduit_end PORT_NAME_MAP ""
set_interface_property conduit_end SVD_ADDRESS_GROUP ""

add_interface_port conduit_end bypass export Input 1

