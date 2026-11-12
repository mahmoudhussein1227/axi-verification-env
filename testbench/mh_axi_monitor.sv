`ifndef MH_AXI_MONITOR_SV
    `define MH_AXI_MONITOR_SV

    class mh_axi_monitor#(type ITEM_TYPE = mh_axi_item_base) extends uvm_monitor;
        mh_axi_agent_config agent_config;
        process process_collect_transacitons;

        uvm_analysis_port#(ITEM_TYPE) output_port;

        `uvm_component_param_utils(mh_axi_monitor#(ITEM_TYPE))
        function new(string name = "" , uvm_component parent = null);
            super.new(name , parent);
            output_port = new("output_port" , this);
        endfunction

        // collect_transaction -> implemented by each agent monitor
        virtual task collect_transaction(ITEM_TYPE item);
            `uvm_fatal("ALG_ISSUE" , "the collect_transaction must be implemented")
        endtask
        // collect_trasnactions 
        virtual task collect_transactions();
            fork
                begin
                    process_collect_transacitons = process::self();
                    forever begin
                        ITEM_TYPE item;
                        item = ITEM_TYPE::type_id::create("item" , this);
                        collect_transaction(item);
                    end
                end
            join
        endtask

        // run_phase
        virtual task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                collect_transactions();
            end
        endtask

    endclass

`endif