# Quick Test Script - Run this in Vivado TCL Console
# This script runs a quick test on all three designs

# 1. Create a temporary project for testing
create_project temp_quick_test ./temp_quick_test -part xc7z020clg400-1 -force

# 2. Add all design files
add_files ./design/adder_rca.sv
add_files ./design/adder_cla.sv  
add_files ./design/multiplier.sv
add_files ./design/dut_wrapper.sv

# Add testbench file to simulation sources
add_files -fileset sim_1 ./sim/tb.sv

# 3. Set top module
set_property top tb [get_filesets sim_1]

# 4. Configure and run tests for all DUTs sequentially
set_property -name {xsim.simulate.runtime} -value {all} -objects [get_filesets sim_1]

# 4.1 Test RCA Adder
puts "=== Testing RCA Adder ==="
set_property -name {xsim.simulate.xsim.more_options} -value {+DUT_TYPE=adder_rca +MODE=directed +VECTORS=5 +DELAY=2} -objects [get_filesets sim_1]
launch_simulation
run all
close_sim

# 4.2 Test CLA Adder
puts "=== Testing CLA Adder ==="
set_property -name {xsim.simulate.xsim.more_options} -value {+DUT_TYPE=adder_cla +MODE=directed +VECTORS=5 +DELAY=2} -objects [get_filesets sim_1]
launch_simulation
run all
close_sim

# 4.3 Test Multiplier
puts "=== Testing Multiplier ==="
set_property -name {xsim.simulate.xsim.more_options} -value {+DUT_TYPE=multiplier +MODE=directed +VECTORS=5 +DELAY=2} -objects [get_filesets sim_1]
launch_simulation
run all
close_sim

puts "=== All Tests Complete ==="

# 5. Clean up
close_project
puts "Cleaning up temporary project..."
if {[catch {file delete -force ./temp_quick_test} error]} {
    puts "Warning: Could not delete temporary project: $error"
    puts "You may need to manually delete ./temp_quick_test directory"
} else {
    puts "Temporary project cleaned up successfully"
}
