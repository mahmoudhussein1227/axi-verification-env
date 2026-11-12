`ifndef MH_AXI_AGENT_SV
    `define MH_AXI_AGENT_SV

    class mh_axi_agent#(type ITEM_DRV = mh_axi_item_base , type ITEM_MON  = mh_axi_item_base ) extends uvm_agent;
        // agent_config handle
        mh_axi_agent_config agent_config;
        // sequencer handle
        mh_axi_sequencer_base#(ITEM_DRV) sequencer;
        // driver handle
        mh_axi_driver#(ITEM_DRV) driver;
        // monitor handle
        mh_axi_monitor#(ITEM_MON) monitor;
        // coverage handel
        mh_axi_coverage#(ITEM_MON) coverage;
        `uvm_component_param_utils(mh_axi_agent#(ITEM_DRV , ITEM_MON))
        function new (string name = "" , uvm_component parent = null);
            super.new(name , parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            // create agent components
            agent_config = mh_axi_agent_config::type_id::create("agent_config" , this);
            if(agent_config.get_is_active() == UVM_ACTIVE)begin
                sequencer = mh_axi_sequencer_base#(ITEM_DRV)::type_id::create("sequencer" , this);
                driver    = mh_axi_driver#(ITEM_DRV)::type_id::create("driver" , this);
            end

            monitor  = mh_axi_monitor#(ITEM_MON)::type_id::create("monitor" , this);

            if(agent_config.get_has_coverage())begin
                coverage = mh_axi_coverage#(ITEM_MON)::type_id::create("coverage" , this);
            end
           
            
        endfunction

        virtual function void connect_phase (uvm_phase phase);
            super.connect_phase(phase);
            if(agent_config.get_is_active())begin
                driver.seq_item_port.connect(sequencer.seq_item_export);   
                driver.agent_config = agent_config; 
            end
            monitor.agent_config = agent_config;

            if(agent_config.get_has_coverage())begin
                monitor.output_port.connect(coverage.port_in);
            end
        endfunction

       
    endclass

`endif