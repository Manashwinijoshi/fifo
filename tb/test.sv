`include "interface.sv"
`include "transaction.sv"
`include "base_sequence.sv"
`include "mix_seq.sv"
`include "write_seq.sv"
`include "underflow_seq.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
`include "environment.sv"

class test;
  event next_tr;
  environment env;
  
  function new(virtual inf vif);
    env = new(vif,sb_done);
  endfunction

  task run();
     fork
       env.run();
       seq.run();
     join_none
  
  
 @done;
 @sb_done;
  env.sb.report();
  $finish;
  endtask
endclass
