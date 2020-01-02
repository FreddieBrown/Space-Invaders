`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.11.2019 13:11:44
// Design Name: 
// Module Name: vga_out
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


module vga_out(input gen_clk, 
               input[3:0] draw_r, draw_g, draw_b, 
               output[3:0] pix_r, pix_g, pix_b, 
               output hsync, vsync, 
               output[10:0] curr_x, 
               output[9:0] curr_y
              );
    reg[10:0] hcount = 0;
    reg[9:0] vcount = 0;
    reg[10:0] vis_x = 0;
    reg[9:0] vis_y = 0;
    always@(posedge gen_clk)
    begin
        hcount = hcount + 1;
        if(hcount == 1904)
        begin
            hcount = 0;
            vcount = vcount + 1;
        end
        
        if(vcount == 932)
        begin 
            vcount = 0;
        end
        
        if((hcount >= 384 && hcount <= 1823) && (vcount >= 31 && vcount <= 930))
        begin
            vis_x = vis_x + 1;
            if(vis_x == 1440)
            begin
                vis_x = 0;
                vis_y = vis_y + 1;
            end
            if(vis_y == 900)
            begin
                vis_y = 0;
            end
        end
    end
    assign hsync = (hcount >= 0 && hcount <= 151) ? 0 : 1;
    assign vsync = (vcount >= 0 && vcount <= 2) ? 1 : 0;
    assign pix_r = (hcount >= 384 && hcount <= 1823) && (vcount >= 31 && vcount <= 930) ? draw_r : 0;
    assign pix_g = (hcount >= 384 && hcount <= 1823) && (vcount >= 31 && vcount <= 930) ? draw_g : 0;
    assign pix_b = (hcount >= 384 && hcount <= 1823) && (vcount >= 31 && vcount <= 930) ? draw_g : 0;
    assign curr_x = vis_x;
    assign curr_y = vis_y;
endmodule
