`ifndef MAC_TRANSACTION_SV
`define MAC_TRANSACTION_SV
class mac_transaction extends uvm_sequence_item;

  rand bit [7:0]   loaded_data[];
  rand bit [47:0]  dst_addr;
  rand bit [47:0]  src_addr;
  rand bit [15:0]  ether_len; // frame length
  rand bit [31:0]  inter_packet_gap; // IPG: nearly takes 9.6 macro seconds(9.6us=9600ns, 9600/6.4=1500cycles)
  rand bit            reset_156m25_n;
  rand bit            reset_xgmii_rx_n;
  rand bit            reset_xgmii_tx_n;
  rand bit            wb_rst_i;

   constraint data_size {loaded_data.size() inside {[0:9000]};}
   constraint ipg_size {inter_packet_gap inside {[0:50]};}
  
  `uvm_object_utils_begin(mac_transaction);
    `uvm_field_array_int(loaded_data,UVM_ALL_ON)
    `uvm_field_int(dst_addr,UVM_ALL_ON)
    `uvm_field_int(src_addr,UVM_ALL_ON)
    `uvm_field_int(ether_len,UVM_ALL_ON)
    `uvm_field_int(inter_packet_gap,UVM_ALL_ON)
    `uvm_field_int(reset_xgmii_tx_n,UVM_ALL_ON)
    `uvm_field_int(reset_xgmii_rx_n,UVM_ALL_ON)
    `uvm_field_int(reset_156m25_n,UVM_ALL_ON)
    `uvm_field_int(wb_rst_i,UVM_ALL_ON)
  `uvm_object_utils_end
  


  function new(string name="mac_transaction");
    super.new(name);
  endfunction


endclass


`endif
