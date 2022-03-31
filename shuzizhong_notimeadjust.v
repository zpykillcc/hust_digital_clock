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
	//����˵����
	//clk_100M��100M��ʱ���ź�select�ǿ��������������ʹ�ܶˣ�y���߶��������������
	//count���ڼ�¼ʱ���߹���������clk_1hz�Ƿ�Ƶ��1hz��ʱ���ź�
	//s0~h1��¼�롢�֡�ʱ�ĸ�ʮλ
	
	//��Ƶ�����1hz��1khzʱ���źţ������������Ϊwire��
	frequency_divider fred(clk_1hz, clk_1khz, clk_100M);
	//��ʱģ��,ÿ24*60*60��Ϊһ��
	initial count = 0;
	always@(posedge clk_1hz)
		begin
			if(count != 17'd86399)
				count <= count + 1;
			else count <= 0;
		end
	//��õ�ǰʱ���ʱ�����λ��
	time_count t(count, s0, s1, m0, m1, h0, h1);
	
	
	//��ȡ��ǰʱ���ʱ�����λ�����߶�����ֵ
	wire[7:0] y0, y1, y2, y3, y4, y5;
	decoder4_8 d1(s0, y0);
	decoder4_8 d2(s1, y1);
	decoder4_8 d3(m0, y2);
	decoder4_8 d4(m1, y3);
	decoder4_8 d5(h0, y4);
	decoder4_8 d6(h1, y5);

		
	//����ܸ�Ƶ��ʾ��ǰСʱ�����Ӻ���
	reg[2:0] flag;//flag�൱��ģ6����������Ӧʱ�������λ��
	initial
		begin 
			flag = 0;
			y = 0;
			select = 0;
		end
	always@(posedge clk_1khz) flag = (flag+1)%6;
	always@(flag)
		begin
			if(flag == 3'd0)//��ʾ��ĸ�λ
				begin
					select <= 8'b1111_1110;
					y <= y0;
				end
			if(flag == 3'd1)//��ʾ���ʮλ
				begin
					select <= 8'b1111_1101;
					y <= y1;
				end
			if(flag == 3'd2)//��ʾ���ӵĸ�λ
				begin
					select <= 8'b1111_1011;
					y <= y2;
				end
			if(flag == 3'd3)//��ʾ���ӵ�ʮλ
				begin
					select <= 8'b1111_0111;
					y <= y3;
				end
			if(flag == 3'd4)//��ʾСʱ�ĸ�λ
				begin
					select <= 8'b1110_1111;
					y <= y4;
				end
			if(flag == 3'd5)//��ʾСʱ��ʮλ
				begin
					select <= 8'b1101_1111;
					y <= y5;
				end
		end	
endmodule
	


//�߶�������
module decoder4_8(x, y);
	input[3:0] x;
	output[7:0] y;
	reg[7:0] y;
	
	always@(x)
		case(x)
			4'd0: y <= 8'h03;//�������ʾ0
			4'd1: y <= 8'h9f;//�������ʾ1
			4'd2: y <= 8'h25;//�������ʾ2
			4'd3: y <= 8'h0d;//�������ʾ3
			4'd4: y <= 8'h99;//�������ʾ4
			4'd5: y <= 8'h49;//�������ʾ5
			4'd6: y <= 8'h41;//�������ʾ6
			4'd7: y <= 8'h1f;//�������ʾ7
			4'd8: y <= 8'h01;//�������ʾ8
			4'd9: y <= 8'h09;//�������ʾ9
		endcase
endmodule 



