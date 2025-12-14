////////////////////////////HAZARD BLOCK///////////////////////
module hazard_unit(
                    input rst,
                    input regwriteM,regwriteW,
                    input [4:0]rdM,rdW,rs1E,rs2E,
                    output [1:0]forwardAE,forwardBE
                    );
assign forwardAE = (rst)?2'b00:
                    ((regwriteM==1'b1)&(rdM!=5'b0)&(rdM==rs1E))?2'b10:
                    ((regwriteM==1'b1)&(rdM!=5'b0)&(rdW==rs1E))?2'b01:
                    2'b00;
assign forwardBE = (rst)?2'b00:
                    ((regwriteM==1'b1)&(rdM!=5'b0)&(rdM==rs2E))?2'b10:
                    ((regwriteM==1'b1)&(rdM!=5'b0)&(rdW==rs2E))?2'b01:
                    2'b00;                    
endmodule
