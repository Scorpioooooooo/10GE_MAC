`ifndef MAC_MST_MONITOR_SV
`define MAC_MST_MONITOR_SV
class mac_mst_monitor extends mac_monitor;

  uvm_analysis_port #(mac_transaction) item_observed_port;
  `uvm_component_utils(mac_mst_monitor)


  function new(string name="mac_mst_monitor", uvm_component parent);
    super.new(name,parent);
    item_observed_port = new("item_observed_port",this);
  endfunction

  function void build_phase (uvm_phase phase);
   super.build_phase(phase);
   `uvm_info("build_phase","mac_mst_monitor: starting...",UVM_LOW)
   `uvm_info("build_phase","mac_mst_monitor: finishing...",UVM_LOW)
  endfunction

 function void connect_phase(uvm_phase phase);
   super.connect_phase(phase);
 endfunction

 task run_phase(uvm_phase phase);
   super.run_phase(phase);
   fork
     monitor_transactions();
   join_none
 endtask 

 task monitor_transactions();
   int ipg;
   bit pkt_trans = 0;
   bit pkt_end   = 0;
   int m = 2; // data byte number
   int g = 0; // 
   logic [63:0] temp_txd;
   logic [7:0]  temp_fifo[$];
   mac_transaction tr;

   forever 
   begin
     // if reset
     // if(!vif.reset_xgmii_tx_n || !vif.reset_156m25_n)begin
     //   tr = mac_transaction::type_id::create("tr",this);
     //   tr.reset_156m25_n    = vif.reset_156m25_n;
     //   tr.reset_xgmii_tx_n  = vif.reset_xgmii_tx_n;
     //   tr.reset_xgmii_rx_n  = vif.reset_xgmii_rx_n;
     //   tr.wb_rst_i          = vif.wb_rst_i;
     //   item_observed_port.write(tr);
     // end


     // @(negedge vif.clk_156m25);
     // if(vif.reset_xgmii_tx_n && vif.reset_156m25_n) 
     // begin

        @(negedge vif.clk_156m25);
        //****   ipg cycle  ****//
        if(!vif.pkt_tx_val && !vif.pkt_tx_full && vif.pkt_tx_data==0)begin
          ipg++;
        end


        // collected valid data has start
        // frame cycle
        if(vif.pkt_tx_val) 
        begin

          //**** first cycle *****//
          if(vif.pkt_tx_sop && !vif.pkt_tx_eop)begin

            tr = mac_transaction::type_id::create("tr",this);
            tr.dst_addr          = vif.pkt_tx_data[63:16];
            tr.src_addr[47:32]   = vif.pkt_tx_data[15:0];
            tr.reset_156m25_n    = vif.reset_156m25_n;
            tr.reset_xgmii_tx_n  = vif.reset_xgmii_tx_n;
            tr.reset_xgmii_rx_n  = vif.reset_xgmii_rx_n;
            tr.wb_rst_i          = vif.wb_rst_i;
            pkt_trans            = 0;
            tr.inter_packet_gap  = ipg;
            pkt_end              = 0;
            m                    = 2;
            g                    = 0;
          end


          //****  packet cycle   ****//
          if(!vif.pkt_tx_sop && !vif.pkt_tx_eop && pkt_trans)begin
            temp_txd   = vif.pkt_tx_data; 
            for(int i = 0; i<8; i++)begin
              temp_fifo.push_back(temp_txd[63:56]);
              temp_txd = temp_txd << 8;
            end
            m = m+8;
          end

          //****  second cycle   ****//
          if(!vif.pkt_tx_sop && !vif.pkt_tx_eop && !pkt_trans)begin
            tr.src_addr[31:0]  = vif.pkt_tx_data[63:32];
            tr.ether_len       = vif.pkt_tx_data[31:16];
            temp_fifo.push_back(vif.pkt_tx_data[15:8]);
            temp_fifo.push_back(vif.pkt_tx_data[7:0]);
            pkt_trans = 1; // The first two pieces of data have been collected, and the rest are packets
          end



          //****  last cycle   ****//
          if(vif.pkt_tx_eop && !vif.pkt_tx_sop && pkt_trans)begin
            if(vif.pkt_tx_mod == 0)begin
               temp_txd   = vif.pkt_tx_data; 
               for(int i = 0; i<8; i++)begin
                temp_fifo.push_back(temp_txd[63:56]);
                temp_txd = temp_txd << 8;
               end
              end
            else begin
               temp_txd   = vif.pkt_tx_data; 
               for(int i = 0; i<vif.pkt_tx_mod; i++)begin
                temp_fifo.push_back(temp_txd[7:0]);
                temp_txd = temp_txd >> 8;
               end
             end

            tr.loaded_data = new[temp_fifo.size()];
            while(temp_fifo.size())begin
              tr.loaded_data[g] = temp_fifo.pop_front();
              g++;
            end
            pkt_end = 1;  
          end  

        if(pkt_end)begin
          item_observed_port.write(tr);
          pkt_end = 0;
          pkt_trans = 0;
          ipg = 0;
        end
      // collected valid data has finished
      end // if(vif.pkt_tx_val) 


   //end // if(cif.reset_xgmii_tx_n && vif.reset_156m25_n)

 end // forever


 endtask


endclass

`endif


