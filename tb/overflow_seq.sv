class overflow_seq extends base_sequence;
  function new(mailbox#(transaction) seq2drv);
    super.new(seq2drv);
  endfunction
  task run();
      transaction tx;
    repeat(8)
      begin
        tx = new();
        assert (tx.randomize() with {
        wr_en dist {1 := 90, 0 := 10};
        rd_en dist {0 := 80, 1 := 20};
      }) else
          $fatal(1, "Randomization failed in overflow_seq");
          seq2drv.put(tx);
      end
  endtask
endclass
