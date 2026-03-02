class driver;

  transaction tx;
  mailbox#(transaction) seq2drv;
  virtual inf vinf;
  function new(
    mailbox#(transaction) seq2drv,
    virtual inf.DRV vinf
  );
    this.seq2drv = seq2drv;
    this.vinf    = vinf;
  endfunction

  task run();
    forever begin
      seq2drv.get(tx);
      @(vinf.drv_cb);
      drive();
    end
  endtask

  task drive();
    vinf.drv_cb.wr_en <= tx.wr_en;
  vinf.drv_cb.rd_en <= tx.rd_en;
  if(tx.wr_en)
    vinf.drv_cb.d_in <= tx.d_in;
  @(vinf.drv_cb);          // wait one cycle
  vinf.drv_cb.wr_en <= 0;  // deassert after driving
  vinf.drv_cb.rd_en <= 0;
  endtask

endclass
