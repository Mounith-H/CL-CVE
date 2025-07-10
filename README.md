# Command Line Controlled Verification Environment (CL-CVE)

## Overview
This project implements a comprehensive Command Line Controlled Verification Environment (CL-CVE) in SystemVerilog using Vivado 2024.2. The environment enables testing of multiple DUTs (Design Under Test) through a single, unified testbench controlled via command-line arguments, without requiring testbench modifications between runs.

### What is CL-CVE?
CL-CVE is a verification framework that allows you to test different digital hardware designs from the command line without modifying test code. Think of it like a test harness where you can swap designs in and out and control test parameters all from the command line.

### Who Can Use This?
- **FPGA/ASIC Engineers**: For verifying hardware designs
- **Digital Design Students**: For learning verification methodologies
- **Computer Architecture Researchers**: For testing different implementations
- **Non-Verilog Users**: With basic command-line knowledge, you can run tests without understanding HDL

## Features
- **Single Testbench Control**: One testbench (`tb.sv`) can test multiple DUTs
- **Command Line Control**: DUT selection and test parameters via plusargs
- **Automated TCL Scripts**: Complete automation of Vivado project creation and simulation
- **Batch Mode Operation**: Full batch-mode simulation support for regression testing
- **Multiple DUT Support**: RCA Adder, CLA Adder, and Multiplier implementations
- **Comprehensive Testing**: Directed, random, and exhaustive test modes
- **No GUI Required**: All operations can be performed from command line
- **Self-Contained**: All dependencies are included in the repository

## Project Structure
```
PBL/
├── design/                 # Design files (HDL code for the hardware modules)
│   ├── adder_rca.sv       # Ripple Carry Adder implementation
│   ├── adder_cla.sv       # Carry Look-Ahead Adder implementation
│   ├── multiplier.sv      # 8-bit Multiplier implementation
│   └── dut_wrapper.sv     # DUT Selection Wrapper (switches between designs)
├── sim/                   # Simulation files (testbenches)
│   ├── tb.sv              # Main testbench (general-purpose, RCA default)
│   ├── tb_cla.sv          # CLA-specific testbench
│   └── tb_mult.sv         # Multiplier-specific testbench
├── scripts/               # TCL automation scripts (Vivado commands)
│   ├── run_rca.tcl        # RCA Adder test script
│   ├── run_cla.tcl        # CLA Adder test script
│   ├── run_mult.tcl       # Multiplier test script
│   ├── run_all_tests.tcl  # Run all tests in sequence (comprehensive)
│   ├── run_test.tcl       # Parameterized test script (reusable)
│   └── run_all_quick_tests.tcl # Quick test all DUTs (faster)
├── batch/                 # Windows batch files (command-line shortcuts)
│   ├── run_all_tests.bat  # Run all tests (comprehensive)
│   ├── test_rca.bat       # Test RCA Adder only
│   ├── test_cla.bat       # Test CLA Adder only
│   ├── test_mult.bat      # Test Multiplier only
│   ├── quick_test.bat     # Quick test all DUTs
│   └── cleanup.bat        # Cleanup temporary projects and files
└── README.md              # This documentation
```

### File Types Explained

#### SystemVerilog (.sv) Files
These are hardware description language files that describe the digital circuits and test environments:
- **Design Files**: Describe the actual hardware functionality
- **Testbench Files**: Provide test inputs and verify outputs

#### TCL (.tcl) Files
Tool Command Language scripts that automate Vivado operations:
- Create temporary projects
- Add design and testbench files
- Configure simulation settings
- Run simulations
- Generate reports

#### Batch (.bat) Files
Windows command-line scripts that:
- Call Vivado with appropriate TCL scripts
- Provide simple one-click execution of tests
- Handle cleanup operations

## DUT Modules Explained (For Non-Verilog Users)

### 1. Ripple Carry Adder (RCA)
The Ripple Carry Adder (`adder_rca.sv`) is a digital circuit that adds two 8-bit binary numbers.

**How it works:**
- Adds two numbers bit by bit, starting from the least significant bit (rightmost)
- Each bit addition produces a sum bit and a carry bit
- The carry bit "ripples" through to the next bit position
- Think of it like manual addition where you carry the "1" to the next column

**Visual Representation:**
```
    Carry:   0 → 1 → 1 → 0
    Input A: 0   1   1   0  (6 in decimal)
    Input B: 0   1   0   1  (5 in decimal)
    -------------------
    Result:  0   0   0   1  (11 in decimal)
```

**Pros:**
- Simple design, easy to implement
- Uses minimal hardware resources
- Good for small bit widths

**Cons:**
- Slower for large numbers (carry must propagate through each stage)
- Delay increases linearly with bit width

