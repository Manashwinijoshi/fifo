class underflow_seq extends base_sequence;
  function new(mailbox#(transaction) seq2drv);
    super.new(seq2drv);
  endfunction
  task run();
      transaction tx;
    repeat(8)
      begin
        tx = new();
        assert (tx.randomize() with {
          wr_en dist {1 := 10, 0 := 90};
          rd_en dist {0 := 20, 1 := 80};
      }) else
          $fatal(1, "Randomization failed in underflow_seq");
          seq2drv.put(tx);
      end
  endtask
endclass
