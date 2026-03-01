class read_seq extends base_sequence;
  function new(mailbox#(transaction) seq2drv);
    super.new(seq2drv);
  endfunction
  task run();
      transaction tx;
    repeat(8)
      begin
        tx = new();
        assert (tx.randomize() with {wr_en == 0; rd_en == 1;}) else
        $fatal(1, "Randomization failed in read_seq");
          seq2drv.put(tx);
      end
  endtask
endclass
