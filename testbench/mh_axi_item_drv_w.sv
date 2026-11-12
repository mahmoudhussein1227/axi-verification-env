`ifndef MH_AXI_ITEM_DRV_W_SV
    `define MH_AXI_ITEM_DRV_W_SV

    class mh_axi_item_drv_w extends mh_axi_item_base_w;
        rand int unsigned pre_drv_delay;
        rand int unsigned pos_drv_delay;

        constraint drive_delay_c {
            pre_drv_delay inside {[0:5]};
            pos_drv_delay inside {[0:5]};
        }

        `uvm_object_utils(mh_axi_item_drv_w)
        function new(string name = "");
            super.new(name);
        endfunction

        virtual function string convert2string();
            string result = super.convert2string();
            result  = $sformatf("%0s , pre_drv_delay : %0d , pos_drv_delay : %0d" , result , pre_drv_delay , pos_drv_delay);
            return result;
        endfunction
    endclass

`endif