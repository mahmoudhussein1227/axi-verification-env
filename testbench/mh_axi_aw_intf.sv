interface mh_axi_aw_intf #(
  parameter int ADDR_WIDTH = 32,
  parameter int ID_WIDTH   = 4
) (
  input logic aclk
);
  logic aresetn;

  logic [ID_WIDTH-1:0]   awid;
  logic [ADDR_WIDTH-1:0] awaddr;
  logic [7:0]            awlen;
  logic [2:0]            awsize;
  logic [1:0]            awburst;
  logic                  awvalid;
  logic                  awready;

endinterface
