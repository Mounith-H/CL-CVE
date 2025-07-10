# Quick Test Script - Run with DUT type parameter
# This runs a quick test for a specific DUT (adder_rca, adder_cla, or multiplier)
# Example usage: vivado -mode batch -source scripts\run_test.tcl -tclargs adder_rca

# Get DUT type from command line arguments
if {$argc != 1} {
    puts "Error: Missing DUT type parameter."
    puts "Usage: vivado -mode batch -source scripts\\run_test.tcl -tclargs <dut_type>"
    puts "Where <dut_type> is one of: adder_rca, adder_cla, multiplier"
    exit 1
}

set dut_type [lindex $argv 0]

# Check for valid DUT type
if {$dut_type != "adder_rca" && $dut_type != "adder_cla" && $dut_type != "multiplier"} {
    puts "Error: Invalid DUT type '$dut_type'."
    puts "Valid types are: adder_rca, adder_cla, multiplier"
    exit 1
}

# Create a temporary project
puts "Creating temporary project for $dut_type test..."
create_project temp_${dut_type}_test ./temp_${dut_type}_test -part xc7z020clg400-1 -force

# Add all design files
add_files ./design/adder_rca.sv
add_files ./design/adder_cla.sv  
add_files ./design/multiplier.sv
add_files ./design/dut_wrapper.sv

# Add appropriate testbench file
if {$dut_type == "adder_rca"} {
    add_files -fileset sim_1 ./sim/tb.sv
    set_property top tb [get_filesets sim_1]
} elseif {$dut_type == "adder_cla"} {
    add_files -fileset sim_1 ./sim/tb_cla.sv
    set_property top tb_cla [get_filesets sim_1]
} elseif {$dut_type == "multiplier"} {
    add_files -fileset sim_1 ./sim/tb_mult.sv
    set_property top tb_mult [get_filesets sim_1]
}

set_property top_lib xil_defaultlib [get_filesets sim_1]

# Launch simulation
puts "Launching simulation for $dut_type..."
launch_simulation

# Run the simulation
puts "Running simulation..."
run 100ns

puts "$dut_type test completed!"

# Clean up
close_sim
close_project
puts "Cleaning up temporary project..."
if {[catch {file delete -force ./temp_${dut_type}_test} error]} {
    puts "Warning: Could not delete temporary project: $error"
    puts "You may need to manually delete ./temp_${dut_type}_test directory"
} else {
    puts "Temporary project cleaned up successfully"
}
