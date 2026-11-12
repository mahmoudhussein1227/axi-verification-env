`ifndef  MH_AXI_COVERAGE_AW_SV
    `define MH_AXI_COVERAGE_AW_SV

    class mh_axi_coverage_aw#(int unsigned ADDR_WIDTH = 32 , int unsigned ID_WIDTH = 4) extends mh_axi_coverage#(.ITEM_TYPE(mh_axi_item_base_aw#(ADDR_WIDTH , ID_WIDTH)));
        int unsigned mem_depth;
        
        covergroup cover_item with function sample(mh_axi_item_base_aw#(ADDR_WIDTH , ID_WIDTH) item); 
            option.per_instance = 1;

            burst_type : coverpoint item.burst_type {    
            }
            beat_size : coverpoint item.beat_size{
                bins single_byte = {0};
                bins half_word   = {1};
                bins full_word   = {2};          
            }
            start_addr : coverpoint item.st_addr{
                bins addr_bins[] = {[0 : 4*(mem_depth-1)]} with (item %4 == 0);
                bins illegal_addr = default;
            }
            tr_len : coverpoint item.tr_len{
                
            }
        endgroup

        `uvm_component_param_utils(mh_axi_coverage_aw#(ADDR_WIDTH , ID_WIDTH))
        function new(string name = "" , uvm_component parent = null);
            super.new(name , parent);
            if(!uvm_resource_db#(int unsigned)::read_by_type("ANY::*", mem_depth , this))begin
                `uvm_fatal( "ALG_ISSUE", "can't get the mem depth from the rdb")
            end
            cover_item = new();
        endfunction


        virtual function void write_in(mh_axi_item_base_aw#(ADDR_WIDTH , ID_WIDTH) item);
            cover_item.sample(item);

        endfunction

    endclass

`endif