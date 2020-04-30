`include "ctrl_encode_def.v"
`include "instruction_def.v"
module mips();

   reg clk, rst;
    
   initial begin
      $readmemh( "test_code.txt" , U_IM.imem ) ;
      $monitor("PC = 0x%8X, IR = 0x%8X", U_PC.PC, ins ); 
      clk = 1 ;
      rst = 0 ;
      #5 rst = 1 ;
      #20 rst = 0 ;
   end
   
   always
	   #(50) clk = ~clk;

//PC
   wire [31:0] PCin;
   wire [1:0]  PCSrc;
   wire [31:0] NPC;
   wire PCWr;

//Ctrl
	wire 		RegDst;						
   wire 		RFWr;
	wire 		MemR;						
	wire 		Mem2R;					
	wire 		DMWr;						
	wire		Alusrc;					
   wire [1:0]  EXTOp;
   wire [4:0]  ALUOp;
   wire [25:0] IMM;

//Alu
	wire [31:0] aluDataIn2;
	wire [31:0]	aluDataOut;
   wire 		   Zero;
   wire [31:0] A;
   wire [31:0] B;

//IM	
	wire [31:0] ins;

//RF
	wire [4:0] rs,rt,rd;
	wire [31:0] WD;
	wire [31:0] RD1,RD2;
	
//Extender
	wire [15:0] Imm16;
	wire [31:0] Imm32;
	
//DMem
	wire [4:0]  dmDataAdr;
	wire [31:0] dmDataOut;

//IFID
   wire [31:0] PC;
   wire [31:0] instr;

   assign rs = instr[25:21];
   assign rt = instr[20:16];
   assign Imm16 = instr[15:0];
   assign IMM = instr[25:0];

//IDEX
   wire [31:0] PCout;
   wire [31:0] instrout;
   wire [31:0] rd1;
   wire [31:0] rd2;
   wire regdst;
   wire [4:0] aluctrl;
   wire alusrc;
   wire [1:0] pcsrc;
   wire memr;
   wire memw;
   wire regw;
   wire mem2r;
   wire pcwr;
   wire [31:0] IMM32;

//forwarding_unit
   wire [1:0] ForwardA;
   wire [1:0] ForwardB;
   wire [31:0] dmrd2;

//hazard
   wire flush;
   wire Branch;
   wire stall;

//PCBranch
   wire [31:0] PCnext;

//EXMEM
   wire [31:0] aluout1;
   wire [31:0] PCnext1;
   wire [31:0] rd21;
   wire [4:0] rdd1;
   wire [1:0] pcsrc1;
   wire memr1;
   wire memw1;
   wire regw1;
   wire mem2r1;
   wire pcwr1;
   wire [5:0] op;

