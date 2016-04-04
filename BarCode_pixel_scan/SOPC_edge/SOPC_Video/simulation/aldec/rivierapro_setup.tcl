
# (C) 2001-2016 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions and 
# other software and tools, and its AMPP partner logic functions, and 
# any output files any of the foregoing (including device programming 
# or simulation files), and any associated documentation or information 
# are expressly subject to the terms and conditions of the Altera 
# Program License Subscription Agreement, Altera MegaCore Function 
# License Agreement, or other applicable license agreement, including, 
# without limitation, that your use is for the sole purpose of 
# programming logic devices manufactured by Altera and sold by Altera 
# or its authorized distributors. Please refer to the applicable 
# agreement for further details.

# ACDS 13.0sp1 232 win32 2016.03.29.12:24:49

# ----------------------------------------
# Auto-generated simulation script

# ----------------------------------------
# Initialize the variable
if ![info exists SYSTEM_INSTANCE_NAME] { 
  set SYSTEM_INSTANCE_NAME ""
} elseif { ![ string match "" $SYSTEM_INSTANCE_NAME ] } { 
  set SYSTEM_INSTANCE_NAME "/$SYSTEM_INSTANCE_NAME"
} 

if ![info exists TOP_LEVEL_NAME] { 
  set TOP_LEVEL_NAME "SOPC_Video"
} 

if ![info exists QSYS_SIMDIR] { 
  set QSYS_SIMDIR "./../"
} 

if ![info exists QUARTUS_INSTALL_DIR] { 
  set QUARTUS_INSTALL_DIR "C:/altera/13.0sp1/quartus/"
} 

set Aldec "Riviera"
if { [ string match "*Active-HDL*" [ vsim -version ] ] } {
  set Aldec "Active"
}

if { [ string match "Active" $Aldec ] } {
  scripterconf -tcl
  createdesign "$TOP_LEVEL_NAME"  "."
  opendesign "$TOP_LEVEL_NAME"
}

# ----------------------------------------
# Copy ROM/RAM files to simulation directory
alias file_copy {
  echo "\[exec\] file_copy"
  file copy -force $QSYS_SIMDIR/submodules/SOPC_Video_CPU_ociram_default_contents.dat ./
  file copy -force $QSYS_SIMDIR/submodules/SOPC_Video_CPU_ociram_default_contents.hex ./
  file copy -force $QSYS_SIMDIR/submodules/SOPC_Video_CPU_ociram_default_contents.mif ./
  file copy -force $QSYS_SIMDIR/submodules/SOPC_Video_CPU_rf_ram_a.dat ./
  file copy -force $QSYS_SIMDIR/submodules/SOPC_Video_CPU_rf_ram_a.hex ./
  file copy -force $QSYS_SIMDIR/submodules/SOPC_Video_CPU_rf_ram_a.mif ./
  file copy -force $QSYS_SIMDIR/submodules/SOPC_Video_CPU_rf_ram_b.dat ./
  file copy -force $QSYS_SIMDIR/submodules/SOPC_Video_CPU_rf_ram_b.hex ./
  file copy -force $QSYS_SIMDIR/submodules/SOPC_Video_CPU_rf_ram_b.mif ./
  file copy -force $QSYS_SIMDIR/submodules/SOPC_Video_Onchip_Memory.hex ./
}

