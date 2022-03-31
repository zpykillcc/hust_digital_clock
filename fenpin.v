`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:51:31 03/31/2022 
// Design Name: 
// Module Name:    fenpin 
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
//��Ƶ�õ�1khz��1hz
module frequency_divider(clk_1hz, clk_100M);
	input clk_100M;
	output clk_1hz;
	reg[16:0] count1;
	reg[9:0] count2;
	reg clk_1khz, clk_1hz;
	//����˵����
	//����clk_100MΪ100M��ʱ���ź�
	//count1��count2�Ƿ�Ƶ���Ƶ���������clk_1khz��clk_1hz�Ƿ�Ƶ�������
	//�м����������Դ�����г�ʼ��
	initial 
		begin
			count1 = 0;
			count2 = 0;
			clk_1khz = 0;
			clk_1hz = 0;
		end

	//100M 100000��Ƶ�õ�1khz
	always@(posedge clk_100M)
		begin
			if(count1 == 17'd49999)
				begin
					clk_1khz <= ~clk_1khz;
					count1 <= 0;
				end
			else count1 <= count1 + 1;
		end
	
	//1khz 1000��Ƶ�õ�1hz
	always@(posedge clk_1khz)
		begin
			if(count2 == 10'd499)
				begin
					clk_1hz <= ~clk_1hz;
					count2 <= 0;
				end
			else count2 <= count2 + 1;
		end
endmodule 
