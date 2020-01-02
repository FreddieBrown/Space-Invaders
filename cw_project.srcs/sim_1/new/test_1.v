`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.11.2019 13:26:14
// Design Name: 
// Module Name: test
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


module test();
    wire[3:0] pix_r, pix_g, pix_b;
    wire vsync, hsync;
    reg clk;
    wire[3:0] draw_r, draw_g, draw_b;
    reg fire, left, right;
    assign draw_r = 12;
    assign draw_b = 12;
    assign draw_g = 12;
    game_top gt1(.clk(clk), .fire(fire), .right(right), .left(left), .pix_r(pix_r), .pix_g(pix_g), .pix_b(pix_b), .hsync(hsync), .vsync(vsync));
    always begin
    clk = 0;
    fire = 1;
    #5 clk = 1; fire = 0;
    #5 ;
    end
endmodule
