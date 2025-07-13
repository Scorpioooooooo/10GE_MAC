`ifndef MAC_SEQUENCER_SV
`define MAC_SEQUENCER_SV

class mac_sequencer #(type REQ = mac_transaction, RSP = REQ) extends uvm_sequencer#(REQ,RSP);

 virtual mac_if vif;

 `uvm_component_utils(mac_sequencer)
  

 function new(string name="mac_sequencer", uvm_component parent = null);
   super.new(name, parent);
 endfunction

 function void build_phase (uvm_phase phase);
   super.build_phase(phase);
 endfunction

 function void connect_phase(uvm_phase phase);
   super.connect_phase(phase);
 endfunction

 task run_phase(uvm_phase phase);
   super.run_phase(phase);
 endtask 

endclass

`endif// mac_SEQUENCER_SV

