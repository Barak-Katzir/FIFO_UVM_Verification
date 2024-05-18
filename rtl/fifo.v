module fifo (
  clk      , // Clock
  rst      , // Reset
  data_in  , // Data input
  rd_en    , // Read enable
  wr_en    , // Write enable
  data_out , // Data output
  empty    , // FIFO empty
  full       // FIFO full
);

  // FIFO constants
  parameter DATA_WIDTH = 8;
  parameter ADDR_WIDTH = 4;
  parameter FIFO_DEPTH = (1 << ADDR_WIDTH);

  // Port Declarations
  input                   clk;
  input                   rst;
  input                   rd_en;
  input                   wr_en;
  input  [DATA_WIDTH-1:0] data_in;
  output                  full;
  output                  empty;
  output [DATA_WIDTH-1:0] data_out;

  // Internal variables
  reg [DATA_WIDTH-1:0] mem [0:FIFO_DEPTH-1];
  reg [ADDR_WIDTH-1:0] wr_pointer;
  reg [ADDR_WIDTH-1:0] rd_pointer;
  reg [ADDR_WIDTH  :0] status_cnt;
  reg [DATA_WIDTH-1:0] data_out;

  // Variable assignments
  assign full  = (status_cnt == FIFO_DEPTH);
  assign empty = (status_cnt == 0);

  // Code Start
  always @ (posedge clk or posedge rst)
  begin : WRITE_POINTER
    if (rst) begin
      wr_pointer <= 0;
    end
    else if (wr_en & ~full) begin
      mem[wr_pointer] <= data_in;
      wr_pointer <= wr_pointer + 1;
    end
  end

  always @ (posedge clk or posedge rst)
  begin : READ_POINTER
    if (rst) begin
      data_out <= 0;
      rd_pointer <= 0;
    end
    else if (rd_en & ~empty) begin
      data_out <= mem[rd_pointer];
      rd_pointer <= rd_pointer + 1;
    end
  end

  always @ (posedge clk or posedge rst)
  begin : STATUS_COUNTER
    if (rst)
      status_cnt <= 0;
    // Read but no write.
    else if (rd_en && !(wr_en && !full) && (status_cnt != 0))
      status_cnt <= status_cnt - 1;
    // Write but no read.
    else if (wr_en && !(rd_en && !empty) && (status_cnt != FIFO_DEPTH))
      status_cnt <= status_cnt + 1;
  end

endmodule

