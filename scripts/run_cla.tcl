# Script to test CLA Adder - Working Version
puts "Starting CLA Adder Test..."

# 1. Create a temporary project (not in-memory for simulation)
create_project temp_cla_test ./temp_cla_test -part xc7z020clg400-1 -force

# 2. Add design sources  
add_files -norecurse ./design/adder_rca.sv
add_files -norecurse ./design/adder_cla.sv
add_files -norecurse ./design/multiplier.sv
add_files -norecurse ./design/dut_wrapper.sv

# 3. Add simulation sources - use CLA-specific testbench
add_files -fileset sim_1 -norecurse ../sim/tb_cla.sv

# 4. Set simulation properties
set_property top tb_cla [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]

# 5. Launch simulation
puts "Launching simulation..."
launch_simulation

# 6. Run the simulation  
puts "Running simulation..." 
run 100ns

puts "CLA Adder test completed!"

# 8. Clean up (with error handling)
close_project
puts "Cleaning up temporary project..."
if {[catch {file delete -force ./temp_cla_test} error]} {
    puts "Warning: Could not delete temporary project: $error"
    puts "You may need to manually delete ./temp_cla_test directory"
} else {
    puts "Temporary project cleaned up successfully"
}
