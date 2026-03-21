`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer(may be): Krishnendu
// 
// Create Date: 21.03.2026 03:48:07
// Design Name: 
// Module Name: tb_matrix_mul
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


module tb_matrix_mul;

    reg clk, reset;
    reg [7:0] a_r0, a_r1, a_r2, a_r3;
    reg [7:0] b_c0, b_c1, b_c2, b_c3;

    wire [15:0] c00, c01, c02, c03;
    wire [15:0] c10, c11, c12, c13;
    wire [15:0] c20, c21, c22, c23;
    wire [15:0] c30, c31, c32, c33;

    mm_sys_array dut(
        .clk(clk),
        .reset(reset),
        .a_r0(a_r0), .a_r1(a_r1), .a_r2(a_r2), .a_r3(a_r3),
        .b_c0(b_c0), .b_c1(b_c1), .b_c2(b_c2), .b_c3(b_c3),
        .c00(c00), .c01(c01), .c02(c02), .c03(c03),
        .c10(c10), .c11(c11), .c12(c12), .c13(c13),
        .c20(c20), .c21(c21), .c22(c22), .c23(c23),
        .c30(c30), .c31(c31), .c32(c32), .c33(c33)
    );

    always #5 clk = ~clk;

    initial begin
        // 1. Initialize inputs to 0 to prevent 'x' propagation
        a_r0=0; a_r1=0; a_r2=0; a_r3=0;
        b_c0=0; b_c1=0; b_c2=0; b_c3=0;

        clk = 0; 
        reset = 1;
        
        @(posedge clk); 
        @(posedge clk);  
        
        @(negedge clk);
        reset = 0;

       
        a_r0=1;  a_r1=5;  a_r2=9;  a_r3=13;
        b_c0=1;  b_c1=2;  b_c2=3;  b_c3=4;

      
        @(negedge clk);
        a_r0=2;  a_r1=6;  a_r2=10; a_r3=14;
        b_c0=5;  b_c1=6;  b_c2=7;  b_c3=8;

        @(negedge clk);
        a_r0=3;  a_r1=7;  a_r2=11; a_r3=15;
        b_c0=9;  b_c1=10; b_c2=11; b_c3=12;

        // Cycle 4
        @(negedge clk);
        a_r0=4;  a_r1=8;  a_r2=12; a_r3=16;
        b_c0=13; b_c1=14; b_c2=15; b_c3=16;

        @(negedge clk);
        a_r0=0; a_r1=0; a_r2=0; a_r3=0;
        b_c0=0; b_c1=0; b_c2=0; b_c3=0;

        
        repeat(10) @(posedge clk);
        #1; 

        $display("output matrix:");
        $display("%5d %5d %5d %5d", c00, c01, c02, c03);
        $display("%5d %5d %5d %5d", c10, c11, c12, c13);
        $display("%5d %5d %5d %5d", c20, c21, c22, c23);
        $display("%5d %5d %5d %5d", c30, c31, c32, c33);
        $finish;
    end


endmodule
