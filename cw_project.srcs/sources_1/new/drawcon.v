`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.11.2019 14:45:07
// Design Name: 
// Module Name: drawcon
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


module drawcon #(parameter BULLNO=10, ENEMYNO=5, ESIZE=32, HSIZE=32, BSIZE=4)
(input clk, input[10:0] heropos_x, draw_x, input[((BULLNO-1)*11)+10:0] bullpos_xreg, input[((ENEMYNO-1)*11)+10:0] epos_xreg,
 input[9:0] heropos_y, draw_y,input[((BULLNO-1)*10)+9:0] bullpos_yreg, input[((ENEMYNO-1)*10)+9:0] epos_yreg,
 input [3:0] p_r,p_g,p_b,eMem_r,eMem_g,eMem_b,
 output[3:0] draw_r, draw_g, draw_b);

    reg[3:0] bg_r, bg_g, bg_b = 0;
    reg[3:0] bul_r, bul_g, bul_b = 0;
    reg[3:0] hero_r, hero_g, hero_b = 0;
    reg[3:0] e_r, e_g, e_b = 0;
    reg[10:0] bulletpos_x[BULLNO-1:0], epos_x[ENEMYNO-1:0];
    reg[9:0] bulletpos_y[BULLNO-1:0], epos_y[ENEMYNO-1:0];
    integer i;

    always@(*)
    begin
        for(i=0; i<BULLNO;i=i+1)
        begin
            bulletpos_x[i] = bullpos_xreg[(11*i)+:11];
            bulletpos_y[i] = bullpos_yreg[(10*i)+:10];
        end
        
        for(i=0; i<ENEMYNO;i=i+1)
        begin
            epos_x[i] = epos_xreg[(11*i)+:11];
            epos_y[i] = epos_yreg[(10*i)+:10];
        end
    end
    
    reg heroDraw = 0;
    
    always@(*)
    begin
        if((draw_x >=0 && draw_x <= 10) || (draw_x >=1429 && draw_x <= 1439) || (draw_y >=0 && draw_y <= 10) || (draw_y >=889 && draw_y <= 899))
        begin
            bg_r <= 4'b1111;
            bg_g <= 4'b1111;
            bg_b <= 4'b1111;
        end
        else
        begin
            bg_r <= 4'b0010;
            bg_b <= 4'b0010;
            bg_g <= 4'b0010;
        end
    end
    
    always@(*)
    begin
        heroDraw = draw_x >= heropos_x && draw_x <= (heropos_x+HSIZE) && draw_y >= heropos_y && draw_y <= (heropos_y+HSIZE);
        if(heroDraw)
        begin
            hero_r = p_r;
            hero_g = p_g;
            hero_b = p_b;
        end
        else
        begin
            hero_r = 0;
            hero_g = 0;
            hero_b = 0;
        end  
    end
    
    ////////////// Drawing bullets

    reg col = 0;
    reg enemyDraw  = 0;    
    always@(*)
    begin
        bul_r = 0;
        bul_g = 0;
        bul_b = 0;
        e_r = 0;
        e_g = 0;
        e_b = 0;
    
        for(i = 0; i<BULLNO; i=i+1)
        begin
            col = (draw_x >= bulletpos_x[i] && draw_x <= (bulletpos_x[i]+BSIZE) && draw_y >= bulletpos_y[i] && draw_y <= (bulletpos_y[i] + BSIZE) && bulletpos_y[i] != 0 && bulletpos_x[i] != 0);
            if(col)
            begin
                bul_r = 0;
                bul_g = 4'b1111;
                bul_b = 0;
            end
        end    

    //////////////////////////////////////////////////////////////////////////
    /////////////// Drawing Enemies
    
        for(i = 0; i<ENEMYNO; i=i+1)
        begin
            enemyDraw = (draw_x >= epos_x[i] && draw_x <= (epos_x[i]+ESIZE) && draw_y >= epos_y[i] && draw_y <= (epos_y[i] + ESIZE) && epos_y[i] != 0 && epos_x[i] != 0);
            if(enemyDraw) 
            begin
                e_r = eMem_r;
                e_g = eMem_g;
                e_b = eMem_b;
            end 
        end
    end
    
    
    
    assign draw_r = (hero_r != 0 || hero_g != 0 || hero_b != 0) ? hero_r : ((e_r != 0 || e_g != 0 || e_b != 0) ? e_r : ((bul_r != 0 || bul_g != 0 || bul_b != 0) ? bul_r : bg_r));
    assign draw_g = (hero_r != 0 || hero_g != 0 || hero_b != 0) ? hero_g : ((e_r != 0 || e_g != 0 || e_b != 0) ? e_g : ((bul_r != 0 || bul_g != 0 || bul_b != 0) ? bul_g : bg_g));
    assign draw_b = (hero_r != 0 || hero_g != 0 || hero_b != 0) ? hero_b : ((e_r != 0 || e_g != 0 || e_b != 0) ? e_b : ((bul_r != 0 || bul_g != 0 || bul_b != 0) ? bul_b : bg_b));
endmodule
