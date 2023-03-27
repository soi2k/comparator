`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:
// Design Name:
// Module Name: comparator
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
module comparator 
#(
    parameter QUEUE_DEPTH = `QUEUE_DEPTH
)
(
    input                   reset_n,    // Tín hiệu reset để thiết lập giá trị mặc định cho các cờ.
    input [QUEUE_DEPTH-1:0] status,     // Thể hiện trạng thái hiện tại của queue. 
    input [QUEUE_DEPTH-1:0] rd_sel,     // Vị trí xuất dữ liệu
    output reg              valid,      // Cờ báo lệnh xuất dữ liệu có hiệu lực
    output reg              empty,      // Cờ báo hàng đợi rỗng
    output reg              full        // Cờ báo hàng đợi đầy
);

	//============================================
	//      Internal signals and variables
	//============================================
    integer i;

    initial begin
        valid <= 0;
        empty <= 1;
        full  <= 0;
    end

    always @(negedge reset_n) begin
        if(~reset_n)
        begin
            valid <= 0;
            empty <= 1;
            full  <= 0;
        end
    end

    always @(*) begin
        full = 1'b1;
        for ( i=0; i<QUEUE_DEPTH; i=i+1) begin
            full = full & status[i];
        end
        if(status == 0)
            begin
                empty <= 1;
                valid <= 0;
            end
            else if((status & rd_sel) != 0)
            begin
                empty <= 0;
                valid <= 1;
            end
            else
            begin
                empty <= 0;
                valid <= 0;
            end
    end
        
endmodule