module memory_fetch (
    input wire clk,
    input wire rst,
    input wire is_immediate,
    input wire [11:0] addr,
    input wire is_load_in,
    input wire is_store_in,
    input wire [3:0] opcode_in,
    input wire [15:0] data_in,
    output reg [15:0] data_out,
    input wire [15:0] alu_result,

    output reg [15:0] value,
    output reg is_load_out,
    output reg [3:0] opcode_out
);

reg [15:0] registers [0:31];

reg [1:0] store_history = 4'b0000;
reg [11:0] addr_history [1:0];

`ifdef FPGA
initial begin
    $readmemh("./registers.hex", registers);
    addr_history[0] = 'b0;
    addr_history[1] = 'b0;
end
`endif

always @(posedge clk) begin
    if (!rst) begin
        value <= 0;
        is_load_out <= 0;
        opcode_out <= 0;
    end else begin
        data_out <= registers[31];
        if(addr == 0)
            value <= data_in;
        else
            value <= (is_immediate ? {4'b0, addr} : registers[addr]);
        is_load_out <= is_load_in; 
        opcode_out <= opcode_in;

        // For the record...
        store_history <= {store_history[0], is_store_in};
        addr_history[0] <= addr_history[1];
        addr_history[1] <= addr;

        if (store_history[0]) begin
            $strobe("Writeback: %h => %h", alu_result, addr_history[0]);
            registers[addr_history[1]] <= alu_result;
        end
    end
end

endmodule