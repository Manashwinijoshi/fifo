class base_sequence;

  mailbox #(transaction) seq2drv;

  function new(mailbox #(transaction) seq2drv);
    this.seq2drv = seq2drv;
  endfunction

  virtual task run();
   
  endtask

endclass
