`include "ctrl_encode_def.v"
module ALU (A, B, ALUOp, C, Zero, sa);
           
   input  [31:0] A, B;
   input  [4:0]  ALUOp;
   input  [4:0] sa;
   output reg [31:0] C;
   output reg Zero;
   
   initial
   begin
	Zero = 0;
	C = 0;
	end
   integer i=0;
   always @( A or B or ALUOp ) begin
      case ( ALUOp )
         `ALUOp_ADDU: 
         begin
         C = A + B;
         Zero=(C==0)?1:0;
         end
	      `ALUOp_ADD:  
         begin
         C = A + B;
         Zero=(C==0)?1:0;
         end
	      `ALUOp_SUB:  
         begin 
         C = A - B;
         Zero=(C==0)?1:0;
         end
         `ALUOp_SUBU: 
         begin
         C = A - B;
         Zero=(C==0)?1:0;
         end
	      `ALUOp_OR: 
         begin  
         C = A | B;
         Zero=(C==0)?1:0;
         end
	      `ALUOp_EQL:  
         begin
         C = A - B;
         Zero=(C==0)?1:0;
         end
         `ALUOp_SLL:  
         begin
         C = B << sa;
         Zero=(C==0)?1:0;
         end
         `ALUOp_SRL:  
         begin
         C = B >> sa;
         Zero=(C==0)?1:0;
         end
         `ALUOp_SRA:  
         begin
         C = B >> sa;
         for (i = 0 ; i<sa; i=i+1) 
         begin
            C[31-i]=C[31-sa];
         end
         Zero=(C==0)?1:0;
         end
         `ALUOp_BNE:  
         begin
         C = A - B;
         Zero=(C==0)?0:1;
         end
         `ALUOp_SLT:  
         begin
         if(A[31]==0&&B[31]==0)C = (A<B)?1:0;
         else if(A[31]==0&&B[31]==1)C = 0;
         else if(A[31]==1&&B[31]==0)C = 1;
         else C = (A<B)?1:0;
         Zero=(C==0)?1:0;
         end
         `ALUOp_AND:  
         begin
         C = A & B;
         Zero=(C==0)?1:0;
         end
         `ALUOp_GT0:
         begin
         C = B[15:0]<<16;
         Zero=(C==0)?1:0;
         end
         default:   ;
      endcase
   end
   
endmodule
    
