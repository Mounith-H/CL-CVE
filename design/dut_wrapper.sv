`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.06.2025 09:36:23
// Design Name: 
// Module Name: dut_wrapper
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module dut_wrapper #(parameter WIDTH = 8)(
  input logic clk, reset,
  input logic [WIDTH-1:0] a, b,
  output logic [2*WIDTH-1:0] result
);

  string dut_type = "adder_rca"; // Default, will be overridden by testbench
  string operation_mode;
  int test_vectors;
  
  // Internal signals
  logic [WIDTH-1:0] sum_rca, sum_cla;
  logic [2*WIDTH-1:0] product;
  logic carry_out_rca, carry_out_cla;

  // DUT Instantiations
  adder_rca #(.WIDTH(WIDTH)) u_rca (
    .a(a), .b(b), .sum(sum_rca), .carry_out(carry_out_rca)
  );
  
  adder_cla #(.WIDTH(WIDTH)) u_cla (
    .a(a), .b(b), .sum(sum_cla), .carry_out(carry_out_cla)
  );
  
  multiplier #(.WIDTH(WIDTH)) u_mult (
    .a(a), .b(b), .product(product)
  );

  // Output selection based on DUT type
  always_comb begin
    case (dut_type)
      "adder_rca": result = {{WIDTH{1'b0}}, sum_rca};
      "adder_cla": result = {{WIDTH{1'b0}}, sum_cla};
      "multiplier", "mult": result = product;
      default: begin
        result = '0;
        $display("ERROR: Unknown DUT_TYPE=%s", dut_type);
      end
    endcase
  end

  // Debug: Monitor DUT type changes
  always @(dut_type) begin
    $display("INFO: DUT_WRAPPER: DUT type changed to: %s", dut_type);
  end

endmodule
