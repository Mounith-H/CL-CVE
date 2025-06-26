# 1. Create a project (in memory)
create_project my_xsim . -part xc7z020clg400-1 -in_memory

# 2. Add sources_1 and sim sources
#add_files ./PBL.srcs/sources_1/adder_rca.sv
#add_files ./PBL.srcs/sources_1/adder_cla.sv
#add_files ./PBL.srcs/sources_1/multiplier.sv
#add_files ./PBL.srcs/sources_1/dut_wrapper.sv
#add_files -tb ./PBL.srcs/sim_1/new/tb.sv


add_files ./design/adder_rca.sv
add_files ./design/adder_cla.sv
add_files ./design/multiplier.sv
add_files ./design/dut_wrapper.sv

# Add testbench file to simulation sources
add_files -fileset sim_1 ./sim/tb.sv

# 3. Set the top module
set_property top tb [current_fileset]

# 4. Run simulation with command line plusargs
# Example usage:
# vivado -mode batch -source xsim_script.tcl -tclargs +DUT_TYPE=adder_rca +MODE=directed +VECTORS=20
# or modify the launch_simulation line below

# Default simulation
launch_simulation -simset sim_1 -mode behavioral

# Alternative: Run with specific plusargs
# launch_simulation -simset sim_1 -mode behavioral -args {+DUT_TYPE=adder_rca +MODE=directed +VECTORS=10 +DELAY=2}

# For different configurations, uncomment one of these:
# launch_simulation -simset sim_1 -mode behavioral -args {+DUT_TYPE=adder_cla +MODE=random +VECTORS=15}
# launch_simulation -simset sim_1 -mode behavioral -args {+DUT_TYPE=multiplier +MODE=exhaustive +VECTORS=50}
