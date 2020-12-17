`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////////
//Company:
//Engineer:
//
//CreateDate:12:32:0410/17/2014
//DesignName:
//ModuleName:VGA_controller
//ProjectName:
//TargetDevices:
//Toolversions:
//Description:
//
//Dependencies:
//
//Revision:
//Revision0.01_FileCreated
//AdditionalComments:
//
//////////////////////////////////////////////////////////////////////////////////
module vga_sync(
	input wire clk, reset,
	output wire hsync, vsync, video_on, p_tick,
	output wire [9:0] pixel_x, pixel_y
);

//`define R1024x768
`define R640x480 


`ifdef R640x480
localparam HD=640;	//
localparam VD=480;	//
localparam tamCont=2;
`endif

`ifdef R1024x768
localparam HD=1024;	//
localparam VD=768;	//
localparam tamCont=1;
`endif
//Declaración de variables
//Parámetros para la sincronización vertical y horizontal.

localparam HF=48;		//left border
localparam HB=16;		//right border
localparam HR=96;		//horizontal retrace 
localparam VF=10;		//top border
localparam VB=33;		//bottom border
localparam VR=2;		//vertical retrace

//mod_2 counter (Contador para el divisor de frecuencia)
reg [tamCont-1:0] mod2_reg;
reg [tamCont-1:0] mod2_next;
//sync counters 
reg [9:0] h_count_reg, h_count_next;
reg [9:0] v_count_reg, v_count_next;
//output buffer
reg v_sync_reg, h_sync_reg;
wire v_sync_next, h_sync_next;
//status signal
wire h_end, v_end;
reg pixel_tick_next, pixel_tick;
//body
//registers
always @(posedge clk,posedge reset)
	if(reset)
	begin
		mod2_reg <= {tamCont{1'b0}};
		v_count_reg <= 0;
		h_count_reg <= 0;
		v_sync_reg <= 1'b0;
		h_sync_reg <= 1'b0;
		pixel_tick <= 1'b0;
	end
	else
	begin
		pixel_tick <= pixel_tick_next;
		mod2_reg <= mod2_next;
		v_count_reg <= v_count_next;
		h_count_reg <= h_count_next;
		v_sync_reg <= v_sync_next;
		h_sync_reg <= h_sync_next;
	end
//mod_2 circuit to generate 25MHz enable tick
always @* 
	begin
	mod2_next = mod2_reg + 1'b1;
	if(mod2_reg == {tamCont{1'b0}}) 
		pixel_tick_next = 1'b1;
	else
		pixel_tick_next = 1'b0;
	end
//status signals
//end of horizontal counter (799)
assign h_end = (h_count_reg == (HD+HF+HB+HR-1));
//end of vertical counter (524)
assign v_end = (v_count_reg == (VD+VF+VB+VR-1));
//next_state logic of mod_800 horizontal sync counter
always @*
	if(pixel_tick)
	//25MHz pulse
		if(h_end)
			h_count_next = 0;
		else
			h_count_next = h_count_reg + 1'b1;
	else
		h_count_next = h_count_reg;
//next_state logic of mod_525 vertical sync counter
always @*
	if(pixel_tick & h_end)
		if(v_end)
			v_count_next = 0;
		else
			v_count_next = v_count_reg + 1'b1;
	else
		v_count_next = v_count_reg;
//horizontal and vertical sync, buffered to avoid glitch
//h_svnc_next asserted between 656 and 751
assign h_sync_next = (h_count_reg >= (HD+HB) && h_count_reg <= (HD+HB+HR-1));
//vh_sync_next asserted between 490 and 491
assign v_sync_next = (v_count_reg >= (VD+VB)&& v_count_reg <= (VD+VB+VR-1));

//video on/off
assign video_on = (h_count_reg < HD) && (v_count_reg < VD);
//output
assign hsync = h_sync_reg;
assign vsync = v_sync_reg;
assign pixel_x = (h_count_reg > HF & h_count_reg <= (HD+HF) & v_count_reg > VF & v_count_reg <= (VD+VF)) ? h_count_reg - HF : {10{1'b0}};
assign pixel_y = (v_count_reg > VF & v_count_reg <= (VD+VF)) ? v_count_reg - VF : {10{1'b0}};
assign p_tick = (h_count_reg > HF & h_count_reg <= (HD+HF) & v_count_reg > VF & v_count_reg <= (VD+VF)) ? pixel_tick : 1'b0;


endmodule