class driver;

  transaction tx;
  mailbox#(transaction) seq2drv;
  virtual inf vinf;
  event next_tr;
  
  function new(
    mailbox#(transaction) seq2drv,
    virtual inf.DRV vinf,
    event next_tr
  );
    this.seq2drv = seq2drv;
    this.vinf    = vinf;
    this.next_tr = next_tr;
  endfunction

 task run();
  forever begin
    wait(!vinf.reset);
    seq2drv.get(tx);
    drive();
    -> next_tr;
    @(vif.drv_cb);
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
  vinf.drv_cb.d_in  <='0;
  endtask

endclass
