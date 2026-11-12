`ifndef MH_AXI_AGENT_CONFIG_B_SV
    `define MH_AXI_AGENT_CONFIG_B_SV

    class mh_axi_agent_config_b#(int unsigned ID_WIDTH = 4)extends mh_axi_agent_config;
        // vif type 
        typedef virtual mh_axi_b_intf #(
            .ID_WIDTH(ID_WIDTH)
        ) b_vif_t;

        // vif handle;
        local b_vif_t vif;

        `uvm_component_param_utils(mh_axi_agent_config_b#(ID_WIDTH))
        function new(string name = "" , uvm_component parent = null);
            super.new(name , parent);
            has_coverage = 0;
        endfunction

        virtual function b_vif_t get_vif();
            return vif;
        endfunction

        virtual function void set_vif(b_vif_t value);
            if(vif != null)begin
                `uvm_fatal("ALG_ISSUE" , "b_ch vif can't be set more than once during the simulation");
            end
            vif = value;
        endfunction

        virtual function void start_of_simulation_phase(uvm_phase phase);
            super.start_of_simulation_phase(phase);
            if(vif == null)begin
                `uvm_fatal("ALG_ISSU" , "the vif of the b channel can't be null upon the start of sim")
            end
            else begin
                `uvm_info("DEBUG" , "the vif of the b channel is configured successfully" , UVM_LOW)
            end
        endfunction

    endclass

`endif