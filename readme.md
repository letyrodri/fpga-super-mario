# FPGA Super Mario Bros Levels

by Leticia L. Rodriguez

This project started in the year 2014 as a FPGA course final work at the University of Buenos Aires. I was attending as a Computer Science Msc. student. This was an optional course.

Description
-----------
This is an implementation in Verilog of Super Mario Bros console game levels to be uploaded in an FPGA card.

About this project
------------------
On September 13th, 1985 the Super Mario Bros. platforms video game was launched for Family Computers Famicom and Nintendo Entertainment System (NES). This project implements, on an FPGA board, the levels of the legendary game.

I've designed new levels using the Mario artwork. They use a 640x480 monitor resolution. A second goal is to do memory space saving as video games do. It is not storing complete images. It uses small portions for them and compose them according to a level configuration. The whole level image will be composed in real time from small images of 32x32 pixels called sprites.

Repository organization
-----------------------
* docs: the report of my work
* res: this folder contains all the images and data used for creating the visual interface.
* scripts: additional scripts written in python to pre-process the data. They are used to converst csv files and raw files in binaries ready for verilog
* src: verilog code to be upload in the FPGA board

About FPGA and the board
-------------------------
FPGA stands for Field-programmable gate array. It's a customizable array of blocks that can be programmed forming different configurations to achieve complex combinational functions or simple gates. Usually, circuits are composed of specific wired combinational functions and gates that can't be changed or reconfigured. The advantage of using FPGA is that the technology lets us build our logic components by changing the configuration. Thus we are able to programm close to hardware level and increase the computation time rather than programming in software level that could be slower. Sometimes, printing electronic components could be hard, so FPGA is an intermediate solution to have low level computation without having fixed components.

I've used Verilog. Verilog is a hardware description language (HDL) used to model electronic systems. It's not lineal, everything happens at the same time like in a circuit. We can build sentences using a block begin/end. All the blocks are executed in parallel.

More about FPGA:
https://www.allaboutcircuits.com/technical-articles/what-is-an-fpga-introduction-to-programmable-logic-fpga-vs-microcontroller/
https://www.coursera.org/learn/intro-fpga-design-embedded-systems

I've tested my work on an Xilinx FPGA board. You can find more about them here:
https://www.xilinx.com/products/silicon-devices.html


Project deployment
-------------------
This project was developed and deployed on the board using Xilinx's ISEC Simulator (ISim). This simulator let you test the program without having a board and implement the code on the FPGA board:
https://www.xilinx.com/products/design-tools/isim.html

The steps for development and deployment in ISE are:
* Write the HDL (provided in src in this repository)
* Syntasis verification and run the simulator
* Sythesis and implementation:
	* Translate: generate a netlist
	* Map: Maps the FPGA
	* Place and Route: decides the cells that is going to use our logic and how they will connect.
* Generate and download the file to the FPGA board


# Implementation details

## Level building

As explained before, this project recreates Super Mario Bros. levels in a FPGA board. It's designed in a 640x480 resolution. The level is composed using a level map and sprites that are assigned according to the mapping. To create the map, the 640x480 resolution was divided in 32x32 squares in the following way:

