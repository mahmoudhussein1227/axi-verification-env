`ifndef MH_AXI_SEQUENCE_BASE_B_SV
    `define MH_AXI_SEQUENCE_BASE_B_SV

    class mh_axi_sequence_base_b extends uvm_sequence#(mh_axi_item_drv_b);
        `uvm_object_utils(mh_axi_sequence_base_b)
        function new(string name = "");
            super.new(name);
        endfunction

        // body task
        virtual task body();
            mh_axi_item_drv_b item;
            `uvm_do(item);
        endtask

    endclass

`endif