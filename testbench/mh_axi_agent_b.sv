`ifndef MH_AXI_AGENT_B_SV
    `define MH_AXI_AGENT_B_SV

    class mh_axi_agent_b#(int unsigned ID_WIDTH = 4) extends mh_axi_agent#(.ITEM_DRV(mh_axi_item_drv_b) , .ITEM_MON(mh_axi_item_mon_b));
        // vif type 
        typedef virtual mh_axi_b_intf #(
            .ID_WIDTH(ID_WIDTH)
        ) b_vif_t;

        // vif handle;
        b_vif_t vif;

        `uvm_component_param_utils(mh_axi_agent_b#(ID_WIDTH))
        function new(string name = "" , uvm_component parent = null);
            super.new(name , parent);
            // comp overrides
            mh_axi_agent_config::type_id::set_inst_override(mh_axi_agent_config_b#(ID_WIDTH)::get_type() , "agent_config" , this);
            mh_axi_sequencer_base#(mh_axi_item_drv_b)::type_id::set_inst_override(mh_axi_sequencer_b::get_type() , "sequencer" , this);
            mh_axi_driver#(mh_axi_item_drv_b)::type_id::set_inst_override(mh_axi_driver_b#(ID_WIDTH)::get_type() , "driver" , this);
            mh_axi_monitor#(mh_axi_item_mon_b)::type_id::set_inst_override(mh_axi_monitor_b#(ID_WIDTH)::get_type() , "monitor" , this);

        endfunction

        virtual function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
           
            // get the vif of b_ch from the resource db
            if (!uvm_resource_db#(b_vif_t)::read_by_type("ANY::*", vif, this)) begin
                `uvm_fatal("B_VIF", "No B-channel virtual interface was set in the resource database")
            end
            begin
                mh_axi_agent_config_b#(ID_WIDTH) child;
                if($cast( child , agent_config))begin
                    child.set_vif(vif);
                end
            end
            
        endfunction



    endclass

`endif