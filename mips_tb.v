///////////////////////////////////////MIPS TEST BENCH//////////////////////////////////////
module mips_tb();
             reg clk,rst;
            //output of if stage
            wire [31:0]instD,pcD,pcplus4D;
            //output of id stage
            wire regwriteE,memwriteE,jumpE,branchE,alucontrolE,alusrcE;
            wire [1:0]resultsrcE;
            wire [31:0]rd1E,rd2E,pcE,immextE,pcplus4E;
            wire[4:0]rdE,rs1E,rs2E;
            //output of exe stage
            wire regwriteM,memwriteM;
            wire [1:0]resultsrcM;
            wire [31:0]aluresultM,writedataM,pcplus4M;
            wire [4:0]rdM;
            //output of mem stage
            wire regwriteW;
            wire [1:0]resultsrcW;
            wire [31:0]aluresultW,readdataW,pcplus4W;
             wire[4:0]rdW;
            //output of wb stage
            wire [31:0]resultW;
mips dut(
            .clk(clk),.rst(rst),
            //output of if stage
            .instD(instD),.pcD(pcD),.pcplus4D(pcplus4D),
            //output of id stage
            .regwriteE(regwriteE),.memwriteE(memwriteE),.jumpE(jumpE),.branchE(branchE),.alucontrolE(alucontrolE),.alusrcE(alusrcE),
            .resultsrcE(resultsrcE),
            .rd1E(rd1E),.rd2E(rd2E),.pcE(pcE),.immextE(immextE),.pcplus4E(pcplus4E),
            .rdE(rdE),.rs1E(rs1E),.rs2E(rs2E),
            //output of exe stage
            .regwriteM(regwriteM),.memwriteM(memwriteM),
            .resultsrcM(resultsrcM),
            .aluresultM(aluresultM),.writedataM(writedataM),.pcplus4M(pcplus4M),
            .rdM(rdM),
            //output of mem stage
            .regwriteW(regwriteW),
            .resultsrcW(resultsrcW),
            .aluresultW(aluresultW),.readdataW(readdataW),.pcplus4W(pcplus4W),
             .rdW(rdW),
            //output of wb stage
            .resultW(resultW)
            );
            initial begin
            clk=1;rst=1;
            #10 rst=0;
            end
            always #5 clk= ~clk;
endmodule
