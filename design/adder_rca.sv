`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.06.2025 09:34:05
// Design Name: 
// Module Name: adder_rca
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


module adder_rca #(parameter WIDTH = 8)(
  input logic [WIDTH-1:0] a, b,
  output logic [WIDTH-1:0] sum,
  output logic carry_out
);
  
  // Ripple Carry Adder - bit by bit addition
  logic [WIDTH:0] carry;
  
  assign carry[0] = 1'b0;  // Initial carry
  
  genvar i;
  generate
    for (i = 0; i < WIDTH; i++) begin : rca_stage
      full_adder fa_inst (
        .a(a[i]),
        .b(b[i]),
        .cin(carry[i]),
        .sum(sum[i]),
        .cout(carry[i+1])
      );
    end
  endgenerate
  
  assign carry_out = carry[WIDTH];
  
endmodule

// Full Adder module for RCA
module full_adder (
  input logic a, b, cin,
  output logic sum, cout
);
  assign sum = a ^ b ^ cin;
  assign cout = (a & b) | (b & cin) | (a & cin);
endmodule
