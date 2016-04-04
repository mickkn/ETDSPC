
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
# ncsim - auto-generated simulation script

# ----------------------------------------
# initialize variables
TOP_LEVEL_NAME="SOPC_Video"
QSYS_SIMDIR="./../"
QUARTUS_INSTALL_DIR="C:/altera/13.0sp1/quartus/"
SKIP_FILE_COPY=0
SKIP_DEV_COM=0
SKIP_COM=0
SKIP_ELAB=0
SKIP_SIM=0
USER_DEFINED_ELAB_OPTIONS=""
USER_DEFINED_SIM_OPTIONS="-input \"@run 100; exit\""

# ----------------------------------------
# overwrite variables - DO NOT MODIFY!
# This block evaluates each command line argument, typically used for 
# overwriting variables. An example usage:
#   sh <simulator>_setup.sh SKIP_ELAB=1 SKIP_SIM=1
for expression in "$@"; do
  eval $expression
  if [ $? -ne 0 ]; then
    echo "Error: This command line argument, \"$expression\", is/has an invalid expression." >&2
    exit $?
  fi
done

# ----------------------------------------
# create compilation libraries
mkdir -p ./libraries/work/
mkdir -p ./libraries/nios_custom_instr_floating_point_0/
mkdir -p ./libraries/switch/
mkdir -p ./libraries/red_leds/
mkdir -p ./libraries/lcd/
mkdir -p ./libraries/timer_system/
mkdir -p ./libraries/sdram_0/
mkdir -p ./libraries/sysid_qsys_0/
mkdir -p ./libraries/video_rgb_resampler_0/
mkdir -p ./libraries/video_scaler_0/
mkdir -p ./libraries/video_clipper_0/
mkdir -p ./libraries/video_bayer_resampler/
mkdir -p ./libraries/jtag_uart_0/
mkdir -p ./libraries/Clock_Signals/
mkdir -p ./libraries/CPU/
mkdir -p ./libraries/AV_Config/
mkdir -p ./libraries/Video_DMA/
mkdir -p ./libraries/Video_In_Decoder/
mkdir -p ./libraries/VGA_Controller/
mkdir -p ./libraries/Pixel_RGB_Resampler/
mkdir -p ./libraries/Pixel_Buffer_DMA/
mkdir -p ./libraries/Pixel_Buffer/
mkdir -p ./libraries/Dual_Clock_FIFO/
mkdir -p ./libraries/Onchip_Memory/
mkdir -p ./libraries/altera_ver/
mkdir -p ./libraries/lpm_ver/
mkdir -p ./libraries/sgate_ver/
mkdir -p ./libraries/altera_mf_ver/
mkdir -p ./libraries/altera_lnsim_ver/
mkdir -p ./libraries/cycloneii_ver/
mkdir -p ./libraries/altera/
mkdir -p ./libraries/lpm/
mkdir -p ./libraries/sgate/
mkdir -p ./libraries/altera_mf/
mkdir -p ./libraries/altera_lnsim/
mkdir -p ./libraries/cycloneii/

# ----------------------------------------
# copy RAM/ROM files to simulation directory
if [ $SKIP_FILE_COPY -eq 0 ]; then
  cp -f $QSYS_SIMDIR/submodules/SOPC_Video_CPU_ociram_default_contents.dat ./
  cp -f $QSYS_SIMDIR/submodules/SOPC_Video_CPU_ociram_default_contents.hex ./
  cp -f $QSYS_SIMDIR/submodules/SOPC_Video_CPU_ociram_default_contents.mif ./
  cp -f $QSYS_SIMDIR/submodules/SOPC_Video_CPU_rf_ram_a.dat ./
  cp -f $QSYS_SIMDIR/submodules/SOPC_Video_CPU_rf_ram_a.hex ./
  cp -f $QSYS_SIMDIR/submodules/SOPC_Video_CPU_rf_ram_a.mif ./
  cp -f $QSYS_SIMDIR/submodules/SOPC_Video_CPU_rf_ram_b.dat ./
  cp -f $QSYS_SIMDIR/submodules/SOPC_Video_CPU_rf_ram_b.hex ./
  cp -f $QSYS_SIMDIR/submodules/SOPC_Video_CPU_rf_ram_b.mif ./
  cp -f $QSYS_SIMDIR/submodules/SOPC_Video_Onchip_Memory.hex ./
