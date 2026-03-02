class environment;
  driver drv;
  monitor mon;
  scoreboard sb;
  event sb_done;
  
  mailbox#(transaction) seq2drv;
  mailbox#(transaction) mon2sb;

  virtual inf vinf;

  function new(virtual inf vinf,event sb_done);
    this.vinf = vinf ;
    this.sb_done = sb_done;
    seq2drv = new();
    mon2sb = new();
    drv = new(seq2drv,vinf);
    mon = new(mon2sb,vinf);
    sb = new(mon2sb,sb_done);
  endfunction 

  task run();
   fork 
     drv.run();
     mon.run();
     sb.run();
  join_none
  endtask
endclass
