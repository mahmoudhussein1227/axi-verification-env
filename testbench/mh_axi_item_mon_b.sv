`ifndef MH_AXI_ITEM_MON_B_SV
    `define MH_AXI_ITEM_MON_B_SV

    class mh_axi_item_mon_b extends mh_axi_item_base_b;
        response_e b_resp;
        int unsigned tr_id;
        `uvm_object_utils(mh_axi_item_mon_b)
        function new(string name = "");
            super.new(name);
        endfunction

        virtual function string convert2string();
            string result ;
            result = $sformatf("%0s , tr_id : %0d , b_resp : %0s" ,super.convert2string() , tr_id , b_resp.name());
            return result;
        endfunction
    endclass
    
`endif