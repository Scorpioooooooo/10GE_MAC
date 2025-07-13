`ifndef MAC_MST_SEQUENCER_SV
`define MAC_MST_SEQUENCER_SV

class mac_mst_sequencer extends mac_sequencer;

 `uvm_component_utils(mac_mst_sequencer)

 function new(string name="mac_mst_sequencer", uvm_component parent = null);
   super.new(name, parent);
 endfunction

 function void build_phase (uvm_phase phase);
   super.build_phase(phase);
   `uvm_info("build_phase","mac_mst_sequencer: starting...",UVM_LOW)

   `uvm_info("build_phase","mac_mst_sequencer: finishing...",UVM_LOW)
 endfunction

 function void connect_phase(uvm_phase phase);
   super.connect_phase(phase);
 endfunction

 task run_phase(uvm_phase phase);
   super.run_phase(phase);
 endtask 
endclass

`endif//MAC_MST_SEQUENCER_SV


