# Working Script for RCA Adder Testing
# This script uses proper Vivado batch mode syntax

# 1. Create a new project in memory
create_project -in_memory -part xc7z020clg400-1

# 2. Read design files
read_verilog ./design/adder_rca.sv
read_verilog ./design/adder_cla.sv
read_verilog ./design/multiplier.sv
read_verilog ./design/dut_wrapper.sv

# 3. Read testbench
read_verilog ./sim/tb.sv

# 4. Set top module
set_property top tb [current_fileset -simset]

# 5. Launch XSim
launch_simulation

# 6. Run with custom commands
puts "Setting up RCA Adder test..."
# Force the DUT type in the simulation
add_force /tb/dut/dut_type -value adder_rca
restart
run 1000ns

puts "RCA Adder test completed"