### 2. Carry Look-Ahead Adder (CLA)
The Carry Look-Ahead Adder (`adder_cla.sv`) is a faster adder that calculates carry bits in advance.

**How it works:**
- Instead of waiting for carries to ripple, it predicts all carries simultaneously
- Uses "Generate" (G) and "Propagate" (P) signals
- G tells us when a position will always generate a carry
- P tells us when a position will propagate an incoming carry
- These signals allow calculating all carries at once

**Mathematical Basis:**
```
Generate: G_i = A_i AND B_i (position will generate a carry)
Propagate: P_i = A_i XOR B_i (position will propagate a carry)
Carry: C_(i+1) = G_i OR (P_i AND C_i)
```

**Pros:**
- Much faster than RCA, especially for larger bit widths
- Constant delay regardless of input values
- Better for timing-critical applications

**Cons:**
- More complex circuitry
- Uses more hardware resources
- Higher power consumption

### 3. Multiplier
The Multiplier (`multiplier.sv`) is a digital circuit that multiplies two 8-bit binary numbers.

**How it works:**
- Implements the binary multiplication algorithm in hardware
- Similar to the multiplication method taught in elementary school
- For each bit in the multiplier, it either adds the multiplicand or zero to the result
- Shifts the multiplicand left for each bit position

**Example (simplified):**
```
        1011  (11 in decimal, multiplicand)
      × 1010  (10 in decimal, multiplier)
      ------
        0000  (multiplier bit 0 is 0, add 0)
       1011   (multiplier bit 1 is 1, add 1011 shifted left once)
      0000    (multiplier bit 2 is 0, add 0)
     1011     (multiplier bit 3 is 1, add 1011 shifted left three times)
     ------
    1101110   (110 in decimal, final product)
```

**Input/Output:**
- Input: Two 8-bit numbers (range: 0-255 each)
- Output: One 16-bit result (range: 0-65,025)

**Applications:**
- Digital signal processing
- Graphics calculations
- Scientific computing
- Financial calculations

### 4. DUT Wrapper
The DUT Wrapper (`dut_wrapper.sv`) is a special module that contains all three designs and selects which one to test.

**Purpose:**
- Allows switching between different designs without changing testbench code
- Acts as a multiplexer that routes signals to the selected design
- Provides a consistent interface for all designs
- Enables command-line control of which design to test

**How it works:**
- Instantiates all three designs (RCA, CLA, Multiplier)
- Connects all designs to the same inputs
- Selects which design's output to use based on a control signal
- The control signal comes from a command-line parameter

**Key Advantages:**
- Reusable testbench infrastructure
- Simplified testing process
- Easy comparison between different implementations
- Supports automated testing workflows

## Testbench Architecture Explained (For Non-Verilog Users)

### What is a Testbench?
A testbench is a special program that verifies digital designs by:
1. Generating test inputs (stimuli)
2. Applying inputs to the design (stimulus application)
3. Checking if outputs match expected results (response checking)
4. Reporting pass/fail information (results reporting)

Think of it as an automated test apparatus that exercises your digital circuit and checks if it behaves correctly.

### Main Testbench Components

#### 1. Stimulus Generation
The testbench creates input patterns to test the design:
- **Directed**: Pre-defined test cases targeting specific behaviors
- **Random**: Randomly generated inputs to find unexpected issues
- **Exhaustive**: All possible input combinations for complete testing

#### 2. DUT Instantiation
The testbench creates an instance of the design to test:
```systemverilog
dut_wrapper #(.WIDTH(WIDTH)) dut (
  .clk(clk), 
  .reset(reset), 
  .a(a), 
  .b(b), 
  .result(result)
);
```

#### 3. Configuration
The testbench reads command-line arguments to configure the test:
```systemverilog
if (!$value$plusargs("DUT_TYPE=%s", dut_type)) dut_type = "adder_rca";
if (!$value$plusargs("MODE=%s", test_mode)) test_mode = "directed";
if (!$value$plusargs("VECTORS=%d", num_vectors)) num_vectors = 10;
if (!$value$plusargs("DELAY=%d", delay_cycles)) delay_cycles = 2;
```

#### 4. DUT Selection
The testbench forces the DUT wrapper to use the selected design:
```systemverilog
force dut.dut_type = dut_type; // Set design type from command line
```

#### 5. Expected Result Calculation
The testbench calculates expected results based on the operation:
```systemverilog
case (dut_type)
  "adder_rca": expected = test_a + test_b;
  "adder_cla": expected = test_a + test_b;
  "multiplier": expected = test_a * test_b;
  default: expected = 0;
endcase
```

