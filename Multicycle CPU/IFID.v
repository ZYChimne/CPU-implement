module IFID (clk, PCin, instrin, PCout, instrout, flush, stall);

   input clk;
   input [31:0] PCin;
   input [31:0] instrin;
   input flush;
   input stall;

   output reg [31:0] PCout;
   output reg [31:0] instrout;

   always @(posedge clk or flush) begin
      if(flush)
      begin
         PCout<=0;
         instrout<=0;
      end
      else if(stall!=1)
      begin
         PCout<=PCin;
         instrout<=instrin;
      end
   end 

endmodule