`ifndef MH_AXI_AGENT_CONFIG_W_SV
    `define MH_AXI_AGENT_CONFIG_W_SV

    class mh_axi_agent_config_w#(int unsigned DATA_WIDTH = 32) extends mh_axi_agent_config;
        // vif handle 
        typedef virtual mh_axi_w_intf #(
            .DATA_WIDTH(DATA_WIDTH)
        ) w_vif_t;

        local w_vif_t vif;

        `uvm_component_param_utils(mh_axi_agent_config_w#(DATA_WIDTH))
        function new(string name = "" , uvm_component parent);
            super.new(name , parent);
            has_coverage = 1;
        endfunction

        virtual function void set_vif(w_vif_t value);
            if (vif != null)begin
                `uvm_fatal("ALG_ISSUE" , "vif can't be more than on time during the sim")
            end
            vif = value;
        endfunction

        virtual function w_vif_t get_vif();
            return vif;
        endfunction

        virtual function void start_of_simulation_phase(uvm_phase phase);
            super.start_of_simulation_phase(phase);
            if(vif == null)begin
                `uvm_fatal("ALG_ISSU" , "the vif of the w channel can't be null upon the start of sim")
            end
            else begin
                `uvm_info("DEBUG" , "the vif of the w channel is configured successfully" , UVM_LOW)
            end
        endfunction
    endclass

`endif