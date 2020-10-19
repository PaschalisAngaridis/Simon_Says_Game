module SimonSAys(
    input logic clk,
    input logic rst,
    input logic kData,
    output logic hsync,
    output logic vsync,
    input  logic kclk,
    output logic [3:0] red,
    output logic [3:0] green,
    output logic [3:0] blue,
    output logic [3:0] mitsos,
    output logic [2:0] score,
    //output logic [3:0] round,
    output logic [10:0]  Q);
    
	
   
    integer cntff; 

    logic [2:0] x,y;
    logic [9:0] Hcnt,Vcnt;
    logic half_clk;
    logic falledge;
	

	
	always_ff @(posedge clk) begin
		if(half_clk)
			half_clk<=1'b0;
		else
			half_clk<=1'b1;
    end

  
     
       
        always_ff@(posedge clk)
        begin
           x[2]<=x[1];
           x[1]<=x[0];
           x[0]<=kclk;
        end
        always_ff@(posedge clk)
        begin
           y[2]<=y[1];
           y[1]<=y[0];
           y[0]<=kData;
        end
        
        assign falledge=(~x[1])&x[2];
        
    always_ff@(posedge clk,negedge rst) begin
		if (!rst) cntff<=0;
        else if(cntff==33)cntff<=0;
		else if(falledge) begin
            if(cntff<33)
                cntff<=cntff+1;
            else
                cntff<=0;
            end
	end

      always_ff@(posedge clk ,negedge rst)
      begin
          if(!rst) Q<=0;
          else if(falledge&&cntff<=33)
                       begin
                             Q[0]<=y[2];
                             Q[1]<=Q[0];
                             Q[2]<=Q[1];
                             Q[3]<=Q[2];
                              Q[4]<=Q[3];
                               Q[5]<=Q[4];
                                Q[6]<=Q[5];
                                Q[7]<=Q[6];
                               Q[8]<=Q[7];
                                Q[9]<=Q[8];
                                Q[10]<=Q[9];
                       end
       end
   
