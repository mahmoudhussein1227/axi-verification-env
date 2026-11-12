`ifndef MH_AXI_MONITOR_B_sV
    `define MH_AXI_MONITOR_B_sV

    class mh_axi_monitor_b#(int unsigned ID_WIDTH = 4) extends mh_axi_monitor#(mh_axi_item_mon_b);
        typedef virtual mh_axi_b_intf #(
            .ID_WIDTH(ID_WIDTH)
        ) b_vif_t;

        // vif handle;
        b_vif_t vif;

        `uvm_component_param_utils(mh_axi_monitor_b#(ID_WIDTH))
        function new(string name = "" , uvm_component parent = null);
            super.new(name , parent);
        endfunction

       
        virtual task collect_transaction(mh_axi_item_mon_b item);
            mh_axi_agent_config_b#(ID_WIDTH) child;

            if (!$cast(child, agent_config)) begin
                `uvm_fatal("B_CONFIG", "B-channel agent configuration has the wrong type")
            end
            vif = child.get_vif();

           while (vif.bvalid !== 1 || vif.bready !== 1) begin
                item.ready_default = vif.bready;
                @(posedge vif.aclk);
            end

           item.b_resp = response_e'(vif.bresp);
           item.tr_id = vif.bid;
           output_port.write(item);
           `uvm_info("B_MONITOR", $sformatf("%0s", item.convert2string()), UVM_LOW)
           @(posedge vif.aclk);
        endtask 

    endclass
`endif