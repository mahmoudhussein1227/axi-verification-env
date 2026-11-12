`ifndef MH_AXI_ITEM_DRV_B_SV
    `define MH_AXI_ITEM_DRV_B_SV

    class mh_axi_item_drv_b extends mh_axi_item_base_b;
        rand int unsigned ready_gap;
        constraint ready_gap_d{
            soft ready_gap <= 10;
        }
        `uvm_object_utils(mh_axi_item_drv_b)
        function new(string name = "");
            super.new(name);
        endfunction

        virtual function string convert2string();
            string result;
            result = $sformatf("%0s , ready_gap : %0d" , super.convert2string() , ready_gap);
            return result;
        endfunction
    endclass

`endif