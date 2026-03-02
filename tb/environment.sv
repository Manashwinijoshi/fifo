class environment;
  driver drv;
  monitor mon;
  
  mailbox#(transaction) seq2drv;
  mailbox#(transaction) drv2sb;
  mailbox#(transaction) mon2sb;

  virtual inf vinf;

  function new(virtual inf vinf);
    this.vinf = vinf ;
    seq2drv = new();
    drv2sb = new();
    mon2sb = new();
    drv = new(seq2drv,drv2sb,vinf);
    mon = new(mon2sb,vinf);
  endfunction 

  task run();
   fork 
    drv.run();
     mon.run();
  join_none
  endtask
endclass
