add wave -noupdate -divider {SOPC_Video_CPU: top-level ports}
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/d_irq
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/d_waitrequest
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/d_address
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/d_byteenable
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/d_read
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/d_readdata
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/d_write
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/d_writedata
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/i_waitrequest
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/i_address
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/i_read
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/i_readdata
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/E_ci_dataa
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/E_ci_datab
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/W_ci_ipending
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/W_ci_status
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/W_ci_estatus
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/D_ci_n
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/D_ci_a
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/D_ci_b
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/D_ci_c
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/D_ci_readra
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/D_ci_readrb
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/D_ci_writerc
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/E_ci_result
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/E_ci_multi_clk_en
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/E_ci_multi_clock
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/E_ci_multi_reset
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/E_ci_multi_start
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/E_ci_multi_done
add wave -noupdate -divider {SOPC_Video_CPU: common}
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/clk
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/reset_n
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/F_pcb_nxt
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/F_pcb
add wave -noupdate -format Logic -radix ascii /NIOS2_INSTANCE_TOP/F_vinst
add wave -noupdate -format Logic -radix ascii /NIOS2_INSTANCE_TOP/D_vinst
add wave -noupdate -format Logic -radix ascii /NIOS2_INSTANCE_TOP/R_vinst
add wave -noupdate -format Logic -radix ascii /NIOS2_INSTANCE_TOP/E_vinst
add wave -noupdate -format Logic -radix ascii /NIOS2_INSTANCE_TOP/W_vinst
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/F_valid
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/D_valid
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/R_valid
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/E_valid
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/W_valid
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/D_wr_dst_reg
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/D_dst_regnum
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/W_wr_data
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/F_iw
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/D_iw
add wave -noupdate -divider {SOPC_Video_CPU: breaks}
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/hbreak_req
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/oci_hbreak_req
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/hbreak_enabled
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/wait_for_one_post_bret_inst
add wave -noupdate -divider {SOPC_Video_CPU: custom_instruction}
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/R_ctrl_custom
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/R_ctrl_custom_multi
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/E_ci_dataa
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/E_ci_datab
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/W_ipending_reg
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/W_status_reg
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/W_estatus_reg
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/D_ci_n
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/D_ci_readra
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/D_ci_readrb
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/D_ci_writerc
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/E_ci_result
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/E_ci_multi_clk_en
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/E_ci_multi_start
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/E_ci_multi_done
add wave -noupdate -format Logic -radix hexadecimal /NIOS2_INSTANCE_TOP/E_ci_multi_stall

configure wave -justifyvalue right
configure wave -signalnamewidth 1
TreeUpdate [SetDefaultTree]
