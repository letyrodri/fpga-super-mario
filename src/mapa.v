`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:05:05 11/07/2014 
// Design Name: 
// Module Name:    mapa 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module mapa(
input  clk, en,
input [RAM_ADDR_BITS-1:0] addr,
output reg [RAM_WIDTH-1:0]dataout
);


   parameter RAM_WIDTH = 5;
   parameter RAM_ADDR_BITS = 11;
   
   (* RAM_STYLE="{AUTO | BLOCK |  BLOCK_POWER1 | BLOCK_POWER2}" *)
   reg [RAM_WIDTH-1:0] mapa [1499:0];


   //  The forllowing code is only necessary if you wish to initialize the RAM 
   //  contents via an external file (use $readmemb for binary data)
   initial
   $readmemb("mapas.bin", mapa, 0, 1499);

   always @(posedge clk)
      if (en) begin
			dataout <= mapa[addr];
      end
						
				
				
endmodule