#### 6. Checking and Reporting
The testbench compares actual results with expected results:
```systemverilog
if (result == expected) begin
  pass_count++;
  $display("PASS [%0d]: a=%0d, b=%0d => result=%0d (expected=%0d)", 
           test_count, test_a, test_b, result, expected);
end else begin
  fail_count++;
  $display("FAIL [%0d]: a=%0d, b=%0d => result=%0d (expected=%0d)", 
           test_count, test_a, test_b, result, expected);
end
```

### Test Modes Explained

#### 1. Directed Testing
- **What**: Pre-defined, targeted test cases
- **How**: Uses a fixed set of input values
- **When to use**: When you want to verify specific behaviors or edge cases
- **Advantages**: Focused, deterministic, repeatable
- **Example values**: 
  - Basic operations: a=5, b=3
  - Edge cases: a=0, b=0 or a=255, b=255
  - Overflow conditions: a=255, b=1

#### 2. Random Testing
- **What**: Randomly generated test inputs
- **How**: Uses `$random` function to create inputs
- **When to use**: For general verification and finding unexpected bugs
- **Advantages**: Broad coverage, can find unexpected issues
- **Limitations**: May miss specific edge cases, not deterministic
- **Code example**:
  ```systemverilog
  test_a = $random;
  test_b = $random;
  ```

#### 3. Exhaustive Testing
- **What**: Tests all possible input combinations
- **How**: Systematically generates every possible input pair
- **When to use**: For small designs where complete testing is feasible
- **Advantages**: 100% input coverage, guaranteed to find all bugs
- **Limitations**: Exponential growth with input size (impractical for large designs)
- **Code example**:
  ```systemverilog
  for (int i = 0; i < (2**WIDTH)*(2**WIDTH); i++) begin
    test_a = i % (2**WIDTH);
    test_b = (i / (2**WIDTH)) % (2**WIDTH);
    // Test with these values
  end
  ```

### Understanding Test Output

When you run a test, you'll see output like this:
```
=== TESTBENCH CONFIGURATION ===
DUT_TYPE: adder_rca
TEST_MODE: directed
NUM_VECTORS:          10
DELAY_CYCLES:           2
===============================
INFO: DUT_WRAPPER: DUT type changed to: adder_rca
=== Starting adder_rca Tests ===
PASS [1]: a=5, b=3 => result=8 (expected=8)
PASS [2]: a=10, b=4 => result=14 (expected=14)
...
=== TEST RESULTS ===
Total Tests:           8
Passed:           8
Failed:           0
Success Rate: 100.00%
==================
```

This output tells you:
1. The test configuration used
2. The DUT type being tested
3. Each test case with inputs, actual result, and expected result
4. A summary of test results

## Usage Instructions

### Prerequisites
1. **Xilinx Vivado** (2024.2 or compatible version) installed
2. Basic knowledge of command-line operations
3. Windows OS (for batch files) or ability to run TCL scripts directly

### Quick Start Guide

For first-time users, here's the fastest way to get started:

1. **Run a quick test of all designs**:
   ```powershell
   cd batch
   .\quick_test.bat
   ```

2. **Test a specific design** (e.g., RCA Adder):
   ```powershell
   cd batch
   .\test_rca.bat
   ```

3. **Clean up after testing**:
   ```powershell
   cd batch
   .\cleanup.bat
   ```

### Running Individual Tests

#### RCA Adder Test
```powershell
# Using TCL script directly
vivado -mode batch -source scripts\run_rca.tcl

# Using Windows batch file (easier)
batch\test_rca.bat
```

#### CLA Adder Test  
```powershell
# Using TCL script directly
vivado -mode batch -source scripts\run_cla.tcl

# Using Windows batch file (easier)
batch\test_cla.bat
```

#### Multiplier Test
```powershell
# Using TCL script directly
vivado -mode batch -source scripts\run_mult.tcl

# Using Windows batch file (easier)
batch\test_mult.bat
```

### Running All Tests
Run comprehensive tests on all three designs:

```powershell
# Using TCL script directly
vivado -mode batch -source scripts\run_all_tests.tcl

# Using Windows batch file (easier)
batch\run_all_tests.bat
```

### Using the Parameterized Test Script
The `run_test.tcl` script accepts a DUT type parameter, making it easy to test different designs:

```powershell
# Test RCA Adder
vivado -mode batch -source scripts\run_test.tcl -tclargs adder_rca

# Test CLA Adder
vivado -mode batch -source scripts\run_test.tcl -tclargs adder_cla

# Test Multiplier
vivado -mode batch -source scripts\run_test.tcl -tclargs multiplier
```

### Quick Test All DUTs
For a faster test of all designs (with fewer test vectors):

```powershell
# Using Windows batch file
batch\quick_test.bat

# Using TCL script directly
vivado -mode batch -source scripts\run_all_quick_tests.tcl
```

### Customizing Test Parameters

