

# Delete old compilation results
if { [file exists "work"] } {
    vdel -all
}

# Create new modelsim working library

vlib work

# Compile all the Verilog sources in current folder into working library

vlog FIFO_test.sv FIFO.sv
# Open testbench module for simulation

vsim -t 1ns -voptargs="+acc" work.FIFO_test

# Add all testbench signals to waveform diagram


add wave /FIFO_test/*


onbreak resume

# Run simulation
run -all

wave zoom full