class mix_seq extends base_sequence;
  function new(mailbox#(transaction) seq2drv);
    super.new(seq2drv);
  endfunction
  task run();
      transaction tx;
    repeat(8)
      begin
        tx = new();
        assert (tx.randomize()) else
          $fatal(1, "Randomization failed in mix_seq");
          seq2drv.put(tx);
      end
  endtask
endclass
