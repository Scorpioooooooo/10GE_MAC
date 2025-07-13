`ifndef MAC_SLV_MONITOR_SV
`define MAC_SLV_MONITOR_SV
class mac_slv_monitor extends mac_monitor;

  uvm_analysis_port #(mac_transaction) item_collected_port;
  `uvm_component_utils(mac_slv_monitor)


  function new(string name="mac_slv_monitor", uvm_component parent);
    super.new(name,parent);
    item_collected_port = new("item_collected_port",this);
  endfunction

  function void build_phase (uvm_phase phase);
   super.build_phase(phase);
   `uvm_info("build_phase","mac_slv_monitor: starting...",UVM_LOW)
   `uvm_info("build_phase","mac_slv_monitor: finishing...",UVM_LOW)
  endfunction

 function void connect_phase(uvm_phase phase);
   super.connect_phase(phase);
 endfunction

 task run_phase(uvm_phase phase);
   super.run_phase(phase);
   fork
     collect_transactions();
   join_none
 endtask 

 task collect_transactions();
   int ipg;
   bit pkt_trans = 0;
   int m = 2; // data byte number
   int g = 0; // 
   logic [63:0] temp_rxd;
   logic [7:0]  temp_fifo[$];
   mac_transaction tr;

   vif.cb_slv.pkt_rx_ren <= 0;

   forever begin
      @(posedge vif.clk_156m25);
      if(vif.reset_156m25_n && vif.reset_xgmii_rx_n)
      begin

        if(vif.pkt_rx_avail) vif.cb_slv.pkt_rx_ren <= 1'b1;

        //****  rx data start  ****//
        if(vif.pkt_rx_val) 
        begin



          //**** first rx cycle  ****//
          if(vif.pkt_rx_sop)begin
            tr = mac_transaction::type_id::create("tr",this);
            tr.dst_addr          <= vif.pkt_rx_data[63:16];
            tr.src_addr[47:32]   <= vif.pkt_rx_data[15:0];
            pkt_trans = 0;
            g         = 0;
            m         = 2;
          end

          //**** packet  cycle  ****//
          if(!vif.pkt_rx_sop && !vif.pkt_rx_eop && pkt_trans)begin
            temp_rxd = vif.pkt_rx_data;
              for(int i = 0; i<8; i++)begin
                temp_fifo.push_back(temp_rxd[63:56]);
                temp_rxd = temp_rxd << 8;
              end
            m = m+8;
          end

          //****  second cycle   ****//
          if(!vif.pkt_rx_sop && !vif.pkt_rx_eop && !pkt_trans)begin
            tr.src_addr[31:0]  = vif.pkt_rx_data[63:32];
            tr.ether_len       = vif.pkt_rx_data[31:16];
            temp_fifo.push_back(vif.pkt_rx_data[15:8]);
            temp_fifo.push_back(vif.pkt_rx_data[7:0]);
            pkt_trans = 1; // The first two pieces of data have been collected, and the rest are packets
          end





          //****  last cycle  ****//
          if(vif.pkt_rx_eop)begin
            vif.cb_slv.pkt_rx_ren  <= 1'b0;

            if(vif.pkt_rx_mod == 0)begin
              temp_rxd  = vif.pkt_rx_data; 
                for(int i = 0; i<8; i++)begin
                  temp_fifo.push_back(temp_rxd[63:56]);
                  temp_rxd = temp_rxd << 8;
                end
            end
            else begin
                  temp_rxd  = vif.pkt_rx_data; 
                    for(int i = 0; i<vif.pkt_rx_mod; i++)begin
                      temp_fifo.push_back(temp_rxd[7:0]);
                      temp_rxd = temp_rxd >> 8;
                    end
                 end

             tr.loaded_data = new[temp_fifo.size()];
             while(temp_fifo.size())begin
               tr.loaded_data[g] = temp_fifo.pop_front();
               g++;
             end
             if(!vif.pkt_rx_err) item_collected_port.write(tr);
          end


        end


      end
      //else begin
      //     tr = mac_transaction::type_id::create("tr",this);
      //     tr.reset_xgmii_rx_n = vif.reset_xgmii_rx_n;
      //     tr.reset_xgmii_rx_n = vif.reset_xgmii_rx_n;
      //     tr.reset_156m25_n   = vif.reset_156m25_n;
      //     tr.wb_rst_i         = vif.wb_rst_i;
      //     item_collected_port.write(tr);
      //end
   end
 endtask


endclass

`endif



