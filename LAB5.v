`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Stefan Sigurdsson
// 
// Create Date:    17:09:50 5/2/2017 
// Module Name:    Lab6
// Description: 5 Stage Pipelined CPU
//
// Dependencies: 
//
// Additional Comments: Functional up to 200 MHz clock frequency
//
//////////////////////////////////////////////////////////////////////////////////

module LAB5(input wire CLOCK_50, input wire [17:0] SW);

//Registers
reg [31:0] Instructions [0:32];
reg [31:0] Registers [0:15];
reg [31:0] BranchStored; //Is there a stored branch for this instruction?
reg [4:0] BranchDestination [0:31]; //Destinations of branches
reg [4:0] PCF;
reg [31:0] InstrD;

//Initialize Registers and Instructions as generated from the assembly program (palyndrome checker in this case)
initial begin
Registers[0] = 32'd0;
Registers[1] = 32'd0;
Registers[2] = 32'd0;
Registers[3] = 32'd0;
Registers[4] = 32'd0;
Registers[5] = 32'd0;
Registers[6] = 32'd0;
Registers[7] = 32'd0;
Registers[8] = 32'd0;
Registers[9] = 32'd0;
Registers[10] = 32'd0;
Registers[11] = 32'd0;
Registers[12] = 32'd0;
Registers[13] = 32'd31;
Registers[14] = 32'd0;
Registers[15] = 32'd0;
Instructions[0] = 32'hE3A00000;
Instructions[1] = 32'hE50D0007;
Instructions[2] = 32'hE3A00071;
Instructions[3] = 32'hE50D0006;
Instructions[4] = 32'hE3A00061;
Instructions[5] = 32'hE50D0005;
Instructions[6] = 32'hE3A00063;
Instructions[7] = 32'hE50D0004;
Instructions[8] = 32'hE3A00065;
Instructions[9] = 32'hE50D0003;
Instructions[10] = 32'hE3A00063;
Instructions[11] = 32'hE50D0002;
Instructions[12] = 32'hE3A00061;
Instructions[13] = 32'hE50D0001;
Instructions[14] = 32'hE3A00072;
Instructions[15] = 32'hE58D0000;
Instructions[16] = 32'hE28D2001;
Instructions[17] = 32'hE2422001;
Instructions[18] = 32'hE5923000;
Instructions[19] = 32'hE3530000;
Instructions[20] = 32'h1AFFFFFB;
Instructions[21] = 32'hE2822001;
Instructions[22] = 32'hE5923000;
Instructions[23] = 32'hE15D0002;
Instructions[24] = 32'hE59D4000;
Instructions[25] = 32'hE24DD001;
Instructions[26] = 32'h51935004;
Instructions[27] = 32'h0AFFFFF8;
Instructions[28] = 32'hE3A0B000;
Instructions[29] = 32'h43A0B001;
Instructions[30] = 32'hE58BB000;
Instructions[31] = 32'hE58BC001;
Instructions[32] = 32'hFFFFFFFF;
BranchStored = 32'd0;
PCF = 5'd0;
InstrD = 32'hF8000000;
RegWriteE1 = 1'd0;
MemtoRegE1 = 1'd0;
MemWriteE1 = 1'd0;
ALUControlE1 = 3'd0;
BranchE1 = 1'd0;
LinkE1 = 1'd0;
ALUSrcE1 = 1'd0;
FlagWriteE1 = 2'd0;
CondE1 = 4'd0;
RD1E1 = 32'd0;
RD2E1 = 32'd0;
WA3E1 = 4'd0;
ExtImmE1 = 2'd0;
RegWriteE2 = 1'd0;
MemtoRegE2 = 1'd0;
MemWriteE2 = 1'd0;
BranchE2 = 1'd0;
LinkE2 = 1'd0;
FlagWriteE2 = 2'd0;
CondE2 = 4'd0;
FlagsE2 = 4'd0;
WriteDataE2 = 32'd0;
WA3E2 = 4'd0;
RegWriteMW = 1'd0;
MemtoRegMW = 1'd0;
ALUOutMW = 32'd0;
WA3MW = 4'd0;
end


//Halt wire
wire clocki;
assign clocki = CLOCK_50;


//Stage D wires
wire RegWriteD, MemtoRegD, MemWriteD, BranchD, LinkD, ALUSrcD, RegSrcD, MovD; //MovD is move command
wire [2:0] ALUControlD;
wire [1:0] FlagWriteD, ImmSrcD; //ImmSrcD 00 is 8bit, 01 is 12bit, 10 is 24bit, 11 is 0's
//Execution1 registers
reg RegWriteE1, MemtoRegE1, MemWriteE1, BranchE1, LinkE1, ALUSrcE1;
reg [2:0] ALUControlE1;
reg [1:0] FlagWriteE1;
reg [3:0] CondE1, WA3E1;
reg [31:0] RD1E1, RD2E1, ExtImmE1;
reg [4:0] PCE1;
//Execution2 registers
reg RegWriteE2, MemtoRegE2, MemWriteE2, BranchE2, LinkE2;
reg [1:0] FlagWriteE2;
reg [3:0] CondE2, FlagsE2, WA3E2;
reg [31:0] WriteDataE2;
reg [4:0] PCE2;
//MemWrite + RegWrite registers
reg RegWriteMW, MemtoRegMW;
reg [31:0] ALUOutMW;
reg [3:0] WA3MW;


//Hazard Unit
wire StallF, StallD, FlushD, FlushE1, FlushE2, ForwardAE1, ForwardBE1, ForwardAE2, ForwardBE2, MatchE2A, MatchE2B, MatchE1A, MatchE1B, MatchMWA, MatchMWB;
reg ForwardAE1REG, ForwardBE1REG;
assign MatchE1A = ~BranchD & RegWriteE1 & ~MovD & (RA1 == WA3E1); //Forward A on match with E1
assign MatchE1B = (~ALUSrcD | MemWriteD) & RegWriteE1 & (RA2 == WA3E1); //Forward B on match with E1
assign MatchE2A = ~BranchD & RegWriteE2 & ~MovD & (RA1 == WA3E2); //Forward A on match with E2 and no match E1
assign MatchE2B = (~ALUSrcD | MemWriteD) & RegWriteE2 & (RA2 == WA3E2); //Forward B on match with E2 and no match E1
assign MatchMWA = (InstrD == 32'hFFFFFFFF) | RegWriteMW & (~BranchD & ~MovD & (RA1 == WA3MW)); //Stall D and F on match with MW
assign MatchMWB = (InstrD == 32'hFFFFFFFF) | RegWriteMW & ((~ALUSrcD | MemWriteD) & (RA2 == WA3MW)); //Stall D and F on match with MW


//Internal wires
wire [4:0] PCPlus1, NextPC, NextPCLoc, PCE2Plus1, PCDPlus2;
wire [3:0] RA1, RA2, ALUFlags, Flags, LocR;
wire [31:0] RD1D, RD1Db, RD2D, ExtImmD, SrcA, SrcB, ALUResult, WriteDataE1, ResultMW, NextLR, ReadDataMW, ReadDataMWram;
wire CondExE2, BranchTakenE2, BranchCorrect;
wire [7:0] Reg12Plus1;


//Internal logic
assign RD1Db = BranchD ? {27'd0,PCDPlus2} : Registers[RA1];
assign RD1D = (~ForwardAE1 & ForwardAE2) ? ALUResult : RD1Db;
assign RD2D = (~ForwardBE1 & ForwardBE2) ? ALUResult : Registers[RA2];
assign SrcA = ForwardAE1REG ? ALUResult : RD1E1;
assign SrcB = ALUSrcE1 ? ExtImmE1 : WriteDataE1;
assign WriteDataE1 = ForwardBE1REG ? ALUResult : RD2E1;
assign ResultMW = MemtoRegMW ? ReadDataMW : ALUOutMW;
assign PCPlus1 = PCF + 5'd1;
assign PCE2Plus1 = PCE2 + 5'd1;
assign PCDPlus2 = Registers[15][4:0] + 5'd2;
assign RA1 = InstrD[19:16];
assign RA2 = RegSrcD ? InstrD[15:12] : InstrD[3:0];

assign BranchTakenE2 = BranchE2 & CondExE2;
assign BranchCorrect = (PCE1 == ALUResult[4:0]);
assign NextPCLoc = (BranchTakenE2 & ~BranchCorrect) ? ALUResult[4:0] : PCPlus1;
assign NextPC = BranchStored[PCF] ? BranchDestination[PCF] : NextPCLoc;
assign NextLR = BranchTakenE2 ? {27'd0,PCE2Plus1} : ResultMW;
assign LocR = ((WA3MW == 4'd15) | (WA3MW == 4'd14) | (WA3MW == 4'd12)) ? 4'd0 : WA3MW;
assign Reg12Plus1 = Registers[12][7:0] + 8'd1;


//Module calls
//Decoder
decoder d1(InstrD[27:26],InstrD[25:20],InstrD[15:12],InstrD[7],InstrD[4],
FlagWriteD,RegWriteD,MemWriteD,MemtoRegD,ALUSrcD,RegSrcD,BranchD,LinkD,MovD,ImmSrcD,ALUControlD);

//Conditional
conditional c1(FlagWriteE2,CondE2,FlagsE2,ALUFlags,Flags,CondExE2);

//Extend
immmux m1({24'b0, InstrD[7:0]},{20'b0, InstrD[11:0]},
{InstrD[23],InstrD[23],InstrD[23],InstrD[23],InstrD[23],InstrD[23],InstrD[23],InstrD[23],InstrD[23:0]},32'b0,ImmSrcD,ExtImmD);

//ALU logic 
ALU a1(clocki, SrcA, SrcB, ALUControlE1, ALUFlags, ALUResult);

//Hazard
hazard haz1(MemtoRegE1, MemtoRegE2, MatchE2A, MatchE2B, MatchE1A, MatchE1B, MatchMWA, MatchMWB, 
BranchTakenE2, BranchCorrect, CondExE2, CondE1, ForwardAE1, ForwardBE1, ForwardAE2, ForwardBE2, FlushE2, FlushE1, FlushD, StallD, StallF);

//RAM
rammem ram1(ALUResult[4:0],clocki,WriteDataE2,MemWriteE2 & CondExE2,ReadDataMWram);


//Wrapper for the RAM to include Input from switches
assign ReadDataMW = (ALUResult[4:0] == 5'd30) ? {{24{SW[7]}},SW[7:0]} : ReadDataMWram;
assign ReadDataMW = (ALUResult[4:0] == 5'd29) ? {{24{SW[15]}},SW[15:8]} : ReadDataMWram;
assign ReadDataMW = (ALUResult[4:0] == 5'd28) ? {30'd0,SW[17:16]} : ReadDataMWram;




//Latching
always @(posedge clocki)
begin

//Forwarding
ForwardAE1REG <= ForwardAE1;
ForwardBE1REG <= ForwardBE1;

//Branches
if (BranchTakenE2 & (CondE2 == 4'b1110))
begin
BranchStored[PCE2] <= 1'b1;
BranchDestination[PCE2] <= ALUResult[4:0];
end

//PC Latch
if (~StallF)
PCF <= NextPC;

//Instruction Latch
if (FlushD)
InstrD <= 32'hF8000000;
else if (~StallD)
InstrD <= Instructions[PCF];

//E1 Latch
if (FlushE1)
begin
RegWriteE1 <= 1'd0;
MemtoRegE1 <= 1'd0;
MemWriteE1 <= 1'd0;
ALUControlE1 <= 3'd0;
BranchE1 <= 1'd0;
LinkE1 <= 1'd0;
ALUSrcE1 <= 1'd0;
FlagWriteE1 <= 2'd0;
CondE1 <= 4'd0;
RD1E1 <= 32'd0;
RD2E1 <= 32'd0;
WA3E1 <= 4'd0;
ExtImmE1 <= 32'd0;
PCE1 <= 5'd0;
end
else
begin
RegWriteE1 <= RegWriteD;
MemtoRegE1 <= MemtoRegD;
MemWriteE1 <= MemWriteD;
ALUControlE1 <= ALUControlD;
BranchE1 <= BranchD;
LinkE1 <= LinkD;
ALUSrcE1 <= ALUSrcD;
FlagWriteE1 <= FlagWriteD;
CondE1 <= InstrD[31:28];
RD1E1 <= RD1D;
RD2E1 <= RD2D;
WA3E1 <= InstrD[15:12];
ExtImmE1 <= ExtImmD;
PCE1 <= Registers[15][4:0];
end

//E2 Latch
if (FlushE2)
begin
RegWriteE2 <= 1'd0;
MemtoRegE2 <= 1'd0;
MemWriteE2 <= 1'd0;
BranchE2 <= 1'd0;
LinkE2 <= 1'd0;
FlagWriteE2 <= 2'd0;
CondE2 <= 4'd0;
FlagsE2 <= 4'd0;
WriteDataE2 <= 32'd0;
WA3E2 <= 4'd0;
PCE2 <= 5'd0;
end
else
begin
RegWriteE2 <= RegWriteE1;
MemtoRegE2 <= MemtoRegE1;
MemWriteE2 <= MemWriteE1;
BranchE2 <= BranchE1;
LinkE2 <= LinkE1;
FlagWriteE2 <= FlagWriteE1;
CondE2 <= CondE1;
FlagsE2 <= Flags;
WriteDataE2 <= WriteDataE1;
WA3E2 <= WA3E1;
PCE2 <= PCE1;
end

//MW Latch
RegWriteMW <= RegWriteE2 & CondExE2;
MemtoRegMW <= MemtoRegE2;
ALUOutMW <= ALUResult;
WA3MW <= WA3E2;

//Writing into Registers
Registers[12] <= {24'd0,Reg12Plus1};

if (~StallF)
Registers[15] <= {27'd0,PCF};

if ((RegWriteMW & (WA3MW == 4'd14)) | (BranchTakenE2 & LinkE2))
Registers[14] <= NextLR;

if (RegWriteMW & ~((WA3MW == 4'd15) | (WA3MW == 4'd14)))
Registers[LocR] <= ResultMW;
end
endmodule 