# ----------------------------------------
# Create compilation libraries
proc ensure_lib { lib } { if ![file isdirectory $lib] { vlib $lib } }
ensure_lib      ./libraries     
ensure_lib      ./libraries/work
vmap       work ./libraries/work
ensure_lib                  ./libraries/altera_ver      
vmap       altera_ver       ./libraries/altera_ver      
ensure_lib                  ./libraries/lpm_ver         
vmap       lpm_ver          ./libraries/lpm_ver         
ensure_lib                  ./libraries/sgate_ver       
vmap       sgate_ver        ./libraries/sgate_ver       
ensure_lib                  ./libraries/altera_mf_ver   
vmap       altera_mf_ver    ./libraries/altera_mf_ver   
ensure_lib                  ./libraries/altera_lnsim_ver
vmap       altera_lnsim_ver ./libraries/altera_lnsim_ver
ensure_lib                  ./libraries/cycloneii_ver   
vmap       cycloneii_ver    ./libraries/cycloneii_ver   
ensure_lib                  ./libraries/altera          
vmap       altera           ./libraries/altera          
ensure_lib                  ./libraries/lpm             
vmap       lpm              ./libraries/lpm             
ensure_lib                  ./libraries/sgate           
vmap       sgate            ./libraries/sgate           
ensure_lib                  ./libraries/altera_mf       
vmap       altera_mf        ./libraries/altera_mf       
ensure_lib                  ./libraries/altera_lnsim    
vmap       altera_lnsim     ./libraries/altera_lnsim    
ensure_lib                  ./libraries/cycloneii       
vmap       cycloneii        ./libraries/cycloneii       
ensure_lib                                    ./libraries/nios_custom_instr_floating_point_0
vmap       nios_custom_instr_floating_point_0 ./libraries/nios_custom_instr_floating_point_0
ensure_lib                                    ./libraries/switch                            
vmap       switch                             ./libraries/switch                            
ensure_lib                                    ./libraries/red_leds                          
vmap       red_leds                           ./libraries/red_leds                          
ensure_lib                                    ./libraries/lcd                               
vmap       lcd                                ./libraries/lcd                               
ensure_lib                                    ./libraries/timer_system                      
vmap       timer_system                       ./libraries/timer_system                      
ensure_lib                                    ./libraries/sdram_0                           
vmap       sdram_0                            ./libraries/sdram_0                           
ensure_lib                                    ./libraries/sysid_qsys_0                      
vmap       sysid_qsys_0                       ./libraries/sysid_qsys_0                      
ensure_lib                                    ./libraries/video_rgb_resampler_0             
vmap       video_rgb_resampler_0              ./libraries/video_rgb_resampler_0             
ensure_lib                                    ./libraries/video_scaler_0                    
vmap       video_scaler_0                     ./libraries/video_scaler_0                    
ensure_lib                                    ./libraries/video_clipper_0                   
vmap       video_clipper_0                    ./libraries/video_clipper_0                   
ensure_lib                                    ./libraries/video_bayer_resampler             
vmap       video_bayer_resampler              ./libraries/video_bayer_resampler             
ensure_lib                                    ./libraries/jtag_uart_0                       
vmap       jtag_uart_0                        ./libraries/jtag_uart_0                       
ensure_lib                                    ./libraries/Clock_Signals                     
vmap       Clock_Signals                      ./libraries/Clock_Signals                     
ensure_lib                                    ./libraries/CPU                               
vmap       CPU                                ./libraries/CPU                               
ensure_lib                                    ./libraries/AV_Config                         
vmap       AV_Config                          ./libraries/AV_Config                         
ensure_lib                                    ./libraries/Video_DMA                         
vmap       Video_DMA                          ./libraries/Video_DMA                         
ensure_lib                                    ./libraries/Video_In_Decoder                  
vmap       Video_In_Decoder                   ./libraries/Video_In_Decoder                  
ensure_lib                                    ./libraries/VGA_Controller                    
vmap       VGA_Controller                     ./libraries/VGA_Controller                    
ensure_lib                                    ./libraries/Pixel_RGB_Resampler               
vmap       Pixel_RGB_Resampler                ./libraries/Pixel_RGB_Resampler               
ensure_lib                                    ./libraries/Pixel_Buffer_DMA                  
vmap       Pixel_Buffer_DMA                   ./libraries/Pixel_Buffer_DMA                  
ensure_lib                                    ./libraries/Pixel_Buffer                      
vmap       Pixel_Buffer                       ./libraries/Pixel_Buffer                      
ensure_lib                                    ./libraries/Dual_Clock_FIFO                   
vmap       Dual_Clock_FIFO                    ./libraries/Dual_Clock_FIFO                   
ensure_lib                                    ./libraries/Onchip_Memory                     
vmap       Onchip_Memory                      ./libraries/Onchip_Memory                     

