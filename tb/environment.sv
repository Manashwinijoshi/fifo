class environment;
  driver drv;
  monitor mon;
  scoreboard sb;
  sequencer sqr;
  
  event next_tr;
  
  mailbox#(transaction) seq2drv;
  mailbox#(transaction) mon2sb;

  virtual inf vinf;

  function new(virtual inf vinf,event next_tr);
    this.vinf = vinf ;
    this.next_tr = next_tr;
    seq2drv = new();
    mon2sb = new();
    drv = new(seq2drv,vinf,next_tr);
    mon = new(mon2sb,vinf,next_tr);
    sb = new(mon2sb);
    sqr = new(seq2drv,"write_seq",8,next_tr);
  endfunction 

  task run();
   fork 
     sqr.run();
     drv.run();
     mon.run();
     sb.run();
     
  join_none
  endtask
endclass
