`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.12.2019 23:32:35
// Design Name: 
// Module Name: ledControl
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


module ledControl(input clk,
    input lives,
    output [4:0] LED
    );
    integer i;
    reg [4:0] ledArray;
    
    always@(posedge clk) begin
        case(lives)
            5:ledArray <= 5'b11111;
            4:ledArray <= 5'b01111;
            3:ledArray <= 5'b00111;
            2:ledArray <= 5'b00011;
            1:ledArray <= 5'b00001;
            0:ledArray <= 5'b00000;
        endcase
    end
    assign LED = ledArray;
endmodule
