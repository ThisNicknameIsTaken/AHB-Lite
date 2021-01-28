

# Delete old compilation results
if { [file exists "work"] } {
    vdel -all
}

# Create new modelsim working library

vlib work

# Compile all the Verilog sources in current folder into working library

vlog Top_tb.v AHB_Lite_master_top.v AHB_Lite_defines.v

# Open testbench module for simulation

vsim -t 1ns -voptargs="+acc" work.Top_tb

# Add all testbench signals to waveform diagram

add wave /Top_tb/*


onbreak resume

# Run simulation
run -all

wave zoom full