You can customize test parameters by modifying the TCL scripts. For example, in `run_rca.tcl`:

```tcl
# Default: "+DUT_TYPE=adder_rca +MODE=directed +VECTORS=10 +DELAY=2"
set_property -name {xsim.simulate.xsim.more_options} -value {+DUT_TYPE=adder_rca +MODE=random +VECTORS=50 +DELAY=1} -objects [get_filesets sim_1]
```

#### Common Customizations:
- Change test mode: Replace `directed` with `random` or `exhaustive`
- Increase test vectors: Change `VECTORS=10` to a higher number
- Decrease delay: Change `DELAY=2` to a lower number

### Running in Vivado GUI Mode
If you prefer using the Vivado GUI:

1. Open Vivado and create a new project
2. Add all design files from the `design/` folder
3. Add the testbench file from the `sim/` folder
4. Set the top module to `tb`
5. Open the simulation settings and add plusargs:
   - Right-click on "Simulation" → "Simulation Settings"
   - Under "Simulation" tab, add to "xsim.simulate.xsim.more_options":
     ```
     +DUT_TYPE=adder_rca +MODE=directed +VECTORS=10 +DELAY=2
     ```
6. Run the simulation

### Expected Directory Structure After Testing

After running tests, you'll see temporary project directories created:
- `temp_rca_test/` - RCA test project
- `temp_cla_test/` - CLA test project
- `temp_mult_test/` - Multiplier test project

Use the cleanup script to remove these directories when done.

## Command-Line Arguments Explained in Detail

The CL-CVE environment uses "plusargs" - special arguments prefixed with "+" that are passed to the simulation. These control the behavior of the testbench without changing any code.

### DUT Type Selection
```
+DUT_TYPE=<type>
```

**Available options:**
- `adder_rca`: Test the Ripple Carry Adder
- `adder_cla`: Test the Carry Look-Ahead Adder
- `multiplier`: Test the Multiplier

**Example:**
```
+DUT_TYPE=adder_cla
```

**What it does:**
This argument tells the testbench which design to test. The testbench uses a "force" statement to dynamically change the DUT wrapper's configuration:
```systemverilog
force dut.dut_type = dut_type; // dut_type comes from +DUT_TYPE
```

**Default if not specified:**
`adder_rca` (Ripple Carry Adder)

### Test Mode Selection 
```
+MODE=<mode>
```

**Available options:**
- `directed`: Use predefined test vectors with specific corner cases
- `random`: Generate random input values for testing
- `exhaustive`: Test all possible input combinations (suitable for small designs)

**Example:**
```
+MODE=random
```

**What it does:**
This argument determines how the testbench generates test inputs:
- `directed`: Uses a fixed array of test cases
- `random`: Uses `$random` to generate inputs
- `exhaustive`: Systematically generates all possible input combinations

**Default if not specified:**
`directed`

### Test Vector Count
```
+VECTORS=<n>
```

**Available options:**
Any positive integer (e.g., 10, 50, 100, 1000)

**Example:**
```
+VECTORS=50
```

**What it does:**
Sets the number of test vectors to run. For directed tests, this is capped by the number of predefined test cases. For random and exhaustive tests, this controls the total number of tests to run.

**Default if not specified:**
`10`

### Test Delay Setting
```
+DELAY=<n>
```

**Available options:**
Any positive integer (e.g., 1, 2, 5, 10)

**Example:**
```
+DELAY=1
```

**What it does:**
Sets the number of clock cycles between applying test vectors. A higher number allows more time for signals to stabilize but makes the simulation run longer.

**Default if not specified:**
`2`

### Combining Multiple Arguments

You can combine multiple arguments to customize the test behavior:

**Example: 100 random tests on the multiplier with minimum delay**
```
+DUT_TYPE=multiplier +MODE=random +VECTORS=100 +DELAY=1
```

### How to Pass Arguments in Different Contexts

#### 1. In TCL Scripts
```tcl
set_property -name {xsim.simulate.xsim.more_options} -value {+DUT_TYPE=adder_cla +MODE=random +VECTORS=50 +DELAY=1} -objects [get_filesets sim_1]
```

#### 2. Directly with xsim (Advanced)
```powershell
xsim tb_behav -testplusarg "DUT_TYPE=adder_cla" -testplusarg "MODE=random" -testplusarg "VECTORS=50" -testplusarg "DELAY=1"
```

#### 3. By Modifying Batch Files
You can create custom batch files with different argument combinations by modifying the existing ones:

```bat
@echo off
REM Custom test with 1000 random vectors for CLA
echo Running custom CLA random test...
vivado -mode batch -source scripts\run_cla.tcl
```

