`include "rtl/library/opcodes.v"

module alu #(
    parameter INT_SIZE=16
) (
    input clk,
    input rst,

    input wire load,
    input wire [15:0] in_val,
    input wire [3:0] opcode,

    output reg [15:0] out_val
);

reg [15:0] acc;

always @(posedge clk) begin
    if (!rst) begin
        out_val <= 0;
        acc <= 0;
        out_val <= 0;
    end else if(load) begin
        acc <= in_val;
    end else begin
        // Regular arithmetic op
        case (opcode)
            `ALU_ADD:
                acc <= acc + in_val;
            `ALU_MUL:
                acc <= acc * in_val; 
            default: 
                acc <= acc;
        endcase
        out_val <= acc;
    end
end

endmodule