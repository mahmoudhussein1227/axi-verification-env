`ifndef MH_AXI_TEST_BASE_SV
    `define MH_AXI_TEST_BASE_SV

    class mh_axi_test_base extends uvm_test;
        localparam int unsigned ADDR_WIDTH = `MH_AXI_ADDR_WIDTH;
        localparam int unsigned ID_WIDTH = `MH_AXI_ID_WIDTH;
        localparam int unsigned MEM_DEPTH = `MH_AXI_MEM_DEPTH;
        localparam int unsigned DATA_WIDTH = `MH_AXI_DATA_WIDTH;
        // env handle
        mh_axi_env#(ADDR_WIDTH, ID_WIDTH, DATA_WIDTH) env;

        `uvm_component_utils(mh_axi_test_base)
        function new (string name = "" , uvm_component parent = null);
            super.new(name , parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            // build the env
            env = mh_axi_env#(ADDR_WIDTH, ID_WIDTH, DATA_WIDTH)::type_id::create("env" , this);

        endfunction

        virtual task run_phase(uvm_phase phase);
            mh_axi_sequence_base_aw#(ADDR_WIDTH , ID_WIDTH) sequence_aw;
            mh_axi_sequence_base_w#(DATA_WIDTH) sequence_w;
            mh_axi_sequence_base_b sequence_b;

            super.run_phase(phase);
            phase.raise_objection(this);
            `uvm_info("DEBUG" , "START OF THE TEST" , UVM_LOW)
            #100;
            fork
                begin
                    sequence_aw = mh_axi_sequence_base_aw#(ADDR_WIDTH , ID_WIDTH)::type_id::create("sequence_aw");
                    sequence_aw.mem_depth = MEM_DEPTH;
                    sequence_aw.start(env.agent_aw.sequencer);

                    sequence_w = mh_axi_sequence_base_w#(DATA_WIDTH)::type_id::create("sequence_w");
                    sequence_w.set_sequencer(env.agent_w.sequencer);
                    sequence_w.start(env.agent_w.sequencer);
                end
                begin
                    sequence_b = mh_axi_sequence_base_b::type_id::create("sequence_b");
                    sequence_b.start(env.agent_b.sequencer);
                end
            join
           
            #100;
            `uvm_info("DEBUG" , "END OF THE TEST" , UVM_LOW)
            phase.drop_objection(this);
        endtask
    endclass

`endif