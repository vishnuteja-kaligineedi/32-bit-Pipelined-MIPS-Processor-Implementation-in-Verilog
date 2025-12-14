/////////////////////////////////////////////////////////////EXE STAGE//////////////////////////////////////////////////////////////////
////////////////address adder////////////
module adder(
               input [31:0]ina,
               input [31:0]inb,
               output [31:0]out
               );
assign out = ina + inb;
endmodule
//////////////2:1 mux/////////
module mux2_1(
            input [31:0]a,
            input [31:0]b,
            input sel,
            output [31:0]out
            );
assign out=sel?b:a;
endmodule
/////////////////////3:1 mux//////////////////// 
module mux3_1(
                input [31:0]a,
                input [31:0]b,
                input [31:0]c,
                input [1:0]sel,
                output [31:0]out
                    );
                assign out = (sel == 2'b00) ? a : (sel == 2'b01) ? b : (sel == 2'b10) ? c : 32'h00000000;
endmodule   
/////////////////pcsrce generate signal////////////////
module comb_ckt(
                   input a,b,
                   input c,
                   output pcsrcE
                );                    //////////circuit for generating pcsrcE signal for selection line for mux in if stage
                wire w1;
              assign w1=a & b ;
              assign pcsrcE=w1 | c;
endmodule                                 

///////////////////////alu///////////////
module alu(
            input [31:0]ina,
            input [31:0]inb,
            input [2:0]alucontrol,
            output carry,overflow,zero,negative,
            output [31:0]out
            );
wire cout;
assign {cout,out}=(alucontrol==3'b000)?ina+inb:
                    (alucontrol==3'b001)?ina-inb:
                    (alucontrol==3'b010)?ina&inb:
                    (alucontrol==3'b011)?ina|inb:
                    (alucontrol== 3'b101)?ina<inb:
                    33'b0;
assign overflow=(~ina[31] & ~inb[31] & out[31]) | (ina[31] & inb[31] & ~out[31]);
assign carry=cout;
assign zero=&(~out);
assign negative=out[31];
endmodule
/////////////////ex mem register///////////////
module exmem_register(
                    input clk,rst,
                    input regwriteE,memwriteE,
                    input [1:0]resultsrcE,
                    input [31:0]aluresultE,writedataE,pcplus4E,
                    input [4:0]rdE,
                    output reg regwriteM,memwriteM,
                    output reg[31:0]aluresultM,writedataM,pcplus4M,
                    output reg[4:0]rdM,
                    output reg [1:0]resultsrcM
                  );
always@(posedge clk or posedge rst)begin
if(rst)begin
aluresultM <= 32'b0;
writedataM <= 32'b0;
pcplus4M <= 32'b0;
rdM <= 5'b0;
regwriteM <=1'b0;
memwriteM <=1'b0;
resultsrcM <= 2'b00;
end
else begin
aluresultM <= aluresultE;
writedataM <= writedataE;
pcplus4M <= pcplus4E;
rdM <= rdE;
regwriteM <=regwriteE;
memwriteM <=memwriteE;
resultsrcM <= resultsrcE;
end
end
endmodule
/////////////////////////////////////////EXECUTION STAGE/////////////////////////////////////////
 module ex_stage(
            input clk,rst,
            input regwriteE,memwriteE,jumpE,branchE,alusrcE,
            input [1:0]resultsrcE,forwardAE,forwardBE,
            input [2:0]alucontrolE,
            input [31:0]rd1E,rd2E,pcE,pcplus4E,immextE,resultW,
            input [4:0]rdE,
            output regwriteM,memwriteM,pcsrcE,
            output [1:0]resultsrcM,
            output [31:0]aluresultM,writedataM,pcplus4M,pctargetE,
            output [4:0]rdM
            );
wire [31:0]writedataE,srcAE,srcBE,aluresultE;
wire zeroE;
wire carry,overflow,negative;
//////////////address adder//////////
adder ADDER(.ina(pcE),
            .inb(immextE),  
            .out(pctargetE)
            );
////////////3_1 mux///////////////////
mux3_1 SRCAEMUX(.a(rd1E),
                .b(resultW),
                .c(aluresultM),
                .sel(forwardAE),
                .out(srcAE)
                );
////////////3_1 mux///////////////////
mux3_1 SRCBEMUX(.a(rd2E),
                .b(resultW),
                .c(aluresultM),
                .sel(forwardBE),
                .out(writedataE)
                );
///////////2_1 mux//////////
mux2_1 ALU_SRCBEMUX(.a(writedataE),
                    .b(immextE),
                    .sel(alusrcE),
                    .out(srcBE)
                    );
////////////////////alu///////////////////////////
alu ALU(.ina(srcAE),
        .inb(srcBE),
        .alucontrol(alucontrolE),
        .carry(carry),
        .overflow(overflow),
        .zero(zeroE),
        .negative(negative),
        .out(aluresultE)
        );
////////////////pcsrcE signal generator////////////////////////////
comb_ckt  PCSRCE(.a(zeroE),
                 .b(branchE),
                 .c(jumpE),
                 .pcsrcE(pcsrcE)
                 );
//////////////////exmem register//////////////
exmem_register EXMEM_REGISTER(.clk(clk),
                               .rst(rst),
                               .regwriteE(regwriteE),
                               .memwriteE(memwriteE),
                               .resultsrcE(resultsrcE),
                               .aluresultE(aluresultE),
                               .writedataE(writedataE),
                               .pcplus4E(pcplus4E),
                               .rdE(rdE),
                               .aluresultM(aluresultM),
                               .writedataM(writedataM),
                               .pcplus4M(pcplus4M),
                               .rdM(rdM),
                               .regwriteM(regwriteM),
                               .memwriteM(memwriteM),
                               .resultsrcM(resultsrcM)
                               );
endmodule

