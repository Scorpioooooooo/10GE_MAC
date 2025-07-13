`ifndef MAC_slv_AGENT_SV
`define MAC_slv_AGENT_SV
class mac_slv_agent extends uvm_agent;
  virtual mac_if vif;
  mac_slv_monitor monitor;

  `uvm_component_utils(mac_slv_agent)

  function new (string name="mac_slv_agent", uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("build_phase","mac_slv_agent: starting...",UVM_LOW)
    if(!uvm_config_db#(virtual mac_if)::get(this,"","vif",vif)) begin
    `uvm_fatal("GETCFG","cannot get MAC interface handle from config DB")
    end

    monitor = mac_slv_monitor::type_id::create("monitor",this);

    `uvm_info("build_phase","mac_slv_agent: finishing...",UVM_LOW)

  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("connect_phase","mac_slv_agent: starting...",UVM_LOW)
      monitor.vif = vif;
    `uvm_info("connect_phase","mac_slv_agent: finishing...",UVM_LOW)

  endfunction

   task run_phase(uvm_phase phase);
     super.run_phase(phase);
   endtask 



endclass
`endif

