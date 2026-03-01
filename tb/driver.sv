class driver;

  transaction tx;

  mailbox#(transaction) seq2drv;
  mailbox#(transaction) drv2sb;

  virtual inf.DRV vinf;

  function new(
    mailbox#(transaction) seq2drv,
    mailbox#(transaction) drv2sb,
    virtual inf.DRV vinf
  );
    this.seq2drv = seq2drv;
    this.drv2sb  = drv2sb;
    this.vinf    = vinf;
  endfunction

  task run();
    forever begin
      seq2drv.get(tx);
      @(vinf.drv_cb);
      drive();
      drv2sb.put(tx);
    end
  endtask

  task drive();
    vinf.drv_cb.wr_en <= tx.wr_en;
    vinf.drv_cb.rd_en <= tx.rd_en;

    if(tx.wr_en)
      vinf.drv_cb.d_in <= tx.d_in;
  endtask

endclass
