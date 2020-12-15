`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Facultad de Ciencias Exactas y Naturales - UBA 
// Autor: Leticia Lorena Rodríguez
// Super Mario Bros. 2 en FPGA
//////////////////////////////////////////////////////////////////////////////////
module mario(
	input wire clk, reset,
	input wire [1:0] btn,
	output wire hsync, vsync,
	output wire [7:0] rgb
    );
	 
	wire [9:0] pixel_x, pixel_y;
	wire video_on, pixel_tick;
	reg [7:0] rgb_reg;
	wire [7:0] rgb_next;
	
	vga_sync vga_unit
		(.clk(clk), .reset(reset), .hsync(hsync), .vsync(vsync),
		.video_on(video_on), .p_tick(pixel_tick),
		.pixel_x(pixel_x), .pixel_y(pixel_y));
		
	bitmap_gen bitmap_unit
		(.clk(clk), .reset(reset), .btn(btn), 
		.video_on(video_on), .pix_x(pixel_x),
		.pix_y(pixel_y), .bit_rgb(rgb_next));
		
	always @(posedge clk)
		if (pixel_tick)
			rgb_reg <=  rgb_next;
	
	assign rgb = rgb_reg;


endmodule