![Screen division](https://raw.githubusercontent.com/letyrodri/fpga-super-mario/master/imgs/screen.png)

Each of these 300 boxes can be filled with a different pattern selected from the sprite:

![Sprite](https://raw.githubusercontent.com/letyrodri/fpga-super-mario/master/imgs/sprites.jpeg)

For example, a map may indicate the following: in the first position the binary value 00010, in the 230th position the binary value 11000 and, finally, in the 231th position the value 110001. A configuration like that will replace three boxes in the screen in the following way:

![Replacement](https://raw.githubusercontent.com/letyrodri/fpga-super-mario/master/imgs/replace.jpeg)

The rest of the boxes are defaulted to 00000, that it's the color of the sky. The pixel value 11010111 (pink) in each sprite section is also replaced by light blue as the sky. Finally, the combination between the map provided in the example above and the sky replacement will result in this level:

![Replacement](https://raw.githubusercontent.com/letyrodri/fpga-super-mario/master/imgs/bluereplace.jpeg)

All this replacement will be performed by the FPGA board in realtime. Additionally, a code for moving mario around the screen was added. If we press the left or right on the board and Mario is located in the screen, he will move from right to left and left to right according to the button pressed.

## Design

#### Top Level: Mario

##### vga_sync module
##### bitmap_gen module


## Implementation

### Data preparation

The implementation includes three memories: two for the sprites and one for the map. The values of those memories are providen by the files sprite1.bin, sprite2.bin and mapa.bin.

The sprite's memories occupy 2KB each one. Each memory address stores 8 bits and it's addressed by 14-bits memory address.

By the other side, the map memory stores 5 bits. Due the fact we have 5 maps of 300 boxes, the memory address is 11-bits long. 

#### Sprites encoding

The Super Mario Bros images were grabbed from internet in 16 bit color. The software for Linux GIMP was used to compose the sprites. The steps were the following:

* Select and cut the images in 32x32 pixels
* Organize the sprites, one after another, in a single image until have 16 sprites per image.
* Convert the image to 256 bits color encoding using Xilinx color palette
* Save the image as raw
* Process the image using a python script to translate it to a binary string so it can be read by spritex.v implementation

The output files are sprite1.bin and sprite2.bin. The memory is accesible by the module sprite1.v and sprite2.v. 

Here an image displaying sprite1.bin contents:
![Sprite1 content](https://raw.githubusercontent.com/letyrodri/fpga-super-mario/master/imgs/sprite_encoded.png)


#### Maps file encoding

For building the map, a CSV file was used. It has 20 columns and 75 lines (5 maps of 15 lines each) where eas position indicates a value between 0 and 31. Each value corresponds to the sprite index in the related position. Using a python script, that CSV was converted to a format that will be read by mapa.v file. 

The Python script takes each map position, column by column, and covert the 5-bits binary number to a string. The output filename is mapa.bin.

Here an image displaying mapa.bin contents:
![Mapa content](https://raw.githubusercontent.com/letyrodri/fpga-super-mario/master/imgs/mapa_cat.png)


### Code

The code includes a lot of mapping for replacing the sprite images according to the map specified. The map and the sprites are saved in memory. Here I'm showing  the calculations done for addressing the memory according to the current position (x, y) and the value in the map for that position.

#### MAP\_ADDRESS\_LOGIC

We can find the logic for calculating the memory address, according to x,y from the map, in the module MAP_ADDRESS_LOGIC.

The calculation is the following:

```
assign addr_map_next = shift_map ∗ 15+((pix_x >>5)∗15)+( pix_y >>5);
mapa mapa(.clk (clk), .en (1 ’b1), .addr( addr_map_next ), .dataout(sprite_block));
```

where pix\_x and pix\_y represent the screening current position (given by the module vga_sync.v) and shift\_map represent a register that contains the offset. This offset is calculated in base on the pressed right or left buttons.


To search the index in the map, it divides by 32. It then multiplies by 15, so it can select the correct column. After that, it adds both values because the memory is contiguous. Finally, adds the ofset of the column.


#### SPRITE\_ADDRESS\_LOGIC

The memory address calculation for the sprite is in the bitmap\_gen.v module.

As everything runs simustaneusly in a circuit, a calculated address is always in the output wire. The is a logic that uses the memory address when needed. The ouput value of sprite\_block is used to select the sprite.

This is the formula used to calculate the sprite address:

```
assign addr_next = (pix_x % 32)+(( pix_y % 32)<<5)+( sprite_block −1)∗32∗32;
sprite1 sprite1 ( .clk(clk) , .en( 1’b1 ) , .addr( addr_next ), .dataout( sprite1_out ));
sprite2 sprite2 ( .clk(clk) , .en( 1’b1 ) , .addr( addr_next ), .dataout( sprite2_out ));
```

#### PIXEL\_LOGIC

At last, there is a logic to solve the color and exceptional cases. In example, this code selects from sprite1 or sprite2. It replaces the pink with sky or when the value is 00000, it's also replaced by the sky.

Here is the related code:
```
wire is_sprite2, is_sky;
assign is_sprite2 = ( sprite_block > 16);
assign is_sky = (sprite_block == 5’b00000) ||
(is_sprite2 && (sprite2_out == TRANSPARENT_COLOR)) ||
((!is_sprite2) && sprite1_out == TRANSPARENT_COLOR);

always @∗
	begin
	bit_rgb = 8’b00000000;
	if ( video_on )
		begin
			if ( is_sky )
				// Block value 0 shows the light blue sky
				bit_rgb = SKY_COLOR;
			else
				if ( is_sprite2 )
					bit_rgb = sprite2_out ;
				else
					bit_rgb = sprite1_out ;
		end
	end
```


************
My original project is hosted in Spanish on my work in progress github: https://github.com/letyrodridc/fpga-super-mario/wiki/Super-Mario-Bros-FPGA
************



