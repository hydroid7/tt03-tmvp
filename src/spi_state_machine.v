`default_nettype none

module spi_state_machine #(
    parameter word_bits = 16
  )(

  input resetn,
  // Bus Interface
  input wire [word_bits-1:0] word_data_received,
  output reg [word_bits-1:0] word_send_data,
  input wire word_received,
  input CLK,
  input pwm_clock
);


  end else if (resetn) begin
    if (word_received_rising) begin
      // Zero out send data register
      word_send_data <= 64'b0;

      // Header Processing
      if (!awaiting_more_words) begin

        // Save CMD header incase multi word transaction
        message_header <= word_data_received[word_bits-1:word_bits-8]; // Header is 8 MSB

        message_word_count <= 1;

        case (word_data_received[word_bits-1:word_bits-8])

          // Coordinated Move
          CMD_COORDINATED_STEP: begin

            // Get Direction Bits
            dir_r[writemoveind] <= word_data_received[num_motors-1:0];
          end

          CMD_STATUS_REG: begin
            dma_addr <= word_data_received[7:0];
            word_send_data <= status_reg_ro[word_data_received[32:0]];
          end

          CMD_CONFIG_REG: begin
            dma_addr <= word_data_received[7:0];
            word_send_data <= config_reg_rw[word_data_received[32:0]];
          end

          default: word_send_data <= 64'b0;

        endcase

      // Addition Word Processing
      end else begin

        message_word_count <= message_word_count + 1'b1;

        case (message_header)

          // Move Routine
          CMD_COORDINATED_STEP: begin
            word_send_data <= telemetry_reg_ro[message_word_count-1]; // Prep to send steps
            command_reg_rw[writemoveind][message_word_count] <= word_data_received;
            if (message_word_count == num_motors*2 + 1) begin
              message_header <= 8'b0; // Reset Message Header at the end
              message_word_count <= 0;
              writemoveind <= writemoveind + 1'b1;
              stepready[writemoveind] <= ~stepready[writemoveind];
            end
          end // `CMD_COORDINATED_STEP

          CMD_CONFIG_REG: begin
            config_reg_rw[dma_addr] <= word_data_received[31:0];
            message_header <= 8'b0;
          end

          // by default reset the message header if it was a two word transaction
          default: message_header <= 8'b0; // Reset Message Header

        endcase
      end
    end
  end

endmodule
