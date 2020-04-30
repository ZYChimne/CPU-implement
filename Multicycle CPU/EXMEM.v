module EXMEM (clk, PCin, Aluout, RD2, Op, RD, PCSrc, MemR, MemW, RegW, Mem2R, PCWr,
PCout, aluout, rd2, rd, pcsrc, memr, memw, regw, mem2r, pcwr, op, flush);

   input clk;
   input [31:0] PCin;
   input [31:0] Aluout;
   input [31:0] RD2;
   input [4:0] RD;
   input [1:0] PCSrc;
   input MemR;
   input Mem2R;
   input MemW;
   input RegW;
   input PCWr;
   input [5:0] Op;
   input flush;
   
   output reg [31:0] PCout;
   output reg [31:0] aluout;
   output reg [31:0] rd2;
   output reg [4:0] rd;
   output reg [1:0] pcsrc;
   output reg memr;
   output reg mem2r;
   output reg memw;
   output reg regw;
   output reg pcwr;
   output reg [5:0] op;

   always @(posedge clk ) begin
         PCout<=PCin;
         aluout<=Aluout;
         rd2<=RD2;
         rd<=RD;
         pcsrc<=PCSrc;
         memr<=MemR;
         mem2r<=Mem2R;
         memw<=MemW;
         regw<=RegW;
         pcwr<=PCWr;
         op<=Op;
   end 

endmodule
