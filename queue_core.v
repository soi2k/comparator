`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:
// Design Name:
// Module Name: queue_core
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

module queue_core 
#(
    parameter QUEUE_DEPTH = `QUEUE_DEPTH,
    parameter DATA_WIDTH = `DATA_WIDTH,
    parameter ADDR_WIDTH = $clog2(QUEUE_DEPTH)  // Số bit cần thiết để lưu trữ địa chỉ của phần tử trong hàng đợi
)
(
    input                           clk,        // Hoạt động đồng bộ theo sườn dương của clock
    input                           reset_n,    // Tín hiệu reset, tích cực mức THẤP
    input [QUEUE_DEPTH-1:0]         rd_sel,     // Vị trí xuất dữ liệu
    input [DATA_WIDTH-1:0]          data_in,    // Dữ liệu vào
    input                           wr_en,      // Tín hiệu cho phép ghi dữ liệu vào hàng đợi
    input                           rd_en,      // Tín hiệu cho phép đọc dữ liệu từ hàng đợi
    output reg [QUEUE_DEPTH-1:0]    status,     // Thể hiện trạng thái hiện tại của queue
    output reg [DATA_WIDTH-1:0]     data_out   // Dữ liệu xuất
);

	//============================================
	//      Internal signals and variables
	//============================================

	reg [DATA_WIDTH-1:0] queue[0:QUEUE_DEPTH-1];    // Mảng lưu trữ dữ liệu trong hàng đợi
    reg [ADDR_WIDTH-1:0] wr_ptr;                    // Con trỏ ghi -> vị trí ghi dữ liệu tiếp theo trong hàng đợi
                                                    // Do hàng đợi bắt đầu từ địa chỉ 0 nên giá trị ptr
                                                    // chính là số phần tử chứa dữ liệu có trong hàng đợi
    reg [ADDR_WIDTH-1:0] rd_ptr;                    // Con trỏ đọc -> vị trí đọc dữ liệu trong hàng đợi       
    integer i;

    initial begin
        status <= 0;
        wr_ptr <= 0;
    end

    // Chuyển đổi one-hot -> giá trị của vị trí bit 1
    always @(*) begin
        for (i = 0; i < QUEUE_DEPTH; i = i + 1) begin
        if (rd_sel[i] == 1'b1)
        begin
            rd_ptr = i; // Gán giá trị số nguyên bằng vị trí bit 1
        end
        end
    end

    always @(posedge clk or negedge reset_n) begin
        if(~reset_n) begin
            status <= 0;
        end
        else begin
            if(wr_en)
            begin
                queue[wr_ptr] = data_in;
                status = status | (1 << wr_ptr);
                wr_ptr = wr_ptr + 1;
            end
            if(rd_en) 
            begin
                data_out = queue[rd_ptr];
                // Dồn dữ liệu về phía đầu và đặt lại con trỏ ghi
                wr_ptr = wr_ptr - 1;
                for ( i=rd_ptr; i<QUEUE_DEPTH; i=i+1) begin
                    if(i < wr_ptr)
                    begin
                        queue[i] = queue[i+1];
                    end
                    else
                    begin
                        queue[i] = 'bx;
                    end
                end
                status = status & (~(1 << wr_ptr));
            end
            
        end
    end
    
endmodule