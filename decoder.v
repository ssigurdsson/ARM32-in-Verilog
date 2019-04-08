module decoder(input wire [1:0] Op, input wire [5:0] Funct, 
input wire [3:0] Rd, input wire mula, mulb, 
output wire [1:0] FlagWriteD, 
output wire RegWriteD, MemWriteD, MemtoRegD, ALUSrcD, RegSrcD, BranchD, LinkD, MovD, 
output wire [1:0] ImmSrcD, output wire [2:0] ALUControlD);

assign FlagWriteD[1] = ~Op[1] & ~Op[0] & Funct[0];
assign FlagWriteD[0] = ~Op[1] & ~Op[0] & Funct[0] & ~((Funct[4:1] == 4'b0000) | (Funct[4:1] == 4'b1100));

//assign PCSrcD = Op[1];

assign RegWriteD = ~Op[1] & ~(Op[0] & ~Funct[0]) & ~(Funct[4:1] ==4'b1010);

assign MemWriteD = ~Op[1] & Op[0] & ~Funct[0];

assign MemtoRegD = ~Op[1] & Op[0] & Funct[0];

assign ALUSrcD = Op[0] | Funct[5];

assign ImmSrcD[1] = Op[1];
assign ImmSrcD[0] = Op[0];

assign RegSrcD = ~Op[1] & Op[0] & ~Funct[0];

assign BranchD = Op[1] & Funct[5] | (Rd == 4'd15);

assign LinkD = Op[1] & Funct[5] & Funct[4];
assign MovD = ~Op[1] & ~Op[0] & (Funct[4:1] == 4'b1101);

assign ALUControlD[2] = ~Op[1] & ~Op[0] & (Funct[5:0] == 0) & mula & mulb | ~Op[1] & ~Op[0] & (Funct[4:1] == 4'b1101);
assign ALUControlD[1] = ~(~Op[1] & ~Op[0] & (Funct[5:0] == 0) & mula & mulb) & ((Op[1] & ~Funct[5]) | ~Op[1] & ~Op[0] & ((Funct[4:1] == 4'b0000) | (Funct[4:1] == 4'b1100) | (Funct[4:1] == 4'b1101)));
assign ALUControlD[0] = ~(Op[1] & Funct[5]) & ~Op[1] & ~Op[0] & ((Funct[4:1] == 4'b0010) | (Funct[4:1] == 4'b1100) | (Funct[4:1] ==4'b1010)) | Op[0] & ~Funct[3];


endmodule