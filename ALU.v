module ALU(input wire clocki, input wire [31:0] SrcA, SrcB, input wire [2:0] ALUControlE1, output wire [3:0] ALUFlags, 
output wire [31:0] ALUResult);

wire [31:0] added;
wire [9:0] rmulti1;
wire [63:0] rmulti2;
wire [31:0] rmulti;
reg [31:0] andor;
reg [2:0] ALUControlE2;
reg [31:0] SrcAE2, SrcBE2;

assign ALUFlags[3] = ALUResult[31];
assign ALUFlags[2] = (ALUResult == 32'd0);

addsub a1(~ALUControlE1[0],clocki,SrcA,SrcB,ALUFlags[1],ALUFlags[0],added);
multi mul1(clocki,SrcA[6:0],SrcB[2:0],rmulti1);
multi2 mul2(clocki,SrcA,SrcB,rmulti2);

assign rmulti = ((SrcAE2 < 32'd128) && (SrcBE2 < 32'd8)) ? {22'd0,rmulti1} : rmulti2[31:0];

immmux m2(added,andor,rmulti,SrcBE2,ALUControlE2[2:1],ALUResult);

always @(posedge clocki)
begin
andor <= ALUControlE1[0] ? SrcA ^ SrcB : SrcA & SrcB;
ALUControlE2 <= ALUControlE1;
SrcAE2 <= SrcA;
SrcBE2 <= SrcB;
end

endmodule