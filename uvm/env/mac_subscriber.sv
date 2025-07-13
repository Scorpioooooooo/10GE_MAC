`ifndef MAC_SUBSCRIBER_SV
`define MAC_SUBSCRIBER_SV

`uvm_analysis_imp_decl(_mst)
`uvm_analysis_imp_decl(_slv)

class mac_subscriber extends uvm_component;

  // analysis import
  uvm_analysis_imp_mst #(mac_transaction, mac_subscriber) mst_trans_observed_imp;
  uvm_analysis_imp_slv #(mac_transaction, mac_subscriber) slv_trans_collected_imp;

  mac_config cfg;
  virtual mac_if vif;

  `uvm_component_utils(mac_subscriber)

  function new (string name = "mac_subscriber", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mst_trans_observed_imp = new("mst_trans_observed_imp", this);
    slv_trans_collected_imp = new("slv_trans_ccollected_imp", this);
    if(!uvm_config_db#(mac_config)::get(this,"","cfg", cfg)) begin
      `uvm_fatal("GETCFG","cannot get config object from config DB")
    end
    vif = cfg.vif;

  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
  endtask

  virtual function void write_mst(mac_transaction tr);
  endfunction
  virtual function void write_slv(mac_transaction tr);
  endfunction

endclass

`endif



