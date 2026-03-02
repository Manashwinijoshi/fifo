class underflow_seq extends base_sequence;

  function new(mailbox #(transaction) seq2drv,
               ref event seq_done);
    super.new(seq2drv, seq_done);
  endfunction


  task run();
    transaction tx;

    repeat (`TX) begin
      tx = new();

      assert (tx.randomize() with {
        wr_en dist {1 := 10, 0 := 90};
        rd_en dist {1 := 80, 0 := 20};
      })
      else
        $fatal(1, "Randomization failed in underflow_seq");

      seq2drv.put(tx);
    end

    // ⭐ Notify sequence completion
    -> seq_done;

  endtask

endclass
