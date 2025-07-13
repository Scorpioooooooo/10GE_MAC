`ifndef MAC_BASE_VIRTUAL_SEQUENCE_SV
`define MAC_BASE_VIRTUAL_SEQUENCE_SV
class mac_base_virtual_sequence extends uvm_sequence #(mac_transaction);
  
  virtual mac_if vif;
  mac_rgm rgm;
  mac_config cfg;

  mac_reset_sequence reset_seq;

  `uvm_object_utils(mac_base_virtual_sequence)
  `uvm_declare_p_sequencer(mac_virtual_sequencer)


  function new(string name="mac_base_virtual_sequence");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info("body", "Entering ...", UVM_LOW)
      cfg = p_sequencer.cfg;
      vif = cfg.vif;
      rgm = cfg.rgm;
    `uvm_info("body", "Exiting ...", UVM_LOW)
  endtask
endclass
`endif

