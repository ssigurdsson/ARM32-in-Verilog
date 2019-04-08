#PROGRAM 1: Factorial 6

MOV R0, #6
BL FACT
MOV R1, #0
STR R0, [R1]
STR R12, [R1, #1]
SWI 0x11
FACT: CMP R0, #1
MOVEQ PC, LR
SUB SP, SP, #2
STR LR, [SP, #1]
STR R0, [SP]
SUB R0, R0, #1
BL FACT
LDR R1, [SP]
LDR LR, [SP, #1]
ADD SP, SP, #2
MUL R0, R1, R0
MOV PC, LR
MOV R1, R0
SWI 0x11

Instructions[0] = 32'hE3A00006;
Instructions[1] = 32'hEB000003;
Instructions[2] = 32'hE3A01000;
Instructions[3] = 32'hE5810000;
Instructions[4] = 32'hE581C001;
Instructions[5] = 32'hFFFFFFFF;
Instructions[6] = 32'hE3500001;
Instructions[7] = 32'h01A0F00E;
Instructions[8] = 32'hE24DD002;
Instructions[9] = 32'hE58DE001;
Instructions[10] = 32'hE58D0000;
Instructions[11] = 32'hE2400001;
Instructions[12] = 32'hEBFFFFF8;
Instructions[13] = 32'hE59D1000;
Instructions[14] = 32'hE59DE001;
Instructions[15] = 32'hE28DD002;
Instructions[16] = 32'hE0000091;
Instructions[17] = 32'hE1A0F00E;
Instructions[18] = 32'hFFFFFFFF;



#PROGRAM 2: Palindrome checker (racecar, Replace ORR “|” with EOR “^” in the ALU for this to work )

MOV R0, #0x00
STR R0, [SP, #-7]
MOV R0, #0x72
STR R0, [SP, #-6]
MOV R0, #0x61
STR R0, [SP, #-5]
MOV R0, #0x63
STR R0, [SP, #-4]
MOV R0, #0x65
STR R0, [SP, #-3]
MOV R0, #0x63
STR R0, [SP, #-2]
MOV R0, #0x61
STR R0, [SP, #-1]
MOV R0, #0x72
STR R0, [SP]
ADD R2, SP, #1

WHILE:
SUB R2, R2, #1
LDR R3, [R2]
CMP R3, #0
BNE WHILE

CONTINUE:
ADD R2, R2, #1
LDR R3, [R2]
CMP SP, R2
LDR R4, [SP]
SUB SP, SP, #1
EORPLS R5, R3, R4
BEQ CONTINUE

MOV R11, #0
MOVMI R11, #1
STR R11, [R11]
STR R12, [R11, #1]
SWI 0x11

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




#PROGRAM 3: READS SIGNED BINARY NUMBERS FROM INPUT AND CONVERTS THEM TO DECIMAL FOR DISPLAY

READ:
MOV R7, #30
MOV R8, #29
MOV R9, #28
LDR R1, [R7]
LDR R2, [R8]
LDR R3, [R9]
CMP R1, R4
CMPEQ R2, R5
CMPEQ R3, R6
BEQ READ

MOV R1, #-3
MOV R2, #-4
MOV R3, #0

OPERATIONS:
CMP R3, #3
ANDEQ R7, R1, R2
CMP R3, #2
MULEQ R7, R1, R2
CMP R3, #1
SUBEQ R7, R1, R2
CMP R3, #0
ADDEQ R7, R1, R2

BDCDISP:
;thesign
MOV R2, #0
;hundred
MOV R3, #0
;tens
MOV R4, #0
;ones
MOV R5, #0

;thesign and exoring
MOV R11, #0x80
MOV R12, #0x80
MUL R11, R12, R11
MUL R11, R12, R11
ANDS R8, R7, R11
SUBNE R2, R2, #1
EOR R7, R2, R7
SUB R7, R7, R2

;display thesign
MOV R11, #0x7F
MOV R10, #0x40
MUL R2, R10, R2
ADD R2, R11, R2
MUL R2, R12, R2
MUL R2, R12, R2
MUL R2, R12, R2


;hundreds
MOV R8, #0x7F
AND R1, R7, R8
CMP R1, #100
MOVPL R3, #1
SUBPL R1, R1, #100

;display hundreds
MOV R11, #0x40
MOV R10, #0x39
MUL R3, R10, R3
ADD R3, R11, R3
MUL R3, R12, R3
MUL R3, R12, R3


;tens
CMP R1, #90
SUBPL R1, R1, #90
MOVPL R4, #0x18
BPL DISPTENS
CMP R1, #80
SUBPL R1, R1, #80
MOVPL R4, #0x00
BPL DISPTENS
CMP R1, #70
SUBPL R1, R1, #70
MOVPL R4, #0x78
BPL DISPTENS
CMP R1, #60
SUBPL R1, R1, #60
MOVPL R4, #0x02
BPL DISPTENS
CMP R1, #50
SUBPL R1, R1, #50
MOVPL R4, #0x12
BPL DISPTENS
CMP R1, #40
SUBPL R1, R1, #40
MOVPL R4, #0x19
BPL DISPTENS
CMP R1, #30
SUBPL R1, R1, #30
MOVPL R4, #0x30
BPL DISPTENS
CMP R1, #20
SUBPL R1, R1, #20
MOVPL R4, #0x24
BPL DISPTENS
CMP R1, #10
SUBPL R1, R1, #10
MOVPL R4, #0x79
BPL DISPTENS
MOV R4, #0x40

DISPTENS:
MUL R4, R12, R4

;ones
CMP R1, #9
SUBPL R1, R1, #9
MOVPL R5, #0x18
BPL DISP
CMP R1, #8
SUBPL R1, R1, #8
MOVPL R5, #0x00
BPL DISP
CMP R1, #7
SUBPL R1, R1, #7
MOVPL R5, #0x78
BPL DISP
CMP R1, #6
SUBPL R1, R1, #6
MOVPL R5, #0x02
BPL DISP
CMP R1, #5
SUBPL R1, R1, #5
MOVPL R5, #0x12
BPL DISP
CMP R1, #4
SUBPL R1, R1, #4
MOVPL R5, #0x19
BPL DISP
CMP R1, #3
SUBPL R1, R1, #3
MOVPL R5, #0x30
BPL DISP
CMP R1, #2
SUBPL R1, R1, #2
MOVPL R5, #0x24
BPL DISP
CMP R1, #1
SUBPL R1, R1, #1
MOVPL R5, #0x79
BPL DISP
MOV R5, #0x40

DISP:
MOV R0, #0
ADD R0, R0, R2
ADD R0, R0, R3
ADD R0, R0, R4
ADD R0, R0, R5
MOV R1, #31
STR R0, [R1]
MOV R7, #30
MOV R8, #29
MOV R9, #28
LDR R4, [R7]
LDR R5, [R8]
LDR R6, [R9]
B READ

Instructions[0] = 32'hE3A0701E;
Instructions[1] = 32'hE3A0801D;
Instructions[2] = 32'hE3A0901C;
Instructions[3] = 32'hE5971000;
Instructions[4] = 32'hE5982000;
Instructions[5] = 32'hE5993000;
Instructions[6] = 32'hE1510004;
Instructions[7] = 32'h01520005;
Instructions[8] = 32'h01530006;
Instructions[9] = 32'h0AFFFFF5;
Instructions[10] = 32'hE3530003;
Instructions[11] = 32'h00017002
Instructions[12] = 32'hE3530002
Instructions[13] = 32'h00007291
Instructions[14] = 32'hE3530001
Instructions[15] = 32'h00417002
Instructions[16] = 32'hE3530000
Instructions[17] = 32'h00817002
Instructions[18] = 32'hE3A02000
Instructions[19] = 32'hE3A03000
Instructions[20] = 32'hE3A04000
Instructions[21] = 32'hE3A05000
Instructions[22] = 32'hE3A0B080
Instructions[23] = 32'hE3A0C080
Instructions[24] = 32'hE000BB9C
Instructions[25] = 32'hE000BB9C
Instructions[26] = 32'hE007800B
Instructions[27] = 32'h12422001
Instructions[28] = 32'hE1827007
Instructions[29] = 32'hE3A0B07F
Instructions[30] = 32'hE3A0A040
Instructions[31] = 32'hE000229A
Instructions[32] = 32'hE08B2002
Instructions[33] = 32'hE000229C
Instructions[34] = 32'hE000229C
Instructions[35] = 32'hE000229C
Instructions[36] = 32'hE3A0807F
Instructions[37] = 32'hE0071008
Instructions[38] = 32'hE3510064
Instructions[39] = 32'h53A03001
Instructions[40] = 32'h52411064
Instructions[41] = 32'hE3A0B040
Instructions[42] = 32'hE3A0A039
Instructions[43] = 32'hE000339A
Instructions[44] = 32'hE08B3003
Instructions[45] = 32'hE000339C
Instructions[46] = 32'hE000339C
Instructions[47] = 32'hE351005A
Instructions[48] = 32'h5241105A
Instructions[49] = 32'h53A04018
Instructions[50] = 32'h5A000020
Instructions[51] = 32'hE3510050
Instructions[52] = 32'h52411050
Instructions[53] = 32'h53A04000
Instructions[54] = 32'h5A00001C
Instructions[55] = 32'hE3510046
Instructions[56] = 32'h52411046
Instructions[57] = 32'h53A04078
Instructions[58] = 32'h5A000018
Instructions[59] = 32'hE351003C
Instructions[60] = 32'h5241103C
Instructions[61] = 32'h53A04002
Instructions[62] = 32'h5A000014
Instructions[63] = 32'hE3510032
Instructions[64] = 32'h52411032
Instructions[65] = 32'h53A04012
Instructions[66] = 32'h5A000010
Instructions[67] = 32'hE3510028
Instructions[68] = 32'h52411028
Instructions[69] = 32'h53A04019
Instructions[70] = 32'h5A00000C
Instructions[71] = 32'hE351001E
Instructions[72] = 32'h5241101E
Instructions[73] = 32'h53A04030
Instructions[74] = 32'h5A000008
Instructions[75] = 32'hE3510014
Instructions[76] = 32'h52411014
Instructions[77] = 32'h53A04024
Instructions[78] = 32'h5A000004
Instructions[79] = 32'hE351000A
Instructions[80] = 32'h5241100A
Instructions[81] = 32'h53A04079
Instructions[82] = 32'h5A000000
Instructions[83] = 32'hE3A04040
Instructions[84] = 32'hE000449C
Instructions[85] = 32'hE3510009
Instructions[86] = 32'h52411009
Instructions[87] = 32'h53A05018
Instructions[88] = 32'h5A000020
Instructions[89] = 32'hE3510008
Instructions[90] = 32'h52411008
Instructions[91] = 32'h53A05000
Instructions[92] = 32'h5A00001C
Instructions[93] = 32'hE3510007
Instructions[94] = 32'h52411007
Instructions[95] = 32'h53A05078
Instructions[96] = 32'h5A000018
Instructions[97] = 32'hE3510006
Instructions[98] = 32'h52411006
Instructions[99] = 32'h53A05002
Instructions[100] = 32'h5A000014
Instructions[101] = 32'hE3510005
Instructions[102] = 32'h52411005
Instructions[103] = 32'h53A05012
Instructions[104] = 32'h5A000010
Instructions[105] = 32'hE3510004
Instructions[106] = 32'h52411004
Instructions[107] = 32'h53A05019
Instructions[108] = 32'h5A00000C
Instructions[109] = 32'hE3510003
Instructions[110] = 32'h52411003
Instructions[111] = 32'h53A05030
Instructions[112] = 32'h5A000008
Instructions[113] = 32'hE3510002
Instructions[114] = 32'h52411002
Instructions[115] = 32'h53A05024
Instructions[116] = 32'h5A000004
Instructions[117] = 32'hE3510001
Instructions[118] = 32'h52411001
Instructions[119] = 32'h53A05079
Instructions[120] = 32'h5A000000
Instructions[121] = 32'hE3A05040
Instructions[122] = 32'hE0800002
Instructions[123] = 32'hE0800003
Instructions[124] = 32'hE0800004
Instructions[125] = 32'hE0800005
Instructions[126] = 32'hE3A0101F
Instructions[127] = 32'hE5810000
Instructions[128] = 32'hEAFFFF7E
Instructions[129] = 32'hFFFFFFFF;