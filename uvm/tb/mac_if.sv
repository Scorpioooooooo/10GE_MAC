`ifndef MAC_IF_SV
`define MAC_IF_SV
interface mac_if(
                  input logic clk_156m25,
                  logic clk_xgmii_tx,
                  logic clk_xgmii_rx,
                  logic wb_clk_i
                  );

//*** input signals ***//

//pkt_rx_*
logic           pkt_rx_avail; // There has a Packet could be read from RX-FIFO
logic [63:0]    pkt_rx_data;
logic           pkt_rx_eop;
logic           pkt_rx_val;
logic           pkt_rx_sop;
logic [2:0]     pkt_rx_mod; // indecates that valid bytes of last word, only valid during EOP
logic           pkt_rx_err;
// pkt_tx_*
logic           pkt_tx_full;
// wishbone_*
logic [31:0]    wb_dat_o;
logic           wb_ack_o;
logic           wb_int_o;
//xgmii_transmit
logic [7:0]     xgmii_txc;  // indicates that the byte is a control character
logic [63:0]    xgmii_txd;  


//*** output signals ***//

//pkt_tx_*
logic [63:0]    pkt_tx_data;
logic           pkt_tx_eop;
logic           pkt_tx_val;
logic           pkt_tx_sop;
logic [2:0]     pkt_tx_mod; // indecates that valid bytes of last word, only valid during EOP
// pkt_rx_*
logic           pkt_rx_ren; // indecates that is not EMPTY, in next-cycle trasnfer packet
// wishbone_*
logic [7:0]     wb_adr_i;
logic           wb_cyc_i;
logic [31:0]    wb_dat_i;
logic           wb_stb_i;
logic           wb_we_i;
//xgmii_transmit
logic [7:0]     xgmii_rxc;  // indicates that the byte is a control character
logic [63:0]    xgmii_rxd;  


//*** reset signals ***//
logic reset_156m25_n;   // Active low
logic reset_xgmii_tx_n; // Active low
logic reset_xgmii_rx_n; // Active low
logic wb_rst_i; // Ative high




clocking cb_mst @(posedge clk_156m25);
  default input #1ps output #1ps;
  output pkt_tx_data, pkt_tx_eop, pkt_tx_val, pkt_tx_sop, pkt_tx_mod;
  input  pkt_tx_full;
endclocking


clocking cb_slv @(posedge clk_156m25);
  default input #1ps output #1ps;
  output  pkt_rx_ren;
  input pkt_rx_avail, pkt_rx_data, pkt_rx_eop, pkt_rx_val, pkt_rx_sop, pkt_rx_mod, pkt_rx_err;
endclocking

clocking cb_wb @(posedge wb_clk_i);
  default input #1ps output #1ps;
  output wb_adr_i, wb_dat_i, wb_stb_i, wb_we_i, wb_cyc_i;
  input  wb_dat_o, wb_int_o, wb_ack_o;
endclocking


initial begin
   wb_adr_i = 0;
   wb_cyc_i = 0;
   wb_dat_i = 0;
   wb_stb_i = 0;
   wb_we_i = 0; 
end

task assert_reset();
  reset_156m25_n = 1;
  reset_xgmii_tx_n = 1;
  reset_xgmii_rx_n = 1;
  repeat(5) @(posedge clk_156m25);
  reset_156m25_n = 0;
  reset_xgmii_tx_n = 0;
  reset_xgmii_rx_n = 0;
endtask


endinterface
`endif
