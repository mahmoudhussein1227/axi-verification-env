`ifndef MH_AXI_ENV_SV
    `define MH_AXI_ENV_SV

    class mh_axi_env#(int unsigned ADDR_WIDTH = 32 ,  int unsigned ID_WIDTH = 4 , int unsigned DATA_WIDTH = 32) extends uvm_env;
        //mh_axi_agent agent;
        // aw channel agent
        mh_axi_agent_aw#(ADDR_WIDTH, ID_WIDTH) agent_aw;
        mh_axi_agent_w#(DATA_WIDTH) agent_w;
        mh_axi_agent_b#(ID_WIDTH) agent_b;
        `uvm_component_param_utils(mh_axi_env#(ADDR_WIDTH , ID_WIDTH, DATA_WIDTH))
        function new(string name = "" , uvm_component parent);
            super.new(name , parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            // build the agents
            agent_aw = mh_axi_agent_aw#(ADDR_WIDTH, ID_WIDTH)::type_id::create("agent_aw" , this);
            agent_w  = mh_axi_agent_w#(DATA_WIDTH)::type_id::create("agent_w" , this);
            agent_b  = mh_axi_agent_b#(ID_WIDTH)::type_id::create("agent_b" , this);
        endfunction

        virtual function void connect_phase(uvm_phase phase);
            mh_axi_sequencer_w#(DATA_WIDTH) w_seq;
            mh_axi_monitor_w#(DATA_WIDTH) w_mon;
            mh_axi_monitor_aw#(ADDR_WIDTH, ID_WIDTH) aw_mon;

            super.connect_phase(phase);
            if (!$cast(w_seq, agent_w.sequencer)) begin
                `uvm_fatal("ENV", "W-channel sequencer cast failed")
            end
            if (!$cast(w_mon, agent_w.monitor)) begin
                `uvm_fatal("ENV", "W-channel monitor cast failed")
            end
            if (!$cast(aw_mon, agent_aw.monitor)) begin
                `uvm_fatal("ENV", "AW-channel monitor cast failed")
            end
            // connect the tr_len_port from the aw ch monitor to the tr_len_port of the w ch sequencer
            aw_mon.tr_len_port.connect(w_seq.port_in_tr_len);
            // connect the beat_size_port from the aw ch monitor to the beat_size_port of the w ch sequencer
            aw_mon.beat_size_port.connect(w_seq.port_in_beat_size);
            // connect the beat_size port from aw ch monitor to the w channel monitor
            aw_mon.beat_size_port.connect(w_mon.port_in_beat_size);
        endfunction

    endclass

`endif