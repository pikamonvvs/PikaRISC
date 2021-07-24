`ifndef __DEFINES_V__
`define __DEFINES_V__

`define IMEM_SIZE	256 // maximum 131072
`define IMEM_BITS	22

`define DMEM_SIZE	256 // maximum 131072
`define DMEM_BITS	22

`define OP_ALU		6'b0xxxxx
`define OP_CMP		6'b100000
`define OP_JMP		6'b100010
`define OP_JCC		6'b100011
`define OP_LD		6'b100100
`define OP_STR		6'b100101
`define OP_CALL		6'b100110
`define OP_RET		6'b100111

`define ALUOP_ADD	5'b00000
`define ALUOP_SUB	5'b00001
`define ALUOP_MUL	5'b00010
`define ALUOP_DIV	5'b00011
`define ALUOP_AND	5'b00100
`define ALUOP_OR 	5'b00101
`define ALUOP_NOT	5'b00110
`define ALUOP_XOR	5'b00111
`define ALUOP_SHL	5'b01000
`define ALUOP_SHR	5'b01001
`define ALUOP_ASR	5'b01010
`define ALUOP_MOV	5'b01100
`define ALUOP_MOVL	5'b01110
`define ALUOP_MOVH	5'b01111

`define COND_JMP	4'b0000
`define COND_JEQ	4'b0001
`define COND_JGE	4'b0010
`define COND_JGT	4'b0011
`define COND_JLE	4'b0100
`define COND_JLT	4'b0101
`define COND_JNE	4'b0110

`endif /*__DEFINES_V__*/