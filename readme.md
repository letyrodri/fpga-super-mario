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

# Implementation details

## Level building

As explained before, this project recreates Super Mario Bros. levels in a FPGA board. It's designed in a 640x480 resolution. The level is composed using a level map and sprites that are assigned according to the mapping. To create the map, the 640x480 resolution was divided in 32x32 squares in the following way:

![Screen division](https://raw.githubusercontent.com/letyrodri/fpga-super-mario/master/imgs/screen.png)

Each of these 300 boxes can be filled with a different pattern selected from the sprite:

![Sprite](https://raw.githubusercontent.com/letyrodri/fpga-super-mario/master/imgs/sprites.jpeg)

For example, a map may indicate the following: in the first position the binary value 00010, in the 230th position the binary value 11000 and, finally, in the 231th position the value 110001. A configuration like that will replace three boxes in the screen in the following way:

![Replacement](https://raw.githubusercontent.com/letyrodri/fpga-super-mario/master/imgs/replace.jpeg)

The rest of the boxes are defaulted to 00000, that it's the color of the sky. The pixel value 11010111 (fucsia) in each sprite section is also replaced by light blue as the sky. Finally, the combination between the map provided in the example above and the sky replacement will result in this level:

![Replacement](https://raw.githubusercontent.com/letyrodri/fpga-super-mario/master/imgs/bluereplace.jpeg)

All this replacement will be performed by the FPGA board in realtime. Additionally, a code for moving mario around the screen was added. If we press the left or right on the board and Mario is located in the screen, he will move from right to left and left to right according to the button pressed.

## Design

#### 

#####
#####

## Implementation

### Data preparation

The implementation includes three memories: two for the sprites and one for the map. The values of those memories are providen by the files sprite1.bin, sprite2.bin and mapa.bin.

The sprite's memories occupy 2KB each one. Each memory address stores 8 bits and it's addressed by 14-bits memory address.

By the other side, the map memory stores 5 bits. Due the fact we have 5 maps of 300 boxes, the memory address is 11-bits long. 

#### Sprites file encoding
#### Maps file encoding

### Code




************
My original project is hosted in Spanish in my work in progress github: https://github.com/letyrodridc/fpga-super-mario/wiki/Super-Mario-Bros-FPGA
:D
************



