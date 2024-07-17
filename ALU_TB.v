`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.07.2024 18:33:59
// Design Name: 
// Module Name: ALU_TB
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU_tb;

    reg [3:0] A;
    reg [3:0] B;
    reg [2:0] OpCode;

    wire [7:0] Result;

    ALU dut (.A(A),.B(B),.OpCode(OpCode),.Result(Result));

    initial begin
        A = 4'd0;
        B = 4'd0;
        OpCode = 3'd8;
        #10;
        A = 4'd5; 
        B = 4'd3; 
        OpCode = 3'd0; 
        #10;
        A = 4'd5; 
        B = 4'd3; 
        OpCode = 3'd1; 
        #10;
        A = 4'd5;
        B = 4'd3;
        OpCode = 3'd2; 
        #10;
        A = 4'd5;
        B = 4'd3; 
        OpCode = 3'd3; 
        #10;
        A = 4'd4; 
        B = 4'd3; 
        OpCode = 3'd4; 
        #10;
        A = 4'd7; 
        B = 4'd3; 
        OpCode = 3'd5;
        #10;
        A = 4'd7; 
        B = 4'd3; 
        OpCode = 3'd6;
        #10;
        $finish;
    end

endmodule
