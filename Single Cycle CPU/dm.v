module dm_4k( addr, din, DMWr, clk, dout );
   
   input  [4:0] addr;
   input  [31:0] din;
   input         DMWr;
   input         clk;
   output [31:0] dout;
     
   reg [31:0] dmem[1023:0];
   
   always @(posedge clk) 
   begin
      if (DMWr)
         dmem[addr] <= din;
         $display("addr=%8X",addr);
         $display("din=%8X",din);
         $display("Mem[00-07]=%8X, %8X, %8X, %8X, %8X, %8X, %8X, %8X",dmem[0],dmem[1],dmem[2],dmem[3],dmem[4],dmem[5],dmem[6],dmem[7]);
         $display("Mem[08-15]=%8X, %8X, %8X, %8X, %8X, %8X, %8X, %8X",dmem[8],dmem[9],dmem[10],dmem[11],dmem[12],dmem[13],dmem[14],dmem[15]);
         $display("Mem[16-23]=%8X, %8X, %8X, %8X, %8X, %8X, %8X, %8X",dmem[16],dmem[17],dmem[18],dmem[19],dmem[20],dmem[21],dmem[22],dmem[23]);
         $display("Mem[24-31]=%8X, %8X, %8X, %8X, %8X, %8X, %8X, %8X",dmem[24],dmem[25],dmem[26],dmem[27],dmem[28],dmem[29],dmem[30],dmem[31]);
   end 
     assign dout = dmem[addr];

endmodule    
