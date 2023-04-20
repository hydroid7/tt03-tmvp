////////////////////////////////////////////////
// Simple program counter without any jumps   //
////////////////////////////////////////////////
`include "rtl/config.v"
module program_counter (
    input wire clk,
    input wire rst,
    output reg [15:0] pc,
    output reg [15:0] instruction
);

reg [15:0] counter;
reg [15:0] pmem [0:15];
reg halt;

assign pc = counter;

initial begin
    $readmemh("./pmem.hex", pmem);    
end

always @(posedge clk) begin
    if (!rst) begin
        counter <= 0;
        instruction <= 0;
        halt <= 0;
    end else begin
        if (pmem[counter] == 'hffff) begin
            halt <= 1;
            counter <= counter + 1;
            instruction <= pmem[counter];
        end else if (!halt) begin
            counter <= counter + 1;
            instruction <= pmem[counter];
        end
    end
end

endmodule