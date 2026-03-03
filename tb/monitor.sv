class monitor;

  transaction tx;
  virtual inf vinf;
  mailbox #(transaction) mon2sb;
  event next_tr;

  function new(mailbox #(transaction) mon2sb,
               virtual inf vinf, event next_tr);
    this.mon2sb = mon2sb;
    this.vinf   = vinf;
    this.next_tr = next_tr;
  endfunction

  task run();
    forever begin
     /* @(posedge vinf.clk);
      @(negedge vinf.clk);*/
       @(vinf.mon_cb);
         
      tx = new();

    
      tx.wr_en = vinf.mon_cb.wr_en;
      tx.rd_en = vinf.mon_cb.rd_en;
      tx.d_in  = vinf.mon_cb.d_in;
      tx.full  = vinf.mon_cb.full;
      tx.empty = vinf.mon_cb.empty;
      tx.d_out = vinf.mon_cb.d_out;

      mon2sb.put(tx);
      
      ->next_tr;
    end
  endtask

endclass
