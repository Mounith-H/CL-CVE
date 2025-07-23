#xsim_script.tcl

# 1. Create a project (in memory)
create_project my_xsim ./my_xsim_proj -part xc7z020clg400-1 -force

# 2. Add sources
add_files ./design/adder_rca.sv
add_files ./design/adder_cla.sv
add_files ./design/multiplier.sv
add_files ./design/dut_wrapper.sv
add_files -fileset sim_1 ./sim/tb.sv

# 3. Reconstruct plusargs early
set plusargs ""
if { $argc > 0 } {
    set i 0
    while { $i < $argc } {
        set arg [lindex $argv $i]

        if {[regexp {^\+[^=]+=.*$} $arg]} {
            append plusargs " -testplusarg $arg"
            incr i
        } elseif {[regexp {^\+[^=]+$} $arg] && ($i + 1) < $argc} {
            set key $arg
            set val [lindex $argv [expr {$i + 1}]]
            append plusargs " -testplusarg ${key}=$val"
            incr i 2
        } else {
            puts "WARNING: Skipping unrecognized argument format: $arg"
            incr i
        }
    }
    puts "Final reconstructed plusargs: $plusargs"
    
    # ✅ Set plusargs BEFORE launch
    set_property xsim.simulate.xsim.more_options $plusargs [get_filesets sim_1]
}

# 4. Set the top module
set_property top tb [get_filesets sim_1]

# 5. Launch simulation
launch_simulation

# -------------------------------------------------------------------
# Run simulation with command line plusargs
# Example usage:
# vivado -mode batch -source xsim_script.tcl -tclargs +DUT_TYPE=adder_rca +MODE=directed +VECTORS=20
# or modify the launch_simulation line below

# Alternative: Run with specific plusargs
# launch_simulation -simset sim_1 -mode behavioral -args {+DUT_TYPE=adder_rca +MODE=directed +VECTORS=10 +DELAY=2}

# For different configurations, uncomment one of these:
# launch_simulation -simset sim_1 -mode behavioral -args {+DUT_TYPE=adder_cla +MODE=random +VECTORS=15}
# launch_simulation -simset sim_1 -mode behavioral -args {+DUT_TYPE=multiplier +MODE=exhaustive +VECTORS=50}
