///////////////////////////////////////////////WRITE BACK STAGE/////////////////////////////////////////////////////////////////////////////
////////////////////////mux for selecting readadta or aluresult///////////////////////////
module mux31(
           input [31:0]a,b,c,
           input [1:0]sel,
           output [31:0]out
           );
assign out = (sel==2'b00)?a:(sel==2'b01)?b:(sel==2'b10)?c:32'b0;          
endmodule
////////////////////////////////////////////////////////wb stage//////////////////////////////////////
module wb_stage(
                input regwriteW,
                input[1:0]resultsrcW,
                input [31:0]aluresultW,readdataW,pcplus4W,
                input [4:0]rdW,
                output [31:0]resultW
                );
mux31 WB_MUX(.a(aluresultW),
             .b(readdataW),
             .c(pcplus4W),
             .sel(resultsrcW),
             .out(resultW)
             );           
endmodule