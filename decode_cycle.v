/////////////////////////////////////////////////////////////////ID STAGE///////////////////////////////////////////////////////////////////
/////////////////////////register file///////////////////////////////////
module register_file(
                input clk,
                input rst,
                input we3,
                input [4:0]a1,
                input [4:0]a2,
                input [4:0]a3,
                input [31:0]wd3,
                output [31:0]rd1,
                output [31:0]rd2
                );
reg [31:0]regs[31:0];
integer i;
always@(posedge clk)begin
    regs[0]=32'b0;             ////////register[0] is assigned with zero only
    if(rst)                   //////////////initial all registers are zero
        for(i=1;i<=32;i=i+1)begin
        regs[i]=32'b0;
        end
    else if(we3)
        begin
            if(a3!=5'b0)
            regs[a3]=wd3;
        end
end
assign rd1 = regs[a1];
assign rd2 = regs[a2];
always@(posedge clk) begin
regs[1] = 32'h45;
regs[2] = 32'h46;
regs[3] = 32'h47;
regs[4] = 32'h48;
regs[5] = 32'h49;
regs[6] = 32'h50;
regs[7] = 32'h51;
regs[8] = 32'h52;
regs[9] = 32'h53;
regs[10] = 32'h54;
regs[11] = 32'h55;
regs[12] = 32'h567;
regs[13] = 32'h57;
regs[14] = 32'h58;
regs[15] = 32'h590;
regs[16] = 32'h60;                       ////////////intitialisied some values in register for an example
regs[17] = 32'h61;
regs[18] = 32'h62;
regs[19] = 32'h63;
regs[20] = 32'h64;
regs[21] = 32'h65;
regs[22] = 32'h66;
regs[23] = 32'h67;
regs[24] = 32'h68;
regs[25] = 32'h69;
regs[26] = 32'h70;
regs[27] = 32'h71;
regs[28] = 32'h72;
regs[29] = 32'h73;
regs[30] = 32'h74;
regs[31] = 32'h75;
end
endmodule
///////////////////////////sign extension///////////////////////
 module sign_extend(
                        input [31:0]ext_in,
                        input [1:0]immsrc,
                        output [31:0]ext_out
                        );
assign ext_out=(immsrc==2'b00) ? {{20{ext_in[31]}},ext_in[31:20]} : 
                (immsrc == 2'b01) ? {{20{ext_in[31]}},ext_in[31:25],ext_in[11:7]} : 
                32'h00000000;
endmodule
////////////////////////control unit////////////////
module control_unit(
                    input [6:0]opcode,
                    output reg regwrite,
                    output reg[1:0] resultsrc,
                    output reg memwrite,
                    output reg jump,
                    output reg branch,
                    output reg alusrc,
                    output reg[1:0]immsrc,
                    output reg[1:0]aluop
                    );
always@(*) begin
casex(opcode)
7'b0110011:begin             ///////////r type////////
        regwrite = 1;
        resultsrc = 2'b00;
        memwrite = 0;
        jump = 0;
        branch = 0;
        alusrc = 0;
        immsrc=2'bxx;
        aluop = 2'b10;
        end
7'b0010011:begin                //////////i type ///////////
        regwrite = 1;
        resultsrc = 2'b00;
        memwrite = 0;
        jump = 0;
        branch = 0;
        alusrc = 1;
        immsrc=2'b00;
        aluop = 2'b10;
        end
7'b0000011:begin            //////////////////load word///////////////
        regwrite = 1;
        resultsrc = 2'b01;
        memwrite = 0;
        jump = 0;
        branch = 0;
        alusrc = 1;
        immsrc=2'b00;
        aluop = 2'b00;
        end
7'b0100011:begin            ///////////////////store word////////////
        regwrite = 0;
        resultsrc = 2'bxx;
        memwrite = 1;
        jump = 0;
        branch = 0;
        alusrc = 1;
        immsrc=2'b01;
        aluop = 2'b00;
        end 
7'b1100011:begin       //////////////////branch equal////////////////////////
        regwrite = 0;
        resultsrc = 2'bxx;
        memwrite = 0;
        jump = 0;
        branch = 1;
        alusrc = 0;
        immsrc=2'b10;
        aluop = 2'b01;
        end 
default:begin                   /////////////////default/////////////
        regwrite = 0;
        resultsrc = 2'b00;
        memwrite = 0;
        jump = 0;
        branch = 0;
        alusrc = 0;
        immsrc=2'b00;
        aluop = 2'b00;
        end                      
endcase
end
endmodule
////////////////////////alu control unit//////////////////////////
module alu_control(
                    input [1:0]aluop,
                    input [2:0]funct3,
                    input [6:0]funct7,
                    input [6:0]op,
                    output [2:0]alucontrol
                    );
                        assign alucontrol = (aluop == 2'b00) ? 3'b000 :
                        (aluop == 2'b01) ? 3'b001 :
                        ((aluop == 2'b10) & (funct3 == 3'b000) & ({op[5],funct7[5]} == 2'b11)) ? 3'b001 : 
                        ((aluop == 2'b10) & (funct3 == 3'b000) & ({op[5],funct7[5]} != 2'b11)) ? 3'b000 : 
                        ((aluop == 2'b10) & (funct3 == 3'b010)) ? 3'b101 : 
                        ((aluop == 2'b10) & (funct3 == 3'b110)) ? 3'b011 : 
                        ((aluop == 2'b10) & (funct3 == 3'b111)) ? 3'b010 : 
                                                                  3'b000 ;
endmodule
//////////////////////////id_ex register///////////////////////////
module id_ex_reg(
                 input clk,rst,
                 input regwriteD,memwriteD,jumpD,branchD,alusrcD,
                 input [1:0]resultsrcD,
                 input [2:0]alucontrolD,
                 input [31:0]pcplus4D,pcD,rd1D,rd2D,immextendD,
                 input [4:0]rdD,rs1D,rs2D,
                 output reg regwriteE,memwriteE,branchE,jumpE,alusrcE,
                 output reg[1:0]resultsrcE,
                 output reg [2:0]alucontrolE,
                 output reg[31:0]pcplus4E,pcE,rd1E,rd2E,immextendE,
                 output reg[4:0]rdE,rs1E,rs2E
                 );
always@(posedge clk)begin                
if(rst)begin                             //////////initial all values are zero/////////
regwriteE <= 0;
resultsrcE <= 0;
memwriteE <= 0;
jumpE <= 0;
branchE <= 0;
alucontrolE <= 3'b000;
alusrcE <= 0;
rd1E <= 32'b0;
rd2E <= 32'b0;
pcE <= 32'b0;
rs1E <= 5'b0;
rs2E <= 5'b0;
rdE <= 5'b0;
immextendE <=32'b0;
pcplus4E <= 32'b0;
end
else begin
regwriteE <= regwriteD;
resultsrcE <= resultsrcD;
memwriteE <= memwriteD;
jumpE <= jumpD;
branchE <= branchD;
alucontrolE <= alucontrolD;
alusrcE <= alusrcD;
rd1E <= rd1D;
rd2E <= rd2D;
pcE <= pcD;
rs1E <= rs1D;
rs2E <= rs2D;
rdE <= rdD;
immextendE <=immextendD;
pcplus4E <= pcplus4D;
end
end
endmodule
/////////////////////////INSTRUCTION DECODING STAGE////////////////////////////////
 module id_stage(
                    input clk,rst,we3,
                    input [4:0]a3,
                    input [31:0]wd3,pcplus4D,instD,pcD,
                    output regwriteE,memwriteE,jumpE,branchE,alusrcE,
                    output [1:0]resultsrcE,
                    output [2:0]alucontrolE,
                    output [31:0]pcplus4E,pcE,rd1E,rd2E,immextendE,
                    output [4:0]rdE,rs1E,rs2E
                    );
wire [31:0]a_reg,b_reg;
wire [31:0]imm_out;
wire regwriteD,memwriteD,branchD,jumpD,alusrcD;
wire [1:0]aluop,immsrc,resultsrcD;
wire [2:0]alucontrolD;
//////////////register file//////////////////////////
register_file REGISTER_FILE(.clk(clk),
                            .rst(rst),
                            .we3(we3),
                            .a1(instD[19:15]),
                            .a2(instD[24:20]),
                            .a3(a3),
                            .wd3(wd3),
                            .rd1(a_reg),
                            .rd2(b_reg)
                            );
//////////////////sign extension//////////////////////
sign_extend SIGN_EXTEND(.ext_in(instD[31:0]),
                        .immsrc(immsrc),
                        .ext_out(imm_out)
                        );
/////////////////control signal/////////////////////////////
control_unit CONTROL_UNIT(.opcode(instD[31:0]),
                          .regwrite(regwriteD),
                          .resultsrc(resultsrcD),
                          .memwrite(memwriteD),
                          .jump(jumpD),
                          .branch(branchD),
                          .aluop(aluop),
                          .alusrc(alusrcD),
                          .immsrc(immsrc)
                          );
////////////////alu control siganl//////////////////
alu_control ALU_CONTROL(.aluop(aluop),
                        .funct3(instD[14:12]),
                        .funct7(instD[31:25]),
                        .op(instD[6:0]),
                        .alucontrol(alucontrolD)
                        );                          
//////////////////////////id ex pipeline////////////////////////////////////                        
id_ex_reg ID_EX_REGISTER(.clk(clk),
                         .rst(rst),
                         .regwriteD(regwriteD),
                         .resultsrcD(resultsrcD),
                         .memwriteD(memwriteD),
                         .jumpD(jumpD),
                         .branchD(branchD),
                         .alucontrolD(alucontrolD),
                         .alusrcD(alusrcD),
                         .pcplus4D(pcplus4D),
                         .pcD(pcD),
                         .rd1D(a_reg),
                         .rd2D(b_reg),
                         .immextendD(imm_out),
                         .rdD(instD[11:7]),
                         .rs1D(instD[19:15]),
                         .rs2D(instD[24:20]),
                         .regwriteE(regwriteE),
                         .resultsrcE(resultsrcE),
                         .memwriteE(memwriteE),
                         .jumpE(jumpE),
                         .branchE(branchE),
                         .alucontrolE(alucontrolE),
                         .alusrcE(alusrcE),
                         .pcplus4E(pcplus4E),
                         .pcE(pcE),
                         .rd1E(rd1E),
                         .rd2E(rd2E),
                         .immextendE(immextendE),
                         .rs1E(rs1E),
                         .rs2E(rs2E),
                         .rdE(rdE)
                         );                                          
endmodule

