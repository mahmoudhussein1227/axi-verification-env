`ifndef MH_AXI_SEQUENCER_B_SV
    `define MH_AXI_SEQUENCER_B_SV


    class mh_axi_sequencer_b extends mh_axi_sequencer_base#(.ITEM_DRV(mh_axi_item_drv_b));
        `uvm_component_utils(mh_axi_sequencer_b)
        
        function new(string name = "" , uvm_component parent = null);
            super.new(name , parent);
        endfunction

    endclass

`endif