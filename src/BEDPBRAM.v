//
// verilog that synthesizes to Byte Enabled Dual Port RAM
//

`default_nettype none
`define DBG
`define INFO

module BEDPBRAM #(
    parameter ADDRESS_BITWIDTH = 16,
    parameter DATA_BITWIDTH = 32,
    parameter DATA_COLUMN_BITWIDTH = 8
) (
    // port A
    input wire a_clk,
    input wire [3:0] a_write_enable,
    input wire [ADDRESS_BITWIDTH-1:0] a_address,
    output reg [DATA_BITWIDTH-1:0] a_data_out,
    input wire [DATA_BITWIDTH-1:0] a_data_in,

    // port B
    input wire b_clk,
    input wire [3:0] b_write_enable,
    input wire [ADDRESS_BITWIDTH-1:0] b_address,
    output reg [DATA_BITWIDTH-1:0] b_data_out,
    input wire [DATA_BITWIDTH-1:0] b_data_in
);

  reg [DATA_BITWIDTH-1:0] a_data[2**ADDRESS_BITWIDTH-1:0];
  reg [DATA_BITWIDTH-1:0] b_data[2**ADDRESS_BITWIDTH-1:0];

  integer i;

  always @(posedge a_clk) begin
    for (i = 0; i < 4; i = i + 1) begin
      if (a_write_enable[i]) begin
        a_data[a_address][
          (i+1)*DATA_COLUMN_BITWIDTH-1
          -:DATA_COLUMN_BITWIDTH
        ] <= a_data_in[(i+1)*DATA_COLUMN_BITWIDTH-1-:DATA_COLUMN_BITWIDTH];
      end
    end
    a_data_out <= a_data[a_address];
  end

  always @(posedge b_clk) begin
    for (i = 0; i < 4; i = i + 1) begin
      if (b_write_enable[i]) begin
        b_data[b_address][
          (i+1)*DATA_COLUMN_BITWIDTH-1
          -:DATA_COLUMN_BITWIDTH
        ] <= b_data_in[(i+1)*DATA_COLUMN_BITWIDTH-1-:DATA_COLUMN_BITWIDTH];
      end
    end
    b_data_out <= b_data[b_address];
  end

endmodule

`undef DBG
`undef INFO
`default_nettype wire
