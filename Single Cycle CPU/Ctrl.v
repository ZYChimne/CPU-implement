`include "ctrl_encode_def.v"
`include "instruction_def.v"
module Ctrl(RegDst,PCSrc,MemR,Mem2R,MemW,RegW,Alusrc,EXTOp,Aluctrl,OpCode,Funct,PCWr);

    input [5:0] OpCode;
    input [5:0] Funct;
					
	output reg RegDst;						
	output reg [1:0] PCSrc;						
	output reg MemR;						
	output reg Mem2R;						
	output reg MemW;						
	output reg RegW;						
	output reg Alusrc;						
	output reg [1:0] EXTOp;					
	output reg [4:0] Aluctrl;               
    output reg PCWr;
    always @(OpCode or Funct)
        begin
            case(OpCode)
            `INSTR_RTYPE_OP:
            begin
                assign PCWr=1;
                assign Mem2R=0;
                assign MemW=0;
                assign MemR=0;
                assign Alusrc=0;
                assign RegDst=0;
                case(Funct)
                `INSTR_ADD_FUNCT:
                begin
                    assign PCSrc=`NPC_PLUS4;
                    assign RegW=1;
                    assign Aluctrl=`ALUOp_ADD;
                    assign EXTOp=`EXT_ZERO;
                end
                `INSTR_ADDU_FUNCT:
                begin
                    assign PCSrc=`NPC_PLUS4;
                    assign RegW=1;
                    assign Aluctrl=`ALUOp_ADDU;
                    assign EXTOp=`EXT_ZERO;
                end
                `INSTR_SUB_FUNCT:
                begin
                    assign PCSrc=`NPC_PLUS4;
                    assign RegW=1;
                    assign Aluctrl=`ALUOp_SUB;
                    assign EXTOp=`EXT_ZERO;
                end
                `INSTR_SUBU_FUNCT:
                begin
                    assign PCSrc=`NPC_PLUS4;
                    assign RegW=1;
                    assign Aluctrl=`ALUOp_SUBU;
                    assign EXTOp=`EXT_ZERO;
                end
                `INSTR_SLL_FUNCT:
                begin
                    assign PCSrc=`NPC_PLUS4;
                    assign RegW=1;
                    assign Aluctrl=`ALUOp_SLL;
                    assign EXTOp=`EXT_ZERO;
                end
                `INSTR_SRL_FUNCT:
                begin
                    assign PCSrc=`NPC_PLUS4;
                    assign RegW=1;
                    assign Aluctrl=`ALUOp_SRL;
                    assign EXTOp=`EXT_ZERO;
                end
                `INSTR_SRA_FUNCT:
                begin
                    assign PCSrc=`NPC_PLUS4;
                    assign RegW=1;
                    assign Aluctrl=`ALUOp_SRA;
                    assign EXTOp=`EXT_ZERO;
                end
                `INSTR_JR_FUNCT:
                begin
                    assign PCSrc=`NPC_JR;
                    assign RegW=0;
                    assign Aluctrl=`ALUOp_ADD;
                    assign EXTOp=`EXT_ZERO;
                end
                `INSTR_SLT_FUNCT:
                begin
                    assign PCSrc=`NPC_PLUS4;
                    assign RegW=1;
                    assign Aluctrl=`ALUOp_SLT;
                    assign EXTOp=`EXT_ZERO;
                end
                `INSTR_AND_FUNCT:
                begin
                    assign PCSrc=`NPC_PLUS4;
                    assign RegW=1;
                    assign Aluctrl=`ALUOp_AND;
                    assign EXTOp=`EXT_ZERO;
                end
                `INSTR_OR_FUNCT:
                begin
                    assign PCSrc=`NPC_PLUS4;
                    assign RegW=1;
                    assign Aluctrl=`ALUOp_OR;
                    assign EXTOp=`EXT_ZERO;
                end
                default:;
                endcase
            end
            `INSTR_ORI_OP:
            begin
                assign RegDst=1;
                assign PCSrc=`NPC_PLUS4;
                assign PCWr=1;
                assign MemR=0;
                assign Mem2R=0;
                assign MemW=0;
                assign RegW=1;
                assign Alusrc=1;
                assign Aluctrl=`ALUOp_OR;
                assign EXTOp=`EXT_ZERO;
            end
            `INSTR_LW_OP:
            begin
                assign RegDst=1;
                assign PCSrc=`NPC_PLUS4;
                assign MemR=1;
                assign PCWr=1;
                assign Mem2R=1;
                assign MemW=0;
                assign RegW=1;
                assign Alusrc=1;
                assign EXTOp=`EXT_SIGNED;
                assign Aluctrl=`ALUOp_ADDU;
            end
            `INSTR_SW_OP:
              begin
                assign RegDst=0;
                assign PCSrc=`NPC_PLUS4;
                assign MemR=0;
                assign PCWr=1;
                assign Mem2R=0;
                assign MemW=1;
                assign RegW=0;
                assign Alusrc=1;
                assign EXTOp=`EXT_SIGNED;
                assign Aluctrl=`ALUOp_ADDU;
            end
            `INSTR_BEQ_OP:
            begin
                assign RegDst=0;
                assign PCSrc=`NPC_BRANCH;
                assign MemR=0;
                assign PCWr=1;
                assign Mem2R=0;
                assign MemW=0;
                assign RegW=0;
                assign Alusrc=0;
                assign EXTOp=`EXT_SIGNED;
                assign Aluctrl=`ALUOp_EQL;
            end
            `INSTR_BNE_OP:
            begin
                assign RegDst=0;
                assign PCSrc=`NPC_BRANCH;
                assign MemR=0;
                assign PCWr=1;
                assign Mem2R=0;
                assign MemW=0;
                assign RegW=0;
                assign Alusrc=0;
                assign EXTOp=`EXT_SIGNED;
                assign Aluctrl=`ALUOp_BNE;
            end
            `INSTR_LUI_OP:
            begin
                assign RegDst=1;
                assign PCSrc=`NPC_PLUS4;
                assign MemR=0;
                assign PCWr=1;
                assign Mem2R=0;
                assign MemW=0;
                assign RegW=1;
                assign Alusrc=1;
                assign EXTOp=`EXT_SIGNED;
                assign Aluctrl=`ALUOp_GT0;
            end
            `INSTR_J_OP:
            begin
                assign RegDst=1;
                assign PCSrc=`NPC_JUMP;
                assign MemR=0;
                assign PCWr=1;
                assign Mem2R=0;
                assign MemW=0;
                assign RegW=0;
                assign Alusrc=0;
                assign EXTOp=`EXT_SIGNED;
                assign Aluctrl=`ALUOp_ADD;
            end
            `INSTR_JAL_OP:
            begin
                assign RegDst=0;
                assign PCSrc=`NPC_JUMP;
                assign MemR=0;
                assign PCWr=1;
                assign Mem2R=0;
                assign MemW=0;
                assign RegW=1;
                assign Alusrc=0;
                assign EXTOp=`EXT_SIGNED;
                assign Aluctrl=`ALUOp_ADD;
            end
            `INSTR_SLTI_OP:
            begin
                assign RegDst=1;
                assign PCSrc=`NPC_PLUS4;
                assign MemR=0;
                assign PCWr=1;
                assign Mem2R=0;
                assign MemW=0;
                assign RegW=1;
                assign Alusrc=1;
                assign EXTOp=`EXT_SIGNED;
                assign Aluctrl=`ALUOp_SLT;
            end
            `INSTR_ADDI_OP:
            begin
                assign RegDst=1;
                assign PCSrc=`NPC_PLUS4;
                assign MemR=0;
                assign PCWr=1;
                assign Mem2R=0;
                assign MemW=0;
                assign RegW=1;
                assign Alusrc=1;
                assign EXTOp=`EXT_SIGNED;
                assign Aluctrl=`ALUOp_ADD;
            end
            default:;
            endcase
        end
        
endmodule