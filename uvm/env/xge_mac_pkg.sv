`ifndef XGE_MAC_PKG_SV
`define XGE_MAC_PKG_SV
package xge_mac_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import mac_pkg::*;

  `include "mac_rgm.sv"
  `include "mac_config.sv"
  `include "mac_reg_adapter.sv"
  `include "mac_subscriber.sv"
  `include "mac_scoreboard.sv"
  `include "mac_coverage.sv"
  `include "mac_virtual_sequencer.sv"
  `include "mac_env.sv"
  `include "mac_seq_lib.svh"
  `include "mac_tests.svh" 
endpackage

`endif//XGE_MAC_PKG_SV
