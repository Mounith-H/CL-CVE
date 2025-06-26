# Script to run random testing on all DUTs - Working Version
puts "Starting Random Test..."

# 1. Create a temporary project (not in-memory for simulation)
create_project temp_random_test ./temp_random_test -part xc7z020clg400-1 -force

# 2. Add design sources  
add_files -norecurse ./design/adder_rca.sv
add_files -norecurse ./design/adder_cla.sv
add_files -norecurse ./design/multiplier.sv  
add_files -norecurse ./design/dut_wrapper.sv

# 3. Add simulation sources
add_files -fileset sim_1 -norecurse ./sim/tb.sv

# 4. Set simulation properties
set_property top tb [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]

# 5. Configure simulation with plusargs
set_property -name {xsim.elaborate.xelab.more_options} -value {+DUT_TYPE=adder_rca +MODE=random +VECTORS=20 +DELAY=1} -objects [get_filesets sim_1]

# 6. Launch simulation
puts "Launching simulation..."
launch_simulation

# 7. Run the simulation  
puts "Running simulation..."
run all

puts "Random test completed!"

# 8. Clean up
close_project
puts "Cleaning up temporary project..."
file delete -force ./temp_random_test