# ----------------------------------------
# Compile device library files
alias dev_com {
  echo "\[exec\] dev_com"
  vlog +define+SKIP_KEYWORDS_PRAGMA "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives.v"              -work altera_ver      
  vlog                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/220model.v"                       -work lpm_ver         
  vlog                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/sgate.v"                          -work sgate_ver       
  vlog                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf.v"                      -work altera_mf_ver   
  vlog                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_lnsim.sv"                  -work altera_lnsim_ver
  vlog                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/cycloneii_atoms.v"                -work cycloneii_ver   
  vcom                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_syn_attributes.vhd"        -work altera          
  vcom                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_standard_functions.vhd"    -work altera          
  vcom                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/alt_dspbuilder_package.vhd"       -work altera          
  vcom                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_europa_support_lib.vhd"    -work altera          
  vcom                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives_components.vhd" -work altera          
  vcom                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives.vhd"            -work altera          
  vcom                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/220pack.vhd"                      -work lpm             
  vcom                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/220model.vhd"                     -work lpm             
  vcom                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/sgate_pack.vhd"                   -work sgate           
  vcom                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/sgate.vhd"                        -work sgate           
  vcom                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf_components.vhd"         -work altera_mf       
  vcom                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf.vhd"                    -work altera_mf       
  vcom                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_lnsim_components.vhd"      -work altera_lnsim    
  vcom                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/cycloneii_atoms.vhd"              -work cycloneii       
  vcom                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/cycloneii_components.vhd"         -work cycloneii       
}

