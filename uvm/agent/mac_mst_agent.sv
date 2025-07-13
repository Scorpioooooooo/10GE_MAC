`ifndef MAC_MST_AGENT_SV
`define MAC_MST_AGENT_SV
class mac_mst_agent extends uvm_agent;
  virtual mac_if vif;
  mac_mst_driver driver;
  mac_mst_monitor monitor;
  mac_mst_sequencer sequencer;

  `uvm_component_utils(mac_mst_agent)

  function new (string name="mac_mst_agent", uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("build_phase","mac_mst_agent: starting...",UVM_LOW)
    if(!uvm_config_db#(virtual mac_if)::get(this,"","vif",vif)) begin
    `uvm_fatal("GETCFG","cannot get MAC interface handle from config DB")
    end

    monitor = mac_mst_monitor::type_id::create("monitor",this);
    driver  = mac_mst_driver::type_id::create("driver",this);
    sequencer = mac_mst_sequencer::type_id::create("sequencer",this);

    `uvm_info("build_phase","mac_mst_agent: finishing...",UVM_LOW)

  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("connect_phase","mac_mst_agent: starting...",UVM_LOW)
      monitor.vif = vif;
      // driver communicate with sequencer by TLM
      driver.seq_item_port.connect(sequencer.seq_item_export);
      driver.vif = vif;
      sequencer.vif = vif;
    `uvm_info("connect_phase","mac_mst_agent: finishing...",UVM_LOW)

  endfunction

   task run_phase(uvm_phase phase);
     super.run_phase(phase);
   endtask 



endclass
`endif
