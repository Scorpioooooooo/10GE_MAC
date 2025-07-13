`ifndef MAC_ENV_SV
`define MAC_ENV_SV
class mac_env extends uvm_env;

  virtual mac_if vif;
  mac_mst_agent mst_agent;
  mac_slv_agent slv_agent;
  mac_scoreboard scb;
  mac_coverage   cgm;
  mac_config     cfg;
  mac_virtual_sequencer virt_sqr;


  mac_rgm rgm;
  mac_reg_adapter adapter;
  uvm_reg_predictor #(mac_transaction) predictor;

  `uvm_component_utils(mac_env)

  function new (string name="mac_env", uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("build_phase","mac_env: starting...",UVM_LOW)
    if(!uvm_config_db#(mac_config)::get(this,"","cfg",cfg)) begin
    `uvm_fatal("GETCFG","cannot get MAC config handle from config DB")
    end
    if(!uvm_config_db#(virtual mac_if)::get(this,"","vif",vif)) begin
    `uvm_fatal("GETCFG","cannot get MAC interface handle from config DB")
    end

    mst_agent = mac_mst_agent::type_id::create("mst_agent",this);
    slv_agent = mac_slv_agent::type_id::create("slv_agent",this);


    uvm_config_db#(mac_config)::set(this, "scb", "cfg", cfg);
    uvm_config_db#(mac_config)::set(this, "cgm", "cfg", cfg);
    uvm_config_db#(mac_config)::set(this, "virt_sqr", "cfg", cfg);
    scb = mac_scoreboard::type_id::create("scb",this);
    cgm = mac_coverage::type_id::create("cgm",this);
    virt_sqr = mac_virtual_sequencer::type_id::create("virt_sqr",this);

    if(!uvm_config_db #(mac_rgm)::get(this, "", "rgm", rgm)) begin
      rgm = mac_rgm::type_id::create("rgm", this);
      rgm.build();
    end
    uvm_config_db#(mac_rgm)::set(this,"*","rgm",rgm);
    
    adapter = mac_reg_adapter::type_id::create("adapter",this);
    predictor = uvm_reg_predictor#(mac_transaction)::type_id::create("predictor",this);
    `uvm_info("build_phase","mac_env: starting...",UVM_LOW)
  endfunction: build_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    mst_agent.monitor.item_observed_port.connect(scb.mst_trans_observed_imp);
    slv_agent.monitor.item_collected_port.connect(scb.slv_trans_collected_imp);

    mst_agent.monitor.item_observed_port.connect(cgm.mst_trans_observed_imp);
    slv_agent.monitor.item_collected_port.connect(cgm.slv_trans_collected_imp);

    virt_sqr.mst_sqr = mst_agent.sequencer;

    rgm.default_map.set_sequencer(mst_agent.sequencer, adapter);
    mst_agent.monitor.item_observed_port.connect(predictor.bus_in);
    predictor.map = rgm.default_map;
    predictor.adapter = adapter;

  endfunction: connect_phase



endclass

`endif
