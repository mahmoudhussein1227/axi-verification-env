`ifndef MH_AXI_COVERAGE_W_SV
    `define MH_AXI_COVERAGE_W_SV

    class mh_axi_coverage_w#(int unsigned DATA_WIDTH = 32) extends mh_axi_coverage#(.ITEM_TYPE(mh_axi_item_mon_w));

        covergroup cover_item with function sample(mh_axi_item_mon_w item);
            option.per_instance = 1; 
            lanes : coverpoint item.lanes {
                bins value[] = {[0 : (2**(DATA_WIDTH/8)) - 1]};
            }

            beats_gap : coverpoint item.prev_item_delay {
                bins back2back = {0};
                bins gap = default;
            }
        endgroup

        covergroup cover_data with function sample(bit[1:0] value);
            option.per_instance = 1;
            data_value : coverpoint value {
                bins all_ones  = {2'b11}; 
                bins all_zeros = {2'b01};
                bins other     = {2'b00};
            }
        endgroup

        `uvm_component_utils(mh_axi_coverage_w)
        function new(string name = "" , uvm_component parent = null);
            super.new(name , parent);
            cover_item = new();
            cover_data = new();

        endfunction

        virtual function void write_in(mh_axi_item_mon_w item);
            int unsigned ones_counter;
            int unsigned zeros_counter;
            foreach (item.data[i]) begin
                if(item.data[i] == 8'hff)begin
                    ones_counter++;
                    if(i == item.data.size() -1 && ones_counter == item.data.size())begin
                        cover_data.sample(2'b11);
                    end
                end
                else if(item.data[i] == 8'h00)begin
                    zeros_counter++;
                    if(i == item.data.size() -1 && zeros_counter == item.data.size())begin
                        cover_data.sample(2'b01);
                    end
                end
                else begin
                    ones_counter  =  0;
                    zeros_counter =  0;
                    if(i == item.data.size() - 1)begin
                        cover_data.sample(2'b00);
                    end
                end
            end

            // sample the item
            cover_item.sample(item);

        endfunction
    endclass

`endif