# ----------------------------------------
# Compile the design files in correct order
alias com {
  echo "\[exec\] com"
  vcom "$QSYS_SIMDIR/submodules/SOPC_Video_nios_custom_instr_floating_point_0.vho"                                       -work nios_custom_instr_floating_point_0
  vcom "$QSYS_SIMDIR/submodules/SOPC_Video_switch.vhd"                                                                   -work switch                            
  vcom "$QSYS_SIMDIR/submodules/SOPC_Video_red_leds.vhd"                                                                 -work red_leds                          
  vcom "$QSYS_SIMDIR/submodules/SOPC_Video_lcd.vhd"                                                                      -work lcd                               
  vcom "$QSYS_SIMDIR/submodules/SOPC_Video_timer_system.vhd"                                                             -work timer_system                      
  vcom "$QSYS_SIMDIR/submodules/SOPC_Video_sdram_0.vhd"                                                                  -work sdram_0                           
  vcom "$QSYS_SIMDIR/submodules/SOPC_Video_sysid_qsys_0.vho"                                                             -work sysid_qsys_0                      
  vcom "$QSYS_SIMDIR/submodules/SOPC_Video_video_rgb_resampler_0.vhd"                                                    -work video_rgb_resampler_0             
  vlog "$QSYS_SIMDIR/submodules/altera_up_video_scaler_shrink.v"                                                         -work video_scaler_0                    
  vlog "$QSYS_SIMDIR/submodules/altera_up_video_scaler_multiply_width.v"                                                 -work video_scaler_0                    
  vlog "$QSYS_SIMDIR/submodules/altera_up_video_scaler_multiply_height.v"                                                -work video_scaler_0                    
  vcom "$QSYS_SIMDIR/submodules/SOPC_Video_video_scaler_0.vhd"                                                           -work video_scaler_0                    
  vlog "$QSYS_SIMDIR/submodules/altera_up_video_clipper_add.v"                                                           -work video_clipper_0                   
  vlog "$QSYS_SIMDIR/submodules/altera_up_video_clipper_drop.v"                                                          -work video_clipper_0                   
  vlog "$QSYS_SIMDIR/submodules/altera_up_video_clipper_counters.v"                                                      -work video_clipper_0                   
  vcom "$QSYS_SIMDIR/submodules/SOPC_Video_video_clipper_0.vhd"                                                          -work video_clipper_0                   
  vcom "$QSYS_SIMDIR/submodules/SOPC_Video_video_bayer_resampler.vhd"                                                    -work video_bayer_resampler             
  vcom "$QSYS_SIMDIR/submodules/SOPC_Video_jtag_uart_0.vhd"                                                              -work jtag_uart_0                       
  vcom "$QSYS_SIMDIR/submodules/SOPC_Video_Clock_Signals.vhd"                                                            -work Clock_Signals                     
  vcom "$QSYS_SIMDIR/submodules/SOPC_Video_CPU.vhd"                                                                      -work CPU                               
  vcom "$QSYS_SIMDIR/submodules/SOPC_Video_CPU_jtag_debug_module_sysclk.vhd"                                             -work CPU                               
  vcom "$QSYS_SIMDIR/submodules/SOPC_Video_CPU_jtag_debug_module_tck.vhd"                                                -work CPU                               
  vcom "$QSYS_SIMDIR/submodules/SOPC_Video_CPU_jtag_debug_module_wrapper.vhd"                                            -work CPU                               
  vcom "$QSYS_SIMDIR/submodules/SOPC_Video_CPU_oci_test_bench.vhd"                                                       -work CPU                               
  vcom "$QSYS_SIMDIR/submodules/SOPC_Video_CPU_test_bench.vhd"                                                           -work CPU                               
  vlog "$QSYS_SIMDIR/submodules/altera_up_av_config_serial_bus_controller.v"                                             -work AV_Config                         
  vlog "$QSYS_SIMDIR/submodules/altera_up_slow_clock_generator.v"                                                        -work AV_Config                         
  vlog "$QSYS_SIMDIR/submodules/altera_up_av_config_auto_init.v"                                                         -work AV_Config                         
  vlog "$QSYS_SIMDIR/submodules/altera_up_av_config_auto_init_dc2.v"                                                     -work AV_Config                         
  vlog "$QSYS_SIMDIR/submodules/altera_up_av_config_auto_init_d5m.v"                                                     -work AV_Config                         
  vlog "$QSYS_SIMDIR/submodules/altera_up_av_config_auto_init_lcm.v"                                                     -work AV_Config                         
  vlog "$QSYS_SIMDIR/submodules/altera_up_av_config_auto_init_ltm.v"                                                     -work AV_Config                         
  vlog "$QSYS_SIMDIR/submodules/altera_up_av_config_auto_init_ob_de2_35.v"                                               -work AV_Config                         
  vlog "$QSYS_SIMDIR/submodules/altera_up_av_config_auto_init_ob_adv7181.v"                                              -work AV_Config                         
  vlog "$QSYS_SIMDIR/submodules/altera_up_av_config_auto_init_ob_de2_70.v"                                               -work AV_Config                         
  vlog "$QSYS_SIMDIR/submodules/altera_up_av_config_auto_init_ob_de2_115.v"                                              -work AV_Config                         
  vlog "$QSYS_SIMDIR/submodules/altera_up_av_config_auto_init_ob_audio.v"                                                -work AV_Config                         
  vlog "$QSYS_SIMDIR/submodules/altera_up_av_config_auto_init_ob_adv7180.v"                                              -work AV_Config                         
  vcom "$QSYS_SIMDIR/submodules/SOPC_Video_AV_Config.vhd"                                                                -work AV_Config                         
  vlog "$QSYS_SIMDIR/submodules/altera_up_video_dma_control_slave.v"                                                     -work Video_DMA                         
  vlog "$QSYS_SIMDIR/submodules/altera_up_video_dma_to_memory.v"                                                         -work Video_DMA                         
  vlog "$QSYS_SIMDIR/submodules/altera_up_video_dma_to_stream.v"                                                         -work Video_DMA                         
  vcom "$QSYS_SIMDIR/submodules/SOPC_Video_Video_DMA.vhd"                                                                -work Video_DMA                         
  vlog "$QSYS_SIMDIR/submodules/altera_up_video_itu_656_decoder.v"                                                       -work Video_In_Decoder                  
  vlog "$QSYS_SIMDIR/submodules/altera_up_video_decoder_add_endofpacket.v"                                               -work Video_In_Decoder                  
  vlog "$QSYS_SIMDIR/submodules/altera_up_video_camera_decoder.v"                                                        -work Video_In_Decoder                  
  vlog "$QSYS_SIMDIR/submodules/altera_up_video_dual_clock_fifo.v"                                                       -work Video_In_Decoder                  
  vcom "$QSYS_SIMDIR/submodules/SOPC_Video_Video_In_Decoder.vhd"                                                         -work Video_In_Decoder                  
  vlog "$QSYS_SIMDIR/submodules/altera_up_avalon_video_vga_timing.v"                                                     -work VGA_Controller                    
  vcom "$QSYS_SIMDIR/submodules/SOPC_Video_VGA_Controller.vhd"                                                           -work VGA_Controller                    
  vcom "$QSYS_SIMDIR/submodules/SOPC_Video_Pixel_RGB_Resampler.vhd"                                                      -work Pixel_RGB_Resampler               
  vcom "$QSYS_SIMDIR/submodules/SOPC_Video_Pixel_Buffer_DMA.vhd"                                                         -work Pixel_Buffer_DMA                  
  vcom "$QSYS_SIMDIR/submodules/SOPC_Video_Pixel_Buffer.vhd"                                                             -work Pixel_Buffer                      
  vcom "$QSYS_SIMDIR/submodules/SOPC_Video_Dual_Clock_FIFO.vhd"                                                          -work Dual_Clock_FIFO                   
  vcom "$QSYS_SIMDIR/submodules/SOPC_Video_Onchip_Memory.vhd"                                                            -work Onchip_Memory                     
  vcom "$QSYS_SIMDIR/SOPC_Video.vhd"                                                                                                                             
  vcom "$QSYS_SIMDIR/sopc_video_width_adapter.vhd"                                                                                                               
  vcom "$QSYS_SIMDIR/sopc_video_width_adapter_003.vhd"                                                                                                           
  vcom "$QSYS_SIMDIR/sopc_video_width_adapter_005.vhd"                                                                                                           
  vcom "$QSYS_SIMDIR/sopc_video_width_adapter_008.vhd"                                                                                                           
  vcom "$QSYS_SIMDIR/sopc_video_rst_controller.vhd"                                                                                                              
  vcom "$QSYS_SIMDIR/sopc_video_rst_controller_001.vhd"                                                                                                          
  vcom "$QSYS_SIMDIR/sopc_video_rst_controller_003.vhd"                                                                                                          
  vcom "$QSYS_SIMDIR/sopc_video_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent.vhd"                                                             
  vcom "$QSYS_SIMDIR/sopc_video_sdram_0_s1_translator_avalon_universal_slave_0_agent.vhd"                                                                        
  vcom "$QSYS_SIMDIR/sopc_video_cpu_instruction_master_translator.vhd"                                                                                           
  vcom "$QSYS_SIMDIR/sopc_video_cpu_data_master_translator.vhd"                                                                                                  
  vcom "$QSYS_SIMDIR/sopc_video_pixel_buffer_dma_avalon_pixel_dma_master_translator.vhd"                                                                         
  vcom "$QSYS_SIMDIR/sopc_video_video_dma_avalon_dma_master_translator.vhd"                                                                                      
  vcom "$QSYS_SIMDIR/sopc_video_cpu_jtag_debug_module_translator.vhd"                                                                                            
  vcom "$QSYS_SIMDIR/sopc_video_onchip_memory_s1_translator.vhd"                                                                                                 
  vcom "$QSYS_SIMDIR/sopc_video_sdram_0_s1_translator.vhd"                                                                                                       
  vcom "$QSYS_SIMDIR/sopc_video_pixel_buffer_avalon_sram_slave_translator.vhd"                                                                                   
  vcom "$QSYS_SIMDIR/sopc_video_av_config_avalon_av_config_slave_translator.vhd"                                                                                 
  vcom "$QSYS_SIMDIR/sopc_video_video_dma_avalon_dma_control_slave_translator.vhd"                                                                               
  vcom "$QSYS_SIMDIR/sopc_video_jtag_uart_0_avalon_jtag_slave_translator.vhd"                                                                                    
  vcom "$QSYS_SIMDIR/sopc_video_sysid_qsys_0_control_slave_translator.vhd"                                                                                       
  vcom "$QSYS_SIMDIR/sopc_video_timer_system_s1_translator.vhd"                                                                                                  
  vcom "$QSYS_SIMDIR/sopc_video_lcd_control_slave_translator.vhd"                                                                                                
  vcom "$QSYS_SIMDIR/sopc_video_red_leds_s1_translator.vhd"                                                                                                      
  vcom "$QSYS_SIMDIR/sopc_video_switch_s1_translator.vhd"                                                                                                        
  vcom "$QSYS_SIMDIR/sopc_video_altera_up_sd_card_avalon_interface_0_avalon_sdcard_slave_translator.vhd"                                                         
  vcom "$QSYS_SIMDIR/sopc_video_cpu_instruction_master_translator_avalon_universal_master_0_agent.vhd"                                                           
  vcom "$QSYS_SIMDIR/sopc_video_pixel_buffer_dma_avalon_pixel_dma_master_translator_avalon_universal_master_0_agent.vhd"                                         
}

