
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
