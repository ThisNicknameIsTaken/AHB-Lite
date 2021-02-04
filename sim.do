

# Delete old compilation results
if { [file exists "work"] } {
    vdel -all
}

# Create new modelsim working library

vlib work

# Compile all the Verilog sources in current folder into working library

vlog Top_tb.v AHB_Lite_master_task.v AHB_Lite_slave.v AHB_Lite_defines.v

# Open testbench module for simulation

vsim -t 1ns -voptargs="+acc" work.Top_tb

# Add all testbench signals to waveform diagram

add wave /Top_tb/*
add wave /Top_tb/slave/memory
add wave /Top_tb/slave/paral_reg_for_data
add wave /Top_tb/slave/pipelined_haddr
add wave /Top_tb/slave/pipelined_hwdata
add wave /Top_tb/slave/pipelined_hwrite
add wave /Top_tb/slave/pipelined_hsize
add wave /Top_tb/master/mem
add wave /Top_tb/master/pipeline_command
add wave /Top_tb/master/task_finished
add wave /Top_tb/master/addr_phase_finished
add wave /Top_tb/master/data_phase_finished
add wave /Top_tb/master/error_low
add wave /Top_tb/master/pipelined_data

onbreak resume

# Run simulation
run -all

wave zoom full