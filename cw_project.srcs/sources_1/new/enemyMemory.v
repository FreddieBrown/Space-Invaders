`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.12.2019 23:21:24
// Design Name: 
// Module Name: enemyMemory
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


module enemyMemory #(parameter ENEMYNO = 5)
    (input clk,
    input [10:0] curr_x,
    input [9:0] curr_y,
    input [((ENEMYNO-1)*11)+10:0] ereg_x,
    input [((ENEMYNO-1)*10)+9:0] ereg_y,
    output [15:0] douta
    );
    
    integer i;
    wire ena = 1;
    wire [20:0] addra;
    reg [10:0] pos_x;
    reg [9:0] pos_y;
    reg enemyDraw = 0;
    reg[10:0] epos_x[ENEMYNO-1:0];
    reg[9:0] epos_y[ENEMYNO-1:0];
    
    always@(*)
    begin        
        for(i=0; i<ENEMYNO;i=i+1)
        begin
            epos_x[i] = ereg_x[(11*i)+:11];
            epos_y[i] = ereg_y[(10*i)+:10];
        end
    end
    
    always@(posedge clk) begin
        for (i=0;i<ENEMYNO;i = i+1)
        begin
            enemyDraw = ((curr_x>=epos_x[i]-10)&&(curr_x<=(epos_x[i]+42)));
            if(enemyDraw) begin
                pos_x = epos_x[i];
                pos_y = epos_y[i];
            end
        end
    end
    
    assign addra = (curr_x-pos_x+2) + 32*(curr_y-pos_y-1);
    
    blk_mem_gen_1 enemyMem (
    .clka(clk),    // input wire clka
    .ena(ena),      // input wire ena
    .addra(addra),  // input wire [2 : 0] addra
    .douta(douta)  // output wire [15 : 0] douta
    );
    
    
endmodule
