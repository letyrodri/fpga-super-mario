`timescale 1ns / 1ps
module bitmap_gen(
	input wire clk, reset,
	input wire video_on,
	input [1:0] btn,
	input wire [9:0] pix_x, pix_y,
	output reg [7:0] bit_rgb
	);
	
	parameter TRANSPARENT_COLOR = 8'b11010111;
   parameter SKY_COLOR = 8'b11100000;
	
	// Manejo de direcciones de memoria
	wire [14:0] addr_next;
	wire [10:0] addr_map_next;
	wire sum1, sum2;
	
	// Desplazamiento del mapa por botones
	reg [7:0] shift_map;
	wire [7:0] shift_map_next;
	wire [1:0] db_level, db_tick;
	
	// Valores actuales de sprite1 (pixel), sprite2 (pixel) y mapa (bloque)
	wire [7:0] sprite1_out, sprite2_out;
	wire [4:0] sprite_block;
	
	// Armado en memoria de mapas y sprite	
	mapa mapa(.clk(clk), .en(1'b1), .addr(addr_map_next), .dataout(sprite_block));
	
	sprite1 sprite1(.clk(clk), .en(1'b1), .addr(addr_next), .dataout(sprite1_out));
	sprite2 sprite2(.clk(clk), .en(1'b1), .addr(addr_next), .dataout(sprite2_out));
	
	// Lectura de botones
	debounce db1(.clk(clk), .reset(reset), .sw(btn[0]), .db_level(db_level[0]), .db_tick(db_tick[0]));
	debounce db2(.clk(clk), .reset(reset), .sw(btn[1]), .db_level(db_level[1]), .db_tick(db_tick[1]));
	
	// Calculo de las posiciones de memoria
	assign addr_map_next = shift_map*15+((pix_x >>5)*15)+(pix_y>>5);
	assign addr_next = (pix_x % 32)+((pix_y%32)<<5)+(sprite_block-1)*32*32;
	
	// Limite para el shift
	assign sum1 = shift_map < 80? db_tick[0]:0;
	assign sum2 = shift_map > 0? db_tick[1]:0;
	
	assign shift_map_next = shift_map + sum1 - sum2; 
	
	
	always @(posedge clk)
		if (reset)
		begin
			shift_map <= 0;
		end
		else
		begin
			shift_map <= shift_map_next;
		end

	// Devuelta del pixel
	wire is_sprite2, is_sky;
   
	assign is_sprite2	= (sprite_block > 16);
	assign is_sky = (sprite_block == 5'b00000) || (is_sprite2 && (sprite2_out == TRANSPARENT_COLOR)) || ((!is_sprite2) && sprite1_out == TRANSPARENT_COLOR);
	
	always @*
		begin
		bit_rgb = 8'b00000000;
		if (video_on)
			begin
				if (is_sky)
					// Bloque valor 0 muestra el celeste del cielo
					bit_rgb = SKY_COLOR;
				else
					if (is_sprite2)
						bit_rgb = sprite2_out;
					else	
						bit_rgb = sprite1_out;
			end
		end	

endmodule
