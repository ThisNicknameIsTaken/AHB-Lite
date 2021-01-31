

# Delete old compilation results
if { [file exists "work"] } {
    vdel -all
}

# Create new modelsim working library

vlib work

# Compile all the Verilog sources in current folder into working library

vlog Top_testbench.v AHB_Lite_master_top.v AHB_Lite_slave.v AHB_Lite_defines.v

# Open testbench module for simulation

vsim -t 1ns -voptargs="+acc" work.Top_testbench

# Add all testbench signals to waveform diagram

add wave /Top_testbench/*
add wave /Top_testbench/slave/memory
add wave /Top_testbench/slave/pipelined_haddr
add wave /Top_testbench/slave/pipelined_hwdata
add wave /Top_testbench/slave/pipelined_hwrite
add wave /Top_testbench/slave/pipelined_hsize
add wave /Top_testbench/master/rdata
add wave /Top_testbench/master/pipelined_hwrite
add wave /Top_testbench/master/pipelined_data

onbreak resume

# Run simulation
run -all

wave zoom full