Then modify `scripts\run_cla.tcl` to include:
```tcl
set_property -name {xsim.simulate.xsim.more_options} -value {+DUT_TYPE=adder_cla +MODE=random +VECTORS=1000 +DELAY=1} -objects [get_filesets sim_1]
```

## TCL Script Architecture for Non-Verilog Users

### What is TCL?
TCL (Tool Command Language) is a scripting language used to automate Xilinx Vivado operations. Think of it as a special language that tells Vivado what to do step by step, without needing to click through the GUI.

### Why Use TCL Scripts?
- **Automation**: Run complex sequences of operations with a single command
- **Repeatability**: Get the same results every time
- **Batch Processing**: Run tests without manual intervention
- **Version Control**: Track changes to test setups over time

### TCL Script Workflow
Each TCL script in this project follows this general pattern:

1. **Project Creation**: Create a temporary Vivado project to hold our designs
2. **File Addition**: Add design and simulation files to the project
3. **Configuration**: Set simulation properties and test parameters
4. **Simulation**: Launch and run the simulation
5. **Results Collection**: Capture and display test results
6. **Cleanup**: Close project and remove temporary files

### Key TCL Commands Explained for Non-Verilog Users

#### 1. Create Project
```tcl
create_project temp_test ./temp_test -part xc7z020clg400-1 -force
```
This is like creating a new folder for your project with specific settings:
- **What it does**: Creates a new Vivado project named "temp_test"
- **In simple terms**: "Make me a new project folder called temp_test, set up for a Zynq-7000 device, and replace any old one with this name"

#### 2. Add Design Files
```tcl
add_files -norecurse ./design/adder_rca.sv
add_files -norecurse ./design/adder_cla.sv  
add_files -norecurse ./design/multiplier.sv
add_files -norecurse ./design/dut_wrapper.sv
```
This is like putting your design documents into the project folder:
- **What it does**: Adds the design files to the project
- **In simple terms**: "Put these design files into my project so Vivado knows about them"

#### 3. Add Simulation Files
```tcl
add_files -fileset sim_1 -norecurse ./sim/tb.sv
```
This is like putting your test documents into a special "testing" subfolder:
- **What it does**: Adds the testbench file to the simulation file set
- **In simple terms**: "Put this test file into my project's testing area"

#### 4. Configure Simulation
```tcl
# Set top module for simulation
set_property top tb [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]

# Configure command-line arguments
set_property -name {xsim.simulate.xsim.more_options} -value {+DUT_TYPE=adder_rca +MODE=directed +VECTORS=10 +DELAY=2} -objects [get_filesets sim_1]
```
This is like configuring the test settings:
- **What it does**: Sets the main test file and passes command-line arguments
- **In simple terms**: "Use this test file as the main one, and set these test parameters"

#### 5. Launch Simulation
```tcl
launch_simulation
run 100ns
```
This is like pressing the "Run Test" button:
- **What it does**: Starts the simulation and runs it for a specified time
- **In simple terms**: "Start the test and let it run for 100 nanoseconds"

#### 6. Cleanup
```tcl
close_sim
close_project
file delete -force ./temp_test
```
This is like cleaning up after the test:
- **What it does**: Closes everything and removes temporary files
- **In simple terms**: "We're done, close everything and clean up our workspace"

### Our Project's TCL Scripts

#### 1. Individual Test Scripts
The `run_rca.tcl`, `run_cla.tcl`, and `run_mult.tcl` scripts each set up and run a test for a specific design:

- **Purpose**: Run a focused test on one design
- **When to use**: When you want to test just one design thoroughly
- **How they work**: Create a project, add files, configure for the specific design, run the test
- **Example use**: `vivado -mode batch -source scripts\run_rca.tcl`

#### 2. Parameterized Test Script (`run_test.tcl`)
This script is more flexible and accepts a design type as an input parameter:

- **Purpose**: Provide a reusable test script that works for any design
- **When to use**: When you want a consistent test approach across designs
- **How it works**: Takes a design type parameter, sets up the appropriate test
- **Example use**: `vivado -mode batch -source scripts\run_test.tcl -tclargs adder_rca`

#### 3. All Tests Script (`run_all_tests.tcl`)
This script runs comprehensive tests on all designs sequentially:

- **Purpose**: Complete testing of all designs
- **When to use**: For thorough verification or regression testing
- **How it works**: Calls each individual test script in sequence
- **Example use**: `vivado -mode batch -source scripts\run_all_tests.tcl`

#### 4. Quick Test Script (`run_all_quick_tests.tcl`)
This script runs faster tests on all designs:

- **Purpose**: Quick verification of all designs
- **When to use**: For quick checks after making changes
- **How it works**: Similar to the all tests script but with fewer test vectors
- **Example use**: `vivado -mode batch -source scripts\run_all_quick_tests.tcl`

