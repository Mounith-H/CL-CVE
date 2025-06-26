# Command Line Controlled Verification Environment (CL-CVE)

## Overview
This project implements a comprehensive Command Line Controlled Verification Environment (CL-CVE) in SystemVerilog using Vivado 2024.2. The environment enables testing of multiple DUTs (Design Under Test) through a single, unified testbench controlled via command-line arguments, without requiring testbench modifications between runs.

## Features
- **Single Testbench Control**: One testbench (`tb.sv`) can test multiple DUTs
- **Command Line Control**: DUT selection and test parameters via plusargs
- **Automated TCL Scripts**: Complete automation of Vivado project creation and simulation
- **Batch Mode Operation**: Full batch-mode simulation support for regression testing
- **Multiple DUT Support**: RCA Adder, CLA Adder, and Multiplier implementations
- **Comprehensive Testing**: Directed, random, and exhaustive test modes

## Project Structure
```
PBL/
├── design/                 # Design files
│   ├── adder_rca.sv       # Ripple Carry Adder
│   ├── adder_cla.sv       # Carry Look-Ahead Adder  
│   ├── multiplier.sv      # 8-bit Multiplier
│   └── dut_wrapper.sv     # DUT Selection Wrapper
├── sim/                   # Simulation files
│   ├── tb.sv              # Main testbench (RCA default)
│   ├── tb_cla.sv          # CLA-specific testbench
│   └── tb_mult.sv         # Multiplier-specific testbench
├── scripts/               # TCL automation scripts
│   ├── run_rca.tcl        # RCA Adder test script
│   ├── run_cla.tcl        # CLA Adder test script
│   ├── run_mult.tcl       # Multiplier test script
│   ├── run_all_tests.tcl  # Run all tests
│   └── *.tcl              # Other utility scripts
├── batch/                 # Windows batch files
│   ├── run_all_tests.bat  # Run all tests
│   ├── test_rca.bat       # Test RCA Adder
│   ├── test_cla.bat       # Test CLA Adder
│   ├── test_mult.bat      # Test Multiplier
│   └── cleanup.bat        # Cleanup temporary projects
└── README.md              # This documentation
```

## DUT Modules

### 1. RCA Adder (`adder_rca.sv`)
- 8-bit Ripple Carry Adder
- Uses chain of full adders
- Carry propagates through each stage

### 2. CLA Adder (`adder_cla.sv`) 
- 8-bit Carry Look-Ahead Adder
- Faster than RCA due to parallel carry generation
- Implements generate and propagate logic

### 3. Multiplier (`multiplier.sv`)
- 8-bit × 8-bit = 16-bit multiplier
- Simple array multiplier implementation
- Combinational logic design

### 4. DUT Wrapper (`dut_wrapper.sv`)
- Instantiates all DUTs
- Selects active DUT based on `dut_type` parameter
- Provides unified interface to testbench

## Testbench Architecture

### Main Testbench (`tb.sv`)
- Configurable via plusargs:
  - `+DUT_TYPE=<type>` - Select DUT (adder_rca, adder_cla, multiplier)
  - `+MODE=<mode>` - Test mode (directed, random, exhaustive)
  - `+VECTORS=<n>` - Number of test vectors
  - `+DELAY=<n>` - Clock cycles between tests

### Test Modes
1. **Directed**: Predefined test vectors with corner cases
2. **Random**: Randomized input stimuli
3. **Exhaustive**: All possible input combinations (for small designs)

## Usage

### Running Individual Tests

#### RCA Adder Test
```bash
vivado -mode batch -source scripts\run_rca.tcl
```

#### CLA Adder Test  
```bash
vivado -mode batch -source scripts\run_cla.tcl
```

#### Multiplier Test
```bash
vivado -mode batch -source scripts\run_mult.tcl
```

### Running All Tests
```bash
# Using TCL script
vivado -mode batch -source scripts\run_all_tests.tcl

# Using Windows batch file
batch\run_all_tests.bat
```

### Custom Test Configuration
```bash
# Example: Run CLA adder with 50 random vectors
vivado -mode batch -source "
  source run_cla.tcl
  set_property generic {DUT_TYPE=adder_cla MODE=random VECTORS=50} [get_filesets sim_1]
"
```

## TCL Script Architecture

Each TCL script follows this pattern:
1. **Project Creation**: Create temporary Vivado project
2. **File Addition**: Add design and simulation files
3. **Configuration**: Set simulation properties
4. **Simulation**: Launch and run simulation
5. **Cleanup**: Close project and clean temporary files

### Key TCL Commands
```tcl
# Create project
create_project temp_test ./temp_test -part xc7z020clg400-1 -force

# Add files
add_files -norecurse ./design/*.sv
add_files -fileset sim_1 -norecurse ./sim/tb.sv

# Configure simulation
set_property top tb [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]

# Run simulation
launch_simulation
run 1000ns
```

## Test Results

All DUTs pass comprehensive verification:

### RCA Adder Results
```
=== TEST RESULTS ===
Total Tests: 8
Passed: 8
Failed: 0
Success Rate: 100.00%
```

### CLA Adder Results
```
=== TEST RESULTS ===
Total Tests: 8
Passed: 8
Failed: 0
Success Rate: 100.00%
```

### Multiplier Results
```
=== TEST RESULTS ===
Total Tests: 8
Passed: 8
Failed: 0
Success Rate: 100.00%
```

## Key Implementation Details

### DUT Selection Mechanism
The testbench uses a force statement to control the DUT wrapper:
```systemverilog
initial begin
    #1; // Wait for other initial blocks
    force dut.dut_type = dut_type;
end
```

### Batch Mode Compatibility
- Uses on-disk temporary projects (not in-memory)
- Avoids problematic plusargs in TCL scripts
- Implements proper cleanup with error handling

### File Organization
- Separate testbenches for each DUT type
- Modular design allows easy addition of new DUTs
- Consistent naming convention throughout

## Cleanup and Maintenance

### Automatic Cleanup
```bash
# Clean all temporary projects
cleanup.bat
```

### Manual Cleanup
```bash
# Remove specific temporary project
rmdir /s /q temp_rca_test
rmdir /s /q temp_cla_test  
rmdir /s /q temp_mult_test
```

## Future Enhancements

1. **Additional DUTs**: Easy to add new design modules
2. **Coverage Analysis**: Integrate functional coverage
3. **Waveform Analysis**: Automated waveform comparison
4. **Regression Testing**: Continuous integration support
5. **Performance Metrics**: Timing and resource analysis

## Dependencies
- Xilinx Vivado 2024.2 or later
- SystemVerilog support
- Windows PowerShell (for batch files)

## Troubleshooting

### Common Issues
1. **Permission Errors**: Run cleanup.bat as administrator
2. **Path Issues**: Ensure Vivado is in system PATH
3. **License Issues**: Verify Vivado license is valid

### Debug Mode
Add verbose output to TCL scripts:
```tcl
set_property -name {xsim.simulate.log_all_signals} -value {true} -objects [get_filesets sim_1]
```

---

**Command Line Controlled Verification Environment (CL-CVE)**  
*Comprehensive SystemVerilog Verification Platform*  
*Vivado 2024.2 Compatible*
