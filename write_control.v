`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:
// Design Name:
// Module Name: write_control
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

module write_control
(
    input       push,   // Yêu cầu nạp, mỗi yêu cầu tích cực trong 1 chu kỳ clock
    input       full,   // Cờ báo hàng đợi đầy
    output reg  wr_en   // Tín hiệu cho phép ghi vào hàng đợi
);

always @ (*) begin
    assign wr_en = push & (!full);
end

endmodule