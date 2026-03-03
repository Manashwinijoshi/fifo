class scoreboard;
  mailbox #(transaction) mon2sb;
  transaction mon_tr;

  int pass_count = 0, fail_count = 0;
  bit [7:0] ref_queue[$];

  parameter int FIFO_DEPTH = 32;

  function new(mailbox #(transaction) mon2sb);
    this.mon2sb = mon2sb;
  endfunction

  task run();
    bit [7:0] expected;
    forever begin
      mon2sb.get(mon_tr);

          // ---------------- WRITE ----------------
      if (mon_tr.wr_en) begin
          if (!mon_tr.full) begin
         
                 ref_queue.push_back(mon_tr.d_in);
                 $display("WRITE PASS  : Data = %0d", mon_tr.d_in);
          pass_count++;
        end
        else begin
          $error("WRITE BLOCKED - FIFO FULL");
          fail_count++;
        end
      end

      // ---------------- READ ----------------
      if (mon_tr.rd_en) begin
         if (ref_queue.size() == 0) begin
          if (!mon_tr.empty) begin
            $error("EMPTY flag mismatch");
            fail_count++;
          end
        end
        else begin
          expected = ref_queue.pop_front();
        
          if (expected !== mon_tr.d_out) begin
            $display("Expected=%0d Got=%0d", expected, mon_tr.d_out);
            $error("DATA MISMATCH");
          
            fail_count++;
          end
          else begin
            $display("READ PASS   : Data = %0d", mon_tr.d_out);
            pass_count++;
          end
        end
      end
    end
  endtask

  function void report();
    $display("================================");
    $display("TOTAL PASS = %0d", pass_count);
    $display("TOTAL FAIL = %0d", fail_count);
    if (fail_count == 0)
      $display("ALL TESTS PASSED");
    $display("================================");
  endfunction

endclass
