`ifndef MH_AXI_SEQUENCER_W_SV
    `define MH_AXI_SEQUENCER_W_SV

    `uvm_analysis_imp_decl(_in_beat_size_sw)
    `uvm_analysis_imp_decl(_tr_len_sw)

    class mh_axi_sequencer_w#(int unsigned DATA_WIDTH = 32) extends mh_axi_sequencer_base#(.ITEM_DRV(mh_axi_item_drv_w));
        uvm_analysis_imp_in_beat_size_sw#(logic[2:0], mh_axi_sequencer_w#(DATA_WIDTH)) port_in_beat_size;
        uvm_tlm_fifo#(logic[2:0]) beat_size_q;
        uvm_analysis_imp_tr_len_sw#(logic[7:0], mh_axi_sequencer_w#(DATA_WIDTH)) port_in_tr_len;

        uvm_tlm_fifo#(logic [7:0]) tr_len_q;

        `uvm_component_param_utils(mh_axi_sequencer_w#(DATA_WIDTH))
        function new(string name = "" , uvm_component parent = null);
            super.new(name , parent);
            port_in_beat_size = new("port_in_beat_size" , this);
            port_in_tr_len = new("port_in_tr_len" , this);
            beat_size_q = new("beat_size_q" , this , 1);
            tr_len_q = new("tr_len_q" , this , 1);
        endfunction

        virtual function int unsigned get_data_width();
            return DATA_WIDTH;
        endfunction

        virtual function void write_tr_len_sw(logic [7:0] tr_len);
            if (!tr_len_q.try_put(tr_len)) begin
                `uvm_fatal("W_SEQUENCER", "Write-length queue is full")
            end
        endfunction

        virtual function void write_in_beat_size_sw(logic[2:0] beat_size);
            if (!beat_size_q.try_put(beat_size)) begin
                `uvm_fatal("W_SEQUENCER", "Beat-size queue is full")
            end
        endfunction

        virtual task get_beat_size(output logic[2:0] beat_size);
            beat_size_q.get(beat_size);
        endtask

        virtual task get_tr_len(output logic[7:0] tr_len);
            tr_len_q.get(tr_len);
        endtask

    endclass

`endif