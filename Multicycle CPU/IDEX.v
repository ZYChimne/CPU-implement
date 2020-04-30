module IDEX (clk, PCin, instrin, RD1, RD2, 
RegDst, Aluctrl, Alusrc, PCSrc, MemR, MemW, RegW, Mem2R, PCWr, imm32, PCout, instrout,
rd1, rd2, regdst, aluctrl, alusrc, pcsrc, memr, memw, regw, mem2r, pcwr, IMM32, flush, stall);

   input clk;
   input [31:0] PCin;
   input [31:0] instrin;
   input [31:0] RD1;
   input [31:0] RD2;
   input RegDst;
   input [1:0] PCSrc;
   input MemR;
   input Mem2R;
   input MemW;
   input RegW;
   input Alusrc;
   input [4:0] Aluctrl;
   input PCWr;
   input [31:0] imm32;
   input flush;
   input stall;

   output reg [31:0] PCout;
   output reg [31:0] instrout;
   output reg [31:0] rd1;
   output reg [31:0] rd2;
   output reg regdst;
   output reg [1:0] pcsrc;
   output reg memr;
   output reg mem2r;
   output reg memw;
   output reg regw;
   output reg alusrc;
   output reg [4:0] aluctrl;
   output reg pcwr;
   output reg [31:0] IMM32;

   always @(posedge clk or flush) begin
      if(flush||stall)begin
         PCout<=0;
         instrout<=0;
         rd1<=0;
         rd2<=0;
         regdst<=0;
         pcsrc<=0;
         memr<=0;
         mem2r<=0;
         memw<=0;
         regw<=0;
         alusrc<=0;
         aluctrl<=0;
         pcwr<=0;
         IMM32<=0;
      end
      else begin
         PCout<=PCin;
         instrout<=instrin;
         rd1<=RD1;
         rd2<=RD2;
         regdst<=RegDst;
         pcsrc<=PCSrc;
         memr<=MemR;
         mem2r<=Mem2R;
         memw<=MemW;
         regw<=RegW;
         alusrc<=Alusrc;
         aluctrl<=Aluctrl;
         pcwr<=PCWr;
         IMM32<=imm32;
      end
   end 

endmodule
