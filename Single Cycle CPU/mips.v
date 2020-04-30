`include "ctrl_encode_def.v"
`include "instruction_def.v"
module mips();

   reg clk, rst;
    
   initial begin
      $readmemh( "test_code.txt" , U_IM.imem ) ;
      $monitor("PC = 0x%8X, IR = 0x%8X", U_PC.PC, instr ); 
      clk = 1 ;
      rst = 0 ;
      #5 rst = 1 ;
      #20 rst = 0 ;
   end
   
   always
	   #(50) clk = ~clk;

   wire PCWr=1;

//PC
   wire [31:0]   PC;
   wire [1:0]    PCSrc;
   wire [31:0]   NPC;

//Ctrl
	wire [5:0]		Op;
	wire [5:0]		Funct;
	wire 		RegDst;						
   wire 		RFWr;
	wire 		MemR;						
	wire 		Mem2R;					
	wire 		DMWr;						
	wire		Alusrc;					
   wire [1:0]  EXTOp;
   wire [4:0]  ALUOp;
   wire [25:0] IMM;
   wire [4:0]  sa;

//Alu
	wire [31:0] aluDataIn2;
	wire [31:0]	aluDataOut;
   wire 		   Zero;

//IM	
	wire [31:0] instr;

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

   assign Op = instr[31:26];
   assign Funct = instr[5:0];
   assign rs = instr[25:21];
   assign rt = instr[20:16];
   assign sa = instr[10:6];
   assign Imm16 = instr[15:0];
   assign IMM = instr[25:0];

   assign rd=(Op==`INSTR_JAL_OP)?31:(RegDst==1)?instr[20:16]:instr[15:11];
   assign NPC=(Funct==`INSTR_JR_FUNCT)?RD1:Imm32;

   PC U_PC (
      .clk(clk), .rst(rst), .PCWr(PCWr), .NPC(NPC), .PC(PC), .PCSrc(PCSrc), .Zero(Zero), .IMM(IMM)
   ); 
   
   im_4k U_IM ( 
      .addr(PC[8:2]), .dout(instr)
   );

   RF U_RF (
      .A1(rs), .A2(rt), .A3(rd), .WD(WD), .clk(clk), 
      .RFWr(RFWr), .RD1(RD1), .RD2(RD2)
   );

   Ctrl U_Ctrl (.RegDst(RegDst),.PCSrc(PCSrc),.MemR(MemR),.Mem2R(Mem2R)
				,.MemW(DMWr),.RegW(RFWr),.Alusrc(Alusrc),.EXTOp(EXTOp),.Aluctrl(ALUOp)
				,.OpCode(Op),.Funct(Funct), .PCWr(PCWr)
   );

	EXT U_extend(.Imm16(Imm16),.EXTOp(EXTOp),.Imm32(Imm32));
	assign aluDataIn2 = (Alusrc==1)?Imm32:RD2;
	
   ALU U_ALU (.A(RD1), .B(aluDataIn2), .ALUOp(ALUOp), .C(aluDataOut), .Zero(Zero), .sa(sa));
   assign WD=(Op==`INSTR_JAL_OP)?PC+4:(Mem2R==1)?dmDataOut:aluDataOut;

   assign dmDataAdr = aluDataOut[4:0];
	dm_4k U_Dmem(.addr(dmDataAdr),.din(RD2),.DMWr(DMWr),.clk(clk),.dout(dmDataOut));

endmodule