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
      seq2drv.get(tx);
			vinf.drv_cb.rd_en<=tx.rd_en;
			vinf.drv_cb.wr_en<=tx.wr_en;
			vinf.drv_cb.d_in<=tx.d_in;
			->next_tr;
      @(vinf.drv_cb);
		end
	endtask:run

endclass
