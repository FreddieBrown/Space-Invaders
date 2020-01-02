`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.11.2019 14:02:30
// Design Name: 
// Module Name: ship
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


module ship(
    input clk,
    input fire,
    input left,
    input right,
    input speed,
    input[10:0] curpos_x,
    input[9:0] curpos_y,
    output[10:0] blkpos_x,
    output[9:0] blkpos_y
    );
    
    reg[10:0] blkreg_x;
    reg[9:0] blkreg_y;
    always @ (posedge clk)
    begin
        blkreg_x = curpos_x;
        blkreg_y = curpos_y;
        
        if(fire == 1)
        begin
            blkreg_x <= 691;
        end
        if(right == 1)
        begin
            if(blkreg_x < 1382)
            begin
                blkreg_x <= blkreg_x + speed;
            end
        end
        if(left == 1)
        begin
            if(blkreg_x > 15)
            begin
                blkreg_x <= blkreg_x - speed;
            end
        end
    end
    assign blkpos_x = blkreg_x;
    assign blkpos_y = blkreg_y;
    
endmodule
