`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.03.2026 02:06:40
// Design Name: 
// Module Name: mm_sys_array
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


module mm_sys_array(
    input clk,
    input reset,
    input [7:0] a_r0,a_r1,a_r2,a_r3,
    input [7:0] b_c0,b_c1,b_c2,b_c3,
    output [15:0] c00,c01,c02,c03,
    output [15:0] c10,c11,c12,c13,
    output [15:0] c20,c21,c22,c23,
    output [15:0] c30,c31,c32,c33

    );
    wire [7:0] a0_delayed,a1_delayed,a2_delayed,a3_delayed;
    wire [7:0] b0_delayed,b1_delayed,b2_delayed,b3_delayed;
    
    shift_reg #(.DELAY(0)) a0(.clk(clk),.reset(reset),.in(a_r0), .out(a0_delayed));
    shift_reg #(.DELAY(1)) a1(.clk(clk),.reset(reset),.in(a_r1), .out(a1_delayed));
    shift_reg #(.DELAY(2)) a2(.clk(clk),.reset(reset),.in(a_r2), .out(a2_delayed));
    shift_reg #(.DELAY(3)) a3(.clk(clk),.reset(reset),.in(a_r3), .out(a3_delayed));
    
    shift_reg #(.DELAY(0)) b0(.clk(clk),.reset(reset),.in(b_c0), .out(b0_delayed));
    shift_reg #(.DELAY(1)) b1(.clk(clk),.reset(reset),.in(b_c1), .out(b1_delayed));
    shift_reg #(.DELAY(2)) b2(.clk(clk),.reset(reset),.in(b_c2), .out(b2_delayed));
    shift_reg #(.DELAY(3)) b3(.clk(clk),.reset(reset),.in(b_c3), .out(b3_delayed));
    
    wire [7:0] a_inter_pe[0:19];
    wire [7:0] b_inter_pe[0:19];
    
    assign a_inter_pe[0] = a0_delayed;
    assign a_inter_pe[5] = a1_delayed;
    assign a_inter_pe[10] = a2_delayed;
    assign a_inter_pe[15] = a3_delayed;
    
    assign b_inter_pe[0] = b0_delayed;
    assign b_inter_pe[1] = b1_delayed;
    assign b_inter_pe[2] = b2_delayed;
    assign b_inter_pe[3] = b3_delayed;
    
    wire [15:0] accumulator [0:15];
    
    genvar i,j;
    generate
        for(i=0;i<4;i=i+1) begin : rows
            for(j=0;j<4;j=j+1) begin : col
                processing_element ins( .clk(clk),.reset(reset),
                .a(a_inter_pe[i*5+j]),
                .b(b_inter_pe[i*4+j]),
                .a_out(a_inter_pe[i*5+j+1]),
                .b_out(b_inter_pe[(i+1)*4+j]),
                .accumulator_out(accumulator[i*4+j])
                );
                end
end    
    
    endgenerate
    
    assign c00=accumulator[0];
    assign c01=accumulator[1];
    assign c02=accumulator[2];
    assign c03=accumulator[3];
    
    assign c10=accumulator[4];
    assign c11=accumulator[5];
    assign c12=accumulator[6];
    assign c13=accumulator[7];
    
    assign c20=accumulator[8];
    assign c21=accumulator[9];
    assign c22=accumulator[10];
    assign c23=accumulator[11];
    
    assign c30=accumulator[12];
    assign c31=accumulator[13];
    assign c32=accumulator[14];
    assign c33=accumulator[15];
    
    
    
    
    
    
    
    
endmodule


module processing_element(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] a_out,
    output reg [7:0] b_out,
    output reg [15:0] accumulator_out

);
    always@(posedge clk) begin
        if(reset) begin
            a_out<=8'b0;
            b_out<=8'b0;
            accumulator_out<=16'b0;
        end
        else begin
            a_out<=a;
            b_out<=b;
            accumulator_out<=accumulator_out + (a*b);
        end
    end

endmodule

module shift_reg(
    input clk,
    input reset,
    input [7:0] in,
    output [7:0] out


);
    parameter DELAY = 0;
    generate
        if(DELAY==0) begin : no_delay
            assign out = in;
        end
        else begin : with_delay
            reg [7:0] temp [0:DELAY-1];
            integer i;
            always@(posedge clk) begin
                if(reset) begin
                    for(i=0;i<DELAY;i=i+1)
                        temp[i]<=8'b0;
                end
                else begin
                temp[0]<=in;
                for(i=1;i<DELAY;i=i+1)
                    temp[i]<=temp[i-1];
                end
            end
            assign out = temp [DELAY - 1];
        
        end
        
        endgenerate


endmodule
