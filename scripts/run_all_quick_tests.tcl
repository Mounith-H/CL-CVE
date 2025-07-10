# All-in-one quick test script
# Runs tests for all three DUT types in sequence

puts "========================================="
puts "  Command Line Controlled Verification  "
puts "        Environment (CL-CVE)           "
puts "========================================="
puts "Running quick tests for all DUTs..."
puts ""

# Test 1: RCA Adder
puts "--- TEST 1: RCA ADDER ---"
source scripts/run_test.tcl -tclargs adder_rca
puts ""

# Test 2: CLA Adder  
puts "--- TEST 2: CLA ADDER ---"
source scripts/run_test.tcl -tclargs adder_cla
puts ""

# Test 3: Multiplier
puts "--- TEST 3: MULTIPLIER ---"
source scripts/run_test.tcl -tclargs multiplier
puts ""

puts "========================================="
puts "  All quick tests completed!     "
puts "========================================="
puts "Summary:"
puts "✓ RCA Adder - Test completed"
puts "✓ CLA Adder - Test completed" 
puts "✓ Multiplier - Test completed"
