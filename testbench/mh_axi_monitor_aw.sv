`ifndef MH_AXI_MONITOR_AW
    `define MH_AXI_MONITOR_AW

    class mh_axi_monitor_aw#(int unsigned ADDR_WIDTH = 32 , int unsigned ID_WIDTH = 4) extends mh_axi_monitor#(mh_axi_item_base_aw#(ADDR_WIDTH , ID_WIDTH));
         typedef virtual mh_axi_aw_intf #(
            .ADDR_WIDTH(ADDR_WIDTH),
            .ID_WIDTH(ID_WIDTH)
        ) aw_vif_t;

        aw_vif_t vif;

        // port to pass tr_len info the write data ch
        uvm_analysis_port#(logic [7:0]) tr_len_port;
        uvm_analysis_port#(logic [2:0]) beat_size_port;

        `uvm_component_param_utils(mh_axi_monitor_aw#(ADDR_WIDTH , ID_WIDTH))
        function new(string name = "" , uvm_component parent = null);
            super.new(name , parent);
            tr_len_port = new("tr_len_port", this);
            beat_size_port = new("beat_size_port" , this);
        endfunction

        virtual task collect_transaction(mh_axi_item_base_aw#(ADDR_WIDTH , ID_WIDTH) item);
            mh_axi_agent_config_aw#(ADDR_WIDTH , ID_WIDTH) child;
            if (!$cast(child, agent_config)) begin
                `uvm_fatal("AW_CONFIG", "AW-channel agent configuration has the wrong type")
            end
            vif = child.get_vif();

            do begin
                @(posedge vif.aclk);
            end while (vif.awvalid !== 1'b1 || vif.awready !== 1'b1);

            item.tr_id      = vif.awid;
            item.st_addr    = vif.awaddr;
            item.tr_len     = vif.awlen;
            item.beat_size  = vif.awsize;
            item.burst_type = mh_axi_burst_type_e'(vif.awburst);
            output_port.write(item);
            tr_len_port.write(item.tr_len);  
            beat_size_port.write(item.beat_size);  
                      
            `uvm_info("DEBUG", $sformatf("item_collected -> %0s" , item.convert2string()) , UVM_LOW)
            // and send it to the analysis port
            @(posedge vif.aclk);
        endtask

    endclass

`endif