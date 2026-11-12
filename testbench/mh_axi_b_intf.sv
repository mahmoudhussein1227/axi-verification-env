interface mh_axi_b_intf #(
  parameter int ID_WIDTH = 4
) (
  input logic aclk
);
  logic aresetn;

  logic [ID_WIDTH-1:0] bid;
  logic [1:0]          bresp;
  logic                bvalid;
  logic                bready;

endinterface
