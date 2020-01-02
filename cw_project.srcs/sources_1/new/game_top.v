`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.11.2019 14:07:38
// Design Name: 
// Module Name: game_top
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

module game_top(input clk,fire, left, right, rst,flip,pause,
               output[3:0] pix_r, pix_g, pix_b,
               output a, b, c, d, e, f, g, 
               output hsync, vsync,
               output[7:0] an,
               output reg [4:0] LED
              );
     parameter integer BG_WIDTH = 10;
     parameter integer BULLNO = 10;
     parameter integer FRAMERATECOUNT = 833334;
     parameter integer ENEMYNO = 5; 
     parameter integer HSIZE = 32;
     parameter integer ESIZE = 32;
     parameter integer BSIZE = 4; 
     wire[10:0] curr_x;
     wire[9:0] curr_y;
     reg[3:0] bulletcount;
     reg[10:0] score = 0;
     reg[3:0] score1,score2,score3,score4,score5,score6,score7,score8 = 0;
     reg[3:0] lives = 5;
     wire[3:0] draw_r, draw_g, draw_b;
     wire pixclk;
     wire logclk;
     
     reg control;
     
     wire [4:0] ledArray = 0;
     reg drwclk = 0;
     reg[19:0] clock_counter = 0;
     reg[5:0] speed = 10;
     reg[10:0] heropos_x = 691;
     reg[9:0] heropos_y = 850;
     reg[10:0] bulletpos_x[BULLNO-1:0];
     reg[9:0] bulletpos_y[BULLNO-1:0];
     reg[((BULLNO-1)*11)+10:0] bullreg_x;
     reg[((BULLNO-1)*10)+9:0] bullreg_y;
     reg[((ENEMYNO-1)*11)+10:0] ereg_x;
     reg[((ENEMYNO-1)*10)+9:0] ereg_y;
     reg[3:0] bulletVal = 0;
     reg [5:0] enemyCounter = 0;
     reg [9:0] enemyCountSpeed = 0;
     reg [4:0] formation = 1;     
     reg signed [6:0] eSpe_x = 16;
     reg signed [6:0] eSpe_y = 32;
     reg eDirection = 0;
     reg [10:0] ePos_x [4:0];
     reg [9:0] ePos_y [4:0];
     reg [3:0] eReset;
     reg defeat;
     
     
     always@* begin
        if(rst == 1 || pause == 1)
            control = 0;
        else
            control = 1;
     end
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////// Clock for logic
    always@(posedge clk)
    begin
        
        clock_counter = clock_counter + 1;
        if(clock_counter == FRAMERATECOUNT)
        begin
            clock_counter = 0;
            drwclk = ~drwclk;
        end
    end                     
    assign logclk = drwclk;
     ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////// Hero Controls
    reg flag1 = 0;
    reg flag2 = 0;
    integer j;
    integer i;
    always@(posedge logclk)
    begin
        if(fire == 1)
        begin
            flag1 <= 1;
        end
        
        if(fire == 0)
        begin
            if(bulletcount < BULLNO && flag1 == 1 && pause == 0 && lives > 0 && control == 1)
            begin
                flag1 <= 0;
                flag2 <= 0;
                for(i=0; i<BULLNO; i=i+1)
                begin
                    if(bulletpos_x[i] == 0 && bulletpos_y[i] ==0 && flag2 == 0)
                    begin
                        bulletcount <= bulletcount + 1;
                        bulletpos_x[i] <= heropos_x+14;
                        bulletpos_y[i] <= heropos_y;
                        flag2 = 1;
                    end
                end
            end
            if(bulletcount == BULLNO && flag1 == 1)
            begin
                flag1 <= 0;
            end
            
            if(pause == 1 || lives == 0)
            begin
               flag1 <= 0; 
            end
        
        end
        if(right == 1 && lives > 0 && control == 1)
        begin
            if((heropos_x < 1382))
            begin
                heropos_x <= heropos_x + speed;
            end
        end
        if(left == 1 && lives > 0 && control == 1)
        begin
            if(heropos_x > 15)
            begin
                heropos_x <= heropos_x - speed;
            end
        end
    
     ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////Bullet Controls
        if(bulletcount > BULLNO)
        begin
            bulletcount <= 0;
        end
        for(j = 0; j<BULLNO; j=j+1)
        begin
            if(bulletpos_x[j] != 0 && bulletpos_y[j] != 0)
            begin
                bulletpos_y[j] <= bulletpos_y[j] - speed;
                if(bulletpos_y[j] < 11)
                begin
                    bulletcount <= bulletcount - 1;
                    bulletpos_y[j] <= 0;
                    bulletpos_x[j] <= 0;
                end
            end
        end
        for(i=0;i<BULLNO;i=i+1)
        begin
            bullreg_x = {bullreg_x, bulletpos_x[i]};
            bullreg_y = {bullreg_y, bulletpos_y[i]};
        end    
        
        
             
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //Enemy Stuff
    
         // Work out if enemy has collided with bullet
        for(i = 0; i<ENEMYNO; i=i+1)
        begin
            for(j=0;j<BULLNO;j=j+1)
            begin
                if(( (ePos_x[i] <  bulletpos_x[j]) & ((ePos_x[i] + ESIZE) >  bulletpos_x[j])) & ((ePos_y[i] <  bulletpos_y[j]) & (ePos_y[i] + ESIZE >  bulletpos_y[j]) ))
                begin
                    score1 <= score1 +1; 
                    score <= score +1;
                    if(score1 == 9)
                    begin
                        eSpe_y <= eSpe_y + 5;
                        score1 <= 0;
                        score2 <= score2+1;
                        if(score2 == 9)
                        begin
                            eSpe_y <= eSpe_y + 20;
                            score2 <= 0;
                            score3 <= score3+1;
                            if(score3 == 9)
                            begin
                                score3 <= 0;
                                score4 <= score4+1;
                                if(score4 == 9)
                                begin
                                    score4 <= 0;
                                    score5 <= score5+1;
                                    if(score5 == 9)
                                    begin
                                        score5 <= 0;
                                        score6 <= score6+1;
                                        if(score6 == 9)
                                        begin
                                            score6 <= 0;
                                            score7 <= score7+1;
                                            if(score7 == 9)
                                            begin
                                                score7 <= 0;
                                                score8 <= score8 + 1;
                                                if(score8 == 9)
                                                begin
                                                    score8 <= 0;
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                            
                        end
                    end
                    eReset <= eReset +1; 
                    bulletcount <= bulletcount -1;
                    ePos_x[i] <= 0;
                    ePos_y[i] <= 0;
                    bulletpos_x[j] <= 0;
                    bulletpos_y[j] <= 0;
                end    
            end
        end
        
        //Counter for movement update
        if(enemyCounter >= 60 && pause == 0 && lives > 0 && control == 1) begin
            enemyCounter = 0;
            //Update movement
            for(i=0;i<ENEMYNO;i=i+1) begin
                if(ePos_x[i] != 0 && ePos_y[i] != 0)
                begin
                    if(~(ePos_x[i] < 1439-ESIZE-eSpe_x)&&(ePos_x[i]>0+eSpe_x)) begin
                        eDirection = ~eDirection;
                    end
                    if(eDirection == 0) begin
                        ePos_x[i] <= ePos_x[i] + eSpe_x;
                    end else if(eDirection == 1) begin
                        ePos_x[i] <= ePos_x[i] - eSpe_x;
                    end
                    if((ePos_y[i] < 750)) begin
                        ePos_y[i] <= ePos_y[i] + eSpe_y;
                    end else begin
                        defeat <= 1;
                    end
                end
            end             
        end else begin
            enemyCounter = enemyCounter + 1;
        end
        
        //Counter to change enemy x direction every 240/60 seconds
        if(enemyCountSpeed >= 240) begin
            enemyCountSpeed = 0;
            eDirection = ~eDirection;
        end else begin
            enemyCountSpeed = enemyCountSpeed + 1;
        end
        
        
        //Check if all enemies killed, if player killed or if rst == 1
        if((rst || (eReset == ENEMYNO) || defeat)==1)begin
            //Initialise all registers on rst
            if(rst == 1) begin
                score <= 0;
                score1 <= 0;
                score2 <= 0;
                score3 <= 0;
                score4 <= 0;
                score5 <= 0;
                score6 <= 0;
                score7 <= 0;
                score8 <= 0;
                lives <= 5;
                eReset <= 0;
                eSpe_y <= 32;
                bulletcount <= 0;
                formation = 1;
            end
            //If player killed update lives
            if(defeat == 1) begin
                lives <= lives -1;
                eReset <= 0;
                defeat <= 0;
            end
            //If all enemies killed
            if(eReset == ENEMYNO) begin
                eReset <= 0;
                if(formation >= 4) begin
                    formation <= 1;
                end else begin
                    formation <= formation + 1;
                end
            end
            //Respawn enemies
            if(formation == 1) begin
                for(i=0;i<ENEMYNO-2;i = i+1) begin
                    ePos_x[i] <= BG_WIDTH + 200*i + 510;
                    ePos_y[i] <= BG_WIDTH + 100;
                end
                eReset <= 2;
                ePos_x[3] <= 0;
                ePos_y[3] <= 0;
                ePos_x[4] <= 0;
                ePos_y[4] <= 0;
            end else if (formation == 2) begin
                for(i=0;i<ENEMYNO-1;i = i+1) begin
                    if(i>1) begin
                        ePos_x[i] <= BG_WIDTH + 800*(i-2) + 310;
                        ePos_y[i] <= BG_WIDTH + 150;
                    end else begin
                        ePos_x[i] <= BG_WIDTH + 400*i + 510;
                        ePos_y[i] <= BG_WIDTH + 300;
                    end
                end
                eReset <= 1;
                ePos_x[4] <= 0;
                ePos_y[4] <= 0;
            end else if (formation == 3) begin
                for(i=0;i<ENEMYNO;i = i+1) begin
                    ePos_x[i] <= BG_WIDTH + 200*i + 310;
                    ePos_y[i] <= BG_WIDTH + 100;
                end
            end else if (formation == 4) begin
                for(i=0;i<ENEMYNO-2;i = i+1) begin
                    ePos_x[i] <= BG_WIDTH + 200*i + 510;
                    ePos_y[i] <= BG_WIDTH + 100;
                end
                for(i=ENEMYNO-2;i<ENEMYNO;i = i+1) begin
                    ePos_x[i] <= BG_WIDTH + 200*(i-3) + 610;
                    ePos_y[i] <= BG_WIDTH + 300;
                end
            end
        end        
        
        //Initialise 2D array (kindof)
        for(i=0;i<ENEMYNO;i=i+1)
        begin
            ereg_x = {ereg_x, ePos_x[i]};
            ereg_y = {ereg_y, ePos_y[i]};
        end
    end
    
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //Memory stuff
    wire [15:0] pDouta;
    wire [15:0] eDouta;
    reg [3:0] p_r,p_g,p_b,e_r,e_g,e_b = 0;
    heroMemory heroMem(.clk(pixclk),.curr_x(curr_x),.curr_y(curr_y),.pos_x(heropos_x),.pos_y(heropos_y),.douta(pDouta));
    enemyMemory #(.ENEMYNO(ENEMYNO) ) enemyMem(.clk(pixclk),.curr_x(curr_x),.curr_y(curr_y),.ereg_x(ereg_x),.ereg_y(ereg_y),.douta(eDouta));
    
    always@(posedge pixclk) begin
        p_r <= pDouta[11:8];
        p_g <= pDouta[7:4];
        p_b <= pDouta[3:0];
        
        e_r <= eDouta[11:8];
        e_g <= eDouta[7:4];
        e_b <= eDouta[3:0];
    end
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
    always@(posedge clk) begin
        case(lives)
            5:LED <= 5'b11111;
            4:LED <= 5'b01111;
            3:LED <= 5'b00111;
            2:LED <= 5'b00011;
            1:LED <= 5'b00001;
            0:LED <= 5'b00000;
        endcase
    end
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////     
    
    
    clk_wiz_0 clock1(.clk_out1(pixclk), .clk_in1(clk));
    
     vga_out v1(.gen_clk(pixclk),.draw_r(draw_r), .draw_g(draw_g), 
                .draw_b(draw_b), .pix_r(pix_r), .pix_g(pix_g), 
                .pix_b(pix_b), .hsync(hsync), .vsync(vsync), 
                .curr_x(curr_x), .curr_y(curr_y));
                
     seginterface s1(.clk(clk),.rst(rst), .dig7(score8),.dig6(score7),.dig5(score6), .dig4(score5), .dig3(score4),.dig2(score3),.dig1(score2),.dig0(score1),
                    .a(a), .b(b), .c(c), .d(d), .e(e), .f(f), .g(g), .an(an), .flip(flip), .lives(lives));
     
     drawcon #(.BULLNO(BULLNO),.ENEMYNO(ENEMYNO), .ESIZE(ESIZE), .HSIZE(HSIZE), .BSIZE(BSIZE) )dc1 
                 (.heropos_x(heropos_x),.heropos_y(heropos_y),
                 .bullpos_xreg(bullreg_x),.bullpos_yreg(bullreg_y),
                 .epos_xreg(ereg_x),.epos_yreg(ereg_y),
                 .draw_x(curr_x),.draw_y(curr_y), .draw_r(draw_r), .draw_g(draw_g), .draw_b(draw_b),
                 .eMem_r(e_r),.eMem_g(e_g),.eMem_b(e_b),.p_r(p_r),.p_g(p_g),.p_b(p_b));    
endmodule
