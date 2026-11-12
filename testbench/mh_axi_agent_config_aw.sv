`ifndef MH_AXI_AGENT_CONFIG_AW_SV
    `define MH_AXI_AGENT_CONFIG_AW_SV

    class mh_axi_agent_config_aw#(int unsigned ADDR_WIDTH = 32, int unsigned ID_WIDTH = 4) extends mh_axi_agent_config;
        typedef virtual mh_axi_aw_intf #(
            .ADDR_WIDTH(ADDR_WIDTH),
            .ID_WIDTH(ID_WIDTH)
        ) aw_vif_t;

        aw_vif_t vif;

        `uvm_component_param_utils(mh_axi_agent_config_aw#(ADDR_WIDTH , ID_WIDTH))

        function new(string name = "" , uvm_component parent = null);
            super.new(name , parent);
        endfunction

        virtual function aw_vif_t get_vif();
            return vif;
        endfunction

        virtual function void set_vif(aw_vif_t value);
            if(vif != null)begin
                `uvm_fatal("ALG_ISSUE" , "vif can't be more than on time during the sim")
            end
            vif = value;
        endfunction

        virtual function void start_of_simulation_phase(uvm_phase phase);
            super.start_of_simulation_phase(phase);
            if(vif == null)begin
                `uvm_fatal("ALG_ISSU" , "the vif of the aw channel can't be null upon the start of sim")
            end
            else begin
                `uvm_info("DEBUG" , "the vif of the aw channel is configured successfully" , UVM_LOW)
            end
        endfunction
    endclass


`endif