module im_4k( addr, dout );
    
    input [6:0] addr;
    output [31:0] dout;
    reg [31:0] imem[2047:0];
    reg [31:0] tempDout;
    always@(addr)
    begin
        tempDout = imem[addr];
    end
    assign dout=tempDout;
endmodule    
