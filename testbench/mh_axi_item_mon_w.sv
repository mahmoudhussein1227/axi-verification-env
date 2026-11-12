`ifndef MH_AXI_ITEM_MON_W_SV
    `define MH_AXI_ITEM_MON_W_SV
    
    class mh_axi_item_mon_w extends mh_axi_item_base_w;
        int unsigned prev_item_delay;
        `uvm_object_utils(mh_axi_item_mon_w)
        function new(string name =  "");
            super.new(name);
        endfunction
        
        virtual function string convert2string();
            string result = super.convert2string();
            result  = $sformatf("%0s , prev_item_delay : %0d" , result , prev_item_delay);
            return result;
        endfunction
    endclass

`endif