assign lock = (cntff==33)?1:0;
	
	always_ff @ (posedge clk, negedge rst) begin
    if (!rst) Hcnt <= 0;  
    else if(half_clk==1'b1 ) begin
		if(Hcnt < 799)
			Hcnt <= Hcnt + 1;
		else 
			Hcnt <= 0;
    end
end

always_ff @ (posedge clk, negedge rst)	begin
	if (!rst) Vcnt <= 0;
	else if(half_clk==1'b1) begin
		if (Hcnt == 799)
			if (Vcnt < 523)
				Vcnt <= Vcnt + 1;
			else
			Vcnt <= 0;
		end
	end

always_comb begin
	if(Hcnt >= 656 && Hcnt < 752)
		hsync=1'b0;
	else
		hsync = 1'b1;
end
		
	always_comb	
		begin
		if(Vcnt >=491 && Vcnt< 493)
			vsync=1'b0;
		else
			vsync = 1'b1;
		end


		
		logic [3:0]new_lucky;
		
		always_ff@(posedge clk)
		begin
			 new_lucky=neos%4;
		end
		
		integer neos;
  always_ff@(posedge clk)
  begin
  if(!rst)
  neos<=0;
  else neos<=neos+1;
  end



 
always_comb
begin
if((bling==4'b0001&&Hcnt <=319 && Vcnt <=240)||(bling==4'b1000 && Hcnt>319 && Hcnt<=639 && Vcnt>240 && Vcnt<=479))


red= (cntr < 10000000) ? 0 : 4'b1111;
else
red= 4'b0000;
end
always_comb begin
if ((bling==4'b0010 && Hcnt>319 && Hcnt<=639 &&Vcnt<=240)||(bling==4'b1000 && Hcnt>319 && Hcnt<=639 && Vcnt>240 && Vcnt<=479)) // 34 green

green = (cntg < 10000000) ? 0 : 4'b1111;
else
green = 4'b0000;
end
always_comb begin
if(( bling==4'b0100 && Hcnt<=319 && Vcnt>240 && Vcnt<=479)||(bling==4'b1000 && Hcnt>319 && Hcnt<=639 && Vcnt>240 && Vcnt<=479))

blue = (cntb < 10000000) ? 0 :4'b1111;
else
blue = 4'b0000;
end 



logic [5:0][1:0] mempc;
logic [6:0][1:0] memman;

//assign mitsos = mempc[1];


integer cntg ;
integer cntr;
integer cntb;
integer cntw;

    integer tmp;
    logic [3:0] bling;
	
//enum logic[3:0] {IDLE, RED,GREEN,WHITE,BLUE, PRED, PGREEN, PBLUE, PWHITE,PLAYR,PLAYG,PLAYB,PLAYW}state;

enum logic[3:0] {IDLE,RND1,RND2,RND3,RND4,RND5,RND6,NXTRND1,NXTRND2,NXTRND3,NXTRND4,NXTRND5,NXTRND6}round;
enum logic[3:0] {PC,FIND,PLAYR,PLAYG,PLAYB,PLAYW,RSTR,RSTG,RSTB,RSTW,MAN,CTRL,CORRECT,FALSE,CTRLN}game;
//enum logic[2:0] {ONE,TWO,THREE,FOUR,FIVE,SIX,DONE}per;

assign mitsos = round;
  
  
    
always_ff @(posedge clk,negedge rst) begin

if(!rst) cntr<=0; 

   else if( cntr<50000000) 
   cntr<=cntr+1;

    else if(game==RSTR&&round==IDLE)
    cntr<=0;
    else
    cntr<=0;
end


always_ff @(posedge clk,negedge rst) begin

if(!rst) cntg<=0; 

   else if( cntg<50000000) 
   cntg<=cntg+1;

    else if(game==RSTG&&round==IDLE)
    cntg<=0;
    else
    cntg<=0;
end


always_ff @(posedge clk,negedge rst) begin

if(!rst) cntb<=0; 

   else if( cntb<50000000) 
   cntb<=cntb+1;

    else if(game==RSTB&&round==IDLE)
    cntb<=0;
    else
    cntb<=0;
end

always_ff @(posedge clk,negedge rst) begin

if(!rst) cntw<=0; 

   else if( cntw<50000000) 
   cntw<=cntw+1;

    else if(game==RSTW&&round==IDLE)
    cntw<=0;
    else
    cntw<=0;
end


integer safe;
always_ff @(posedge clk,negedge rst) begin
if(!rst) safe<=0;
else if(game==CTRL) safe<=0;
else
safe<=safe+1;
end

integer safe2;
always_ff @(posedge clk,negedge rst) begin
if(!rst) safe2<=0;

else
safe2<=safe2+1;
end




logic [23:0] frvr ;
always_ff @(posedge clk, negedge rst) begin
if (!rst) frvr<=0;
else 
frvr<=frvr+1;
end
logic xor1,xor2,xor3,xor4,xor5,xor6,xor7,xor8,xor9,xor10,xor11,xor12;
logic [1:0] val1,val2,val3,val4,val5,val6;

assign xor1= frvr[0]^frvr[1];
assign xor2= frvr[2]^frvr[3];
assign xor3= frvr[4]^frvr[5];
assign xor4= frvr[6]^frvr[7];
assign xor5= frvr[8]^frvr[9];
assign xor6= frvr[10]^frvr[11];
assign xor7= frvr[12]^frvr[13];
assign xor8= frvr[14]^frvr[15];
assign xor9= frvr[16]^frvr[17];
assign xor10= frvr[18]^frvr[19];
assign xor11= frvr[20]^frvr[21];
assign xor12= frvr[22]^frvr[23];

assign val1 = {xor1,xor2};
assign val2 = {xor3,xor4};
assign val3 = {xor5,xor6};
assign val4 = {xor7,xor8};
assign val5 = {xor9,xor10};
assign val6 = {xor11,xor12};


logic [2:0]points;
always_ff @(posedge clk, negedge rst)begin
if (!rst) points<=0;
else if(game==RND1)points<=0;
else if(game==RND2)points<=1;
else if(game==RND3)points<=2;
else if(game==RND4)points<=3;
else if(game==RND5)points<=4;
else if(game==RND6)points<=5;
else if(per==7)points<=5;


end

assign score=points;


    always_ff @(posedge clk, negedge rst) begin
        if(!rst)begin 
            round <= IDLE;
            
           // bling <= 0;
        end
        else begin
            case(round) 
			IDLE:  if(lock && Q[0] && !Q[2] && Q[3] && !Q[4] && Q[5] && Q[6] && !Q[7] && !Q[8] && Q[9] && !Q[10]) round<=RND1;
			
			RND1:  if(game==CORRECT) round<=NXTRND1;
			       else if(game==FALSE) round<=IDLE;
			
			RND2:  if(game==CORRECT) round<=NXTRND2;
					else if(game==FALSE) round<=IDLE;
					
			RND3:  if(game==CORRECT) round<=NXTRND3;
					else if(game==FALSE) round<=IDLE;
					
			RND4:  if(game==CORRECT) round<=NXTRND4;
					else if(game==FALSE) round<=IDLE;
					
			RND5:  if(game==CORRECT) round<=NXTRND5;
					else if(game==FALSE) round<=IDLE;
					
			RND6:  if(game==CORRECT) round<=NXTRND6;
					else if (game==FALSE) round<=IDLE;
			NXTRND1:round<=RND2;
			NXTRND2:round<=RND3;
			NXTRND3:round<=RND4;
			NXTRND4:round<=RND5;
			NXTRND5:round<=RND6;
			NXTRND6:round<=IDLE;
			
			
            endcase
        end
    end

 
 
  always_ff @(posedge clk, negedge rst) begin
        if(!rst)begin 
            game <= PC;
            

			//set<=ONE;
           
        end
        else begin
            case(game) 
		    PC: begin 
           
			if(round==RND1)begin
				
					mempc[0]<=0;
					game<=FIND;
				end
				if(round==RND2)begin
					
					mempc[1]<=3;
					game<=FIND;
					
				end
				if(round==RND3)begin
					
					mempc[2]<=0;
					game<=FIND;
				end
				if(round==RND4)begin
					
					mempc[3]<=1;
					game<=FIND;
				end
				if(round==RND5)begin
					
					mempc[4]<=2;
					game<=FIND;
				end
				if(round==RND6)begin
					
					mempc[5]<=2;
                    game<=FIND;
				end
               end	
				
			
			FIND: begin
				if(round==RND1)begin
					if (set==1)begin
						if(mempc[0]==0) game<=RSTR;
						else if (mempc[0]==1) game<=RSTG;
						else if (mempc[0]==2) game<=RSTB;
						else if (mempc[0]==3) game<=RSTW;
					end
					if(set==2) game<=MAN;
				end
				
		
				if(round==RND2)begin
				    if (set==1)begin
						if(mempc[0]==0) game<=RSTR;
						else if (mempc[0]==1) game<=RSTG;
						else if (mempc[0]==2) game<=RSTB;
						else if (mempc[0]==3) game<=RSTW;
					end
				    if (set==2)begin
						if(mempc[1]==0) game<=RSTR;
						else if (mempc[1]==1) game<=RSTG;
						else if (mempc[1]==2) game<=RSTB;
						else if (mempc[1]==3) game<=RSTW;
					end
					if(set==3) game<=MAN;
				end
				if(round==RND3)begin
					if (set==1)begin
						if(mempc[0]==0) game<=RSTR;
						else if (mempc[0]==1) game<=RSTG;
						else if (mempc[0]==2) game<=RSTB;
						else if (mempc[0]==3) game<=RSTW;
					end
					if (set==2)begin
						if(mempc[1]==0) game<=RSTR;
						else if (mempc[1]==1) game<=RSTG;
						else if (mempc[1]==2) game<=RSTB;
						else if (mempc[1]==3) game<=RSTW;
					end
					
					if (set==3)begin
						if(mempc[2]==0) game<=RSTR;
						else if (mempc[2]==1) game<=RSTG;
						else if (mempc[2]==2) game<=RSTB;
						else if (mempc[2]==3) game<=RSTW;
					end
					if(set==4) game<=MAN;
				end
				
				if(round==RND4)begin
					if (set==1)begin
						if(mempc[0]==0) game<=RSTR;
						else if (mempc[0]==1) game<=RSTG;
						else if (mempc[0]==2) game<=RSTB;
						else if (mempc[0]==3) game<=RSTW;
					end
					if (set==2)begin
						if(mempc[1]==0) game<=RSTR;
						else if (mempc[1]==1) game<=RSTG;
						else if (mempc[1]==2) game<=RSTB;
						else if (mempc[1]==3) game<=RSTW;
					end
					
					if (set==3)begin
						if(mempc[2]==0) game<=RSTR;
						else if (mempc[2]==1) game<=RSTG;
						else if (mempc[2]==2) game<=RSTB;
						else if (mempc[2]==3) game<=RSTW;
					end
					
					if (set==4)begin
						if(mempc[3]==0) game<=RSTR;
						else if (mempc[3]==1) game<=RSTG;
						else if (mempc[3]==2) game<=RSTB;
						else if (mempc[3]==3) game<=RSTW;
					end
					
					if(set==5) game<=MAN;
				end
				if(round==RND5)begin
					if (set==1)begin
						if(mempc[0]==0) game<=RSTR;
						else if (mempc[0]==1) game<=RSTG;
						else if (mempc[0]==2) game<=RSTB;
						else if (mempc[0]==3) game<=RSTW;
					end
					if (set==2)begin
						if(mempc[1]==0) game<=RSTR;
						else if (mempc[1]==1) game<=RSTG;
						else if (mempc[1]==2) game<=RSTB;
						else if (mempc[1]==3) game<=RSTW;
					end
					
					if (set==3)begin
						if(mempc[2]==0) game<=RSTR;
						else if (mempc[2]==1) game<=RSTG;
						else if (mempc[2]==2) game<=RSTB;
						else if (mempc[2]==3) game<=RSTW;
					end
					
					if (set==4)begin
						if(mempc[3]==0) game<=RSTR;
						else if (mempc[3]==1) game<=RSTG;
						else if (mempc[3]==2) game<=RSTB;
						else if (mempc[3]==3) game<=RSTW;
					end
					
					if (set==5)begin
						if(mempc[4]==0) game<=RSTR;
						else if (mempc[4]==1) game<=RSTG;
						else if (mempc[4]==2) game<=RSTB;
						else if (mempc[4]==3) game<=RSTW;
					end
					if(set==6) game<=MAN;
					
				end
				if(round==RND6)begin
					if (set==1)begin
						if(mempc[0]==0) game<=RSTR;
						else if (mempc[0]==1) game<=RSTG;
						else if (mempc[0]==2) game<=RSTB;
						else if (mempc[0]==3) game<=RSTW;
					end
					
					if (set==2)begin
						if(mempc[1]==0) game<=RSTR;
						else if (mempc[1]==1) game<=RSTG;
						else if (mempc[1]==2) game<=RSTB;
						else if (mempc[1]==3) game<=RSTW;
					end
					
					if (set==3)begin
						if(mempc[2]==0) game<=RSTR;
						else if (mempc[2]==1) game<=RSTG;
						else if (mempc[2]==2) game<=RSTB;
						else if (mempc[2]==3) game<=RSTW;
					end
					
					if (set==4)begin
						if(mempc[3]==0) game<=RSTR;
						else if (mempc[3]==1) game<=RSTG;
						else if (mempc[3]==2) game<=RSTB;
						else if (mempc[3]==3) game<=RSTW;
					end
					
					if (set==5)begin
						if(mempc[4]==0) game<=RSTR;
						else if (mempc[4]==1) game<=RSTG;
						else if (mempc[4]==2) game<=RSTB;
						else if (mempc[4]==3) game<=RSTW;
					end
					
					if (set==6)begin
						if(mempc[5]==0) game<=RSTR;
						else if (mempc[5]==1) game<=RSTG;
						else if (mempc[5]==2) game<=RSTB;
						else if (mempc[5]==3) game<=RSTW;
					end
					if(set==7) game<=MAN;
				end
			end
			PLAYR: begin
					bling<=4'b0001;
                    if(cntr==25000000)begin
						bling<=4'b0000;
						game<=FIND;      
                    end 
                end					
			PLAYG:begin
					bling<=4'b0010;
                    if(cntg==25000000)begin
						bling<=4'b0000;
						game<=FIND;      
                    end
				end
			PLAYB:begin
					bling<=4'b0100;
                    if(cntb==25000000)begin
						bling<=4'b0000;
						game<=FIND;      
                    end 
                end					
			PLAYW:begin
					bling<=4'b1000;
                    if(cntw==25000000)begin
						bling<=4'b0000;
						game<=FIND;      
                    end      
				end
                				   
			RSTR:game<=PLAYR;
			RSTG:game<=PLAYG;
			RSTB:game<=PLAYB;
			RSTW:game<=PLAYW;
			
			MAN:begin 
             //if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && !Q[5] && Q[6] && Q[7] && !Q[8] && Q[9] && !Q[10])begin
             //    game<=CORRECT;
             //end
             
                   if(round==RND1)begin
                        if(per==1)begin
                            if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && !Q[5] && Q[6] && Q[7] && !Q[8] && Q[9] && !Q[10])begin
                                if(mempc[0]==0) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && Q[5] && !Q[6] && Q[7] && !Q[8] && !Q[9] && !Q[10])begin
                                if(mempc[0]==1) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && Q[5] && !Q[6] && !Q[7] && Q[8] && !Q[9] && !Q[10])begin
                                if(mempc[0]==2) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && !Q[4] && Q[5] && Q[6] && Q[7] && !Q[8] && Q[9] && !Q[10])begin
                                if(mempc[0]==3) game<=CTRL;
                                else game<=FALSE;
                            end
                        end
                        if(per==2) game<=CORRECT;
                    end
                    
                    
                     if(round==RND2)begin
                        if(per==1)begin
                            if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && !Q[5] && Q[6] && Q[7] && !Q[8] && Q[9] && !Q[10])begin
                                if(mempc[0]==0) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && Q[5] && !Q[6] && Q[7] && !Q[8] && !Q[9] && !Q[10])begin
                                if(mempc[0]==1) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && Q[5] && !Q[6] && !Q[7] && Q[8] && !Q[9] && !Q[10])begin
                                if(mempc[0]==2) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && !Q[4] && Q[5] && Q[6] && Q[7] && !Q[8] && Q[9] && !Q[10])begin
                                if(mempc[0]==3) game<=CTRL;
                                else game<=FALSE;
                            end
                        end
                        if(per==2)begin
                         if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && !Q[5] && Q[6] && Q[7] && !Q[8] && Q[9] && !Q[10])begin
                                if(mempc[1]==0) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && Q[5] && !Q[6] && Q[7] && !Q[8] && !Q[9] && !Q[10])begin
                                if(mempc[1]==1) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && Q[5] && !Q[6] && !Q[7] && Q[8] && !Q[9] && !Q[10])begin
                                if(mempc[1]==2) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && !Q[4] && Q[5] && Q[6] && Q[7] && !Q[8] && Q[9] && !Q[10])begin
                                if(mempc[1]==3) game<=CTRL;
                                else game<=FALSE;
                            end
                        end
                        if(per==3) game<=CORRECT;
                    end
                    
                    if(round==RND3)begin
                        if(per==1)begin
                            if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && !Q[5] && Q[6] && Q[7] && !Q[8] && Q[9] && !Q[10])begin
                                if(mempc[0]==0) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && Q[5] && !Q[6] && Q[7] && !Q[8] && !Q[9] && !Q[10])begin
                                if(mempc[0]==1) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && Q[5] && !Q[6] && !Q[7] && Q[8] && !Q[9] && !Q[10])begin
                                if(mempc[0]==2) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && !Q[4] && Q[5] && Q[6] && Q[7] && !Q[8] && Q[9] && !Q[10])begin
                                if(mempc[0]==3) game<=CTRL;
                                else game<=FALSE;
                            end
                        end
                        if(per==2)begin
                         if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && !Q[5] && Q[6] && Q[7] && !Q[8] && Q[9] && !Q[10])begin
                                if(mempc[1]==0) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && Q[5] && !Q[6] && Q[7] && !Q[8] && !Q[9] && !Q[10])begin
                                if(mempc[1]==1) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && Q[5] && !Q[6] && !Q[7] && Q[8] && !Q[9] && !Q[10])begin
                                if(mempc[1]==2) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && !Q[4] && Q[5] && Q[6] && Q[7] && !Q[8] && Q[9] && !Q[10])begin
                                if(mempc[1]==3) game<=CTRL;
                                else game<=FALSE;
                            end
                        end
                    
                    
                        if(per==3)begin
                         if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && !Q[5] && Q[6] && Q[7] && !Q[8] && Q[9] && !Q[10])begin
                                if(mempc[2]==0) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && Q[5] && !Q[6] && Q[7] && !Q[8] && !Q[9] && !Q[10])begin
                                if(mempc[2]==1) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && Q[5] && !Q[6] && !Q[7] && Q[8] && !Q[9] && !Q[10])begin
                                if(mempc[2]==2) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && !Q[4] && Q[5] && Q[6] && Q[7] && !Q[8] && Q[9] && !Q[10])begin
                                if(mempc[2]==3) game<=CTRL;
                                else game<=FALSE;
                            end
                       
                        
                        end
                       if(per==4) game<=CORRECT;
                    end
                  
                  
                    if(round==RND4)begin
                        if(per==1)begin
                            if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && !Q[5] && Q[6] && Q[7] && !Q[8] && Q[9] && !Q[10])begin
                                if(mempc[0]==0) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && Q[5] && !Q[6] && Q[7] && !Q[8] && !Q[9] && !Q[10])begin
                                if(mempc[0]==1) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && Q[5] && !Q[6] && !Q[7] && Q[8] && !Q[9] && !Q[10])begin
                                if(mempc[0]==2) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && !Q[4] && Q[5] && Q[6] && Q[7] && !Q[8] && Q[9] && !Q[10])begin
                                if(mempc[0]==3) game<=CTRL;
                                else game<=FALSE;
                            end
                        end
                        if(per==2)begin
                         if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && !Q[5] && Q[6] && Q[7] && !Q[8] && Q[9] && !Q[10])begin
                                if(mempc[1]==0) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && Q[5] && !Q[6] && Q[7] && !Q[8] && !Q[9] && !Q[10])begin
                                if(mempc[1]==1) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && Q[5] && !Q[6] && !Q[7] && Q[8] && !Q[9] && !Q[10])begin
                                if(mempc[1]==2) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && !Q[4] && Q[5] && Q[6] && Q[7] && !Q[8] && Q[9] && !Q[10])begin
                                if(mempc[1]==3) game<=CTRL;
                                else game<=FALSE;
                            end
                        end
                    
                    
                    if(per==3)begin
                         if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && !Q[5] && Q[6] && Q[7] && !Q[8] && Q[9] && !Q[10])begin
                                if(mempc[2]==0) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && Q[5] && !Q[6] && Q[7] && !Q[8] && !Q[9] && !Q[10])begin
                                if(mempc[2]==1) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && Q[5] && !Q[6] && !Q[7] && Q[8] && !Q[9] && !Q[10])begin
                                if(mempc[2]==2) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && !Q[4] && Q[5] && Q[6] && Q[7] && !Q[8] && Q[9] && !Q[10])begin
                                if(mempc[2]==3) game<=CTRL;
                                else game<=FALSE;
                            end
                       
                        
                        end
                       if(per==4)begin
                         if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && !Q[5] && Q[6] && Q[7] && !Q[8] && Q[9] && !Q[10])begin
                                if(mempc[3]==0) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && Q[5] && !Q[6] && Q[7] && !Q[8] && !Q[9] && !Q[10])begin
                                if(mempc[3]==1) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && Q[5] && !Q[6] && !Q[7] && Q[8] && !Q[9] && !Q[10])begin
                                if(mempc[3]==2) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && !Q[4] && Q[5] && Q[6] && Q[7] && !Q[8] && Q[9] && !Q[10])begin
                                if(mempc[3]==3) game<=CTRL;
                                else game<=FALSE;
                            end
                        end
                        if(per==5) game<=CORRECT;
                    end
                    
                     if(round==RND5)begin
                        if(per==1)begin
                            if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && !Q[5] && Q[6] && Q[7] && !Q[8] && Q[9] && !Q[10])begin
                                if(mempc[0]==0) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && Q[5] && !Q[6] && Q[7] && !Q[8] && !Q[9] && !Q[10])begin
                                if(mempc[0]==1) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && Q[5] && !Q[6] && !Q[7] && Q[8] && !Q[9] && !Q[10])begin
                                if(mempc[0]==2) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && !Q[4] && Q[5] && Q[6] && Q[7] && !Q[8] && Q[9] && !Q[10])begin
                                if(mempc[0]==3) game<=CTRL;
                                else game<=FALSE;
                            end
                        end
                        if(per==2)begin
                         if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && !Q[5] && Q[6] && Q[7] && !Q[8] && Q[9] && !Q[10])begin
                                if(mempc[1]==0) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && Q[5] && !Q[6] && Q[7] && !Q[8] && !Q[9] && !Q[10])begin
                                if(mempc[1]==1) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && Q[5] && !Q[6] && !Q[7] && Q[8] && !Q[9] && !Q[10])begin
                                if(mempc[1]==2) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && !Q[4] && Q[5] && Q[6] && Q[7] && !Q[8] && Q[9] && !Q[10])begin
                                if(mempc[1]==3) game<=CTRL;
                                else game<=FALSE;
                            end
                        end
                    
                    
                    if(per==3)begin
                         if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && !Q[5] && Q[6] && Q[7] && !Q[8] && Q[9] && !Q[10])begin
                                if(mempc[2]==0) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && Q[5] && !Q[6] && Q[7] && !Q[8] && !Q[9] && !Q[10])begin
                                if(mempc[2]==1) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && Q[5] && !Q[6] && !Q[7] && Q[8] && !Q[9] && !Q[10])begin
                                if(mempc[2]==2) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && !Q[4] && Q[5] && Q[6] && Q[7] && !Q[8] && Q[9] && !Q[10])begin
                                if(mempc[2]==3) game<=CTRL;
                                else game<=FALSE;
                            end
                       
                        
                        end
                       if(per==4)begin
                         if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && !Q[5] && Q[6] && Q[7] && !Q[8] && Q[9] && !Q[10])begin
                                if(mempc[3]==0) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && Q[5] && !Q[6] && Q[7] && !Q[8] && !Q[9] && !Q[10])begin
                                if(mempc[3]==1) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && Q[5] && !Q[6] && !Q[7] && Q[8] && !Q[9] && !Q[10])begin
                                if(mempc[3]==2) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && !Q[4] && Q[5] && Q[6] && Q[7] && !Q[8] && Q[9] && !Q[10])begin
                                if(mempc[3]==3) game<=CTRL;
                                else game<=FALSE;
                            end
                        end
                        
                        if(per==5)begin
                         if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && !Q[5] && Q[6] && Q[7] && !Q[8] && Q[9] && !Q[10])begin
                                if(mempc[4]==0) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && Q[5] && !Q[6] && Q[7] && !Q[8] && !Q[9] && !Q[10])begin
                                if(mempc[4]==1) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && Q[5] && !Q[6] && !Q[7] && Q[8] && !Q[9] && !Q[10])begin
                                if(mempc[4]==2) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && !Q[4] && Q[5] && Q[6] && Q[7] && !Q[8] && Q[9] && !Q[10])begin
                                if(mempc[4]==3) game<=CTRL;
                                else game<=FALSE;
                            end
                        end
                        if(per==6) game<=CORRECT;
                    end
                    
                    
                    if(round==RND6)begin
                        if(per==1)begin
                            if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && !Q[5] && Q[6] && Q[7] && !Q[8] && Q[9] && !Q[10])begin
                                if(mempc[0]==0) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && Q[5] && !Q[6] && Q[7] && !Q[8] && !Q[9] && !Q[10])begin
                                if(mempc[0]==1) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && Q[5] && !Q[6] && !Q[7] && Q[8] && !Q[9] && !Q[10])begin
                                if(mempc[0]==2) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && !Q[4] && Q[5] && Q[6] && Q[7] && !Q[8] && Q[9] && !Q[10])begin
                                if(mempc[0]==3) game<=CTRL;
                                else game<=FALSE;
                            end
                        end
                        if(per==2)begin
                         if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && !Q[5] && Q[6] && Q[7] && !Q[8] && Q[9] && !Q[10])begin
                                if(mempc[1]==0) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && Q[5] && !Q[6] && Q[7] && !Q[8] && !Q[9] && !Q[10])begin
                                if(mempc[1]==1) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && Q[5] && !Q[6] && !Q[7] && Q[8] && !Q[9] && !Q[10])begin
                                if(mempc[1]==2) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && !Q[4] && Q[5] && Q[6] && Q[7] && !Q[8] && Q[9] && !Q[10])begin
                                if(mempc[1]==3) game<=CTRL;
                                else game<=FALSE;
                            end
                        end
                    
                    
                    if(per==3)begin
                         if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && !Q[5] && Q[6] && Q[7] && !Q[8] && Q[9] && !Q[10])begin
                                if(mempc[2]==0) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && Q[5] && !Q[6] && Q[7] && !Q[8] && !Q[9] && !Q[10])begin
                                if(mempc[2]==1) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && Q[5] && !Q[6] && !Q[7] && Q[8] && !Q[9] && !Q[10])begin
                                if(mempc[2]==2) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && !Q[4] && Q[5] && Q[6] && Q[7] && !Q[8] && Q[9] && !Q[10])begin
                                if(mempc[2]==3) game<=CTRL;
                                else game<=FALSE;
                            end
                       
                        
                        end
                       if(per==4)begin
                         if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && !Q[5] && Q[6] && Q[7] && !Q[8] && Q[9] && !Q[10])begin
                                if(mempc[3]==0) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && Q[5] && !Q[6] && Q[7] && !Q[8] && !Q[9] && !Q[10])begin
                                if(mempc[3]==1) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && Q[5] && !Q[6] && !Q[7] && Q[8] && !Q[9] && !Q[10])begin
                                if(mempc[3]==2) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && !Q[4] && Q[5] && Q[6] && Q[7] && !Q[8] && Q[9] && !Q[10])begin
                                if(mempc[3]==3) game<=CTRL;
                                else game<=FALSE;
                            end
                        end
                        
                        if(per==5)begin
                         if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && !Q[5] && Q[6] && Q[7] && !Q[8] && Q[9] && !Q[10])begin
                                if(mempc[4]==0) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && Q[5] && !Q[6] && Q[7] && !Q[8] && !Q[9] && !Q[10])begin
                                if(mempc[4]==1) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && Q[5] && !Q[6] && !Q[7] && Q[8] && !Q[9] && !Q[10])begin
                                if(mempc[4]==2) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && !Q[4] && Q[5] && Q[6] && Q[7] && !Q[8] && Q[9] && !Q[10])begin
                                if(mempc[4]==3) game<=CTRL;
                                else game<=FALSE;
                            end
                        end
                        
                        if(per==6)begin
                         if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && !Q[5] && Q[6] && Q[7] && !Q[8] && Q[9] && !Q[10])begin
                                if(mempc[5]==0) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && Q[5] && !Q[6] && Q[7] && !Q[8] && !Q[9] && !Q[10])begin
                                if(mempc[5]==1) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && Q[4] && Q[5] && !Q[6] && !Q[7] && Q[8] && !Q[9] && !Q[10])begin
                                if(mempc[5]==2) game<=CTRL;
                                else game<=FALSE;
                            end
                            else if(lock&&Q[0] && !Q[2] && !Q[3] && !Q[4] && Q[5] && Q[6] && Q[7] && !Q[8] && Q[9] && !Q[10])begin
                                if(mempc[5]==3) game<=CTRL;
                                else game<=FALSE;
                            end
                        end
                        if(per==7) game<=CORRECT;
                    end
                end
			
			CTRL: begin
                game<=CTRLN;
                
            end
            
            CTRLN: game<=MAN;
            
			CORRECT:game<=FIND;
			FALSE:game<=RSTR;
	
			endcase
	
	    end
	end
	
    
	logic [2:0] set;
 always_ff @(posedge clk, negedge rst) begin
        if(!rst) set<=1;
        else if(round==NXTRND1||round==NXTRND2||round==NXTRND3||round==NXTRND4||round==NXTRND5||round==NXTRND6)set<=1;
		else if(game==RSTR||game==RSTG||game==RSTB||game==RSTW)set<=set+1;
	end
    
	logic [2:0] per;
 always_ff @(posedge clk, negedge rst) begin
        if(!rst) per<=1;
        else if(round==NXTRND1||round==NXTRND2||round==NXTRND3||round==NXTRND4||round==NXTRND5||round==NXTRND6)per<=1;
		else if(game==CTRL)per<=per+1;
	end
    
    
endmodule	