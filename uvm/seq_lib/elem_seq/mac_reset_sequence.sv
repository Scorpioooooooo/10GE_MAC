`ifndef MAC_RESET_SEQUENCE_SV
`define MAC_RESET_SEQUENCE_SV
class mac_reset_sequence extends mac_base_element_sequence;
  
  `uvm_object_utils(mac_reset_sequence)

  function new(string name="mac_reset_sequence");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "Starting reset sequence ...", UVM_LOW)
    `uvm_do_with(req, 
      {
        reset_156m25_n == 0;
        reset_xgmii_rx_n == 0;
        reset_xgmii_tx_n == 0;
        wb_rst_i == 1;
        loaded_data.size() == 0;
        inter_packet_gap == 0;
      })

    `uvm_info(get_type_name(), "Fnishing reset sequence ...", UVM_LOW)
  endtask
endclass
`endif

