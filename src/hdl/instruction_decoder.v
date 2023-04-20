`include "rtl/library/opcodes.v"

module instruction_decoder (
    input clk,
    input rst,
    input wire [15:0] instruction,

    output reg [3:0] alu_op,
    output reg is_immediate,
    output reg [11:0] reg_addr,
    output reg is_load,
    output reg is_store
);

wire [3:0] opcode = instruction[15:12];
wire [11:0] addr = instruction[11:0];


always @(posedge clk) begin
    if(!rst) begin
        alu_op <= 0;
        is_immediate <= 0;
        reg_addr <= 0;
        is_load <= 0;
        is_store <= 0;
    end else begin
        // alu_op <= opcode;
        case (opcode)
            `ADD, `ADDI:
                alu_op <= `ALU_ADD;
            `MUL, `MULI:
                alu_op <= `ALU_MUL;
            `JMPZR:
                alu_op <= `ALU_JMP;
            default: 
                alu_op <= `ALU_NOP;
        endcase
        is_immediate <= (opcode == 'h7 || opcode == 'h8 || opcode == 'h1);
        reg_addr <= addr;
        is_load <= (opcode == 'h5 || opcode == 'h1);
        is_store <= (opcode == 'h4);
    end
end

endmodule