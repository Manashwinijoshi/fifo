class write_seq extends base_sequence;
  function new(mailbox #(transaction) seq2drv);
    super.new(seq2drv);
  endfunction

  task run();
      transaction tx;
         tx = new();
        assert (tx.randomize() with {wr_en == 1; rd_en == 0;}) else
                  $fatal(1, "Randomization failed in write_seq");
        
          seq2drv.put(tx);
     endtask
endclass
