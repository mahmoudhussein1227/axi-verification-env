`ifndef MH_AXI_DRIVER_SV
    `define MH_AXI_DRIVER_SV

    class mh_axi_driver#(type ITEM_TYPE = mh_axi_item_base) extends uvm_driver#(.REQ(ITEM_TYPE));
        // drive_transactions process handle
        process process_drive_transactions;
        // agent_config hande
        mh_axi_agent_config agent_config;
        `uvm_component_param_utils(mh_axi_driver#(ITEM_TYPE))
        function new(string name = "" , uvm_component parent = null);
            super.new(name , parent);
        endfunction

        //drive transaction
        virtual task drive_transaction(ITEM_TYPE item);
            `uvm_fatal("ALG_ISSUE" , "the drive_transaction must be implemented")

        endtask
        //drive transactions
        virtual task drive_transactions();
            ITEM_TYPE item;
            fork
                begin
                    process_drive_transactions = process::self();
                    forever begin
                        seq_item_port.get_next_item(item);
                        drive_transaction(item);
                        seq_item_port.item_done();
                    end    
                end
            join
            
        endtask

        //run phase
        virtual task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                drive_transactions();    
            end      
        endtask

    endclass


`endif