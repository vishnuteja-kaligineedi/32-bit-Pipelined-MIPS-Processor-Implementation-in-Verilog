//////////////////////MIPS PIPELINE MAIN MODULE////////////////////
module mips(
            input clk,rst,
            //output of if stage
            output [31:0]instD,pcD,pcplus4D,
            //output of id stage
            output regwriteE,memwriteE,jumpE,branchE,alusrcE,
            output [2:0]alucontrolE,
            output [1:0]resultsrcE,
            output [31:0]rd1E,rd2E,pcE,immextE,pcplus4E,
            output [4:0]rdE,rs1E,rs2E,
            //output of exe stage
            output regwriteM,memwriteM,
            output [1:0]resultsrcM,
            output [31:0]aluresultM,writedataM,pcplus4M,
            output [4:0]rdM,
            //output of mem stage
            output regwriteW,
            output[1:0]resultsrcW,
            output[31:0]aluresultW,readdataW,pcplus4W,
            output [4:0]rdW,
            //output of wb stage
            output [31:0]resultW
            );
            wire [31:0]pctargetE;
            wire pcsrcE;
            wire [1:0]forwardAE,forwardBE;
if_stage FETCHING(.clk(clk),
                  .rst(rst),
                  .pctargetE(pctargetE),
                  .pcsrcE(pcsrcE),
                  .pcplus4D(pcplus4D),
                  .instD(instD),
                  .pcD(pcD)
                  );
id_stage DECODING( .clk(clk),
                  .rst(rst),
                  .we3(regwriteW),
                  .a3(rdW),
                  .wd3(resultW),
                  .pcplus4D(pcplus4D),
                  .instD(instD),
                  .pcD(pcD),
                   .regwriteE(regwriteE),
                   .memwriteE(memwriteE),
                   .jumpE(jumpE),
                   .branchE(branchE),
                   .alusrcE(alusrcE),
                   .resultsrcE(resultsrcE),
                   .alucontrolE(alucontrolE),
                   .pcplus4E(pcplus4E),
                   .pcE(pcE),
                   .rd1E(rd1E),
                   .rd2E(rd2E),
                   .immextendE(immextE),
                   .rdE(rdE),
                   .rs1E(rs1E),
                   .rs2E(rs2E)
                   );
ex_stage EXECUTION(.clk(clk),
                   .rst(rst),
                   .regwriteE(regwriteE),
                   .memwriteE(memwriteE),
                   .jumpE(jumpE),
                   .branchE(branchE),
                   .alusrcE(alusrcE),
                   .forwardAE(forwardAE),
                   .forwardBE(forwardBE),
                   .resultsrcE(resultsrcE),
                   .alucontrolE(alucontrolE),
                   .rd1E(rd1E),
                   .rd2E(rd2E),
                   .pcE(pcE),
                   .pcplus4E(pcplus4E),
                   .immextE(immextE),
                    .resultW(resultW),
                    .rdE(rdE),
                    .regwriteM(regwriteM),
                    .memwriteM(memwriteM),
                    .resultsrcM(resultsrcM),
                    .aluresultM(aluresultM),
                    .writedataM(writedataM),
                    .pcplus4M(pcplus4M),
                    .pctargetE(pctargetE),
                    .rdM(rdM),
                    .pcsrcE(pcsrcE)
                    );
mem_stage MEMORY(.clk(clk),
                 .rst(rst),
                 .regwriteM(regwriteM),
                 .memwriteM(memwriteM),
                 .resultsrcM(resultsrcM),
                 .aluresultM(aluresultM),
                 .writedataM(writedataM),
                 .pcplus4M(pcplus4M),
                 .rdM(rdM),
                 .regwriteW(regwriteW),
                 .resultsrcW(resultsrcW),
                 .aluresultW(aluresultW),
                 .readdataW(readdataW),
                 .pcplus4W(pcplus4W),
                 .rdW(rdW)
                    );
wb_stage WRITEBACK(.regwriteW(regwriteW),
                  .resultsrcW(resultsrcW),
                  .aluresultW(aluresultW),
                  .readdataW(readdataW),
                  .pcplus4W(pcplus4W),
                  .rdW(rdW),
                  .resultW(resultW)
                  ); 
hazard_unit HAZARD(.rst(rst),
                   .regwriteM(regwriteM),
                   .regwriteW(regwriteW),
                   .rdM(rdM),
                   .rdW(rdW),
                   .rs1E(rs1E),
                   .rs2E(rs2E),
                   .forwardAE(forwardAE),
                   .forwardBE(forwardBE)
                   );                                              
endmodule
