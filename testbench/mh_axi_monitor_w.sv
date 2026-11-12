`ifndef MH_AXI_MONITOR_W_SV
    `define MH_AXI_MONITOR_W_SV

    `uvm_analysis_imp_decl(_in_beat_size_mw)

    class mh_axi_monitor_w#(int unsigned DATA_WIDTH = 32) extends mh_axi_monitor#(.ITEM_TYPE(mh_axi_item_mon_w));
        typedef virtual mh_axi_w_intf #(
            .DATA_WIDTH(DATA_WIDTH)
        ) w_vif_t;

        w_vif_t vif;

        uvm_analysis_imp_in_beat_size_mw#(logic[2:0], mh_axi_monitor_w#(DATA_WIDTH)) port_in_beat_size;
        uvm_tlm_fifo#(logic[2:0]) beat_size_q;

        `uvm_component_param_utils(mh_axi_monitor_w#(DATA_WIDTH))
        function new(string name = "" , uvm_component parent = null);
            super.new(name , parent);
            port_in_beat_size = new("port_in_beat_size" , this);
            beat_size_q = new("beat_size_q" , this , 1);
        endfunction

        virtual function void write_in_beat_size_mw(logic[2:0] beat_size);
            if (!beat_size_q.try_put(beat_size)) begin
                `uvm_fatal("W_MONITOR", "Beat-size queue is full")
            end
        endfunction

        bit beat_size_valid;
        logic [2:0] active_beat_size;

        virtual task collect_transaction(mh_axi_item_mon_w item);
            mh_axi_agent_config_w#(DATA_WIDTH) child;

            if (!$cast(child, agent_config)) begin
                `uvm_fatal("W_CONFIG", "W-channel agent configuration has the wrong type")
            end
            vif = child.get_vif();

            if (!beat_size_valid) begin
                beat_size_q.get(active_beat_size);
                if (active_beat_size > $clog2(DATA_WIDTH / 8)) begin
                    `uvm_fatal("W_MONITOR", $sformatf("Unsupported beat size %0d for a %0d-bit data bus", active_beat_size, DATA_WIDTH))
                end
                beat_size_valid = 1'b1;
            end

            forever begin
                @(posedge vif.aclk);
                if (vif.wvalid === 1'b1 && vif.wready === 1'b1) begin
                    break;
                end
                else if(vif.wvalid !== 1'b1)begin
                    item.prev_item_delay++;    
                end
            end

            for (int i = 0; i < (1 << active_beat_size); i++) begin
                item.data.push_back(vif.wdata[(i*8) +: 8]);
            end
            item.lanes = vif.wstrb;
            item.wlast = vif.wlast;
            output_port.write(item);
            `uvm_info("W_MONITOR", $sformatf("%0s", item.convert2string()), UVM_LOW)

            if (item.wlast) begin
                beat_size_valid = 1'b0;
            end
        endtask
    endclass

`endif