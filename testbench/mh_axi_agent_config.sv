`ifndef MH_AXI_AGENT_CONFIG_SV
    `define MH_AXI_AGENT_CONFIG_SV
    
    class mh_axi_agent_config extends uvm_component;
        protected uvm_active_passive_enum is_active;
        protected bit has_coverage;

        `uvm_component_utils(mh_axi_agent_config)
        function new (string name = "" , uvm_component parent = null);
            super.new(name , parent);
            is_active = UVM_ACTIVE;
            has_coverage = 1'b1;
        endfunction

        virtual function uvm_active_passive_enum get_is_active();
            return is_active;
        endfunction

        virtual function void set_is_active(uvm_active_passive_enum value);
            is_active = value;
        endfunction

        virtual function bit get_has_coverage();
            return has_coverage;
        endfunction

        virtual function void set_has_coverage(bit value);
            has_coverage = value;
        endfunction

    endclass


`endif