# ----------------------------------------
# Elaborate top level design
alias elab {
  echo "\[exec\] elab"
  vsim +access +r  -t ps -L work -L nios_custom_instr_floating_point_0 -L switch -L red_leds -L lcd -L timer_system -L sdram_0 -L sysid_qsys_0 -L video_rgb_resampler_0 -L video_scaler_0 -L video_clipper_0 -L video_bayer_resampler -L jtag_uart_0 -L Clock_Signals -L CPU -L AV_Config -L Video_DMA -L Video_In_Decoder -L VGA_Controller -L Pixel_RGB_Resampler -L Pixel_Buffer_DMA -L Pixel_Buffer -L Dual_Clock_FIFO -L Onchip_Memory -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneii_ver -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneii $TOP_LEVEL_NAME
}

# ----------------------------------------
# Elaborate the top level design with -dbg -O2 option
alias elab_debug {
  echo "\[exec\] elab_debug"
  vsim -dbg -O2 +access +r -t ps -L work -L nios_custom_instr_floating_point_0 -L switch -L red_leds -L lcd -L timer_system -L sdram_0 -L sysid_qsys_0 -L video_rgb_resampler_0 -L video_scaler_0 -L video_clipper_0 -L video_bayer_resampler -L jtag_uart_0 -L Clock_Signals -L CPU -L AV_Config -L Video_DMA -L Video_In_Decoder -L VGA_Controller -L Pixel_RGB_Resampler -L Pixel_Buffer_DMA -L Pixel_Buffer -L Dual_Clock_FIFO -L Onchip_Memory -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneii_ver -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneii $TOP_LEVEL_NAME
}

