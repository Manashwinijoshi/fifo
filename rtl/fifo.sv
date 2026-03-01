module fifo #( parameter WIDTH = 8 , parameter DEPTH = 32)(

   input logic clk,
   input logic reset, 
   input logic wr_en,
   input logic rd_en,
   input logic [WIDTH-1:0]d_in,
   output logic [WIDTH-1:0]d_out,
   output logic full,
   output logic empty

);
 
  // caluclation of the addr 
  localparam int ADDR = $clog2(DEPTH);
 
  // fifo memory 
  logic [WIDTH-1:0] MEM [ DEPTH -1: 0]; 
  
  // addr pointers 
  // extra bit for checking the full condition as ptr wraps up
  logic [ADDR:0 ] wr_ptr, rd_ptr;

  always_ff @(posedge clk)
  begin
    if(reset)
         begin
              wr_ptr<='b0;
              rd_ptr<='b0;
              d_out <= 8'b0;
             
         end
     else 
        begin
          if(wr_en && !full)
           begin
             MEM[wr_ptr[ADDR-1:0]] <= d_in;
             wr_ptr <=  wr_ptr + 1; 
           end
          
          if(rd_en && !empty)
            begin
              d_out <= MEM[rd_ptr[ADDR-1:0]];
              rd_ptr <= rd_ptr + 1;              
            end
        end
   

  end

    assign full =  (wr_ptr[ADDR-1:0] == rd_ptr[ADDR - 1:0] && (wr_ptr[ADDR]  != rd_ptr[ADDR]) ); 
    assign empty = (wr_ptr == rd_ptr);
endmodule 
