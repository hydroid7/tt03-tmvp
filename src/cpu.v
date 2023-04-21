`include "config.v"
module cpu #(parameter MEMORY_SIZE = 2048) (
    input clk,
    input rst_n,
    output [15:0] data_out,
    input  [15:0] data_in,
    input data_read
);

wire [15:0] instruction_data;

// PC wires
wire [15:0] pc;


// Instruction decoder wires
wire [11:0] memory_addr;
wire [15:0] alu_op;
wire [15:0] alu_out;
wire is_immediate;
wire [3:0] alu_opcode;
wire [3:0] fetch_opcode;
wire [3:0] decoder_opcode;
wire is_load_alu;
wire is_load;

wire is_store;

program_counter pc0 (
    .clk(clk),
    .rst(rst_n),
    .pc(pc),
    .instruction(instruction_data)
);

instruction_decoder decoder0 (
    .clk(clk),
    .rst(rst_n),
    .instruction(instruction_data),

    .is_immediate(is_immediate),
    .reg_addr(memory_addr),
    .is_load(is_load),
    .is_store(is_store),
    .alu_op(decoder_opcode)
);

memory_fetch fetch0(
    .clk(clk),
    .rst(rst_n),
    .is_immediate(is_immediate),
    .addr(memory_addr),
    .is_load_in(is_load),
    .is_store_in(is_store),
    .opcode_in(decoder_opcode),
    .data_in(data_in),
    .data_out(data_out),

    .value(alu_op),
    .is_load_out(is_load_alu),
    .opcode_out(alu_opcode),

    .alu_result(alu_out)
);

alu alu0 (
    .clk(clk),
    .rst(rst_n),
    .load(is_load_alu),
    .opcode(alu_opcode),
    .in_val(alu_op),
    .out_val(alu_out)
);

endmodule