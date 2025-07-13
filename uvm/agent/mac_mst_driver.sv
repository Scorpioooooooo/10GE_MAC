`ifndef MAC_MST_DRIVER_SV
`define MAC_MST_DRIVER_SV
class mac_mst_driver extends mac_driver;

  `uvm_component_utils(mac_mst_driver)

  function new(string name="mac_mst_driver", uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase (uvm_phase phase);
   super.build_phase(phase);
   `uvm_info("build_phase","mac_mst_driver: starting...",UVM_LOW)
    
   `uvm_info("build_phase","mac_mst_driver: finishing...",UVM_LOW)
  endfunction

  function void connect_phase(uvm_phase phase);
   super.connect_phase(phase);
  endfunction

 task run_phase(uvm_phase phase);
   super.run_phase(phase);
 endtask 

  virtual task drive_transfer(REQ tr);
  //TODO::transmit mac frame

  int data_len;   // Byte number
  int num_trans; // pkt_tx_data number
  logic [63:0] tx_data = 64'b0;


  //--------------  start transmission  -----------------//
  if(tr.reset_156m25_n && tr.reset_xgmii_rx_n && tr.reset_xgmii_tx_n) 
  begin
//*  first cycle  *//
    @(vif.cb_mst);
	   vif.reset_156m25_n   = tr.reset_156m25_n;
	   vif.reset_xgmii_rx_n = tr.reset_xgmii_rx_n;
	   vif.reset_xgmii_tx_n = tr.reset_xgmii_tx_n;
	   vif.wb_rst_i         =  tr.wb_rst_i;
     // imformation frame
     vif.cb_mst.pkt_tx_val <= 1'b1;
     vif.cb_mst.pkt_tx_sop <= 1'b1;
     vif.cb_mst.pkt_tx_mod <= $urandom_range(7,0);
     vif.cb_mst.pkt_tx_eop <= 1'b0;
     vif.cb_mst.pkt_tx_data <= {tr.dst_addr, tr.src_addr[47:32]};
     // -------------------//
     // caculate mac frame packet length
     data_len = 6 + 6 + 2 + tr.loaded_data.size(); // 6->destination addr  6-> source addr  2 -> frame length
     if(data_len % 8) num_trans = data_len / 8 +1; // 
     else num_trans = data_len / 8;
    
     if(num_trans == 2) begin
      //*  second cycle  *//
       @(vif.cb_mst);
       vif.cb_mst.pkt_tx_sop <= 1'b0;
       vif.cb_mst.pkt_tx_eop <= 1'b1;
       vif.cb_mst.pkt_tx_data <= {tr.src_addr[31:0], tr.ether_len, tr.loaded_data[0], tr.loaded_data[1]};
     end
     else 
           begin
             @(vif.cb_mst);
             vif.cb_mst.pkt_tx_sop <= 1'b0;
             vif.cb_mst.pkt_tx_data <= {tr.src_addr[31:0], tr.ether_len, tr.loaded_data[0], tr.loaded_data[1]};

             // Send the rest of the packet, (i-2)*8 is th rest of Byte 
             for(int i = 2; i < num_trans; i++) begin
                 // if tx fifo is full , stop send data
                 while(vif.cb_mst.pkt_tx_full) begin
                   vif.cb_mst.pkt_tx_val  <= 1'b0;
                   vif.cb_mst.pkt_tx_sop  <= 1'b0;
                   vif.cb_mst.pkt_tx_mod  <= $urandom_range(7,0);
                   vif.cb_mst.pkt_tx_data <= 64'b0;
                   vif.cb_mst.pkt_tx_eop  <= 1'b0;
                   @(vif.cb_mst);
                   //TODO:: break loop condition
                 end
                // third cycle to penult cycle tx data
                if(!(i == num_trans - 1))begin
                   @(vif.cb_mst);
                   vif.cb_mst.pkt_tx_data <= {tr.loaded_data[2+(i-2)*8], // (i-2)*8 is byte number
                                             tr.loaded_data[3+(i-2)*8],
                                             tr.loaded_data[4+(i-2)*8],
                                             tr.loaded_data[5+(i-2)*8],
                                             tr.loaded_data[6+(i-2)*8],
                                             tr.loaded_data[7+(i-2)*8],
                                             tr.loaded_data[8+(i-2)*8],
                                             tr.loaded_data[9+(i-2)*8]
                                           };
                end
                else 
                     begin 
                     // the last cycle, i == num_trans -1
                        @(vif.cb_mst);
                        vif.cb_mst.pkt_tx_mod <= data_len % 8; // valid byte number of last word data
                        vif.cb_mst.pkt_tx_eop <= 1'b1;
                        // bitwise OR, intercept valid byte
                        for(int k=0; k < vif.pkt_tx_mod; k++)begin

                          if(vif.pkt_tx_mod == k+1)
                           //the last byte
                           tx_data = {tx_data | tr.loaded_data[2+(i-2)*8+k]};
                          else
                           tx_data = {tx_data | tr.loaded_data[2+(i-2)*8+k]} <<8;
                        end
                        if(!vif.pkt_tx_mod)begin
                          for(int k=0; k<8; k++)
                           tx_data = {tx_data | tr.loaded_data[2+(i-2)*8+k]} <<8;
                        end
                        vif.cb_mst.pkt_tx_data <= tx_data;
                     end // if(!(i == num_trans -1)) ...else...
             end // for loop

           end // if(num_trans ==2) ... else XXX

         //--------------  intercept packet gap  -----------------//
         repeat(tr.inter_packet_gap) begin
           @(vif.cb_mst);
           vif.cb_mst.pkt_tx_val  <= 1'b0;
           vif.cb_mst.pkt_tx_sop  <= 1'b0;
           vif.cb_mst.pkt_tx_mod  <= $urandom_range(7,0);
           vif.cb_mst.pkt_tx_data <= 64'b0;
           vif.cb_mst.pkt_tx_eop  <= 1'b0;
           
         end
  end
  else 
  begin
  // if not reset
	   vif.reset_156m25_n   = tr.reset_156m25_n;
	   vif.reset_xgmii_rx_n = tr.reset_xgmii_rx_n;
	   vif.reset_xgmii_tx_n = tr.reset_xgmii_tx_n;
	   vif.wb_rst_i         =  tr.wb_rst_i;
    vif.cb_mst.pkt_tx_val  <= 1'b0;
    vif.cb_mst.pkt_tx_sop  <= 1'b0;
    vif.cb_mst.pkt_tx_eop  <= 1'b0;

  end




  endtask


endclass

`endif

