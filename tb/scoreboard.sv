class scoreboard;
  mailbox#(transaction) mon2sb;
  mailbox#(transaction) drv2sb;
  
  transaction mon_tr, drv_tr;
  bit [7:0] que[$];
  
  int pass_count = 0;
  int fail_count = 0;
  
  parameter FIFO_DEPTH = 8; // set your FIFO depth here

  function new(mailbox#(transaction) mon2sb, mailbox#(transaction) drv2sb);
    this.mon2sb = mon2sb;
    this.drv2sb = drv2sb;
  endfunction

  task run();
    forever begin
      drv2sb.get(drv_tr);
      mon2sb.get(mon_tr);

      // ---- WRITE CHECK ----
      if (drv_tr.wr_en && !drv_tr.full) begin
        que.push_back(drv_tr.d_in);
        
        if (mon_tr.d_in !== drv_tr.d_in) begin
          $error("[SB - WR] Write mismatch! DRV: 0x%0h | MON: 0x%0h",
                  drv_tr.d_in, mon_tr.d_in);
          fail_count++;
        end else begin
          $display("[SB - WR] Write OK | Data: 0x%0h | Queue size: %0d",
                    drv_tr.d_in, que.size());
          pass_count++;
        end
      end

      // ---- READ CHECK ----
      if (drv_tr.rd_en && !drv_tr.empty) begin
        if (que.size() == 0) begin
          $error("[SB - RD] Underflow! Queue empty but read requested");
          fail_count++;
        end else begin
          bit [7:0] expected = que.pop_front();
          
          if (expected !== mon_tr.d_out) begin
            $error("[SB - RD] MISMATCH | Expected: 0x%0h | DUT Out: 0x%0h",
                    expected, mon_tr.d_out);
            fail_count++;
          end else begin
            $display("[SB - RD] PASS | Expected: 0x%0h | DUT Out: 0x%0h | Queue size: %0d",
                      expected, mon_tr.d_out, que.size());
            pass_count++;
          end
        end
      end

      // ---- EMPTY FLAG CHECK ----
      // After all operations, queue size == 0 means we expect empty=1
      begin
        bit expected_empty = (que.size() == 0) ? 1'b1 : 1'b0;
        
        if (mon_tr.empty !== expected_empty) begin
          $error("[SB - EMPTY] MISMATCH | Expected empty=%0b | DUT empty=%0b | Queue size: %0d",
                  expected_empty, mon_tr.empty, que.size());
          fail_count++;
        end else begin
          $display("[SB - EMPTY] OK | empty=%0b | Queue size: %0d",
                    mon_tr.empty, que.size());
          pass_count++;
        end
      end

      // ---- FULL FLAG CHECK ----
      // Queue size == FIFO_DEPTH means we expect full=1
      begin
        bit expected_full = (que.size() == FIFO_DEPTH) ? 1'b1 : 1'b0;
        
        if (mon_tr.full !== expected_full) begin
          $error("[SB - FULL] MISMATCH | Expected full=%0b | DUT full=%0b | Queue size: %0d",
                  expected_full, mon_tr.full, que.size());
          fail_count++;
        end else begin
          $display("[SB - FULL] OK | full=%0b | Queue size: %0d",
                    mon_tr.full, que.size());
          pass_count++;
        end
      end

    end
  endtask

  function void report();
    $display("===========================================");
    $display("  SCOREBOARD REPORT");
    $display("  PASS: %0d | FAIL: %0d", pass_count, fail_count);
    if (fail_count == 0)
      $display("  RESULT: ALL TESTS PASSED ✓");
    else
      $display("  RESULT: %0d FAILURES DETECTED ✗", fail_count);
    $display("===========================================");
  endfunction

endclass