### Creating Your Own Custom TCL Script

To create your own custom test script:

1. **Copy an existing script** as a starting point:
   ```powershell
   copy scripts\run_rca.tcl scripts\my_custom_test.tcl
   ```

2. **Edit the script** to customize:
   - Change the project name
   - Modify the test parameters
   - Adjust the simulation time

3. **Run your custom script**:
   ```powershell
   vivado -mode batch -source scripts\my_custom_test.tcl
   ```

#### 2. Add Design Files
```tcl
add_files -norecurse ./design/adder_rca.sv
add_files -norecurse ./design/adder_cla.sv
add_files -norecurse ./design/multiplier.sv
add_files -norecurse ./design/dut_wrapper.sv
```
- Adds design files to the project
- `-norecurse` prevents adding files from subdirectories

#### 3. Add Simulation Files
```tcl
add_files -fileset sim_1 -norecurse ./sim/tb.sv
```
- Adds testbench to simulation fileset
- `sim_1` is the default simulation fileset in Vivado

#### 4. Configure Simulation
```tcl
set_property top tb [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]
```
- Sets the top module for simulation
- Specifies the library for the top module

#### 5. Launch Simulation
```tcl
launch_simulation
run 100ns
```
- Launches the simulation
- Runs simulation for specified time

#### 6. Cleanup
```tcl
close_sim
close_project
file delete -force ./temp_test
```
- Closes simulation and project
- Deletes temporary project files

## Understanding Test Results

When you run the tests, you'll see detailed output showing the test configuration, individual test cases, and a summary of results. Here's how to interpret this information:

### Example Test Output (RCA Adder)

```
=== TESTBENCH CONFIGURATION ===
DUT_TYPE: adder_rca
TEST_MODE: directed
NUM_VECTORS:          10
DELAY_CYCLES:           2
===============================
INFO: DUT_WRAPPER: DUT type changed to: adder_rca
=== Starting adder_rca Tests ===
PASS [1]: a=5, b=3 => result=8 (expected=8)
PASS [2]: a=10, b=4 => result=14 (expected=14)
PASS [3]: a=15, b=2 => result=17 (expected=17)
PASS [4]: a=0, b=100 => result=100 (expected=100)
PASS [5]: a=255, b=1 => result=0 (expected=0)
PASS [6]: a=128, b=128 => result=0 (expected=0)
PASS [7]: a=1, b=255 => result=0 (expected=0)
PASS [8]: a=127, b=129 => result=0 (expected=0)
=== TEST RESULTS ===
Total Tests:           8
Passed:           8
Failed:           0
Success Rate: 100.00%
==================
```

### Interpreting the Results

#### 1. Configuration Section
```
=== TESTBENCH CONFIGURATION ===
DUT_TYPE: adder_rca
TEST_MODE: directed
NUM_VECTORS:          10
DELAY_CYCLES:           2
===============================
```
This section shows:
- **Which design** is being tested (adder_rca)
- **What test mode** is being used (directed)
- **How many test vectors** will be applied (10)
- **How many clock cycles** between test vectors (2)

#### 2. DUT Selection Confirmation
```
INFO: DUT_WRAPPER: DUT type changed to: adder_rca
```
This confirms that the DUT wrapper successfully selected the specified design.

#### 3. Individual Test Results
```
PASS [1]: a=5, b=3 => result=8 (expected=8)
```
Each test case shows:
- **Pass/Fail status**: Whether the test passed or failed
- **Test number**: Sequential test identifier
- **Input values**: The values applied to the design (a=5, b=3)
- **Actual result**: What the design actually produced (result=8)
- **Expected result**: What the design should have produced (expected=8)

#### 4. Summary Section
```
=== TEST RESULTS ===
Total Tests:           8
Passed:           8
Failed:           0
Success Rate: 100.00%
==================
```
This section shows:
- **Total tests** run
- **Number of tests** that passed
- **Number of tests** that failed
- **Success rate** as a percentage

### Understanding Test Cases

#### RCA and CLA Adder Test Cases
For the adders, the test cases include:
- **Basic addition**: Regular numbers (5+3=8, 10+4=14)
- **Zero handling**: Testing with zero (0+100=100)
- **Overflow cases**: Values that cause overflow (255+1=0)
- **Maximum values**: Testing with maximum 8-bit values (128+128=0)

> **Note on Overflow**: In 8-bit arithmetic, when the sum exceeds 255, the result "wraps around" and only the 8 least significant bits are kept. This is why 255+1=0 in the test results.

#### Multiplier Test Cases
For the multiplier, the test cases include:
- **Basic multiplication**: Regular numbers (5×3=15, 10×4=40)
- **Zero handling**: Testing with zero (0×100=0)
- **Maximum values**: Testing with maximum 8-bit values (128×128=16384)
- **Large results**: Testing results that need more than 8 bits (127×129=16383)

