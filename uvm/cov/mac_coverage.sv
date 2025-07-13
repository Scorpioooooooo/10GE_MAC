`ifndef MAC_COVERAGE_SV
`define MAC_COVERAGE_SV

// Coverage Model
class mac_coverage extends mac_subscriber; 

  `uvm_component_utils(mac_coverage)
  

  //covergroup definition
  covergroup Ethernet_singals_cover with function sample(mac_transaction tr);
    option.name = "T1 Ethernet signals coverage";
    IPG: coverpoint tr.inter_packet_gap 
    {
         bins zero_ipg = {0};
         bins normal_ipg = {[10:50]};
         illegal_bins others = default;
    }

    LEN: coverpoint tr.ether_len 
    {
         bins IPv6 = {16'h86dd};
         bins IPv4 = {16'h0800};
         bins IPX  = {16'h8137};
         bins ARP  = {16'h0806};
         bins others = default;
    }

    MOD: coverpoint (tr.loaded_data.size()%8)
    {
         bins mod0 = {0};
         bins mod1 = {1};
         bins mod2 = {2};
         bins mod3 = {3};
         bins mod4 = {4};
         bins mod5 = {5};
         bins mod6 = {6};
         bins mod7 = {7};
    }

    DATA_SIZE: coverpoint tr.loaded_data.size()
    {
        bins small_packet = {[46:50]};
        bins large_packet = {[1450:1500]};
        bins oversized_packet = {[1501:9000]};
    }
  endgroup:Ethernet_singals_cover


  function new(string name = "mac_coverage", uvm_component parent = null);
    super.new(name, parent);
    Ethernet_singals_cover = new();
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction: build_phase

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
  endtask


  function void write_mst(mac_transaction tr);
    //TODO: covergroup use sample function to capture tr 

    Ethernet_singals_cover.sample(tr);
  endfunction


  function void write_slv(mac_transaction tr);
  endfunction

endclass


`endif // mac_coverage_SV

