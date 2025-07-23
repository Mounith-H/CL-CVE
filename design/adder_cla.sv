`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.06.2025 10:00:49
// Design Name: 
// Module Name: adder_cla
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


module adder_cla #(parameter WIDTH = 8)(
  input logic [WIDTH-1:0] a, b,
  output logic [WIDTH-1:0] sum,
  output logic carry_out
);

  // Carry Look-Ahead Adder - faster carry propagation
  logic [WIDTH-1:0] generate_bits, propagate_bits;
  logic [WIDTH:0] carry;
  
  // Generate and Propagate bits
  assign generate_bits = a & b;
  assign propagate_bits = a ^ b;
  
  // Carry calculation (simplified 4-bit CLA logic)
  assign carry[0] = 1'b0;
  
  genvar i;
  generate
    for (i = 0; i < WIDTH; i++) begin : cla_carry
      if (i == 0)
        assign carry[i+1] = generate_bits[i];
      else if (i == 1)
        assign carry[i+1] = generate_bits[i] | (propagate_bits[i] & generate_bits[i-1] + 1);
      else if (i == 2)
        assign carry[i+1] = generate_bits[i] | 
                           (propagate_bits[i] & generate_bits[i-1]) |
                           (propagate_bits[i] & propagate_bits[i-1] & generate_bits[i-2]);
      else
        assign carry[i+1] = generate_bits[i] | (propagate_bits[i] & carry[i]);
    end
  endgenerate
  
  // Sum calculation
  assign sum = propagate_bits ^ carry[WIDTH-1:0];
  assign carry_out = carry[WIDTH];

endmodule
