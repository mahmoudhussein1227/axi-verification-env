`ifndef MH_AXI_ADDR_WIDTH
  `define MH_AXI_ADDR_WIDTH 32
`endif
`ifndef MH_AXI_ID_WIDTH
  `define MH_AXI_ID_WIDTH 4
`endif
`ifndef MH_AXI_MEM_DEPTH
  `define MH_AXI_MEM_DEPTH 1024
`endif
`ifndef MH_AXI_DATA_WIDTH
  `define MH_AXI_DATA_WIDTH 32
`endif

`include "mh_axi_test_pkg.sv"
module testbench;
  
  import uvm_pkg::*;
  import mh_axi_test_pkg::*;

  localparam int ADDR_WIDTH = `MH_AXI_ADDR_WIDTH;
  localparam int DATA_WIDTH = `MH_AXI_DATA_WIDTH;
  localparam int ID_WIDTH   = `MH_AXI_ID_WIDTH;
  localparam int MEM_DEPTH  = `MH_AXI_MEM_DEPTH;

  typedef virtual mh_axi_aw_intf #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .ID_WIDTH(ID_WIDTH)
  ) aw_vif_t;

  typedef virtual mh_axi_w_intf #(
    .DATA_WIDTH(DATA_WIDTH)
  ) w_vif_t;

  typedef virtual mh_axi_b_intf #(
    .ID_WIDTH(ID_WIDTH)
  ) b_vif_t;

  typedef virtual mh_axi_ar_intf #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .ID_WIDTH(ID_WIDTH)
  ) ar_vif_t;

  typedef virtual mh_axi_r_intf #(
    .DATA_WIDTH(DATA_WIDTH),
    .ID_WIDTH(ID_WIDTH)
  ) r_vif_t;

  logic aclk = 1'b0;
  logic aresetn;

  mh_axi_aw_intf #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .ID_WIDTH(ID_WIDTH)
  ) aw_if(.aclk(aclk));

  mh_axi_w_intf #(
    .DATA_WIDTH(DATA_WIDTH)
  ) w_if(.aclk(aclk));

  mh_axi_b_intf #(
    .ID_WIDTH(ID_WIDTH)
  ) b_if(.aclk(aclk));

  mh_axi_ar_intf #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .ID_WIDTH(ID_WIDTH)
  ) ar_if(.aclk(aclk));

  mh_axi_r_intf #(
    .DATA_WIDTH(DATA_WIDTH),
    .ID_WIDTH(ID_WIDTH)
  ) r_if(.aclk(aclk));

  assign aw_if.aresetn = aresetn;
  assign w_if.aresetn  = aw_if.aresetn;
  assign b_if.aresetn  = aw_if.aresetn;
  assign ar_if.aresetn = aw_if.aresetn;
  assign r_if.aresetn  = aw_if.aresetn;

  always #5 aclk = ~aclk;

  initial begin
    aresetn = 1'b0;
    repeat (2) @(posedge aclk);
    @(negedge aclk);
    aresetn = 1'b1;
  end

  axi_mem_slave #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH),
    .ID_WIDTH(ID_WIDTH),
    .MEM_DEPTH(MEM_DEPTH)
  ) dut (
    .aclk(aw_if.aclk),
    .aresetn(aw_if.aresetn),

    .awid(aw_if.awid),
    .awaddr(aw_if.awaddr),
    .awlen(aw_if.awlen),
    .awsize(aw_if.awsize),
    .awburst(aw_if.awburst),
    .awvalid(aw_if.awvalid),
    .awready(aw_if.awready),

    .wdata(w_if.wdata),
    .wstrb(w_if.wstrb),
    .wlast(w_if.wlast),
    .wvalid(w_if.wvalid),
    .wready(w_if.wready),

    .bid(b_if.bid),
    .bresp(b_if.bresp),
    .bvalid(b_if.bvalid),
    .bready(b_if.bready),

    .arid(ar_if.arid),
    .araddr(ar_if.araddr),
    .arlen(ar_if.arlen),
    .arsize(ar_if.arsize),
    .arburst(ar_if.arburst),
    .arvalid(ar_if.arvalid),
    .arready(ar_if.arready),

    .rid(r_if.rid),
    .rdata(r_if.rdata),
    .rresp(r_if.rresp),
    .rlast(r_if.rlast),
    .rvalid(r_if.rvalid),
    .rready(r_if.rready)
  );

  initial begin
    uvm_resource_db#(aw_vif_t)::set("ANY::*", "vif", aw_if);
    uvm_resource_db#(w_vif_t)::set("ANY::*", "vif", w_if);
    uvm_resource_db#(b_vif_t)::set("ANY::*", "vif", b_if);
    uvm_resource_db#(ar_vif_t)::set("ANY::*", "vif", ar_if);
    uvm_resource_db#(r_vif_t)::set("ANY::*", "vif", r_if);

    uvm_resource_db#(int unsigned)::set("ANY::*", "mem_depth", MEM_DEPTH);
    run_test();
  end
endmodule