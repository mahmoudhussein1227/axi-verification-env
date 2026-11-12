`ifndef MH_AXI_ITEM_BASE_W_SV
    `define MH_AXI_ITEM_BASE_W_SV

    class mh_axi_item_base_w extends mh_axi_item_base;
        // list of bytes data
        rand logic[7:0]data[$];
        // wstrob 
        rand int unsigned lanes;
        bit wlast;

        
        
        `uvm_object_utils(mh_axi_item_base_w)
        function new(string name = "");
            super.new(name);
        endfunction

        virtual function string convert2string();
            string result;
            result = $sformatf("wr_data : %0p , lanes : %0b , wlast : %0b" , data , lanes, wlast);
            return result;
        endfunction
    endclass

`endif