# ----------------------------------------
# Compile all the design files and elaborate the top level design
alias ld "
  dev_com
  com
  elab
"

# ----------------------------------------
# Compile all the design files and elaborate the top level design with -dbg -O2
alias ld_debug "
  dev_com
  com
  elab_debug
"

# ----------------------------------------
# Print out user commmand line aliases
alias h {
  echo "List Of Command Line Aliases"
  echo
  echo "file_copy                     -- Copy ROM/RAM files to simulation directory"
  echo
  echo "dev_com                       -- Compile device library files"
  echo
  echo "com                           -- Compile the design files in correct order"
  echo
  echo "elab                          -- Elaborate top level design"
  echo
  echo "elab_debug                    -- Elaborate the top level design with -dbg -O2 option"
  echo
  echo "ld                            -- Compile all the design files and elaborate the top level design"
  echo
  echo "ld_debug                      -- Compile all the design files and elaborate the top level design with -dbg -O2"
  echo
  echo 
  echo
  echo "List Of Variables"
  echo
  echo "TOP_LEVEL_NAME                -- Top level module name."
  echo
  echo "SYSTEM_INSTANCE_NAME          -- Instantiated system module name inside top level module."
  echo
  echo "QSYS_SIMDIR                   -- Qsys base simulation directory."
  echo
  echo "QUARTUS_INSTALL_DIR           -- Quartus installation directory."
}
file_copy
h
