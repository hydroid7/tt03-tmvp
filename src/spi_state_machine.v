`default_nettype none

module spi_state_machine(
  input clk,
  input rst_n,
  // Bus Interface
  input [0:7] rx_byte,
  output [0:7] tx_byte,

  output cmd_write,
  output cmd_read,

  output read_addr
);

endmodule
