`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:29:40 03/31/2022 
// Design Name: 
// Module Name:    shuzizhong_notimeadjust 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module digital_clock(clk_100M, select, y);
	input clk_100M;
	output[7:0] y;
	output[7:0] select;
	reg[16:0] count;
	reg[7:0] select, y;
	wire clk_1hz, clk_1khz, clk_100M;
	wire[3:0] s0, s1, m0, m1, h0, h1;
	//变量说明：
	//clk_100M是100M的时钟信号select是控制数码管亮暗的使能端，y是七段译码器的输出端
	//count用于记录时钟走过的秒数，clk_1hz是分频后1hz的时钟信号
	//s0~h1记录秒、分、时的个十位
	
	//分频器获得1hz和1khz时钟信号，输入输出必须为wire型
	frequency_divider fred(clk_1hz, clk_1khz, clk_100M);
	//计时模块,每24*60*60秒为一轮
	initial count = 0;
	always@(posedge clk_1hz)
		begin
			if(count != 17'd86399)
				count <= count + 1;
			else count <= 0;
		end
	//获得当前时间的时分秒各位数
	time_count t(count, s0, s1, m0, m1, h0, h1);
	
	
	//获取当前时间的时分秒各位数的七段译码值
	wire[7:0] y0, y1, y2, y3, y4, y5;
	decoder4_8 d1(s0, y0);
	decoder4_8 d2(s1, y1);
	decoder4_8 d3(m0, y2);
	decoder4_8 d4(m1, y3);
	decoder4_8 d5(h0, y4);
	decoder4_8 d6(h1, y5);

		
	//数码管高频显示当前小时、分钟和秒
	reg[2:0] flag;//flag相当于模6计数器，对应时分秒的六位数
	initial
		begin 
			flag = 0;
			y = 0;
			select = 0;
		end
	always@(posedge clk_1khz) flag = (flag+1)%6;
	always@(flag)
		begin
			if(flag == 3'd0)//显示秒的个位
				begin
					select <= 8'b1111_1110;
					y <= y0;
				end
			if(flag == 3'd1)//显示秒的十位
				begin
					select <= 8'b1111_1101;
					y <= y1;
				end
			if(flag == 3'd2)//显示分钟的个位
				begin
					select <= 8'b1111_1011;
					y <= y2;
				end
			if(flag == 3'd3)//显示分钟的十位
				begin
					select <= 8'b1111_0111;
					y <= y3;
				end
			if(flag == 3'd4)//显示小时的个位
				begin
					select <= 8'b1110_1111;
					y <= y4;
				end
			if(flag == 3'd5)//显示小时的十位
				begin
					select <= 8'b1101_1111;
					y <= y5;
				end
		end	
endmodule
	


//七段译码器
module decoder4_8(x, y);
	input[3:0] x;
	output[7:0] y;
	reg[7:0] y;
	
	always@(x)
		case(x)
			4'd0: y <= 8'h03;//数码管显示0
			4'd1: y <= 8'h9f;//数码管显示1
			4'd2: y <= 8'h25;//数码管显示2
			4'd3: y <= 8'h0d;//数码管显示3
			4'd4: y <= 8'h99;//数码管显示4
			4'd5: y <= 8'h49;//数码管显示5
			4'd6: y <= 8'h41;//数码管显示6
			4'd7: y <= 8'h1f;//数码管显示7
			4'd8: y <= 8'h01;//数码管显示8
			4'd9: y <= 8'h09;//数码管显示9
		endcase
endmodule 



