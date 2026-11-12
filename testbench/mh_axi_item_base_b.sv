`ifndef MH_AXI_ITEM_BASE_B_SV
    `define MH_AXI_ITEM_BASE_B_SV

    class mh_axi_item_base_b extends mh_axi_item_base;
        rand bit ready_default;
        `uvm_object_utils(mh_axi_item_base_b)
        function new(string name = "");
            super.new(name);
        endfunction

        constraint ready_d{
            ready_default dist {
                1 := 70,
                0 := 30
            };
        }

        virtual function string convert2string();
            string result;
            result = $sformatf("ready_default : %0b" , ready_default);
            return result;
        endfunction

        endclass

`endif