//MEMWB
   wire [31:0] wd2;
   wire [4:0] rdd2;
   wire regw2;
   wire mem2r2;

   PC U_PC (.clk(clk), .rst(rst), .PCWr(PCWr), .NPC(PCnext), .PC(PCin), .PCSrc(PCSrc), .IMM(IMM), .Branch(Branch), .stall(stall));

   im_4k U_IM (.addr(PCin[8:2]), .dout(ins));

   IFID U_IFID (.clk(clk), .PCin(PCin), .instrin(ins), .PCout(PC), .instrout(instr), .flush(flush), .stall(stall));

   RF U_RF (.A1(rs), .A2(rt), .A3(rdd2), .WD(WD), .clk(clk), 
            .RFWr(regw2), .RD1(RD1), .RD2(RD2));

   Ctrl U_Ctrl (.RegDst(RegDst), .PCSrc(PCSrc), .MemR(MemR), .Mem2R(Mem2R),
				   .MemW(DMWr), .RegW(RFWr), .Alusrc(Alusrc), .EXTOp(EXTOp), .Aluctrl(ALUOp),
				   .OpCode(instr[31:26]), .Funct(instr[5:0]), .PCWr(PCWr));

	EXT U_extend (.Imm16(Imm16), .EXTOp(EXTOp), .Imm32(Imm32));
   assign aluDataIn2 = (Alusrc==1)?Imm32:RD2;
   
   hazard U_hazard(.clk(clk), .Branch(Branch), .IEMR(memr), .IIRs(rs), .IERt(instrout[20:16]), .IIRt(rt), .flush(flush), .stall(stall));

	IDEX U_IDEX (.clk(clk), .PCin(PC), .instrin(instr), .RD1(RD1), .RD2(aluDataIn2), 
               .RegDst(RegDst), .Aluctrl(ALUOp), .Alusrc(Alusrc), .PCSrc(PCSrc), 
               .MemR(MemR), .MemW(DMWr), .RegW(RFWr), .Mem2R(Mem2R), .PCWr(PCWr), 
               .imm32(Imm32), .PCout(PCout), .instrout(instrout), .rd1(rd1), .rd2(rd2), 
               .regdst(regdst), .aluctrl(aluctrl), .alusrc(alusrc), .pcsrc(pcsrc), 
               .memr(memr), .memw(memw), .regw(regw), .mem2r(mem2r), .pcwr(pcwr), 
               .IMM32(IMM32), .flush(flush), .stall(stall));

   assign rd=(instrout[31:26]==`INSTR_JAL_OP)?31:(regdst==1)?instrout[20:16]:instrout[15:11];

   assign A=(ForwardA==2)?aluout1:(ForwardA==1)?WD:rd1;
   assign B=(instrout[31:26]==`INSTR_SW_OP||instrout[31:26]==`INSTR_LW_OP)?rd2:(ForwardB==2)?aluout1:(ForwardB==1)?WD:rd2;

   ALU U_ALU (.A(A), .B(B), .ALUOp(aluctrl), .C(aluDataOut), .Zero(Zero), .sa(instrout[10:6]));

   forwarding_unit U_Forward(.clk(clk), .EMRd(rd), .EMRegw(regw), .IERs(rs), .IERt(rt),
                              .MWRegw(regw1), .MWRd(rdd1), 
                              .ForwardA(ForwardA), .ForwardB(ForwardB));
   assign NPC=(instrout[5:0]==`INSTR_JR_FUNCT)?rd1:IMM32;
   PCBranch U_PCBranch(.PC(PCnext), .NPC(NPC), .PCSrc(pcsrc), .Zero(Zero), .Branch(Branch), .IPC(PCout));
   assign dmrd2=(ForwardB==2)?aluout1:(ForwardB==1)?dmDataOut:rd2;
   EXMEM U_EXMEM (.clk(clk), .PCin(PCout), .Aluout(aluDataOut), .RD2(dmrd2), .Op(instrout[31:26]),
                  .RD(rd), .PCSrc(pcsrc), .MemR(memr), .MemW(memw), .RegW(regw), 
                  .Mem2R(mem2r), .PCWr(pcwr), .PCout(PCnext1), 
                  .aluout(aluout1), .rd2(rd21), .rd(rdd1), .pcsrc(pcsrc1), .memr(memr1), 
                  .memw(memw1), .regw(regw1), .mem2r(mem2r1), .pcwr(pcwr1), .op(op), .flush(flush));
   
   assign dmDataAdr = aluout1[4:0];
	dm_4k U_Dmem (.addr(dmDataAdr), .din(rd21), .DMWr(memw1), .clk(clk), .dout(dmDataOut));

   assign wd2=(op==`INSTR_JAL_OP)?PCnext1+4:(mem2r1==1)?dmDataOut:aluout1;
   MEMWB U_MEMWB (.clk(clk), .WD(wd2), .RD(rdd1), .RegW(regw1), .Mem2R(mem2r1),
                  .wd(WD), .rd(rdd2), .regw(regw2), .mem2r(mem2r2));

endmodule
