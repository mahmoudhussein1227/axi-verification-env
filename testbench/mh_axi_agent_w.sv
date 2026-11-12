`ifndef MH_AXI_AGENT_W_SV
    `define MH_AXI_AGENT_W_SV

    class mh_axi_agent_w#(int unsigned DATA_WIDTH = 32) extends mh_axi_agent#(.ITEM_DRV(mh_axi_item_drv_w) , .ITEM_MON(mh_axi_item_mon_w));
        typedef virtual mh_axi_w_intf #(
            .DATA_WIDTH(DATA_WIDTH)
        ) w_vif_t;
        // vif handel
        w_vif_t vif;
        

        `uvm_component_param_utils(mh_axi_agent_w#(DATA_WIDTH))
        function new(string name = "" , uvm_component parent);
            super.new(name , parent);
            // override to the agent components
            mh_axi_agent_config::type_id::set_inst_override(mh_axi_agent_config_w#(DATA_WIDTH)::get_type() , "agent_config" , this);
            mh_axi_sequencer_base#(mh_axi_item_drv_w)::type_id::set_inst_override(mh_axi_sequencer_w#(DATA_WIDTH)::get_type() , "sequencer" , this);
            mh_axi_driver#(mh_axi_item_drv_w)::type_id::set_inst_override(mh_axi_driver_w#(DATA_WIDTH)::get_type() , "driver" , this);
            mh_axi_monitor#(mh_axi_item_mon_w)::type_id::set_inst_override(mh_axi_monitor_w#(DATA_WIDTH)::get_type() , "monitor" , this);
            mh_axi_coverage#(mh_axi_item_mon_w)::type_id::set_inst_override(mh_axi_coverage_w#(DATA_WIDTH)::get_type() , "coverage" , this);

        endfunction

        virtual function void connect_phase(uvm_phase phase);
            mh_axi_agent_config_w#(DATA_WIDTH) child;

            super.connect_phase(phase);
            if (!uvm_resource_db#(w_vif_t)::read_by_type("ANY::*", vif, this)) begin
                `uvm_fatal("W_VIF", "No W-channel virtual interface was set in the resource database")
            end
            if (!$cast(child, agent_config)) begin
                `uvm_fatal("W_CONFIG", "W-channel agent configuration has the wrong type")
            end
            child.set_vif(vif);
        endfunction
    endclass

`endif