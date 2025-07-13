`ifndef MAC_OVERSIZED_PACKET_VIRT_SEQUENCE_SV
`define MAC_OVERSIZED_PACKET_VIRT_SEQUENCE_SV
class mac_oversized_packet_virt_sequence extends mac_base_virtual_sequence;
  
  `uvm_object_utils(mac_oversized_packet_virt_sequence)

  function new(string name="mac_oversized_packet_virt_sequence");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "Starting oversized_packet_virt sequence ...", UVM_LOW)
    super.body();
    `uvm_do_on(reset_seq,p_sequencer.mst_sqr);
    //repeat(5) @(posedge vif.clk_156m25);
    #50ns;
    repeat(10) begin
    `uvm_do_on_with(req,p_sequencer.mst_sqr, 
    {
          reset_156m25_n==1;
	        reset_xgmii_rx_n==1;
				  reset_xgmii_tx_n==1;
			 	  wb_rst_i==0;
				  loaded_data.size() inside {[1501:9000]};
				  inter_packet_gap inside {[10:50]}; 
    })
    get_response(rsp);
    end
    `uvm_info(get_type_name(), "Finishing oversized_packet_virt sequence ...", UVM_LOW)
  endtask
endclass
`endif



