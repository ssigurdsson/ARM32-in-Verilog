module conditional(input wire [1:0] FlagWriteE2, input wire [3:0] CondE2, 
input wire [3:0] FlagsE2, input wire [3:0] ALUFlags, 
output wire [3:0] Flags, output wire CondExE2);

assign Flags[3:2] = (CondExE2 & FlagWriteE2[1]) ? ALUFlags[3:2] : FlagsE2[3:2];
assign Flags[1:0] = (CondExE2 & FlagWriteE2[0]) ? ALUFlags[1:0] : FlagsE2[1:0];

//Conditionals
condmux cond1(FlagsE2[2],~FlagsE2[2],~(FlagsE2[3] ^ FlagsE2[0]),FlagsE2[3] ^ FlagsE2[0],~FlagsE2[2] & ~(FlagsE2[3] ^ FlagsE2[0]),
FlagsE2[2] | (FlagsE2[3] ^ FlagsE2[0]),1'b1,1'b0,FlagsE2[1],~FlagsE2[1],FlagsE2[3],~FlagsE2[3],
FlagsE2[0],~FlagsE2[0],~FlagsE2[2] & FlagsE2[1],FlagsE2[2] & ~FlagsE2[1],
CondE2,CondExE2);

endmodule