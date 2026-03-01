interface fifo_if(input logic clk,reset);

logic wr_en;
logic rd_en;
logic [7:0]d_in;
logic [7:0]d_out;
logic full;
logic empty;

  clocking drv_cb @(posedge clk)
    default input #1step output #1step;
    output wr_en;
    output rd_en;
    output d_in;
  endclocking

   clocking mon_cb @(posedge clk)
      default input #1step;
      input wr_en;
      input rd_en;
      input d_in;
      input d_out;
      input full;
      input empty;
  endclocking

    modport DRV (input clk, input reset, clocking drv_cb);
    modport MON ( input clk, input reset, clocking mon_cb);

   
endinterface
