`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Multiplier Testbench - Copy of tb.sv with multiplier default
//////////////////////////////////////////////////////////////////////////////////

module tb_mult;

  parameter WIDTH = 8;

  logic clk, reset;
  logic [WIDTH-1:0] a, b;
  logic [2*WIDTH-1:0] result;
  
  // Configuration variables
  string dut_type;
  string test_mode;
  int num_vectors;
  int delay_cycles;
  
  // Test control
  int test_count = 0;
  int pass_count = 0;
  int fail_count = 0;

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // DUT instantiation
  dut_wrapper #(.WIDTH(WIDTH)) dut (
    .clk(clk), 
    .reset(reset), 
    .a(a), 
    .b(b), 
    .result(result)
  );

  // Pass DUT type to wrapper after configuration
  initial begin
    #1; // Wait for other initial blocks to complete
    force dut.dut_type = dut_type;
  end

  // Get test configuration from command line
  initial begin
    if (!$value$plusargs("+DUT_TYPE=%s", dut_type)) dut_type = "multiplier"; // Multiplier default
    if (!$value$plusargs("+MODE=%s", test_mode)) test_mode = "directed";
    if (!$value$plusargs("+VECTORS=%d", num_vectors)) num_vectors = 10;
    if (!$value$plusargs("+DELAY=%d", delay_cycles)) delay_cycles = 2;

    $display("=== TESTBENCH CONFIGURATION ===");
    $display("DUT_TYPE: %s", dut_type);
    $display("TEST_MODE: %s", test_mode);
    $display("NUM_VECTORS: %d", num_vectors);
    $display("DELAY_CYCLES: %d", delay_cycles);
    $display("===============================");
  end

  // Main test stimulus
  initial begin
    reset = 1;
    a = 0; b = 0;
    #20 reset = 0;
    
    $display("\n=== Starting %s Tests ===", dut_type);
    
    case (test_mode)
      "directed": run_directed_tests();
      "random": run_random_tests();
      "exhaustive": run_exhaustive_tests();
      default: run_directed_tests();
    endcase
    
    // Final report
    #50;
    $display("\n=== TEST RESULTS ===");
    $display("Total Tests: %d", test_count);
    $display("Passed: %d", pass_count);
    $display("Failed: %d", fail_count);
    $display("Success Rate: %.2f%%", (pass_count * 100.0) / test_count);
    $display("==================");
    
    $finish;
  end

  // Directed test patterns
  task run_directed_tests();
    logic [WIDTH-1:0] test_a, test_b;
    logic [2*WIDTH-1:0] expected;
    
    // Basic test vectors for multiplication
    automatic logic [WIDTH-1:0] directed_a [8] = '{5, 10, 15, 0, 255, 128, 1, 127};
    automatic logic [WIDTH-1:0] directed_b [8] = '{3, 4, 2, 100, 1, 128, 255, 129};
    
    for (int i = 0; i < 8 && i < num_vectors; i++) begin
      test_a = directed_a[i];
      test_b = directed_b[i];
      apply_test(test_a, test_b);
    end
  endtask

  // Random test patterns
  task run_random_tests();
    logic [WIDTH-1:0] test_a, test_b;
    
    for (int i = 0; i < num_vectors; i++) begin
      test_a = $random;
      test_b = $random;
      apply_test(test_a, test_b);
    end
  endtask

  // Exhaustive testing (for small widths)
  task run_exhaustive_tests();
    logic [WIDTH-1:0] test_a, test_b;
    automatic int max_tests = (2**WIDTH) * (2**WIDTH);
    automatic int actual_tests = (num_vectors < max_tests) ? num_vectors : max_tests;
    
    if (WIDTH > 4) begin
      $display("WARNING: Exhaustive testing for WIDTH=%d may take very long", WIDTH);
      $display("Limiting to %d tests", num_vectors);
    end
    
    for (int i = 0; i < actual_tests; i++) begin
      test_a = i % (2**WIDTH);
      test_b = (i / (2**WIDTH)) % (2**WIDTH);
      apply_test(test_a, test_b);
    end
  endtask

  // Apply single test
  task apply_test(input logic [WIDTH-1:0] test_a, test_b);
    logic [2*WIDTH-1:0] expected;
    
    a = test_a;
    b = test_b;
    
    // Calculate expected result
    case (dut_type)
      "adder_rca": expected = {{WIDTH{1'b0}}, test_a + test_b};
      "adder_cla": expected = {{WIDTH{1'b0}}, test_a + test_b}; // CLA performs same addition as RCA
      "multiplier", "mult": expected = test_a * test_b;
      default: expected = 0;
    endcase
    
    repeat(delay_cycles) @(posedge clk);
    
    test_count++;
    
    if (result == expected) begin
      pass_count++;
      $display("PASS [%0d]: a=%0d, b=%0d => result=%0d (expected=%0d)", 
               test_count, test_a, test_b, result, expected);
    end else begin
      fail_count++;
      $display("FAIL [%0d]: a=%0d, b=%0d => result=%0d (expected=%0d)", 
               test_count, test_a, test_b, result, expected);
    end
  endtask

endmodule
