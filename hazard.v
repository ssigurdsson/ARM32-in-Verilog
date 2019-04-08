module hazard(input wire MemtoRegE1, MemtoRegE2, MatchE2A, MatchE2B, MatchE1A, MatchE1B, MatchMWA, MatchMWB, BranchTakenE2, BranchCorrect, CondExE2, input wire [3:0] CondE1,
output wire ForwardAE1, ForwardBE1, ForwardAE2, ForwardBE2, FlushE2, FlushE1, FlushD, StallD, StallF);

assign ForwardAE1 = MatchE1A & ~MemtoRegE1 & (CondE1 == 4'b1110);
assign ForwardBE1 = MatchE1B & ~MemtoRegE1 & (CondE1 == 4'b1110);
assign ForwardAE2 = MatchE2A & ~MemtoRegE2 & CondExE2;
assign ForwardBE2 = MatchE2B & ~MemtoRegE2 & CondExE2;
assign FlushE1 = StallD | (BranchTakenE2 & ~BranchCorrect);
assign FlushE2 = BranchTakenE2 & ~BranchCorrect;

assign FlushD = BranchTakenE2 & ~BranchCorrect;
assign StallD = (MatchE1A & MemtoRegE1) | (MatchE2A & MemtoRegE2) | (MatchE1B & MemtoRegE1) | (MatchE2B & MemtoRegE2) | ~ForwardAE1 & ~ForwardAE2 & MatchMWA | ~ForwardBE1 & ~ForwardBE2 & MatchMWB;

assign StallF = StallD & ~BranchTakenE2;

endmodule