`ifndef MAC_IPG_PACKET_TEST_SV
`define MAC_IPG_PACKET_TEST_SV
class mac_ipg_packet_test extends mac_base_test;

  `uvm_component_utils(mac_ipg_packet_test)

  function new(string name="mac_ipg_packet_test",uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // TODO
    // modify components' configurations
  endfunction

  task run_phase(uvm_phase phase);
    mac_ipg_packet_virt_sequence seq = mac_ipg_packet_virt_sequence::type_id::create("seq");
    super.run_phase(phase);
    phase.raise_objection(this);
    `uvm_info("SEQ", "sequence starting", UVM_LOW)
    seq.start(env.virt_sqr);
    `uvm_info("SEQ", "sequence finished", UVM_LOW)
    phase.drop_objection(this);
  endtask
endclass
`endif

