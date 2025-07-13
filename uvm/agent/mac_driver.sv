`ifndef MAC_DRIVER_SV
`define MAC_DRIVER_SV
class mac_driver #(type REQ=mac_transaction, RSP=REQ)extends uvm_driver #(REQ,RSP);

  virtual mac_if vif;
  `uvm_component_utils(mac_driver)

  function new(string name="mac_driver", uvm_component parent);
    super.new(name,parent);
  endfunction

   function void build_phase (uvm_phase phase);
   super.build_phase(phase);
 endfunction

 function void connect_phase(uvm_phase phase);
   super.connect_phase(phase);
 endfunction

 task run_phase(uvm_phase phase);
   super.run_phase(phase);
   fork
     get_and_drive();
     reset_listener();
   join_none
 endtask 

  virtual task get_and_drive();
    forever begin
      seq_item_port.get_next_item(req);
      `uvm_info(get_type_name(),"sequencer get next item", UVM_HIGH)
      drive_transfer(req);
      void'($cast(rsp,req.clone()));
      rsp.set_sequence_id(req.get_sequence_id());
      rsp.set_transaction_id(req.get_transaction_id());
      seq_item_port.item_done(rsp);
      `uvm_info(get_type_name(),"sequence item_done triggered",UVM_HIGH)
    end
  endtask:get_and_drive

  task reset_listener();
  endtask

  virtual task drive_transfer(REQ tr);
  //TODO implementation in child class
  endtask


endclass

`endif
