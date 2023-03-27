`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:
// Design Name:
// Module Name: queue_top
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
`include "../inc/defines.v"

module queue_top 
#(
    parameter QUEUE_DEPTH = `QUEUE_DEPTH,
    parameter DATA_WIDTH = `DATA_WIDTH
)
(
    input                           clk,        // Hoạt động đồng bộ theo sườn dương của clock
    input                           reset_n,    // Tín hiệu reset, tích cực mức THẤP
    input [DATA_WIDTH-1:0]          data_in,    // Dữ liệu vào
    input                           push,       // Yêu cầu nạp, mỗi yêu cầu tích cực trong 1 chu kỳ clock
    input [QUEUE_DEPTH-1:0]         rd_sel,     // Vị trí xuất dữ liệu
    input                           pop,        // Yêu cầu xuất dữ liệu, mỗi yêu cầu tích cực trong 1 chu kỳ clock
    output wire [DATA_WIDTH-1:0]    data_out,   // Dữ liệu xuất
    output wire                     full,       // Cờ báo hàng đợi đầy
    output wire                     empty       // Cờ báo hàng đợi rỗng
);

	//============================================
	//      Internal signals and variables
	//============================================
    wire                    wr_en;  // Tín hiệu cho phép ghi dữ liệu vào hàng đợi
    wire                    rd_en;  // Tín hiệu cho phép đọc dữ liệu từ hàng đợi
    wire [QUEUE_DEPTH-1:0]  status; // Thể hiện trạng thái hiện tại của queue

    queue_core qc(  .clk(clk),.reset_n(reset_n),
                    .rd_sel(rd_sel),.data_in(data_in),
                    .wr_en(wr_en),.rd_en(rd_en),
                    .status(status),.data_out(data_out));

    write_control wr_ctrl(.push(push), .full(full), .wr_en(wr_en));
    read_control rd_ctrl(.pop(pop), .valid(valid), .rd_en(rd_en));

    comparator cmp( .reset_n(reset_n), .status(status), .rd_sel(rd_sel),
                    .valid(valid), .empty(empty), .full(full));
    


endmodule

