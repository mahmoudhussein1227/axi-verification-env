`ifndef MH_AXI_DRIVER_AW_SV
    `define MH_AXI_DRIVER_AW_SV

    class mh_axi_driver_aw#(int unsigned ADDR_WIDTH = 32 , int unsigned ID_WIDTH = 4) extends mh_axi_driver#(.ITEM_TYPE(mh_axi_item_base_aw#(ADDR_WIDTH , ID_WIDTH)));
        typedef virtual mh_axi_aw_intf #(
            .ADDR_WIDTH(ADDR_WIDTH),
            .ID_WIDTH(ID_WIDTH)
        ) aw_vif_t;

        aw_vif_t vif;

        
        
        `uvm_component_param_utils(mh_axi_driver_aw#(ADDR_WIDTH , ID_WIDTH))
        function new(string name = "" , uvm_component parent = null);
            super.new(name , parent);

        endfunction

        virtual task drive_transaction(mh_axi_item_base_aw#(ADDR_WIDTH , ID_WIDTH) item);
            mh_axi_agent_config_aw#(ADDR_WIDTH , ID_WIDTH)child;
            if($cast(child , agent_config))begin
                vif = child.get_vif();
            end
            // start bin level activity
            `uvm_info("DEBUG" , $sformatf("Driving transaction: %0s" , item.convert2string()) , UVM_LOW)
            @(posedge vif.aclk);
            vif.awvalid <= 1 ;
            vif.awid    <= item.tr_id;
            vif.awaddr  <= item.st_addr;
            vif.awlen   <= item.tr_len;
            vif.awsize  <= item.beat_size;
            vif.awburst <= item.burst_type;
            @(posedge vif.aclk);
            while (vif.awready !== 1) begin
                @(posedge vif.aclk);
            end
            // end of the aw channel trasnaction
            vif.awvalid <= 0;
            vif.awid    <= 0;
            vif.awaddr  <= 0;
            vif.awlen   <= 0;
            vif.awsize  <= 0;
            vif.awburst <= 0;
        endtask

    endclass

`endif