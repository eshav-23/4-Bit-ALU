module ALU (A,B,OpCode,Result);
    input [3:0] A, B;   
    input [2:0] OpCode; 
    output reg [7:0] Result ;

    wire [7:0] add_res, sub_res, mul_res, div_res;
    wire [3:0] and_res, or_res, xor_res;

    wire [7:0]  A1, B1;
    
    _8bit extend_A (.a(A), .b(A1));
    _8bit extend_B (.a(B), .b(B1));

    cla add_module (.sum(add_res[3:0]), .a(A), .b(B));
    clasub sub_module (.diff(sub_res[3:0]), .x(A), .y(B));
    boothmul mul_module (.product(mul_res), .Multiplier(A), .Multiplicand(B));
    division div_module (.Quo(div_res), .Divs(B1), .Divd(A1));
    AND_Gate and_module (.A(A), .B(B), .Result(and_res));
    OR_Gate or_module (.A(A), .B(B), .Result(or_res));
    XOR_Gate xor_module (.A(A), .B(B), .Result(xor_res));

    always @(*) begin
        case (OpCode)
            3'b000: Result = {4'b0000, add_res[3:0]}; 
            3'b001: Result = {4'b0000, sub_res[3:0]}; 
            3'b010: Result = {4'b0000, and_res}; 
            3'b011: Result = {4'b0000, or_res}; 
            3'b100: Result = {4'b0000, xor_res};
            3'b101: Result = mul_res; 
            3'b110: Result = div_res; 
            default: Result = 8'b00000000; 
        endcase
    end

endmodule

module cla(sum, a, b);
    output wire [3:0] sum;
    input [3:0] a, b;
    reg cin = 0;
    wire [3:0] c;
    fulladder fa0(sum[0], c[0], a[0], b[0], cin);
    generate
        genvar i;
        for (i = 1; i < 4; i = i + 1) begin : add_loop
            fulladder fa(sum[i], c[i], a[i], b[i], c[i-1]);
        end
    endgenerate
endmodule

module clasub(diff, x, y);
    input [3:0] x, y;
    output [3:0] diff;
    wire [3:0] p;
    wire [3:0] c;
    reg cntl = 1;
    assign p[0] = y[0] ^ cntl;
    fulladder fa0(diff[0], c[0], x[0], p[0], cntl);
    generate
        genvar i;
        for (i = 1; i < 4; i = i + 1) begin : sub_loop
            assign p[i] = y[i] ^ cntl;
            fulladder fa(diff[i], c[i], x[i], p[i], c[i-1]);
        end
    endgenerate
endmodule

module fulladder(sum, cout, a, b, cin);
    input a, b, cin;
    output sum, cout;
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (cin & a);
endmodule

module boothmul(product, Multiplier, Multiplicand);
    output reg signed [7:0] product;
    input signed [3:0] Multiplier, Multiplicand;
    reg [1:0] temp;
    integer i;
    reg q0;
    reg [3:0] B;
    always @(Multiplier, Multiplicand) begin
        product = 8'd0;
        q0 = 1'b0;
        B = -Multiplicand;
        for (i = 0; i < 4; i = i + 1) begin
            temp = { Multiplier[i], q0 };
            case(temp)
                2'd2: product[7:4] = product[7:4] + B;
                2'd1: product[7:4] = product[7:4] + Multiplicand;
            endcase
            product = product >> 1;
            product[7] = product[6];
            q0 = Multiplier[i];
        end
    end
endmodule

module division(Quo, Divs, Divd);
    input [7:0] Divs, Divd;
    output reg [7:0] Quo;
    reg [7:0] Q, R, Rem;
    reg [7:0] A;
    integer i;
    always @(Divs or Divd) begin
        Q = Divs;
        R = Divd;
        A = 0; 
        for (i = 0; i < 8; i = i + 1) begin
            A = {A[6:0], R[7]};
            R[7:1] = R[6:0];
            A = A - Q;
            if (A[7] == 1) begin
                R[0] = 0;
                A = A + Q;
            end else begin
                R[0] = 1;
            end
        end
        Quo = R;
        Rem = Divd - (Q * R);
    end
endmodule

module _8bit(a, b);
    input [3:0] a;
    output [7:0] b;
    assign b = {4'b0000, a};
endmodule

module AND_Gate (A,B,Result);
    input [3:0] A,B;
    output [3:0] Result;
    assign Result = A & B;
endmodule

module OR_Gate (A,B,Result);
    input [3:0] A,B;
    output [3:0] Result;
    assign Result = A | B;
endmodule

module XOR_Gate (A,B,Result);
    input [3:0] A,B;
    output [3:0] Result;
assign Result = A ^ B;
endmodule
