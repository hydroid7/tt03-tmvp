//////////////////////////////////////////////////
// Implicit BRAM that can be inferred by yosys.
// The RAM contains 2 read/write ports
// The design pipelines input and output for f_max
//////////////////////////////////////////////////
`include "rtl/config.v"
module bram #(
    parameter SIZE=4096,
    parameter DATA_WIDTH=16,
    parameter ADDR_WIDTH=$clog2(SIZE),
    parameter ENABLE_INIT=0,
    parameter INIT_FILE=""
)(
    input                            clk,
    input [ADDR_WIDTH - 1:0]         addr_a,
    output reg [DATA_WIDTH - 1:0]    q_a,
    input                            we_a,
    input [DATA_WIDTH - 1:0]         data_a,
    input [ADDR_WIDTH - 1:0]         addr_b,
    output reg [DATA_WIDTH - 1:0]    q_b,
    input                            we_b,
    input [DATA_WIDTH - 1:0]         data_b
);

    reg [DATA_WIDTH - 1:0] data [0:SIZE - 1];
    integer i;
    initial begin
        for (i = 0; i < SIZE; i = i + 1)
            data[i] = 0;
            
        q_a = 0;
        q_b = 0;
        
        if (ENABLE_INIT)
            $readmemh(INIT_FILE, data);
    end

    // Port A
    always @(posedge clk)
    begin
        if (we_a) begin
            data[addr_a] <= data_a;     
            q_a <= data_a;
        end else begin
            q_a <= data[addr_a];
        end
    end

    // Port B
    always @(posedge clk)
    begin
        if (we_b) begin
            data[addr_b] <= data_b;     
            q_b <= data_b;
        end else begin
            q_b <= data[addr_b];
        end
    end
endmodule