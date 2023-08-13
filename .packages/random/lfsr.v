module lfsr (
    input wire clk,
    input wire resetn,

    input wire valid,
    output reg ready,
    input wire [3:0] wstrb,
    input wire [31:0] addr,
    input wire [31:0] wdata,
    output reg [31:0] rdata
);

  reg [31:0] random;

  always @(posedge clk) begin
    if (!resetn) begin
      random <= 0;
    end else begin
      ready <= valid;
      rdata <= random;
      if (|wstrb) begin
        if (wstrb[0]) random[7:0] <= wdata[7:0];
        if (wstrb[1]) random[15:8] <= wdata[15:8];
        if (wstrb[2]) random[23:16] <= wdata[23:16];
        if (wstrb[3]) random[31:24] <= wdata[31:24];
      end else begin
        random <= {random[30:0], ^{random[31], random[3], random[2], 1'b1}};
      end
    end
  end
endmodule
