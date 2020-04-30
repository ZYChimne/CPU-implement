module MEMWB (clk, WD, RD, RegW, Mem2R,
               wd, rd, regw, mem2r);

    input [31:0] WD;
    input [4:0] RD;
    input RegW;
    input Mem2R;
    input clk;

    output reg [31:0] wd;
    output reg [4:0] rd;
    output reg regw;
    output reg mem2r;

    always @(posedge clk) begin
      wd<=WD;
      rd<=RD;
      regw<=RegW;
      mem2r<=Mem2R;
   end 

endmodule
