`ifndef MH_AXI_ITEM_BASE_AW_SV
    `define MH_AXI_ITEM_BASE_AW_SV

    class mh_axi_item_base_aw#(int unsigned ADDR_WIDTH = 32 , int unsigned ID_WIDTH = 4) extends mh_axi_item_base;
        // aw channel transaction items
        // starting addr
        rand logic [ADDR_WIDTH - 1 : 0] st_addr;
        // transaction id 
        rand logic [ID_WIDTH - 1 : 0] tr_id;
        // transaction length
        rand logic [7 : 0] tr_len;
        // beat size in bytes
        rand logic [2 : 0] beat_size;
        // burst type
        rand mh_axi_burst_type_e burst_type;

        // default constraints
        constraint aw_st_addr_d {
            // The W-channel sequence receives no address, so use the low byte lanes.
            st_addr[1:0] == 2'b00;
            beat_size inside {[0:2]};
        }

        `uvm_object_param_utils(mh_axi_item_base_aw#(ADDR_WIDTH , ID_WIDTH))
        function new(string name = "");
            super.new(name);
        endfunction

        // convert2string function
        virtual function string convert2string();
            string result;

            result = $sformatf("st_addr = %0x , tr_id = %0x , tr_len = %0d , beat_size = %0d , burst_type = %0s" , 
            st_addr , tr_id , tr_len , beat_size , burst_type);
        
            return result;
        endfunction

    endclass

`endif