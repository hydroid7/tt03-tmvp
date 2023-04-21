module bus (
    input clk,
    input rst_n,
    input spi_clk,
    input spi_cs,
    input spi_copi,

    output spi_cipo
);

wire rx_byte_ready;
wire [0:7] rx_byte;
wire [0:7] tx_byte;

spi transmitter(
    .clk(clk),
    .rst_n(rst_n),
    .SCK(spi_clk),
    .CS(spi_cs),
    .COPI(spi_copi),
    .CIPO(spi_cipo),
    .rx_byte_ready(rx_byte_ready),
    .tx_byte(tx_byte),
    .rx_byte(rx_byte)
);

wire cmd_write;
wire cmd_read;
wire cmd_data;
wire [0:15] cpu_data_in;
wire [0:15] cpu_data_out;

// spi_state_machine sm(
//     .clk(clk),
//     .rst_n(rst_n),
//     .rx_byte(rx_byte),
//     .tx_byte(tx_byte),

//     .cmd_write(cmd_write),
//     .cmd_read(cmd_read),
    
//     .cmd_data(cmd_data),
//     .cpu_in(cpu_data_in),
//     .cpu_out(cpu_data_out)
// );

cpu core0 (
  .clk(clk),
  .rst_n(rst_n),
  .data_out(cpu_data_out),
  .data_in(cpu_data_in),
  .data_read(cmd_read)
);

endmodule