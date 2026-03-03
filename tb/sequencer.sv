class sequencer;
  mailbox#(transaction) seq2drv;
  
  string seq_name;
  
  function new(  mailbox#(transaction) seq2drv, string seq_name = "");
     this.seq_name = seq_name;
     this.seq2drv = seq2drv;
  endfunction

  task start();

    base_sequence seq;

    case(seq_name)
  
           "write_seq" : seq = new write_seq(seq2drv);
           "read_seq" : seq = new read_seq(seq2drv);
           "mix_seq" : seq = new mix_seq(seq2drv);
           "underflow_seq" : seq = new underflow_seq(seq2drv);
           "overflow_seq" : seq = new overflow_seq(seq2drv);
            default: begin
                        $fatal("Unknown sequence");
                     end

    endcase

    seq.run();

  endtask
endclass
