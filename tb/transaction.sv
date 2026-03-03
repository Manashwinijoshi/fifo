class transaction;

   rand logic wr_en;
   rand logic rd_en;
   rand logic [7:0]d_in;
   logic [7:0]d_out;
   logic full;
   logic empty;

   function void display(string parent="");
          $display("[%s] wr=%0b rd=%0b din=%0h dout=%0h full=%0b empty=%0b",
            parent, wr_en, rd_en, d_in, d_out, full, empty);
   endfunction

endclass
