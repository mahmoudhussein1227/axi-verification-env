`ifndef MH_AXI_COVERAGE_SV
    `define MH_AXI_COVERAGE_SV

    `uvm_analysis_imp_decl(_in) 
    class mh_axi_coverage#(type ITEM_TYPE = mh_axi_item_base) extends uvm_component;
        uvm_analysis_imp_in#(ITEM_TYPE, mh_axi_coverage#(ITEM_TYPE)) port_in;

        `uvm_component_param_utils( mh_axi_coverage#(ITEM_TYPE))
        function new(string name = "" , uvm_component parent = null);
            super.new(name , parent);
            port_in = new("port_in" , this);
        endfunction

        virtual function void write_in(ITEM_TYPE item);
            // must be implemented by each channel agent coverage component
            `uvm_fatal("ALG_ISSUE" , "write function of the converage comp. must be implemented by each agent coverage comp")
        endfunction



    endclass 

`endif