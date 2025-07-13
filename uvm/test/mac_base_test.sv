`ifndef MAC_BASE_TEST_SV
`define MAC_BASE_TEST_SV
virtual class mac_base_test extends uvm_test;
  mac_config cfg;
  mac_rgm rgm;
  mac_env env;

  function new(string name="mac_base_test", uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    rgm = mac_rgm::type_id::create("rgm");
    rgm.build();
    uvm_config_db#(mac_rgm)::set(this,"env","rgm",rgm);

    cfg = mac_config::type_id::create("cfg");
    cfg.rgm = rgm;
    uvm_config_db#(mac_config)::set(this,"env","cfg",cfg);

    if(!uvm_config_db#(virtual mac_if)::get(this,"","vif", cfg.vif))
    `uvm_fatal("GETCFG","cannot get virtual interface from config DB")

    env = mac_env::type_id::create("env",this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.phase_done.set_drain_time(this,1us);
    phase.raise_objection(this);
    phase.drop_objection(this);
  endtask
endclass
`endif
