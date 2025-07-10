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

# 3. Set top module and simulation properties
set_property top tb [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]
set_property -name {xsim.simulate.runtime} -value {all} -objects [get_filesets sim_1]

# 4. Create and configure simulation TCL scripts for each DUT

# Create simulation command script for RCA
set rca_sim_tcl [open "./temp_quick_test/rca_sim.tcl" w]
puts $rca_sim_tcl "run all"
puts $rca_sim_tcl "quit"
close $rca_sim_tcl

# Create simulation command script for CLA
set cla_sim_tcl [open "./temp_quick_test/cla_sim.tcl" w]
puts $cla_sim_tcl "run all"
puts $cla_sim_tcl "quit"
close $cla_sim_tcl

# Create simulation command script for MULT
set mult_sim_tcl [open "./temp_quick_test/mult_sim.tcl" w]
puts $mult_sim_tcl "run all"
puts $mult_sim_tcl "quit"
close $mult_sim_tcl

# 5. Run each DUT test with appropriate plusargs

# 5.1 Test RCA Adder
puts "=== Testing RCA Adder ==="
set_property target_simulator XSim [current_project]
set_property compxlib.xsim_compiled_library_dir {} [current_project]
launch_simulation -simset sim_1 -mode behavioral
launch_simulation -scripts_only -install_path {C:/Xilinx/Vivado/2024.2}

# Create a custom run script with plusargs
set rca_run [open "./temp_quick_test/temp_quick_test.sim/sim_1/behav/xsim/simulate.tcl" w]
puts $rca_run "xsim tb_behav -key \{Behavioral:sim_1:Functional:tb\} -tclbatch \{rca_sim.tcl\} -log \{simulate.log\} -sv_seed 1 -testplusarg \{DUT_TYPE=adder_rca\} -testplusarg \{MODE=directed\} -testplusarg \{VECTORS=5\} -testplusarg \{DELAY=2\}"
close $rca_run

# Run the simulation
cd ./temp_quick_test/temp_quick_test.sim/sim_1/behav/xsim
exec xsim tb_behav -key {Behavioral:sim_1:Functional:tb} -tclbatch {rca_sim.tcl} -log {simulate.log} -sv_seed 1 -testplusarg {DUT_TYPE=adder_rca} -testplusarg {MODE=directed} -testplusarg {VECTORS=5} -testplusarg {DELAY=2}
cd ../../../../../

puts "RCA Adder test completed"

# 5.2 Test CLA Adder
puts "=== Testing CLA Adder ==="
# Create a custom run script with plusargs
set cla_run [open "./temp_quick_test/temp_quick_test.sim/sim_1/behav/xsim/simulate.tcl" w]
puts $cla_run "xsim tb_behav -key \{Behavioral:sim_1:Functional:tb\} -tclbatch \{cla_sim.tcl\} -log \{simulate.log\} -sv_seed 1 -testplusarg \{DUT_TYPE=adder_cla\} -testplusarg \{MODE=directed\} -testplusarg \{VECTORS=5\} -testplusarg \{DELAY=2\}"
close $cla_run

# Run the simulation
cd ./temp_quick_test/temp_quick_test.sim/sim_1/behav/xsim
exec xsim tb_behav -key {Behavioral:sim_1:Functional:tb} -tclbatch {cla_sim.tcl} -log {simulate.log} -sv_seed 1 -testplusarg {DUT_TYPE=adder_cla} -testplusarg {MODE=directed} -testplusarg {VECTORS=5} -testplusarg {DELAY=2}
cd ../../../../../

puts "CLA Adder test completed"

# 5.3 Test Multiplier
puts "=== Testing Multiplier ==="
# Create a custom run script with plusargs
set mult_run [open "./temp_quick_test/temp_quick_test.sim/sim_1/behav/xsim/simulate.tcl" w]
puts $mult_run "xsim tb_behav -key \{Behavioral:sim_1:Functional:tb\} -tclbatch \{mult_sim.tcl\} -log \{simulate.log\} -sv_seed 1 -testplusarg \{DUT_TYPE=multiplier\} -testplusarg \{MODE=directed\} -testplusarg \{VECTORS=5\} -testplusarg \{DELAY=2\}"
close $mult_run

# Run the simulation
cd ./temp_quick_test/temp_quick_test.sim/sim_1/behav/xsim
exec xsim tb_behav -key {Behavioral:sim_1:Functional:tb} -tclbatch {mult_sim.tcl} -log {simulate.log} -sv_seed 1 -testplusarg {DUT_TYPE=multiplier} -testplusarg {MODE=directed} -testplusarg {VECTORS=5} -testplusarg {DELAY=2}
cd ../../../../../

puts "Multiplier test completed"

puts "=== All Tests Complete ==="

# 6. Clean up
close_project
puts "Cleaning up temporary project..."
if {[catch {file delete -force ./temp_quick_test} error]} {
    puts "Warning: Could not delete temporary project: $error"
    puts "You may need to manually delete ./temp_quick_test directory"
} else {
    puts "Temporary project cleaned up successfully"
}
