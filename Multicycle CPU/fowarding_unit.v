module forwarding_unit(clk, EMRd, EMRegw, IERs, IERt, MWRegw, MWRd, 
                        ForwardA, ForwardB);
    input clk;
    input [4:0] EMRd;
    input EMRegw;
    input [4:0] IERs;
    input [4:0] IERt;
    input MWRegw;
    input [4:0] MWRd;

    output reg [1:0] ForwardA;
    output reg [1:0] ForwardB;
    initial
    begin
        ForwardA=0;
        ForwardB=0;
    end
    always @(posedge clk)begin
        begin
            ForwardA=0;
            ForwardB=0;
            if(EMRegw
            &&(EMRd!=0)
            &&(EMRd==IERs))ForwardA=2;
            else if(EMRegw
            &&(EMRd!=0)
            &&(EMRd==IERt))ForwardB=2;
            else if(MWRegw
            &&(MWRd!=0)
            &&(EMRd!=IERs)
            &&(MWRd==IERs))ForwardA=1;
            else if(MWRegw
            &&(MWRd!=0)
            &&(EMRd!=IERt)
            &&(MWRd==IERt))ForwardB=1;
        end
    end
endmodule