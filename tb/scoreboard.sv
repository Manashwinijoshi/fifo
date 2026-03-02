class scoreboard;

  mailbox#(transaction) mon2sb;

  transaction mon_tr;

  bit [7:0] ref_queue[$];

  int pass_count = 0;
  int fail_count = 0;

  parameter FIFO_DEPTH = 8;

  function new(mailbox#(transaction) mon2sb);
    this.mon2sb = mon2sb;
  endfunction

  task run();
    forever begin

      mon2sb.get(mon_tr);

      // ---------------- WRITE ----------------
      if(mon_tr.wr_en) begin

        if(ref_queue.size() == FIFO_DEPTH) begin
          if(!mon_tr.full) begin
            $error("FULL flag mismatch");
            fail_count++;
          end
        end
        else begin
          if(mon_tr.full) begin
            $error("FULL flag mismatch");
            fail_count++;
          end

          ref_queue.push_back(mon_tr.d_in);
        end
      end

      if(mon_tr.rd_en) begin

        if(ref_queue.size() == 0) begin
          if(!mon_tr.empty) begin
            $error("EMPTY flag mismatch");
            fail_count++;
          end
        end
        else begin
          if(mon_tr.empty) begin
            $error("EMPTY flag mismatch");
            fail_count++;
          end

          bit [7:0] expected = ref_queue.pop_front();

          if(expected !== mon_tr.d_out) begin
            $error("DATA MISMATCH");
            fail_count++;
          end
          else begin
            pass_count++;
          end
        end
      end

    end
  endtask

  function void report();
    $display("PASS = %0d | FAIL = %0d", pass_count, fail_count);
    if(fail_count == 0)
      $display("ALL TESTS PASSED ✓");
  endfunction

endclass
