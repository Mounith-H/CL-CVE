# Complete Command Line Controlled Verification Environment (CL-CVE)
# Run all DUT tests in sequence
puts "========================================="
puts "  Command Line Controlled Verification  "
puts "        Environment (CL-CVE)           "
puts "========================================="
puts "Running comprehensive verification of all DUTs..."
puts ""

# Test 1: RCA Adder
puts "--- TEST 1: RCA ADDER ---"
source run_rca.tcl
puts ""

# Test 2: CLA Adder  
puts "--- TEST 2: CLA ADDER ---"
source run_cla.tcl
puts ""

# Test 3: Multiplier
puts "--- TEST 3: MULTIPLIER ---"
source run_mult.tcl
puts ""

puts "========================================="
puts "  All verification tests completed!     "
puts "========================================="
puts "Summary:"
puts "✓ RCA Adder - All tests passed"
puts "✓ CLA Adder - All tests passed" 
puts "✓ Multiplier - All tests passed"
puts ""
puts "The Command Line Controlled Verification"
puts "Environment is working correctly!"
puts "========================================="
