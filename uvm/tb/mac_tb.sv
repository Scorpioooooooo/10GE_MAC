`ifndef MAC_TB_SV
`define MAC_TB_SV
module mac_tb;

import uvm_pkg::*;
`include "uvm_macros.svh"
import xge_mac_pkg::*;

logic clk_156m25;
logic clk_xgmii_tx;
logic clk_xgmii_rx;
logic wb_clk_i;

mac_if intf(
            .clk_xgmii_rx(clk_xgmii_rx),
            .clk_xgmii_tx(clk_xgmii_tx),
            .wb_clk_i(wb_clk_i),
            .clk_156m25(clk_156m25)
            );

xge_mac dut(
     
    // dut input 
    .clk_156m25        (clk_156m25),
    .clk_xgmii_rx     (clk_xgmii_rx),
    .clk_xgmii_tx     (clk_xgmii_tx),
    .wb_clk_i         (wb_clk_i),
    .pkt_tx_data      (intf.pkt_tx_data),
    .pkt_tx_eop       (intf.pkt_tx_eop),
    .pkt_tx_val       (intf.pkt_tx_val),
    .pkt_tx_sop       (intf.pkt_tx_sop),
    .pkt_tx_mod       (intf.pkt_tx_mod),
    .pkt_rx_ren       (intf.pkt_rx_ren),

    .wb_adr_i         (intf.wb_adr_i),
    .wb_cyc_i         (intf.wb_cyc_i),
    .wb_dat_i         (intf.wb_dat_i),
    .wb_stb_i         (intf.wb_stb_i),
    .wb_we_i          (intf.wb_we_i),

    .xgmii_rxc        (intf.xgmii_rxc),
    .xgmii_rxd        (intf.xgmii_rxd),

    .reset_156m25_n   (intf.reset_156m25_n),
    .reset_xgmii_rx_n (intf.reset_xgmii_rx_n),
    .reset_xgmii_tx_n (intf.reset_xgmii_tx_n),
    .wb_rst_i         (intf.wb_rst_i),


    // dut output
    .pkt_rx_avail      (intf.pkt_rx_avail),
    .pkt_rx_data       (intf.pkt_rx_data),
    .pkt_rx_eop        (intf.pkt_rx_eop),
    .pkt_rx_val        (intf.pkt_rx_val),
    .pkt_rx_sop        (intf.pkt_rx_sop),
    .pkt_rx_mod        (intf.pkt_rx_mod), 
    .pkt_rx_err        (intf.pkt_rx_err),
    .pkt_tx_full       (intf.pkt_tx_full),
    
    .wb_dat_o          (intf.wb_dat_o),
    .wb_ack_o          (intf.wb_ack_o),               
    .wb_int_o          (intf.wb_int_o),

    .xgmii_txc         (intf.xgmii_txc),  
    .xgmii_txd         (intf.xgmii_txd)

);

//  xgmii loopback
assign intf.xgmii_rxc = intf.xgmii_txc;
assign intf.xgmii_rxd = intf.xgmii_txd;

// clk generatte
initial begin
  clk_156m25 = 0;
  clk_xgmii_rx = 0;
  clk_xgmii_tx = 0;
  wb_clk_i = 0;

  intf.reset_156m25_n=1;
  intf.reset_xgmii_rx_n=1;
  intf.reset_xgmii_tx_n=1;
  intf.wb_rst_i=0;

  forever begin
  // cycle is 1/156.25MHz = 6.4ns
    #3200
    clk_156m25 = ~clk_156m25;
    clk_xgmii_rx = ~clk_xgmii_rx;
    clk_xgmii_tx = ~clk_xgmii_tx;
    wb_clk_i = ~wb_clk_i;
  end
end

// reset
//initial begin
// intf.assert_reset();
//end

initial begin
  uvm_config_db#(virtual mac_if)::set(uvm_root::get(), "uvm_test_top.env.mst_agent", "vif", intf);
  uvm_config_db#(virtual mac_if)::set(uvm_root::get(), "uvm_test_top.env.slv_agent", "vif", intf);
  uvm_config_db#(virtual mac_if)::set(uvm_root::get(), "uvm_test_top.env", "vif", intf);
  uvm_config_db#(virtual mac_if)::set(uvm_root::get(), "uvm_test_top", "vif", intf);
  run_test();
end

initial begin
  $fsdbDumpfile("mac_tb.fsdb");
  $fsdbDumpvars("+all");
end

initial begin
  #1500000000;
  $finish();
end


endmodule
`endif
