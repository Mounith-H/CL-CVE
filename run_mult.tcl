# Script to test Multiplier - Working Version
puts "Starting Multiplier Test..."

# 1. Create a temporary project (not in-memory for simulation)
create_project temp_mult_test ./temp_mult_test -part xc7z020clg400-1 -force

# 2. Add design sources  
add_files -norecurse ./design/adder_rca.sv
add_files -norecurse ./design/adder_cla.sv
add_files -norecurse ./design/multiplier.sv
add_files -norecurse ./design/dut_wrapper.sv

# 3. Add simulation sources
add_files -fileset sim_1 -norecurse ./sim/tb_mult.sv

# 4. Set simulation properties
set_property top tb_mult [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]

# 5. Remove problematic plusargs for now

# 6. Launch simulation
puts "Launching simulation..."
launch_simulation

# 7. Run the simulation with runtime commands
puts "Running simulation..."
run 100ns

puts "Multiplier test completed!"

# 8. Clean up (with delay to avoid file locks)
close_project
puts "Cleaning up temporary project..."
puts "Note: Temporary project files left in ./temp_mult_test for manual cleanup"
puts "Use cleanup.bat to remove all temporary projects"
