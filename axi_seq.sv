class my_seq extends uvm_sequence#(seq_item);

`uvm_object_utils(my_seq)

function new(string name = "my_seq");
 super.new(name);
endfunction

task body();
 repeat(100)begin
`uvm_info(get_type_name(),"Inside sequence body",UVM_LOW)
  req = seq_item :: type_id :: create("req");
  wait_of_grant();
  req.randomize();
  send_request(req);
  wait_for_item_done();
 end
endtask
endclass


/*class my_seq extends uvm_sequence #(seq_item);
  
  `uvm_object_utils(my_seq);
  
  function new(string name = "my_seq");
    super.new(name);
  endfunction
  
  task body();
    `uvm_info(get_type_name(),"Inside sequence body",UVM_LOW)
    repeat(100000)begin
    req = seq_item :: type_id :: create("req");
    wait_for_grant();
    assert(req.randomize());
    send_request(req);
    wait_for_item_done();
    end
  endtask
  
endclass*/
