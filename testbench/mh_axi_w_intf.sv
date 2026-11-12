interface mh_axi_w_intf #(
  parameter int DATA_WIDTH = 32
) (
  input logic aclk
);
  logic aresetn;

  logic [DATA_WIDTH-1:0]   wdata;
  logic [DATA_WIDTH/8-1:0] wstrb;
  logic                    wlast;
  logic                    wvalid;
  logic                    wready;

endinterface
