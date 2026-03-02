class mix_seq extends base_sequence;
  function new(mailbox#(transaction) seq2drv, ref event seq_done);
    super.new(seq2drv,seq_done);
  endfunction
  task run();
      transaction tx;
    repeat(`TX)
      begin
        tx = new();
        assert (tx.randomize()) else
          $fatal(1, "Randomization failed in mix_seq");
        

  seq2drv.put(tx);
      end
  ->seq_done;
  endtask
endclass
