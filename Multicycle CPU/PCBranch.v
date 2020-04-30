`include "ctrl_encode_def.v"
module PCBranch (PC, NPC, PCSrc, Zero, Branch, IPC);

    input [31:0] NPC;
    input [1:0]  PCSrc;
    input [31:0] IPC;
    input Zero;

    output reg [31:0] PC;
    output reg Branch;

    initial
    begin
        Branch=0;
    end

    always @(NPC or PCSrc or Zero)begin
        case(PCSrc)
        `NPC_BRANCH:
        begin
            if(Zero==1)begin
                PC = IPC + (NPC<<2) + 4;
                Branch=1;
            end
        end
        `NPC_JR:
        begin
            PC=NPC;
            Branch=1;
        end
        default:Branch=0;
        endcase
    end
           
endmodule