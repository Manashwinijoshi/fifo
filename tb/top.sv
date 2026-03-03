`include "test.sv"
module top;

  logic clk;
  logic reset;

  // Clock
  initial clk = 0;
  always #5 clk = ~clk;

  // Reset
  initial begin
    reset = 1;
    #20;
    reset = 0;
  end

  // Interface
fifo_if fifo_if_inst(clk, reset);

  // DUT
  fifo dut (
    .clk   (clk),
    .reset (reset),
    .wr_en (fifo_if_inst.wr_en),
    .rd_en (fifo_if_inst.rd_en),
    .d_in  (fifo_if_inst.d_in),
    .d_out (fifo_if_inst.d_out),
    .full  (fifo_if_inst.full),
    .empty (fifo_if_inst.empty)
  );

  // Test
  initial begin
    test t;
    t = new(fifo_if_inst);
    t.run();
  end

endmodule