> **Note on Multiplication**: The multiplier produces a 16-bit result, so it can represent products up to 65,535 without overflow.

### All Designs Pass the Tests

All three designs (RCA Adder, CLA Adder, and Multiplier) pass all their test cases with a 100% success rate. This means:
- Each design correctly implements its specified functionality
- The verification environment successfully tests all designs
- The command-line control mechanism works properly

### Examining Failed Tests

If you modify the designs and introduce errors, you might see failures like:
```
FAIL [5]: a=255, b=1 => result=254 (expected=0)
```

This would indicate:
- Test case #5 failed
- Input values were a=255, b=1
- The design produced 254
- The correct result should have been 0
- There might be an issue with overflow handling in the design
===============================
INFO: DUT_WRAPPER: DUT type changed to: multiplier
=== Starting multiplier Tests ===
PASS [1]: a=5, b=3 => result=15 (expected=15)
PASS [2]: a=10, b=4 => result=40 (expected=40)
PASS [3]: a=15, b=2 => result=30 (expected=30)
PASS [4]: a=0, b=100 => result=0 (expected=0)
PASS [5]: a=255, b=1 => result=255 (expected=255)
PASS [6]: a=128, b=128 => result=16384 (expected=16384)
PASS [7]: a=1, b=255 => result=255 (expected=255)
PASS [8]: a=127, b=129 => result=16383 (expected=16383)
=== TEST RESULTS ===
Total Tests:           8
Passed:           8
Failed:           0
Success Rate: 100.00%
==================
```

## Script-Specific Information

### 1. Individual Test Scripts (`run_rca.tcl`, `run_cla.tcl`, `run_mult.tcl`)
These scripts create a temporary project for a specific DUT and run the test. Each script:
- Creates a project specific to the DUT (e.g., `temp_rca_test` for RCA)
- Adds all design files and the appropriate testbench
- Sets up the simulation environment
- Runs the simulation
- Cleans up after completion

### 2. Parameterized Test Script (`run_test.tcl`)
This script accepts a DUT type as a parameter and runs the appropriate test:
```bash
vivado -mode batch -source scripts\run_test.tcl -tclargs adder_rca
```
- `-tclargs` passes arguments to the TCL script
- Valid arguments: `adder_rca`, `adder_cla`, `multiplier`

### 3. All Tests Script (`run_all_tests.tcl`)
This script runs tests for all three DUTs in sequence:
- Creates a separate project for each DUT
- Configures and runs simulation for each
- Generates a summary report
- Handles cleanup between tests

### 4. Quick Test Scripts
These scripts provide a faster way to test all DUTs:
- `run_all_quick_tests.tcl`: TCL script for all DUTs
- `quick_test.bat`: Windows batch file wrapper

### 5. Batch Files
Windows batch files provide easy command-line execution:
- `test_rca.bat`: Tests the RCA Adder
- `test_cla.bat`: Tests the CLA Adder
- `test_mult.bat`: Tests the Multiplier
- `run_all_tests.bat`: Runs all tests
- `cleanup.bat`: Cleans up temporary projects

## Troubleshooting Guide

### Common Issues and Solutions

#### 1. Vivado Not Found
**Issue**: You see an error message saying "Vivado not found" or "Command not recognized"

**Solution**:
- Make sure Vivado is installed correctly
- Ensure Vivado is in your system PATH
- Try using the full path to Vivado:
  ```powershell
  C:\Xilinx\Vivado\2024.2\bin\vivado.bat -mode batch -source scripts\run_rca.tcl
  ```

#### 2. Permission Errors During Cleanup
**Issue**: The cleanup script can't delete temporary folders due to permission issues

**Solution**:
- Close any open file explorer windows showing these directories
- Close Vivado completely
- Run Command Prompt as administrator:
  ```powershell
  # Administrator Command Prompt
  batch\cleanup.bat
  ```
- Manually delete folders if needed:
  ```powershell
  Remove-Item -Force -Recurse temp_rca_test
  Remove-Item -Force -Recurse temp_cla_test
  Remove-Item -Force -Recurse temp_mult_test
  ```

#### 3. Simulation Errors
**Issue**: The simulation fails with error messages

**Solution**:
- Check for syntax errors in the design files
- Verify that all required files are in the correct locations
- Try running with verbose output:
  ```tcl
  # Add to TCL script
  set_property -name {xsim.simulate.log_all_signals} -value {true} -objects [get_filesets sim_1]
  ```
- Check Vivado log files in the temporary project directories

#### 4. Path Issues
**Issue**: Files not found or incorrect paths

**Solution**:
- Make sure you're running commands from the root project directory
- Use absolute paths if necessary
- Verify that all files exist in the expected locations
- Check for incorrect path separators (use `\` on Windows)

#### 5. Custom Test Script Issues
**Issue**: Your custom test script doesn't work as expected

**Solution**:
- Start by modifying an existing working script
- Make changes incrementally and test after each change
- Double-check TCL syntax (especially brackets and quotes)
- Verify plusargs are correctly formatted

### Advanced Debugging

#### 1. Enable Waveform Capture
To see detailed signal waveforms for debugging:

```tcl
# Add to your TCL script
set_property -name {xsim.simulate.log_all_signals} -value {true} -objects [get_filesets sim_1]
set_property -name {xsim.simulate.wdb} -value {./debug.wdb} -objects [get_filesets sim_1]
```

#### 2. Add More Debug Messages
Add more print statements to the testbench to see internal operation:

```systemverilog
// In the testbench file
$display("DEBUG: Processing test case %0d with a=%0d, b=%0d", i, test_a, test_b);
```

#### 3. Run in GUI Mode
Sometimes it's easier to debug in GUI mode:

```powershell
# Open project in GUI mode
vivado -source scripts\run_rca.tcl
```

Then use the Vivado GUI to examine signals and step through simulation.

## Maintenance and Cleanup

### Using the Cleanup Script
The project includes a cleanup script to remove temporary projects:

```powershell
# From command line
batch\cleanup.bat
```

This script:
- Removes all temporary projects (temp_rca_test, temp_cla_test, temp_mult_test)
- Frees up disk space
- Prepares for fresh test runs

### Manual Cleanup (If Needed)
If the cleanup script encounters permission issues, you can manually remove directories:

```powershell
# Using PowerShell
Remove-Item -Recurse -Force temp_rca_test
Remove-Item -Recurse -Force temp_cla_test
Remove-Item -Recurse -Force temp_mult_test
```

### Backup Before Major Changes
Before making significant changes, consider backing up your working files:

```powershell
# Create a backup folder
mkdir backup

