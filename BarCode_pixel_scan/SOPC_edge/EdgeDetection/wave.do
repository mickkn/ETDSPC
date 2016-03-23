onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /edge_detection_file_tb/reset
add wave -noupdate /edge_detection_file_tb/clk
add wave -noupdate -radix decimal /edge_detection_file_tb/ast_sink_data
add wave -noupdate /edge_detection_file_tb/ast_sink_ready
add wave -noupdate /edge_detection_file_tb/ast_sink_valid
add wave -noupdate /edge_detection_file_tb/ast_sink_startofpacket
add wave -noupdate /edge_detection_file_tb/ast_sink_endofpacket
add wave -noupdate -radix decimal /edge_detection_file_tb/ast_source_data
add wave -noupdate /edge_detection_file_tb/ast_source_ready
add wave -noupdate /edge_detection_file_tb/ast_source_valid
add wave -noupdate /edge_detection_file_tb/ast_source_startofpacket
add wave -noupdate /edge_detection_file_tb/ast_source_endofpacket
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {717429649 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 353
configure wave -valuecolwidth 40
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {717380828 ps} {717750474 ps}
run 800 us
