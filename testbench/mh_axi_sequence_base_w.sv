`ifndef MH_AXI_SEQUENCE_BASE_W_SV
    `define MH_AXI_SEQUENCE_BASE_W_SV

    class mh_axi_sequence_base_w#(int unsigned DATA_WIDTH = 32) extends uvm_sequence#(mh_axi_item_drv_w);
        `uvm_declare_p_sequencer(mh_axi_sequencer_w#(DATA_WIDTH))

        rand mh_axi_item_drv_w item;

        `uvm_object_param_utils(mh_axi_sequence_base_w#(DATA_WIDTH))
        function new(string name = "");
            super.new(name);
        endfunction


        virtual task body();
            logic [7:0] tr_len;
            logic [2:0] beat_size;
            int unsigned bytes_per_beat;

            p_sequencer.get_tr_len(tr_len);
            p_sequencer.get_beat_size(beat_size);
            if (beat_size > $clog2(DATA_WIDTH / 8)) begin
                `uvm_fatal("W_SEQUENCE", $sformatf("Unsupported beat size %0d for a %0d-bit data bus", beat_size, DATA_WIDTH))
            end
            bytes_per_beat = 1 << beat_size;

            for (int i = 0; i <= tr_len; i++) begin
                item = mh_axi_item_drv_w::type_id::create("item");
                start_item(item);
                if (!item.randomize() with { data.size() == bytes_per_beat; 
                                            lanes inside {[0 : (2**(p_sequencer.get_data_width()/8)) - 1 ]};}) 
                begin
                    `uvm_fatal("W_SEQUENCE", "Failed to randomize write-data bytes for the requested beat size")
                end
                //item.lanes = (1 << bytes_per_beat) - 1;
                item.wlast = (i == tr_len);
                finish_item(item);
            end
        endtask
    endclass

`endif