# Copy key files
copy design\*.sv backup\
copy sim\*.sv backup\
copy scripts\*.tcl backup\
copy batch\*.bat backup\
```

## Extending the Framework

The Command Line Controlled Verification Environment is designed to be extensible. Here's how to add new functionality:

### 1. Adding a New Design
To add a new design (e.g., a Divider):

1. **Create the design file** in the `design/` folder:
   ```powershell
   # Create a new design file
   notepad design\divider.sv
   ```

2. **Update the DUT wrapper** to include the new design:
   - Add instantiation for the new module
   - Add the new design to the case statement
   - Add any necessary signals

3. **Update the testbench** to support the new design:
   - Add expected result calculation for the new design
   - Add any design-specific test cases

4. **Create a test script** for the new design:
   ```powershell
   # Copy and modify an existing script
   copy scripts\run_rca.tcl scripts\run_div.tcl
   # Edit the new script to update DUT_TYPE and other settings
   ```

5. **Create a batch file** for the new design:
   ```powershell
   # Copy and modify an existing batch file
   copy batch\test_rca.bat batch\test_div.bat
   # Edit the new batch file to call the appropriate script
   ```

6. **Update all tests** script to include the new design

### 2. Adding New Test Modes
To add a new test mode (e.g., constrained random):

1. **Update the testbench** with the new mode:
   - Add a new task for the test mode
   - Add the mode to the case statement

2. **Test the new mode** with existing designs:
   ```powershell
   # Run with the new mode
   vivado -mode batch -source scripts\run_test.tcl -tclargs adder_rca
   # Modify the script to use your new mode
   ```

## Conclusion

The Command Line Controlled Verification Environment (CL-CVE) provides a flexible, command-line driven framework for testing different digital hardware designs using a unified approach. By separating the testbench from the designs under test and providing command-line control, it enables efficient verification workflows and automation.

### Key Benefits

1. **Unified Testing**: Test different designs with the same infrastructure
2. **Command-Line Control**: Change test parameters without modifying code
3. **Automation**: Batch files and TCL scripts automate the entire test process
4. **Extensibility**: Easy to add new designs and test modes
5. **Reusability**: Components can be reused across projects

### For Non-Verilog Users

Even if you don't understand SystemVerilog, you can:
1. Run predefined tests using simple batch commands
2. Create custom test scripts by modifying examples
3. Understand test results and diagnose issues
4. Extend the framework with new designs and tests

Whether you're testing a single design or running comprehensive regression tests across multiple implementations, the CL-CVE offers the tools and structure to make verification straightforward and reproducible.

---

**Command Line Controlled Verification Environment (CL-CVE)**  
*Comprehensive SystemVerilog Verification Platform*  
*Vivado 2024.2 Compatible*
