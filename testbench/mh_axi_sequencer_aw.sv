`ifndef MH_AXI_SEQUENCER_AW_SV
    `define MH_AXI_SEQUENCER_AW_SV

    class mh_axi_sequencer_aw#(int unsigned ADDR_WIDTH = 32 , int unsigned ID_WIDTH = 4) extends mh_axi_sequencer_base#(.ITEM_DRV(mh_axi_item_base_aw#(ADDR_WIDTH , ID_WIDTH)));
        `uvm_component_param_utils(mh_axi_sequencer_aw#(ADDR_WIDTH , ID_WIDTH))
        function new(string name = "" , uvm_component parent);
            super.new(name , parent);
        endfunction
    endclass

`endif