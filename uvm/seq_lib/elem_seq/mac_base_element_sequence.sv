`ifndef MAC_BASE_ELEMENT_SEQUENCE_SV
`define MAC_BASE_ELEMENT_SEQUENCE_SV
 class mac_base_element_sequence extends uvm_sequence #(mac_transaction);
  

  `uvm_object_utils(mac_base_element_sequence)
  `uvm_declare_p_sequencer(mac_mst_sequencer)


  function new(string name="mac_base_element_sequence");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info("body", "Entering ...", UVM_LOW)
    super.body();

    `uvm_info("body", "Exiting ...", UVM_LOW)
  endtask
endclass
`endif
