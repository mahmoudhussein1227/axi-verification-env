`ifndef MH_AXI_DRIVER_B_SV
    `define MH_AXI_DRIVER_B_SV

    class mh_axi_driver_b#(int unsigned ID_WIDTH = 4) extends mh_axi_driver#(.ITEM_TYPE(mh_axi_item_drv_b));
        typedef virtual mh_axi_b_intf #(
            .ID_WIDTH(ID_WIDTH)
        ) b_vif_t;

        // vif handle;
        b_vif_t vif;

        
        
        `uvm_component_param_utils(mh_axi_driver_b#(ID_WIDTH))
        function new(string name = "" , uvm_component parent = null);
            super.new(name , parent);

        endfunction

        virtual task drive_transaction(mh_axi_item_drv_b item);
            mh_axi_agent_config_b#(ID_WIDTH)child;
            if($cast(child , agent_config))begin
                vif = child.get_vif();
            end
            // start bin level activity
            `uvm_info("DEBUG" , $sformatf("B CH Driving transaction: %0s" , item.convert2string()) , UVM_LOW)
            while(vif.bvalid !== 1)begin
                vif.bready <= item.ready_default;
                @(posedge vif.aclk);
            end
            for(int i = 0 ; i < item.ready_gap ; i ++)begin
                @(posedge vif.aclk);
            end
            // driving the ready
            vif.bready <= 1;
            @(posedge vif.aclk);
            vif.bready <= 0;
        endtask

    endclass

`endif