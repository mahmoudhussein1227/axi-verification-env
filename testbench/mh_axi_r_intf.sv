interface mh_axi_r_intf #(
  parameter int DATA_WIDTH = 32,
  parameter int ID_WIDTH   = 4
) (
  input logic aclk
);
  logic aresetn;

  logic [ID_WIDTH-1:0]   rid;
  logic [DATA_WIDTH-1:0] rdata;
  logic [1:0]            rresp;
  logic                  rlast;
  logic                  rvalid;
  logic                  rready;

endinterface
