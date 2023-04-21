`default_nettype none
`timescale 1ns/1ps

/*
this testbench just instantiates the module and makes some convenient wires
that can be driven / tested by the cocotb test.py
*/

module tb;

    input clk;
    input rst_n;
    input spi_clk;
    input spi_cs;
    input spi_copi;
    output spi_cipo;
    // this part dumps the trace to a vcd file that can be viewed with GTKWave
    initial begin
        $dumpfile ("tb.vcd");
        $dumpvars (0, tb);
        #1;
    end

    // wire up the inputs and outputs
    wire [7:0] inputs = {6'b0, rst_n, clk};
    wire [7:0] outputs;

    // instantiate the DUT
    bus bus0(
        .clk(clk),
        .rst_n(rst_n),
        .spi_clk(spi_clk),
        .spi_cs(spi_cs),
        .spi_copi(spi_copi)
    );

endmodule
