`ifndef MH_AXI_AGENT_AW_SV
    `define MH_AXI_AGENT_AW_SV

    class mh_axi_agent_aw#(int unsigned ADDR_WIDTH = 32, int unsigned ID_WIDTH = 4)extends mh_axi_agent#(.ITEM_DRV(mh_axi_item_base_aw#(ADDR_WIDTH , ID_WIDTH)) , .ITEM_MON(mh_axi_item_base_aw#(ADDR_WIDTH , ID_WIDTH)));
        typedef virtual mh_axi_aw_intf #(
            .ADDR_WIDTH(ADDR_WIDTH),
            .ID_WIDTH(ID_WIDTH)
        ) aw_vif_t;

        aw_vif_t vif;

        `uvm_component_param_utils(mh_axi_agent_aw#(ADDR_WIDTH , ID_WIDTH))
        function new (string name = "" , uvm_component parent);
            super.new(name , parent);
            is_active = UVM_ACTIVE;
            // override the agent_config type to match the aw agent's
            mh_axi_agent_config::type_id::set_inst_override(mh_axi_agent_config_aw#(ADDR_WIDTH , ID_WIDTH)::get_type() , "agent_config" , this);
            mh_axi_sequencer_base#(mh_axi_item_base_aw#(ADDR_WIDTH , ID_WIDTH))::type_id::set_inst_override(mh_axi_sequencer_aw#(ADDR_WIDTH , ID_WIDTH)::get_type() , "sequencer" , this);
            mh_axi_driver#(mh_axi_item_base_aw#(ADDR_WIDTH , ID_WIDTH))::type_id::set_inst_override(mh_axi_driver_aw#(ADDR_WIDTH , ID_WIDTH)::get_type() , "driver" , this);
            mh_axi_monitor#(mh_axi_item_base_aw#(ADDR_WIDTH , ID_WIDTH))::type_id::set_inst_override(mh_axi_monitor_aw#(ADDR_WIDTH , ID_WIDTH)::get_type() , "monitor" , this);
            mh_axi_coverage#(mh_axi_item_base_aw#(ADDR_WIDTH , ID_WIDTH))::type_id::set_inst_override(mh_axi_coverage_aw#(ADDR_WIDTH , ID_WIDTH)::get_type() , "coverage" , this);

        endfunction

        virtual function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            // get the aw vif from the resourcedb
            if(!uvm_resource_db#(aw_vif_t)::read_by_type("ANY::*" , vif , this))begin
                `uvm_fatal("ALG_ISSUE" , "there is no aw_vif set in the resource_db")
            end

            begin
                mh_axi_agent_config_aw#(ADDR_WIDTH , ID_WIDTH) child;

                if($cast(child, agent_config))begin
                    child.set_vif(vif);
                end
            end
            
        endfunction
    endclass

`endif