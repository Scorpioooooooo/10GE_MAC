`ifndef MAC_MONITOR_SV
`define MAC_MONITOR_SV
class mac_monitor extends uvm_monitor;

  virtual mac_if vif;

  `uvm_component_utils(mac_monitor)


  function new(string name="mac_monitor", uvm_component parent);
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
 endtask 



endclass

`endif

