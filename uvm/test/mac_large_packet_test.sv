`ifndef MAC_LARGE_PACKET_TEST_SV
`define MAC_LARGE_PACKET_TEST_SV
class mac_large_packet_test extends mac_base_test;

  `uvm_component_utils(mac_large_packet_test)

  function new(string name="mac_large_packet_test",uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // TODO
    // modify components' configurations
  endfunction

  task run_phase(uvm_phase phase);
    mac_large_packet_virt_sequence seq = mac_large_packet_virt_sequence::type_id::create("seq");
    super.run_phase(phase);
    //phase.raise_objection(this);
    `uvm_info("SEQ", "sequence starting", UVM_LOW)
    //seq.start(env.virt_sqr);
    for(int i=0; i<10; i++)begin
      #10;
      `uvm_info("case0","phase is executed",UVM_LOW)
    end;
    //#100
    `uvm_info("case0","run phase is executed",UVM_LOW)
    `uvm_info("SEQ", "sequence finished", UVM_LOW)
    //phase.drop_objection(this);
  endtask

  task main_phase(uvm_phase phase);
    phase.raise_objection(this);
    for(int i=0; i<10; i++)begin
      #10;
      `uvm_info("case0","main phase is executed",UVM_LOW)
    end
    phase.drop_objection(this);
  endtask
endclass
`endif