fi

# ----------------------------------------
# compile device library files
if [ $SKIP_DEV_COM -eq 0 ]; then
  ncvlog      "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives.v"              -work altera_ver      
  ncvlog      "$QUARTUS_INSTALL_DIR/eda/sim_lib/220model.v"                       -work lpm_ver         
  ncvlog      "$QUARTUS_INSTALL_DIR/eda/sim_lib/sgate.v"                          -work sgate_ver       
  ncvlog      "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf.v"                      -work altera_mf_ver   
  ncvlog -sv  "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_lnsim.sv"                  -work altera_lnsim_ver
  ncvlog      "$QUARTUS_INSTALL_DIR/eda/sim_lib/cycloneii_atoms.v"                -work cycloneii_ver   
  ncvhdl -v93 "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_syn_attributes.vhd"        -work altera          
  ncvhdl -v93 "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_standard_functions.vhd"    -work altera          
  ncvhdl -v93 "$QUARTUS_INSTALL_DIR/eda/sim_lib/alt_dspbuilder_package.vhd"       -work altera          
  ncvhdl -v93 "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_europa_support_lib.vhd"    -work altera          
  ncvhdl -v93 "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives_components.vhd" -work altera          
  ncvhdl -v93 "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives.vhd"            -work altera          
  ncvhdl -v93 "$QUARTUS_INSTALL_DIR/eda/sim_lib/220pack.vhd"                      -work lpm             
  ncvhdl -v93 "$QUARTUS_INSTALL_DIR/eda/sim_lib/220model.vhd"                     -work lpm             
  ncvhdl -v93 "$QUARTUS_INSTALL_DIR/eda/sim_lib/sgate_pack.vhd"                   -work sgate           
  ncvhdl -v93 "$QUARTUS_INSTALL_DIR/eda/sim_lib/sgate.vhd"                        -work sgate           
  ncvhdl -v93 "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf_components.vhd"         -work altera_mf       
  ncvhdl -v93 "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf.vhd"                    -work altera_mf       
  ncvhdl -v93 "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_lnsim_components.vhd"      -work altera_lnsim    
  ncvhdl -v93 "$QUARTUS_INSTALL_DIR/eda/sim_lib/cycloneii_atoms.vhd"              -work cycloneii       
  ncvhdl -v93 "$QUARTUS_INSTALL_DIR/eda/sim_lib/cycloneii_components.vhd"         -work cycloneii       
fi

