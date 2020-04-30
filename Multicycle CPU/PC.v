`include "ctrl_encode_def.v"
module PC( clk, rst, PCWr, NPC, PC, PCSrc, IMM, Branch, stall );
           
   input         clk;
   input         rst;
   input         PCWr;
   input [31:0] NPC;
   input [1:0]  PCSrc;
   input [25:0] IMM;
   input Branch;
   input stall; 

   output reg [31:0] PC;
   integer PCW;
   initial
   begin
   PCW=1;
   end
   always @(stall)
   begin
      PCW=(stall)?0:1;
   end
   always @(posedge clk or posedge rst)
    begin
      if ( rst ) 
      begin
         PC<= 32'h0000_3000;   
      end
      else if ( PCW ) 
      begin 
         if(Branch==1)PC = NPC;
         else PC = PC + 4;
      end
   end 

   always @(PCSrc or NPC)
    begin
      if ( PCW ) 
      begin
         case(PCSrc)
         `NPC_JUMP:
         PC = (PC[31:28]<<28) + (IMM<<2) + 2'b00;
         `NPC_JR:
         PC = NPC;
         default:
         PC = PC;
         endcase
      end
   end 
           
endmodule
