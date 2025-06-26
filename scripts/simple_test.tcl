# Simple Working Test Script
# This works in both GUI and batch mode

puts "Creating project..."
create_project -in_memory -part xc7z020clg400-1

puts "Reading source files..."
read_verilog {
    ./design/adder_rca.sv
    ./design/adder_cla.sv
    ./design/multiplier.sv
    ./design/dut_wrapper.sv
    ./sim/tb.sv
}

puts "Running elaboration..."
synth_design -top tb -mode out_of_context

puts "Starting simulation..."
launch_simulation

puts "Running test..."
run 2000ns

puts "Simulation complete!"
