class write_seq extends base_sequence;
  function new(mailbox #(transaction) seq2drv, ref event seq_done);
    super.new(seq2drv, seq_done);
  endfunction

  task run();
      transaction tx;
    repeat(`TX)
      begin
        tx = new();
        assert (tx.randomize() with {wr_en == 1; rd_en == 0;}) else
        $fatal(1, "Randomization failed in write_seq");
          seq2drv.put(tx);
      end
   -> seq_done;  
  endtask
endclass
