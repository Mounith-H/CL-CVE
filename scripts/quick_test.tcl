# Quick Test Script - Run this in Vivado TCL Console
# Copy and paste the following commands one by one:

# 1. Create project
create_project test_project . -part xc7z020clg400-1 -in_memory

# 2. Add all design files
add_files ./design/adder_rca.sv
add_files ./design/adder_cla.sv  
add_files ./design/multiplier.sv
add_files ./design/dut_wrapper.sv

# Add testbench file to simulation sources
add_files -fileset sim_1 ./sim/tb.sv

# 3. Set top module
set_property top tb [current_fileset]

# 4. Test RCA Adder
puts "=== Testing RCA Adder ==="
launch_simulation -simset sim_1 -mode behavioral -args {+DUT_TYPE=adder_rca +MODE=directed +VECTORS=5 +DELAY=2}
run all

# 5. Close simulation
close_sim

# 6. Test CLA Adder  
puts "=== Testing CLA Adder ==="
launch_simulation -simset sim_1 -mode behavioral -args {+DUT_TYPE=adder_cla +MODE=directed +VECTORS=5 +DELAY=2}
run all

# 7. Close simulation
close_sim

# 8. Test Multiplier
puts "=== Testing Multiplier ==="
launch_simulation -simset sim_1 -mode behavioral -args {+DUT_TYPE=multiplier +MODE=directed +VECTORS=5 +DELAY=2}
run all

puts "=== All Tests Complete ==="
