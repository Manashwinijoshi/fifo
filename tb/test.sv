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
  
  function new(virtual inf vinf);
    env = new(vinf,next_tr);
  endfunction

  task run();
    
     env.run();
     wait(env.sqr.finish);
     #1;
     env.sb.report();
     $finish;

 endtask
endclass
