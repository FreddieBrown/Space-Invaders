`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.12.2019 23:21:24
// Design Name: 
// Module Name: heroMemory
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


module heroMemory(input clk,
    input [10:0] curr_x, pos_x,
    input [9:0] curr_y, pos_y,
    output [15:0] douta
    );
    
    wire ena = 1;
    wire [20:0] addra;
    assign addra = (curr_x-pos_x+2) + 32*(curr_y-pos_y);
    
    blk_mem_gen_0 heroMem (
    .clka(clk),    // input wire clka
    .ena(ena),      // input wire ena
    .addra(addra),  // input wire [2 : 0] addra
    .douta(douta)  // output wire [15 : 0] douta
    );
    
    
endmodule
