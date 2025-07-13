`ifndef MAC_VIRTUAL_SEQUENCER_SV
`define MAC_VIRTUAL_SEQUENCER_SV

class mac_virtual_sequencer extends uvm_sequencer;
  mac_mst_sequencer mst_sqr;
  mac_config cfg;

  `uvm_component_utils(mac_virtual_sequencer)

  function new (string name = "mac_virtual_sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(mac_config)::get(this,"","cfg", cfg)) begin
      `uvm_fatal("GETCFG","cannot get config object from config DB")
    end
  endfunction

endclass

`endif // MAC_VIRTUAL_SEQUENCER_SV



