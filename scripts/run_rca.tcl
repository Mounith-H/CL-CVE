# Script to test RCA Adder - Working Version
puts "Starting RCA Adder Test..."

# 1. Create a temporary project (not in-memory for simulation)
create_project temp_rca_test ./temp_rca_test -part xc7z020clg400-1 -force

# 2. Add design sources  
add_files -norecurse ./design/adder_rca.sv
add_files -norecurse ./design/adder_cla.sv
add_files -norecurse ./design/multiplier.sv
add_files -norecurse ./design/dut_wrapper.sv

# 3. Add simulation sources
add_files -fileset sim_1 -norecurse ../sim/tb.sv

# 4. Set simulation properties
set_property top tb [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]

# 5. Remove problematic plusargs for now

# 6. Launch simulation
puts "Launching simulation..."
launch_simulation

# 7. Run the simulation
puts "Running simulation..."
run 100ns

puts "RCA Adder test completed!"

# 8. Clean up (with error handling)
close_project
puts "Cleaning up temporary project..."
if {[catch {file delete -force ./temp_rca_test} error]} {
    puts "Warning: Could not delete temporary project: $error"
    puts "You may need to manually delete ./temp_rca_test directory"
} else {
    puts "Temporary project cleaned up successfully"
}
