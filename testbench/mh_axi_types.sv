`ifndef MH_AXI_TYPES_FILE_SV
    `define MH_AXI_TYPES_FILE_SV

    //typedef virtual mh_axi_intf axi_vif;
    typedef enum logic [1:0] {
        FIXED = 2'b00,
        INCR  = 2'b01,
        WRAP  = 2'b10,
        RESERVED = 2'b11
    } mh_axi_burst_type_e;

    // b response type
    typedef enum logic[1:0] { AXI_OK = 2'b00 , AXI_ERR = 2'b11 } response_e;
`endif