`ifndef MH_AXI_DRIVER_W_SV
    `define MH_AXI_DRIVER_W_SV

    class mh_axi_driver_w#(int unsigned DATA_WIDTH = 32) extends mh_axi_driver#(.ITEM_TYPE(mh_axi_item_drv_w));
        typedef virtual mh_axi_w_intf #(
            .DATA_WIDTH(DATA_WIDTH)
        ) w_vif_t;

        w_vif_t vif;

        `uvm_component_param_utils(mh_axi_driver_w#(DATA_WIDTH))
        function new(string name = "" , uvm_component parent = null);
            super.new(name , parent);
        endfunction

        virtual task drive_transaction(mh_axi_item_drv_w item);
            mh_axi_agent_config_w#(DATA_WIDTH) child;
            logic [DATA_WIDTH-1:0] temp_data;
            localparam int STRB_WIDTH = DATA_WIDTH / 8;

            if (!$cast(child, agent_config)) begin
                `uvm_fatal("W_CONFIG", "W-channel agent configuration has the wrong type")
            end
            vif = child.get_vif();

            `uvm_info("DEBUG", $sformatf("W CH DRIVING item -> %0s", item.convert2string()), UVM_LOW)

            if (item.data.size() == 0 || item.data.size() > STRB_WIDTH) begin
                `uvm_fatal("W_DRIVER", $sformatf("Invalid byte count %0d for a %0d-bit W channel", item.data.size(), DATA_WIDTH))
            end

            repeat (item.pre_drv_delay) @(posedge vif.aclk);
            vif.wvalid <= 1'b1;
            vif.wstrb  <= item.lanes;
            vif.wlast  <= item.wlast;
            temp_data = '0;
            for (int i = 0; i < item.data.size(); i++) begin
                temp_data[(i*8) +: 8] = item.data[i];
            end
            vif.wdata <= temp_data;

            do begin
                @(posedge vif.aclk);
            end while (vif.wvalid !== 1'b1 || vif.wready !== 1'b1);
            vif.wvalid <= 1'b0;
            vif.wdata  <= '0;
            vif.wstrb  <= '0;
            vif.wlast  <= 1'b0;
            repeat (item.pos_drv_delay) @(posedge vif.aclk);
        endtask
    endclass

`endif