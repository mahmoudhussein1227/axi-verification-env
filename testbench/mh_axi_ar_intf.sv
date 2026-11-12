interface mh_axi_ar_intf #(
  parameter int ADDR_WIDTH = 32,
  parameter int ID_WIDTH   = 4
) (
  input logic aclk
);
  logic aresetn;

  logic [ID_WIDTH-1:0]   arid;
  logic [ADDR_WIDTH-1:0] araddr;
  logic [7:0]            arlen;
  logic [2:0]            arsize;
  logic [1:0]            arburst;
  logic                  arvalid;
  logic                  arready;

endinterface
