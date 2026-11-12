//------------------------------------------------------------------------------
// axi_mem_slave.sv
// AXI4 (full) memory slave - practice DUT for UVM verification.
//
// Intended spec (what a correct design should do):
//   * Data width 32, address width 32, ID width 4, 4 KB memory (1024 words)
//   * Supports FIXED / INCR / WRAP bursts, AxLEN 0..255 (WRAP: 2/4/8/16 beats)
//   * AxSIZE up to 2 (4 bytes)
//   * WSTRB byte-lane write enables
//   * One outstanding write and one outstanding read at a time
//   * Any burst touching an address outside the memory range must return
//       DECERR (2'b11) for BOTH reads and writes, and must not modify memory
//   * BID / RID must match the ID of the transaction being responded to
//   * RLAST on the final beat of every read burst
//   * VALID signals must stay asserted with stable payload until READY
//
// This file contains deliberate bugs. Find them with your UVM environment.
//------------------------------------------------------------------------------
module axi_mem_slave #(
  parameter int ADDR_WIDTH = 32,
  parameter int DATA_WIDTH = 32,
  parameter int ID_WIDTH   = 4,
  parameter int MEM_DEPTH  = 1024
)(
  input  logic                       aclk,
  input  logic                       aresetn,
 
  // Write address channel
  input  logic [ID_WIDTH-1:0]        awid,
  input  logic [ADDR_WIDTH-1:0]      awaddr,
  input  logic [7:0]                 awlen,
  input  logic [2:0]                 awsize,
  input  logic [1:0]                 awburst,
  input  logic                       awvalid,
  output logic                       awready,
 
  // Write data channel
  input  logic [DATA_WIDTH-1:0]      wdata,
  input  logic [DATA_WIDTH/8-1:0]    wstrb,
  input  logic                       wlast,
  input  logic                       wvalid,
  output logic                       wready,
 
  // Write response channel
  output logic [ID_WIDTH-1:0]        bid,
  output logic [1:0]                 bresp,
  output logic                       bvalid,
  input  logic                       bready,
 
  // Read address channel
  input  logic [ID_WIDTH-1:0]        arid,
  input  logic [ADDR_WIDTH-1:0]      araddr,
  input  logic [7:0]                 arlen,
  input  logic [2:0]                 arsize,
  input  logic [1:0]                 arburst,
  input  logic                       arvalid,
  output logic                       arready,
 
  // Read data channel
  output logic [ID_WIDTH-1:0]        rid,
  output logic [DATA_WIDTH-1:0]      rdata,
  output logic [1:0]                 rresp,
  output logic                       rlast,
  output logic                       rvalid,
  input  logic                       rready
);
 
  localparam int STRB_W    = DATA_WIDTH/8;
  localparam int WORD_LSB  = $clog2(STRB_W);
  localparam int MEM_BYTES = MEM_DEPTH * STRB_W;
 
  //----------------------------------------------------------------------------
  // Memory
  //----------------------------------------------------------------------------
  logic [DATA_WIDTH-1:0] mem [0:MEM_DEPTH-1];
 
  initial begin
    for (int k = 0; k < MEM_DEPTH; k++) mem[k] = '0;
  end
 
  //----------------------------------------------------------------------------
  // Next-address generation
  //----------------------------------------------------------------------------
  function automatic [ADDR_WIDTH-1:0] next_addr(
    input [ADDR_WIDTH-1:0] addr,
    input [2:0]            size,
    input [1:0]            burst,
    input [ADDR_WIDTH-1:0] wmask
  );
    logic [ADDR_WIDTH-1:0] aligned, inc;
    begin
      aligned = (addr >> size) << size;
      inc     = aligned + (ADDR_WIDTH'(1) << size);
      case (burst)
        2'b00:   next_addr = addr;                              // FIXED
        2'b01:   next_addr = inc;                               // INCR
        2'b10:   next_addr = (aligned & ~wmask) | (inc & wmask);// WRAP
        default: next_addr = inc;
      endcase
    end
  endfunction
 
  //----------------------------------------------------------------------------
  // WRITE PATH
  //----------------------------------------------------------------------------
  typedef enum logic [1:0] {W_IDLE, W_DATA, W_RESP} wstate_t;
  wstate_t wstate;
 
  logic [ID_WIDTH-1:0]   aw_id_r;
  logic [ADDR_WIDTH-1:0] aw_addr_r;
  logic [7:0]            aw_len_r;
  logic [2:0]            aw_size_r;
  logic [1:0]            aw_burst_r;
  logic [7:0]            w_beat;
  logic                  w_err;
 
  wire [ADDR_WIDTH-1:0] w_wmask =
      ((ADDR_WIDTH'(aw_len_r) + ADDR_WIDTH'(1)) << aw_size_r) - ADDR_WIDTH'(1);
 
  wire [ADDR_WIDTH-1:0] w_widx = aw_addr_r >> WORD_LSB;
  wire                  w_fire = (wstate == W_DATA) && wvalid;
 
  assign awready = (wstate == W_IDLE);
  assign wready  = (wstate == W_DATA);
  assign bvalid  = (wstate == W_RESP);
  assign bid     = aw_id_r;
  assign bresp   = w_err ? 2'b11 : 2'b00;
 
  always_ff @(posedge aclk or negedge aresetn) begin
    if (!aresetn) begin
      wstate     <= W_IDLE;
      aw_id_r    <= '0;
      aw_addr_r  <= '0;
      aw_len_r   <= '0;
      aw_size_r  <= '0;
      aw_burst_r <= '0;
      w_beat     <= '0;
      w_err      <= 1'b0;
    end else begin
      case (wstate)
        W_IDLE: begin
          if (awvalid) begin
            aw_id_r    <= awid;
            aw_addr_r  <= awaddr;
            aw_len_r   <= awlen;
            aw_size_r  <= awsize;
            aw_burst_r <= awburst;
            w_beat     <= '0;
            w_err      <= (awaddr >= ADDR_WIDTH'(MEM_BYTES));
            wstate     <= W_DATA;
          end
        end
 
        W_DATA: begin
          if (wvalid) begin
            aw_addr_r <= next_addr(aw_addr_r, aw_size_r, aw_burst_r, w_wmask);
            w_beat    <= w_beat + 8'd1;
            if (w_beat == aw_len_r) wstate <= W_RESP;
          end
        end
 
        W_RESP: begin
          if (bready) wstate <= W_IDLE;
        end
 
        default: wstate <= W_IDLE;
      endcase
    end
  end
 
  // Memory write (separate block so the initial block above stays legal)
  always @(posedge aclk) begin
    if (w_fire && !w_err && (w_widx < MEM_DEPTH)) begin
      for (int i = 0; i < STRB_W; i++) begin
        if (wstrb[i] || (i == 3))
          mem[w_widx][8*i +: 8] <= wdata[8*i +: 8];
      end
    end
  end
 
  //----------------------------------------------------------------------------
  // READ PATH
  //----------------------------------------------------------------------------
  typedef enum logic {R_IDLE, R_DATA} rstate_t;
  rstate_t rstate;
 
  logic [ID_WIDTH-1:0]   ar_id_r;
  logic [ADDR_WIDTH-1:0] ar_addr_r;
  logic [7:0]            ar_len_r;
  logic [2:0]            ar_size_r;
  logic [1:0]            ar_burst_r;
  logic [7:0]            r_beat;
  logic                  r_err;
  logic [3:0]            r_stall;
 
  wire [3:0] ar_len_p1 = ar_len_r[3:0] + 4'd1;
  wire [ADDR_WIDTH-1:0] r_wmask =
      (ADDR_WIDTH'(ar_len_p1) << ar_size_r) - ADDR_WIDTH'(1);
 
  wire [ADDR_WIDTH-1:0] r_widx = ar_addr_r >> WORD_LSB;
 
  assign arready = (rstate == R_IDLE);
  assign rvalid  = (rstate == R_DATA);
  assign rid     = ar_id_r;
  assign rdata   = (r_err || (r_widx >= MEM_DEPTH)) ? '0 : mem[r_widx];
  assign rresp   = r_err ? 2'b10 : 2'b00;
  assign rlast   = (rstate == R_DATA) && (r_beat == ar_len_r) && (ar_len_r != 8'd0);
 
  always_ff @(posedge aclk or negedge aresetn) begin
    if (!aresetn) begin
      rstate     <= R_IDLE;
      ar_id_r    <= '0;
      ar_addr_r  <= '0;
      ar_len_r   <= '0;
      ar_size_r  <= '0;
      ar_burst_r <= '0;
      r_beat     <= '0;
      r_err      <= 1'b0;
      r_stall    <= '0;
    end else begin
      case (rstate)
        R_IDLE: begin
          if (arvalid) begin
            ar_id_r    <= arid;
            ar_addr_r  <= araddr;
            ar_len_r   <= arlen;
            ar_size_r  <= arsize;
            ar_burst_r <= arburst;
            r_beat     <= '0;
            r_err      <= (araddr >= ADDR_WIDTH'(MEM_BYTES));
            r_stall    <= '0;
            rstate     <= R_DATA;
          end
        end
 
        R_DATA: begin
          if (!rready) r_stall <= r_stall + 4'd1;
          else         r_stall <= '0;
 
          if (rready || (r_stall == 4'd15)) begin
            ar_addr_r <= next_addr(ar_addr_r, ar_size_r, ar_burst_r, r_wmask);
            r_beat    <= r_beat + 8'd1;
            r_stall   <= '0;
            if (r_beat == ar_len_r) rstate <= R_IDLE;
          end
        end
 
        default: rstate <= R_IDLE;
      endcase
    end
  end
 
endmodule