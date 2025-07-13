`ifndef MAC_CONFIG_SV
`define mac_CONFIG_SV

class mac_config extends uvm_object;
  int seq_check_count;
  int seq_check_error;

  int scb_check_count;
  int scb_check_error;

  mac_rgm rgm;
  virtual mac_if vif;

   

  `uvm_object_utils(mac_config)

  function new (string name = "mac_config");
    super.new(name);
  endfunction

endclass

`endif // mac_CONFIG_SV


