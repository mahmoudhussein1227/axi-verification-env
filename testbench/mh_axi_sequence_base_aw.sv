`ifndef MH_AXI_SEQUENCE_BASE_AW
    `define MH_AXI_SEQUENCE_BASE_AW

    class mh_axi_sequence_base_aw#(int unsigned ADDR_WIDTH = 32 , int unsigned ID_WIDTH = 4) extends uvm_sequence#(mh_axi_item_base_aw#(ADDR_WIDTH , ID_WIDTH));
        int unsigned mem_depth;

        `uvm_object_param_utils(mh_axi_sequence_base_aw#(ADDR_WIDTH , ID_WIDTH))
        function new (string name = "");
            super.new(name);
            mem_depth = 1024;
        endfunction

        virtual task body();
            mh_axi_item_base_aw#(ADDR_WIDTH , ID_WIDTH) item;
            `uvm_do_with(item , {st_addr inside {[0 : 4*(mem_depth-1)]};})
        endtask

    endclass

`endif