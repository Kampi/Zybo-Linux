# 
# Synthesis run script generated by Vivado
# 

proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
create_project -in_memory -part xc7z010clg400-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir /home/daniel/Schreibtisch/Git/Zybo-Linux/Vivado/SimpleLinux/SimpleLinux.cache/wt [current_project]
set_property parent.project_path /home/daniel/Schreibtisch/Git/Zybo-Linux/Vivado/SimpleLinux/SimpleLinux.xpr [current_project]
set_property XPM_LIBRARIES {XPM_CDC XPM_FIFO XPM_MEMORY} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language VHDL [current_project]
set_property ip_output_repo /home/daniel/Schreibtisch/Git/Zybo-Linux/Vivado/SimpleLinux/SimpleLinux.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_vhdl -library xil_defaultlib /home/daniel/Schreibtisch/Git/Zybo-Linux/Vivado/SimpleLinux/SimpleLinux.srcs/sources_1/bd/ProcessingSystem/hdl/ProcessingSystem_wrapper.vhd
add_files /home/daniel/Schreibtisch/Git/Zybo-Linux/Vivado/SimpleLinux/SimpleLinux.srcs/sources_1/bd/ProcessingSystem/ProcessingSystem.bd
set_property used_in_implementation false [get_files -all /home/daniel/Schreibtisch/Git/Zybo-Linux/Vivado/SimpleLinux/SimpleLinux.srcs/sources_1/bd/ProcessingSystem/ip/ProcessingSystem_processing_system7_0_0/ProcessingSystem_processing_system7_0_0.xdc]
set_property used_in_implementation false [get_files -all /home/daniel/Schreibtisch/Git/Zybo-Linux/Vivado/SimpleLinux/SimpleLinux.srcs/sources_1/bd/ProcessingSystem/ip/ProcessingSystem_proc_sys_reset_0_0/ProcessingSystem_proc_sys_reset_0_0_board.xdc]
set_property used_in_implementation false [get_files -all /home/daniel/Schreibtisch/Git/Zybo-Linux/Vivado/SimpleLinux/SimpleLinux.srcs/sources_1/bd/ProcessingSystem/ip/ProcessingSystem_proc_sys_reset_0_0/ProcessingSystem_proc_sys_reset_0_0.xdc]
set_property used_in_implementation false [get_files -all /home/daniel/Schreibtisch/Git/Zybo-Linux/Vivado/SimpleLinux/SimpleLinux.srcs/sources_1/bd/ProcessingSystem/ip/ProcessingSystem_proc_sys_reset_0_0/ProcessingSystem_proc_sys_reset_0_0_ooc.xdc]
set_property used_in_implementation false [get_files -all /home/daniel/Schreibtisch/Git/Zybo-Linux/Vivado/SimpleLinux/SimpleLinux.srcs/sources_1/bd/ProcessingSystem/ip/ProcessingSystem_axi_gpio_0_0/ProcessingSystem_axi_gpio_0_0_board.xdc]
set_property used_in_implementation false [get_files -all /home/daniel/Schreibtisch/Git/Zybo-Linux/Vivado/SimpleLinux/SimpleLinux.srcs/sources_1/bd/ProcessingSystem/ip/ProcessingSystem_axi_gpio_0_0/ProcessingSystem_axi_gpio_0_0_ooc.xdc]
set_property used_in_implementation false [get_files -all /home/daniel/Schreibtisch/Git/Zybo-Linux/Vivado/SimpleLinux/SimpleLinux.srcs/sources_1/bd/ProcessingSystem/ip/ProcessingSystem_axi_gpio_0_0/ProcessingSystem_axi_gpio_0_0.xdc]
set_property used_in_implementation false [get_files -all /home/daniel/Schreibtisch/Git/Zybo-Linux/Vivado/SimpleLinux/SimpleLinux.srcs/sources_1/bd/ProcessingSystem/ip/ProcessingSystem_auto_pc_0/ProcessingSystem_auto_pc_0_ooc.xdc]
set_property used_in_implementation false [get_files -all /home/daniel/Schreibtisch/Git/Zybo-Linux/Vivado/SimpleLinux/SimpleLinux.srcs/sources_1/bd/ProcessingSystem/ProcessingSystem_ooc.xdc]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc /home/daniel/Schreibtisch/Git/Zybo-Linux/Vivado/SimpleLinux/SimpleLinux.srcs/constrs_1/new/SimpleLinux.xdc
set_property used_in_implementation false [get_files /home/daniel/Schreibtisch/Git/Zybo-Linux/Vivado/SimpleLinux/SimpleLinux.srcs/constrs_1/new/SimpleLinux.xdc]

read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]

synth_design -top ProcessingSystem_wrapper -part xc7z010clg400-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef ProcessingSystem_wrapper.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file ProcessingSystem_wrapper_utilization_synth.rpt -pb ProcessingSystem_wrapper_utilization_synth.pb"
