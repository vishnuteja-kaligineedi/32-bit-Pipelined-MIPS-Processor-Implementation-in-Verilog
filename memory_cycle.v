/////////////////////////////////////////////MEM STAGE/////////////////////////////////////////////////////////////////////////////////////
///////////////////data memory/////////////
module data_memory(
                input [31:0]A,
                input [31:0]WD,
                input WE,
                input clk,
                input rst,
                output [31:0]RD
                );
reg [31:0]regs[31:0];
always@(posedge clk) begin
regs[1] = 32'h26;
regs[2] = 32'h27;
regs[3] = 32'h28;
regs[4] = 32'h29;
regs[5] = 32'h30;
regs[6] = 32'h31;   ////////////////////initialised some values in data memory
regs[7] = 32'h32;
regs[8] = 32'h23;
regs[9] = 32'h24;
regs[10]= 32'h78;
regs[11] = 32'h46;
end 
always@(posedge clk)begin
regs[0]=32'h0;
if(WE)regs[A] <= WD;
end
assign RD = (rst) ? 32'b0 : regs[A[4:0]];
endmodule

//////////mem_wb register//////////
module memwb_register(
                        input clk,rst,
                        input regwriteM,
                        input [1:0]resultsrcM,
                        input [31:0]aluresultM,pcplus4M,RD,
                        input [4:0]rdM,
                        output reg regwriteW,
                        output reg [1:0]resultsrcW,
                        output reg [31:0]aluresultW,readdataW,pcplus4W,
                        output reg [4:0]rdW
                    );
always@(posedge clk)begin
if(rst)begin
regwriteW <= 1'b0;
resultsrcW <=2'b00;
aluresultW <= 32'b0;
readdataW <= 32'b0;
pcplus4W <=32'b0;
rdW <= 5'b0;
end
else begin
regwriteW <= regwriteM;
resultsrcW <= resultsrcM;
aluresultW <= aluresultM;
readdataW <= RD;
pcplus4W <=pcplus4M;
rdW <= rdM;
end
end
endmodule
//////////////////////////////////MEMORY STAGE/////////////////////////////////////////////////////
module mem_stage(
                        input clk,rst,
                        input regwriteM,memwriteM,
                        input [1:0]resultsrcM,
                        input [31:0]aluresultM,writedataM,pcplus4M,
                        input [4:0]rdM,
                        output regwriteW,
                        output [1:0]resultsrcW, 
                        output [31:0]aluresultW,readdataW,pcplus4W,
                        output [4:0]rdW
            );
            wire [31:0]RD;
///////////////data meory/////////// 
data_memory DATA_MEMORY(.A(aluresultM),
                        .WD(writedataM),
                        .WE(memwriteM),
                        .clk(clk),
                        .rst(rst),
                        .RD(RD)
                        );
//////////////////mem_wb regidter
memwb_register MEMWB_REGISTER(.clk(clk),
                               .rst(rst),
                               .regwriteM(regwriteM),
                               .resultsrcM(resultsrcM),
                               .aluresultM(aluresultM),
                              .pcplus4M(pcplus4M),
                              .RD(RD),
                              .rdM(rdM),
                              .regwriteW(regwriteW),
                              .resultsrcW(resultsrcW),
                              .aluresultW(aluresultW),
                              .readdataW(readdataW),
                              .pcplus4W(pcplus4W),
                              .rdW(rdW)
                              );
endmodule


