class environment;
  driver drv;
  monitor mon;
  
  mailbox#(transaction) seq2drv;
  mailbox#(transaction) mon2sb;

  virtual inf vinf;

  function new(virtual inf vinf);
    this.vinf = vinf ;
    drv2sb = new();
    mon2sb = new();
    drv = new(seq2drv,vinf);
    mon = new(mon2sb,vinf);
  endfunction 

  task run();
   fork 
    drv.run();
     mon.run();
  join_none
  endtask
endclass
