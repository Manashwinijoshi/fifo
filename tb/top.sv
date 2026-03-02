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
  inf fifo_if(clk, reset);

  // DUT
  fifo dut (
    .clk   (clk),
    .reset (reset),
    .wr_en (fifo_if.wr_en),
    .rd_en (fifo_if.rd_en),
    .d_in  (fifo_if.d_in),
    .d_out (fifo_if.d_out),
    .full  (fifo_if.full),
    .empty (fifo_if.empty)
  );

  // Test
  initial begin
    test t;
    t = new(fifo_if);
    t.run();
  end

endmodule
