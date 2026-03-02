class base_sequence;

  mailbox #(transaction) seq2drv;
   event seq_done;
  function new(mailbox #(transaction) seq2drv, ref event seq_done);
    this.seq2drv = seq2drv;
    this.seq_done = seq_done;

  endfunction

  virtual task run();
   
  endtask

endclass
