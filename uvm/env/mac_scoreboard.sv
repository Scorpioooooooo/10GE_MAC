`ifndef MAC_SCOREBOARD_SV
`define MAC_SCOREBOARD_SV
class mac_scoreboard extends mac_subscriber;

  mac_transaction tx_fifo[$];
  mac_transaction rx_fifo[$];
  
  int enable = 1;
  int mst_count = 0;
  int slv_count = 0;
  int check_count    = 0;
  int data_mismatch_count = 0;

  `uvm_component_utils(mac_scoreboard)

  function new (string name="mac_scoreboard", uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      pkt_compare();
    end
  endtask

  virtual function void write_mst(mac_transaction tr);
    tx_fifo.push_back(tr);
    mst_count++;
  endfunction
  
  virtual function void write_slv(mac_transaction tr);
    rx_fifo.push_back(tr);
    slv_count++;
  endfunction

  task pkt_compare();
    mac_transaction pkt_tx, pkt_rx;
    wait(tx_fifo.size() && rx_fifo.size());
    pkt_tx  =  tx_fifo.pop_front();
    pkt_rx  =  rx_fifo.pop_front();
    //fork
    //  wait(tx_fifo.size() > 0) pkt_tx = tx_fifo.pop_front();
    //  wait(rx_fifo.size() > 0) pkt_rx = rx_fifo.pop_front();
    //join
    if(pkt_rx.reset_156m25_n | pkt_tx.reset_156m25_n)begin
      compare_data(pkt_tx,pkt_rx);
      check_count++;
    end
  endtask

  function void compare_data(mac_transaction pkt_tx,pkt_rx);
    if(pkt_tx.dst_addr != pkt_rx.dst_addr)
	  `uvm_error(get_type_name(),$sformatf("Invalid destination address as : tx_dst_add = %h ,rx_dst_add = %h ",pkt_tx.dst_addr,pkt_rx.dst_addr))

    if(pkt_tx.src_addr != pkt_rx.src_addr)
	  `uvm_error(get_type_name(),$sformatf("Invalid source address as : tx_src_add = %h ,rx_src_add = %h ",pkt_tx.src_addr,pkt_rx.src_addr))		 
		 
    if(pkt_tx.ether_len != pkt_rx.ether_len)
	  `uvm_error(get_type_name(),$sformatf("Invalid ethernet length as : tx_ether_len = %h ,rx_ether_len = %h ",pkt_tx.ether_len,pkt_rx.ether_len))		 
		 
    if(pkt_tx.loaded_data.size() != pkt_rx.loaded_data.size())
	  `uvm_error(get_type_name(),$sformatf("Invalid data size as : tx_data_size = %h ,rx_data_size = %h ",pkt_tx.loaded_data.size(),pkt_rx.loaded_data.size()))		 
		 
   for(int i=0 ; i<pkt_tx.loaded_data.size() ; i++) begin
     if(pkt_tx.loaded_data[i] != pkt_rx.loaded_data[i])begin
		  `uvm_error(get_type_name(),$sformatf("Invalid data : tx_data = %h ,rx_data = %h ",pkt_tx.loaded_data[i],pkt_rx.loaded_data[i]))		
      data_mismatch_count++;
    end
	end

  endfunction


  // ------------------------------------------------------------------------------------------------
  // report phase
  // ------------------------------------------------------------------------------------------------
  virtual function void report_phase(uvm_phase phase);
    if(enable) begin
      `uvm_info(get_type_name(),
      $sformatf("\n\
  ----------------------------------------------\n\
 | ScoreBoard(Enabled) Report                    |\n\
  ---------------------------------------------- \n\
 | Transactions        expected by master %5d  |\n\
 | Transactions        expected by slave  %5d  |\n\
 | Check    in transactions               %5d  |\n\
 | Mismatch in data of transactions       %5d  |\n\
  ---------------------------------------------- ",
      mst_count, slv_count, check_count, data_mismatch_count), UVM_LOW);
     if((mst_count==0 && slv_count==0)) begin
      `uvm_error(get_type_name(),$sformatf("Scoreboard Error : NO transaction observed on the bus"))
     end 
     if(tx_fifo.size() != 0) begin
      `uvm_error(get_type_name(),$sformatf("Scoreboard Error : TX transaction queue still have %0d pending transaction",tx_fifo.size()))
      end
     if(rx_fifo.size() != 0) begin
      `uvm_error(get_type_name(),$sformatf("Scoreboard Error : RX transaction queue still have %0d pending transaction",rx_fifo.size()))
      end
     if(mst_count != slv_count) begin
      `uvm_error(get_type_name(),$sformatf("Scoreboard Error : Mismatch detected in number of transaction of TX - %0d and RX - %0d",mst_count, slv_count))
      end
    end
    else 
    begin
      `uvm_info(get_type_name(), 
                {"\n"
                ," ------------------------------------------------ \n"
                ,"|   ScoreBoard(Disabled) Report                  |\n"
                ," ------------------------------------------------ "
                }, 
                UVM_LOW)
    end
  endfunction

endclass
`endif
