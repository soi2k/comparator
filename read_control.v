`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:
// Design Name:
// Module Name: read_control
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

module read_control
(
    input       pop,    // Yêu cầu xuất dữ liệu, mỗi yêu cầu tích cực trong 1 chu kỳ clock
    input       valid,  // Cờ báo lệnh xuất dữ liệu có hiệu lực
    output reg  rd_en   // Tín hiệu cho phép đọc dữ liệu từ hàng đợi
);

always @ (*) begin
    assign rd_en = pop & valid;
end   

endmodule