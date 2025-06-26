`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.06.2025 09:46:45
// Design Name: 
// Module Name: multiplier
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


module multiplier #(parameter WIDTH = 8)(
  input logic [WIDTH-1:0] a, b,
  output logic [2*WIDTH-1:0] product
);

  // Simple array multiplier
  logic [2*WIDTH-1:0] partial_products [WIDTH-1:0];
  
  // Generate partial products
  genvar i, j;
  generate
    for (i = 0; i < WIDTH; i++) begin : partial_product_gen
      for (j = 0; j < WIDTH; j++) begin : bit_product
        assign partial_products[i][i+j] = a[j] & b[i];
      end
      // Fill remaining bits with zeros
      if (i > 0) begin
        assign partial_products[i][i-1:0] = '0;
      end
      if (i+WIDTH < 2*WIDTH) begin
        assign partial_products[i][2*WIDTH-1:i+WIDTH] = '0;
      end
    end
  endgenerate
  
  // Sum all partial products
  always_comb begin
    product = '0;
    for (int k = 0; k < WIDTH; k++) begin
      product = product + partial_products[k];
    end
  end

endmodule
