

# Delete old compilation results
if { [file exists "work"] } {
    vdel -all
}

# Create new modelsim working library

vlib work

# Compile all the Verilog sources in current folder into working library

vlog Top_tb_slave.v AHB_Lite_slave.v AHB_Lite_defines.v

# Open testbench module for simulation

vsim -t 1ns -voptargs="+acc" work.Top_tb_slave

# Add all testbench signals to waveform diagram

add wave /Top_tb_slave/*
add wave /Top_tb_slave/slave/memory
add wave /Top_tb_slave/slave/pipelined_haddr
add wave /Top_tb_slave/slave/pipelined_hwdata
add wave /Top_tb_slave/slave/pipelined_hwrite
add wave /Top_tb_slave/slave/pipelined_hsize

onbreak resume

# Run simulation
run -all

wave zoom full