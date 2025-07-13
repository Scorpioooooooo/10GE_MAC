`ifndef MAC_REG_ADAPTER_SV
`define MAC_REG_ADAPTER_SV

class mac_reg_adapter extends uvm_reg_adapter;
  `uvm_object_utils(mac_reg_adapter)
  function new(string name = "mac_reg_adapter");
    super.new(name);
    provides_responses = 1;
  endfunction

  function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    mac_transaction tr;
    tr = mac_transaction::type_id::create("tr");
    tr.dst_addr = rw.dst_addr;
    tr.src_addr = rw.src_addr;
  endfunction

  function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
  endfunction
endclass

`endif // mac_REG_ADAPTER

