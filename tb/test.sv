class test;

  environment env;
  write_seq seq;

  function new(virtual inf vif);
    env = new(vif);
    seq = new(env.seq2drv);
  endfunction
  task run();
     fork
       env.run();
     join_none
    seq.run();
    #1000;
    env.sb.report();
    $finish;
  endtask
endclass
