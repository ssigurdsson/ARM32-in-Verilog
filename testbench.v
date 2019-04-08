`timescale 10ns/1ns
module testbench;

 reg CLOCK_50;
 wire [2:0] ALUControlE1o;
 wire [31:0] REG0, REG12, REG2, REG3, REG14, REG15;
 wire [31:0] ALUResulto;
 wire [31:0] InstrDo;
 wire [31:0] SrcAo;
 wire [31:0] SrcBo;
 wire MemWriteMWo,ForwardBE1REGo;
 wire [31:0] ALUOutMWo, WriteDataMWo;
 wire BranchE1o, BranchE2o, MemtoRegMWo, MemWriteE1o, MemWriteE2o, CondExE2o,BranchTakenE2o;
 wire [3:0] WA3E1o, RA2o, FlagsE2o, Flagso, CondE1o, CondE2o;
 wire [4:0] NextPCo, PCFo;
 reg [31:0] ReadDataMW;
 reg [31:0] mem [0:64];
 integer i;
 
always @(posedge CLOCK_50)
begin
	if(MemWriteMWo)
		mem[ALUResulto[5:0]] <= WriteDataMWo;
	ReadDataMW <= mem[ALUResulto[5:0]];
end
 
LAB5 L1(CLOCK_50,ReadDataMW,InstrDo,REG0,REG12,REG2,REG3,REG14,REG15,ALUResulto,SrcAo,SrcBo,WriteDataMWo,MemWriteMWo,BranchE1o,BranchE2o,ForwardBE1REGo,MemtoRegMWo,MemWriteE1o,MemWriteE2o,CondExE2o,BranchTakenE2o,WA3E1o,RA2o,FlagsE2o,Flagso,CondE1o,CondE2o,NextPCo,PCFo,ALUControlE1o);
 initial
 begin
for (i=64; i>=0; i=i-1)
begin
	mem[i] = 32'd0;
end

CLOCK_50 = 0;
#5500 $monitor("%d and %d and %d",mem[0],mem[1],mem[2]); 
#10 $stop;
 end


 always
 #10 CLOCK_50=~CLOCK_50;

endmodule