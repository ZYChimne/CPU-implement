module hazard(clk, Branch, IEMR, IIRs, IERt, IIRt, flush, stall);

    input clk;
    input Branch;
    input IEMR;
    input [4:0] IIRs;
    input [4:0] IERt;
    input [4:0] IIRt;

    output reg flush;
    output reg stall;

    initial 
    begin
        stall=0;
        flush=0;
    end
    
    always @(posedge clk)begin
        if(Branch==1)flush=1;
        else flush=0;
    end

    always @(IEMR or IIRs or IERt or IIRt)begin
        if(IEMR==1
        &&((IERt==IIRs)||
        (IERt==IIRt)))stall=1;
        else stall=0;
    end

endmodule