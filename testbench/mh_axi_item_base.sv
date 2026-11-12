`ifndef MH_AXI_ITEM_BASE_sV
    `define MH_AXI_ITEM_BASE_sV

    class mh_axi_item_base extends uvm_sequence_item;
        `uvm_object_utils(mh_axi_item_base)
        function new(string name = "");
            super.new(name);
        endfunction
    endclass

`endif