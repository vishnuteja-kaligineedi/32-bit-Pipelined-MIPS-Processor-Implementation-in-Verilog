////////////////////////////////////////////////////////////IF STAGE//////////////////////////////////////////////////////////////////////
/////////////////////////////program counter///////////////////////
module pc(
    input [31:0]pc_in,
    input clk,
    input rst,           
    output reg[31:0]pc_out
    );    
always@(posedge clk) begin                     
if(rst)
           pc_out <= 32'b0;
else 
           pc_out <= pc_in;         
end     
endmodule
///////////////////////pc adder///////////////////////////
module pc_adder(
    input [31:0]pc_in,
    output [31:0]pcplus4
    );
assign pcplus4 = pc_in+32'h4;/////////pcvalue added with 4 to get newpc value for next instruction
endmodule
///////////////instruction memory///////////////////////////////////
module imem(
    input [31:0]A,
    output [31:0]RD
    );
reg [31:0]mem[255:0];
initial begin
        mem[0] = 32'b0000000_00010_00001_000_00101_0110011;////////r type  
        mem[1] = 32'b000000001010_00000_000_00110_0010011;///////i type
        mem[2] = 32'b000000000000_00001_010_00111_0000011;//////load
        mem[3] = 32'b0000000_00010_00001_010_00100_0100011;//////store
        mem[4] = 32'b000000_00010_00001_000_01000_1100011;/////branch
end
assign RD = mem[A[9:2]];//////helps to read instruction in instruction memory
endmodule 
///////////////////inst fetch mux//////////////////////////////////
module if_mux( 
    input [31:0]ina,
    input [31:0]inb,
    input sel,
    output [31:0]mux_out
    );
assign mux_out = sel?inb:ina;
endmodule
///////////////////////IF/ID register///////////////////////
module if_id_reg(
    input clk,
    input rst,
    input [31:0]instF,
    input [31:0]pcplus4F,
    input [31:0]pcF,
    output reg[31:0]pcplus4D,
    output reg[31:0]instD,
    output reg[31:0]pcD
    );
always @(posedge clk)begin  
if (rst)begin
instD <= 32'b0;
pcplus4D <= 32'b0;
pcD <= 32'b0;

end
else begin
instD <= instF;
pcplus4D <= pcplus4F;
pcD <= pcF;
end
end
endmodule
///////////////////INSTRUCTION FETCHING STAGE////////////////////////
module if_stage(
    input clk,
    input rst,
    input [31:0]pctargetE,
    input pcsrcE, 
    output [31:0]pcplus4D,
    output [31:0]instD,
    output [31:0]pcD
    );
wire [31:0]pcplus4F,pc_F,instF,pc_out;
//////////////////////////pc + 4 adder//////////////
pc_adder PC_ADDER(.pc_in(pc_out),
                  .pcplus4(pcplus4F)
                  );
///////////mux for selecting next pc////////////
if_mux IF_MUX(.ina(pcplus4F),
              .inb(pctargetE),  
              .sel(pcsrcE), 
              .mux_out(pc_F)
              );
//////////////programm counter////////////////
pc PC(.pc_in(pc_F), 
      .clk(clk),
      .rst(rst),
      .pc_out(pc_out)
      );
///////////////instruction meomry///////////////
imem IMEM(.A(pc_out),
          .RD(instF)
          );
//////////////////if id register////////////////
if_id_reg IF_ID_REGISTER(.clk(clk),
                         .rst(rst),
                         .instF(instF),
                         .pcplus4F(pcplus4F),
                         .pcF(pc_out),
                         .pcplus4D(pcplus4D),
                         .instD(instD),
                        .pcD(pcD)
                        );
endmodule

