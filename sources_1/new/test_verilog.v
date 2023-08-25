`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/27 21:11:24
// Design Name: 
// Module Name: test_verilog
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
// tesd
//////////////////////////////////////////////////////////////////////////////////


module test_verilog(
    input clk,
    input SW0,
    input SW14,
    input SW15,
    input btnC,
    output reg LED15,
    output reg JA0,
    output reg [6:0] seg,
	output reg [7:0] an = 8'b0000_0000	
    );
reg [31:0] counter = 32'd00000000;
reg [7:0] counter_sec = 8'd00000000;
reg [7:0] counter_min = 8'd00000000;
reg [7:0] counter_hour = 8'd00000000;
reg [7:0] counter_day = 8'd00000000;
reg [31:0] count_sec = 32'd00000000;
reg [31:0] count_min = 32'd00000000;
reg [31:0] count_hour = 32'd00000000;
reg [31:0] count_day = 32'd00000000;
reg [7:0] counter_an = 8'b00000000;

reg [31:0] dynamic_counter = 32'd00000000;
reg [4:0] dynamic_cycle = 5'd0;
reg [27:0] dynamic_time = 28'd1_000;

reg [31:0] led_counter = 32'd00000000;
reg [4:0] led_cycle = 5'd0;
reg [27:0] led_time = 28'd0;

reg [31:0] disp_number = 28'd7654_3210;
reg [3:0] disp_number_1 = 4'd0;
reg [3:0] an0 = 4'd0;
reg [3:0] an1 = 4'd0;
reg [3:0] an2 = 4'd0;
reg [3:0] an3 = 4'd0;
reg [3:0] an4 = 4'd0;
reg [3:0] an5 = 4'd0;
reg [3:0] an6 = 4'd0;
reg [3:0] an7 = 4'd0;
reg led_cycle = 1'b0;


always @(posedge clk) begin
//    if(SW15) begin
//        LED15 <= 1'b1;
//        dynamic_time <= 27'd10_000;
//        disp_number = count_min;
//    end
//    else begin
//        LED15 <= 1'b0;
//        dynamic_time <= 27'd1_000;
//        disp_number = count_sec;
//    end
    led_time <= 32'd50_000_000;
    
    
    if(SW15) begin
        LED15 <= 1'b1;
        dynamic_time <= 27'd10_000;
        disp_number = counter_sec + counter_min*100 + counter_hour*10000 + count_day*1000000;
    end
    else begin
        LED15 <= 1'b0;
        dynamic_time <= 27'd1_000;
        disp_number = count_sec;
    end
    
    if(SW0) begin
        JA0 <= led_cycle;
    end
    else begin
        JA0 <= 1'b0;
    end

    
    counter <= counter + 32'd1;
    if(counter >= 32'd100_000_000) begin  //1s 32'd100_000_000
        counter <= 32'd0000000;
        counter_sec <= counter_sec + 32'd00000001;
        count_sec <= count_sec + 8'd00000001;
    end
    else if(counter_sec >= 60) begin
        counter_sec <= 32'd0;
        count_min <= count_min + 32'd1;
        counter_min <= counter_min + 8'd1;
    end
    else if(counter_min >= 60) begin
        counter_min <= 32'd0;
        count_hour <= count_hour + 32'd1;
        counter_hour <= counter_hour + 8'd1;
    end
    else if(counter_hour >= 24) begin
        counter_hour <= 32'd0;
        count_day <= count_day + 32'd1;
    end
    else if(btnC) begin
        counter = 32'd00000000;
        counter_sec = 8'd00000000;
        counter_min = 8'd00000000;
        counter_hour = 8'd00000000;
        counter_day = 8'd00000000;
        count_sec = 32'd00000000;
        count_min = 32'd00000000;
        count_hour = 32'd00000000;
        count_day = 32'd00000000;
    end
    
    dynamic_counter <= dynamic_counter + 32'd1;
    if(dynamic_counter > dynamic_time) begin
        dynamic_counter <= 32'd0;
        dynamic_cycle  <= dynamic_cycle  + 5'd1;
    end
    else if(dynamic_cycle > 5'd15) begin
        dynamic_cycle <= 5'd0;
    end

    led_counter <= led_counter + 32'd1;
    if(led_counter > led_time) begin
        led_counter <= 32'd0;
        led_cycle <= ~led_cycle;
    end

    an0 <= disp_number % 28'd10;
    an1 <= (disp_number/28'd10) % 28'd10;
    an2 <= (disp_number/28'd100) % 28'd10;
    an3 <= (disp_number/28'd1000) % 28'd10;
    an4 <= (disp_number/28'd10000) % 28'd10;
    an5 <= (disp_number/28'd100000) % 28'd10;
    an6 <= (disp_number/28'd1000000) % 28'd10;
    an7 <= (disp_number/28'd10000000);

    case(dynamic_cycle)
        4'd0: an  <= 8'b1111_1110;
        4'd2: an  <= 8'b1111_1101;
        4'd4: an  <= 8'b1111_1011;
        4'd6: an  <= 8'b1111_0111;
        4'd8: an  <= 8'b1110_1111;
        4'd10: an  <= 8'b1101_1111;
        4'd12: an  <= 8'b1011_1111;
        4'd14: an  <= 8'b0111_1111;
        default: an  <= 8'b1111_1111;
    endcase    
    
    case(an)
        8'b1111_1110: disp_number_1  <= an0;
        8'b1111_1101: disp_number_1  <= an1;
        8'b1111_1011: disp_number_1  <= an2;
        8'b1111_0111: disp_number_1  <= an3;
        8'b1110_1111: disp_number_1  <= an4;
        8'b1101_1111: disp_number_1  <= an5;
        8'b1011_1111: disp_number_1  <= an6;
        8'b0111_1111: disp_number_1  <= an7;
        default     : disp_number_1  <= an;
    endcase

    case(disp_number_1)
        0: seg <= 7'b1000000;
        1: seg <= 7'b1111001;
        2: seg <= 7'b0100100;
        3: seg <= 7'b0110000;
        4: seg <= 7'b0011001;
        5: seg <= 7'b0010010;
        6: seg <= 7'b0000010;
        7: seg <= 7'b1111000;
        8: seg <= 7'b0000000;
        9: seg <= 7'b0011000;
        default: seg <= 7'b1111111;
    endcase
    
end

endmodule
