`include "ctrl_encode_def.v"
module PC( clk, rst, PCWr, NPC, PC, PCSrc, Zero, IMM );
           
   input         clk;
   input         rst;
   input         PCWr;
   input  [31:0] NPC;
   input  [1:0]  PCSrc;
   input         Zero;
   input  [25:0] IMM;
   output reg [31:0] PC;
   always @(posedge clk or posedge rst) 
   begin
      if ( rst ) 
      begin
         PC<= 32'h0000_3000;   
         PC = PC + 4;
      end
      if ( PCWr ) 
         begin
         case(PCSrc)
         `NPC_BRANCH:
         begin
         if(Zero==1)PC = PC + (NPC<<2) + 4;
         else PC=PC+4;
         end
         `NPC_JUMP:
         PC = (PC[31:28]<<28)+(IMM<<2)+2'b00; 
         `NPC_PLUS4:
         PC = PC + 4;
         `NPC_JR:
         PC = NPC;
         endcase
         end
   end 
           
endmodule