# ----------------------------------------
# compile design files in correct order
if [ $SKIP_COM -eq 0 ]; then
  ncvhdl -v93 "$QSYS_SIMDIR/submodules/SOPC_Video_nios_custom_instr_floating_point_0.vho"                                       -work nios_custom_instr_floating_point_0 -cdslib ./cds_libs/nios_custom_instr_floating_point_0.cds.lib
  ncvhdl -v93 "$QSYS_SIMDIR/submodules/SOPC_Video_switch.vhd"                                                                   -work switch                             -cdslib ./cds_libs/switch.cds.lib                            
  ncvhdl -v93 "$QSYS_SIMDIR/submodules/SOPC_Video_red_leds.vhd"                                                                 -work red_leds                           -cdslib ./cds_libs/red_leds.cds.lib                          
  ncvhdl -v93 "$QSYS_SIMDIR/submodules/SOPC_Video_lcd.vhd"                                                                      -work lcd                                -cdslib ./cds_libs/lcd.cds.lib                               
  ncvhdl -v93 "$QSYS_SIMDIR/submodules/SOPC_Video_timer_system.vhd"                                                             -work timer_system                       -cdslib ./cds_libs/timer_system.cds.lib                      
  ncvhdl -v93 "$QSYS_SIMDIR/submodules/SOPC_Video_sdram_0.vhd"                                                                  -work sdram_0                            -cdslib ./cds_libs/sdram_0.cds.lib                           
  ncvhdl -v93 "$QSYS_SIMDIR/submodules/SOPC_Video_sysid_qsys_0.vho"                                                             -work sysid_qsys_0                       -cdslib ./cds_libs/sysid_qsys_0.cds.lib                      
  ncvhdl -v93 "$QSYS_SIMDIR/submodules/SOPC_Video_video_rgb_resampler_0.vhd"                                                    -work video_rgb_resampler_0              -cdslib ./cds_libs/video_rgb_resampler_0.cds.lib             
  ncvlog      "$QSYS_SIMDIR/submodules/altera_up_video_scaler_shrink.v"                                                         -work video_scaler_0                     -cdslib ./cds_libs/video_scaler_0.cds.lib                    
  ncvlog      "$QSYS_SIMDIR/submodules/altera_up_video_scaler_multiply_width.v"                                                 -work video_scaler_0                     -cdslib ./cds_libs/video_scaler_0.cds.lib                    
  ncvlog      "$QSYS_SIMDIR/submodules/altera_up_video_scaler_multiply_height.v"                                                -work video_scaler_0                     -cdslib ./cds_libs/video_scaler_0.cds.lib                    
  ncvhdl -v93 "$QSYS_SIMDIR/submodules/SOPC_Video_video_scaler_0.vhd"                                                           -work video_scaler_0                     -cdslib ./cds_libs/video_scaler_0.cds.lib                    
  ncvlog      "$QSYS_SIMDIR/submodules/altera_up_video_clipper_add.v"                                                           -work video_clipper_0                    -cdslib ./cds_libs/video_clipper_0.cds.lib                   
  ncvlog      "$QSYS_SIMDIR/submodules/altera_up_video_clipper_drop.v"                                                          -work video_clipper_0                    -cdslib ./cds_libs/video_clipper_0.cds.lib                   
  ncvlog      "$QSYS_SIMDIR/submodules/altera_up_video_clipper_counters.v"                                                      -work video_clipper_0                    -cdslib ./cds_libs/video_clipper_0.cds.lib                   
  ncvhdl -v93 "$QSYS_SIMDIR/submodules/SOPC_Video_video_clipper_0.vhd"                                                          -work video_clipper_0                    -cdslib ./cds_libs/video_clipper_0.cds.lib                   
  ncvhdl -v93 "$QSYS_SIMDIR/submodules/SOPC_Video_video_bayer_resampler.vhd"                                                    -work video_bayer_resampler              -cdslib ./cds_libs/video_bayer_resampler.cds.lib             
  ncvhdl -v93 "$QSYS_SIMDIR/submodules/SOPC_Video_jtag_uart_0.vhd"                                                              -work jtag_uart_0                        -cdslib ./cds_libs/jtag_uart_0.cds.lib                       
  ncvhdl -v93 "$QSYS_SIMDIR/submodules/SOPC_Video_Clock_Signals.vhd"                                                            -work Clock_Signals                      -cdslib ./cds_libs/Clock_Signals.cds.lib                     
  ncvhdl -v93 "$QSYS_SIMDIR/submodules/SOPC_Video_CPU.vhd"                                                                      -work CPU                                -cdslib ./cds_libs/CPU.cds.lib                               
  ncvhdl -v93 "$QSYS_SIMDIR/submodules/SOPC_Video_CPU_jtag_debug_module_sysclk.vhd"                                             -work CPU                                -cdslib ./cds_libs/CPU.cds.lib                               
  ncvhdl -v93 "$QSYS_SIMDIR/submodules/SOPC_Video_CPU_jtag_debug_module_tck.vhd"                                                -work CPU                                -cdslib ./cds_libs/CPU.cds.lib                               
  ncvhdl -v93 "$QSYS_SIMDIR/submodules/SOPC_Video_CPU_jtag_debug_module_wrapper.vhd"                                            -work CPU                                -cdslib ./cds_libs/CPU.cds.lib                               
  ncvhdl -v93 "$QSYS_SIMDIR/submodules/SOPC_Video_CPU_oci_test_bench.vhd"                                                       -work CPU                                -cdslib ./cds_libs/CPU.cds.lib                               
  ncvhdl -v93 "$QSYS_SIMDIR/submodules/SOPC_Video_CPU_test_bench.vhd"                                                           -work CPU                                -cdslib ./cds_libs/CPU.cds.lib                               
  ncvlog      "$QSYS_SIMDIR/submodules/altera_up_av_config_serial_bus_controller.v"                                             -work AV_Config                          -cdslib ./cds_libs/AV_Config.cds.lib                         
  ncvlog      "$QSYS_SIMDIR/submodules/altera_up_slow_clock_generator.v"                                                        -work AV_Config                          -cdslib ./cds_libs/AV_Config.cds.lib                         
  ncvlog      "$QSYS_SIMDIR/submodules/altera_up_av_config_auto_init.v"                                                         -work AV_Config                          -cdslib ./cds_libs/AV_Config.cds.lib                         
  ncvlog      "$QSYS_SIMDIR/submodules/altera_up_av_config_auto_init_dc2.v"                                                     -work AV_Config                          -cdslib ./cds_libs/AV_Config.cds.lib                         
  ncvlog      "$QSYS_SIMDIR/submodules/altera_up_av_config_auto_init_d5m.v"                                                     -work AV_Config                          -cdslib ./cds_libs/AV_Config.cds.lib                         
  ncvlog      "$QSYS_SIMDIR/submodules/altera_up_av_config_auto_init_lcm.v"                                                     -work AV_Config                          -cdslib ./cds_libs/AV_Config.cds.lib                         
  ncvlog      "$QSYS_SIMDIR/submodules/altera_up_av_config_auto_init_ltm.v"                                                     -work AV_Config                          -cdslib ./cds_libs/AV_Config.cds.lib                         
  ncvlog      "$QSYS_SIMDIR/submodules/altera_up_av_config_auto_init_ob_de2_35.v"                                               -work AV_Config                          -cdslib ./cds_libs/AV_Config.cds.lib                         
  ncvlog      "$QSYS_SIMDIR/submodules/altera_up_av_config_auto_init_ob_adv7181.v"                                              -work AV_Config                          -cdslib ./cds_libs/AV_Config.cds.lib                         
  ncvlog      "$QSYS_SIMDIR/submodules/altera_up_av_config_auto_init_ob_de2_70.v"                                               -work AV_Config                          -cdslib ./cds_libs/AV_Config.cds.lib                         
  ncvlog      "$QSYS_SIMDIR/submodules/altera_up_av_config_auto_init_ob_de2_115.v"                                              -work AV_Config                          -cdslib ./cds_libs/AV_Config.cds.lib                         
  ncvlog      "$QSYS_SIMDIR/submodules/altera_up_av_config_auto_init_ob_audio.v"                                                -work AV_Config                          -cdslib ./cds_libs/AV_Config.cds.lib                         
  ncvlog      "$QSYS_SIMDIR/submodules/altera_up_av_config_auto_init_ob_adv7180.v"                                              -work AV_Config                          -cdslib ./cds_libs/AV_Config.cds.lib                         
  ncvhdl -v93 "$QSYS_SIMDIR/submodules/SOPC_Video_AV_Config.vhd"                                                                -work AV_Config                          -cdslib ./cds_libs/AV_Config.cds.lib                         
  ncvlog      "$QSYS_SIMDIR/submodules/altera_up_video_dma_control_slave.v"                                                     -work Video_DMA                          -cdslib ./cds_libs/Video_DMA.cds.lib                         
  ncvlog      "$QSYS_SIMDIR/submodules/altera_up_video_dma_to_memory.v"                                                         -work Video_DMA                          -cdslib ./cds_libs/Video_DMA.cds.lib                         
  ncvlog      "$QSYS_SIMDIR/submodules/altera_up_video_dma_to_stream.v"                                                         -work Video_DMA                          -cdslib ./cds_libs/Video_DMA.cds.lib                         
  ncvhdl -v93 "$QSYS_SIMDIR/submodules/SOPC_Video_Video_DMA.vhd"                                                                -work Video_DMA                          -cdslib ./cds_libs/Video_DMA.cds.lib                         
  ncvlog      "$QSYS_SIMDIR/submodules/altera_up_video_itu_656_decoder.v"                                                       -work Video_In_Decoder                   -cdslib ./cds_libs/Video_In_Decoder.cds.lib                  
  ncvlog      "$QSYS_SIMDIR/submodules/altera_up_video_decoder_add_endofpacket.v"                                               -work Video_In_Decoder                   -cdslib ./cds_libs/Video_In_Decoder.cds.lib                  
  ncvlog      "$QSYS_SIMDIR/submodules/altera_up_video_camera_decoder.v"                                                        -work Video_In_Decoder                   -cdslib ./cds_libs/Video_In_Decoder.cds.lib                  
  ncvlog      "$QSYS_SIMDIR/submodules/altera_up_video_dual_clock_fifo.v"                                                       -work Video_In_Decoder                   -cdslib ./cds_libs/Video_In_Decoder.cds.lib                  
  ncvhdl -v93 "$QSYS_SIMDIR/submodules/SOPC_Video_Video_In_Decoder.vhd"                                                         -work Video_In_Decoder                   -cdslib ./cds_libs/Video_In_Decoder.cds.lib                  
  ncvlog      "$QSYS_SIMDIR/submodules/altera_up_avalon_video_vga_timing.v"                                                     -work VGA_Controller                     -cdslib ./cds_libs/VGA_Controller.cds.lib                    
  ncvhdl -v93 "$QSYS_SIMDIR/submodules/SOPC_Video_VGA_Controller.vhd"                                                           -work VGA_Controller                     -cdslib ./cds_libs/VGA_Controller.cds.lib                    
  ncvhdl -v93 "$QSYS_SIMDIR/submodules/SOPC_Video_Pixel_RGB_Resampler.vhd"                                                      -work Pixel_RGB_Resampler                -cdslib ./cds_libs/Pixel_RGB_Resampler.cds.lib               
  ncvhdl -v93 "$QSYS_SIMDIR/submodules/SOPC_Video_Pixel_Buffer_DMA.vhd"                                                         -work Pixel_Buffer_DMA                   -cdslib ./cds_libs/Pixel_Buffer_DMA.cds.lib                  
  ncvhdl -v93 "$QSYS_SIMDIR/submodules/SOPC_Video_Pixel_Buffer.vhd"                                                             -work Pixel_Buffer                       -cdslib ./cds_libs/Pixel_Buffer.cds.lib                      
  ncvhdl -v93 "$QSYS_SIMDIR/submodules/SOPC_Video_Dual_Clock_FIFO.vhd"                                                          -work Dual_Clock_FIFO                    -cdslib ./cds_libs/Dual_Clock_FIFO.cds.lib                   
  ncvhdl -v93 "$QSYS_SIMDIR/submodules/SOPC_Video_Onchip_Memory.vhd"                                                            -work Onchip_Memory                      -cdslib ./cds_libs/Onchip_Memory.cds.lib                     
  ncvhdl -v93 "$QSYS_SIMDIR/SOPC_Video.vhd"                                                                                                                                                                                           
  ncvhdl -v93 "$QSYS_SIMDIR/sopc_video_width_adapter.vhd"                                                                                                                                                                             
  ncvhdl -v93 "$QSYS_SIMDIR/sopc_video_width_adapter_003.vhd"                                                                                                                                                                         
  ncvhdl -v93 "$QSYS_SIMDIR/sopc_video_width_adapter_005.vhd"                                                                                                                                                                         
  ncvhdl -v93 "$QSYS_SIMDIR/sopc_video_width_adapter_008.vhd"                                                                                                                                                                         
  ncvhdl -v93 "$QSYS_SIMDIR/sopc_video_rst_controller.vhd"                                                                                                                                                                            
  ncvhdl -v93 "$QSYS_SIMDIR/sopc_video_rst_controller_001.vhd"                                                                                                                                                                        
  ncvhdl -v93 "$QSYS_SIMDIR/sopc_video_rst_controller_003.vhd"                                                                                                                                                                        
  ncvhdl -v93 "$QSYS_SIMDIR/sopc_video_cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent.vhd"                                                                                                                           
  ncvhdl -v93 "$QSYS_SIMDIR/sopc_video_sdram_0_s1_translator_avalon_universal_slave_0_agent.vhd"                                                                                                                                      
  ncvhdl -v93 "$QSYS_SIMDIR/sopc_video_cpu_instruction_master_translator.vhd"                                                                                                                                                         
  ncvhdl -v93 "$QSYS_SIMDIR/sopc_video_cpu_data_master_translator.vhd"                                                                                                                                                                
  ncvhdl -v93 "$QSYS_SIMDIR/sopc_video_pixel_buffer_dma_avalon_pixel_dma_master_translator.vhd"                                                                                                                                       
  ncvhdl -v93 "$QSYS_SIMDIR/sopc_video_video_dma_avalon_dma_master_translator.vhd"                                                                                                                                                    
  ncvhdl -v93 "$QSYS_SIMDIR/sopc_video_cpu_jtag_debug_module_translator.vhd"                                                                                                                                                          
  ncvhdl -v93 "$QSYS_SIMDIR/sopc_video_onchip_memory_s1_translator.vhd"                                                                                                                                                               
  ncvhdl -v93 "$QSYS_SIMDIR/sopc_video_sdram_0_s1_translator.vhd"                                                                                                                                                                     
  ncvhdl -v93 "$QSYS_SIMDIR/sopc_video_pixel_buffer_avalon_sram_slave_translator.vhd"                                                                                                                                                 
  ncvhdl -v93 "$QSYS_SIMDIR/sopc_video_av_config_avalon_av_config_slave_translator.vhd"                                                                                                                                               
  ncvhdl -v93 "$QSYS_SIMDIR/sopc_video_video_dma_avalon_dma_control_slave_translator.vhd"                                                                                                                                             
  ncvhdl -v93 "$QSYS_SIMDIR/sopc_video_jtag_uart_0_avalon_jtag_slave_translator.vhd"                                                                                                                                                  
  ncvhdl -v93 "$QSYS_SIMDIR/sopc_video_sysid_qsys_0_control_slave_translator.vhd"                                                                                                                                                     
  ncvhdl -v93 "$QSYS_SIMDIR/sopc_video_timer_system_s1_translator.vhd"                                                                                                                                                                
  ncvhdl -v93 "$QSYS_SIMDIR/sopc_video_lcd_control_slave_translator.vhd"                                                                                                                                                              
  ncvhdl -v93 "$QSYS_SIMDIR/sopc_video_red_leds_s1_translator.vhd"                                                                                                                                                                    
  ncvhdl -v93 "$QSYS_SIMDIR/sopc_video_switch_s1_translator.vhd"                                                                                                                                                                      
  ncvhdl -v93 "$QSYS_SIMDIR/sopc_video_altera_up_sd_card_avalon_interface_0_avalon_sdcard_slave_translator.vhd"                                                                                                                       
  ncvhdl -v93 "$QSYS_SIMDIR/sopc_video_cpu_instruction_master_translator_avalon_universal_master_0_agent.vhd"                                                                                                                         
  ncvhdl -v93 "$QSYS_SIMDIR/sopc_video_pixel_buffer_dma_avalon_pixel_dma_master_translator_avalon_universal_master_0_agent.vhd"                                                                                                       
fi

# ----------------------------------------
# elaborate top level design
if [ $SKIP_ELAB -eq 0 ]; then
  ncelab -access +w+r+c -namemap_mixgen -relax $USER_DEFINED_ELAB_OPTIONS $TOP_LEVEL_NAME
fi

# ----------------------------------------
# simulate
if [ $SKIP_SIM -eq 0 ]; then
  eval ncsim -licqueue $USER_DEFINED_SIM_OPTIONS $TOP_LEVEL_NAME
fi