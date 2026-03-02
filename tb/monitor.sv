class monitor;

  transaction tx;
  virtual inf.MON vinf;
  mailbox #(transaction) mon2sb;

  function new(mailbox #(transaction) mon2sb,
               virtual inf.MON vinf);
    this.mon2sb = mon2sb;
    this.vinf   = vinf;
  endfunction

  task run();
    forever begin
      @(vinf.mon_cb);

      tx = new();

      // Sample control + input signals immediately
      tx.wr_en = vinf.mon_cb.wr_en;
      tx.rd_en = vinf.mon_cb.rd_en;
      tx.d_in  = vinf.mon_cb.d_in;
      tx.full  = vinf.mon_cb.full;
      tx.empty = vinf.mon_cb.empty;
      tx.d_out = vinf.mon_cb.d_out;

      mon2sb.put(tx);
    end
  endtask

endclass
