`ifndef MH_AXI_SEQUENCER_BASE_SV
    `define MH_AXI_SEQUENCER_BASE_SV

    class mh_axi_sequencer_base#(type ITEM_DRV = mh_axi_item_base) extends uvm_sequencer#(ITEM_DRV);
        `uvm_component_param_utils(mh_axi_sequencer_base#(ITEM_DRV))
        function new(string name = "" , uvm_component parent);
            super.new(name , parent);
        endfunction
    endclass

`endif