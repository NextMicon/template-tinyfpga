module hardware (
    input  fpga_clk,
    inout  fpga_flash_csb,
    inout  fpga_flash_clk,
    inout  fpga_flash_io0,
    inout  fpga_flash_io1,
    inout  fpga_flash_io2,
    inout  fpga_flash_io3,
    /* iopin */
    inout  fpga_user_led,
    input  fpga_pin2,
    input  fpga_pin11,
    output fpga_pin1
    /* end */
);

  /* iopin_assign */
  assign fpga_pin1 = uart0_tx;
  /* end */

  ///////////////////////////////////
  // Wire Deffinitions

  wire clk = fpga_clk;
  wire resetn;

  ///////////////////////////////////
  // Parameters

  parameter integer MEM_WORDS = 2048;
  parameter [31:0] STACKADDR = (4 * MEM_WORDS);  // end of memory
  parameter [31:0] PROGADDR_RESET = 32'h0005_0000;  // 1 MB into flash
  parameter [31:0] PROGADDR_IRQ = 32'h0005_0010;  // 1 MB into flash

  /* parameters */
  /* end */

  ///////////////////////////////////
  // Interrupts Request

  reg [31:0] irq;
  always @* begin
    if (!resetn) irq <= 0;
    else begin
      irq = 0;
      /* irq */
      irq[5] = fpga_pin11;
      /* end */
    end
  end

  ///////////////////////////////////
  // CPU

  picorv32 #(
      .STACKADDR(STACKADDR),
      .PROGADDR_RESET(PROGADDR_RESET),
      .PROGADDR_IRQ(PROGADDR_IRQ),
      .BARREL_SHIFTER(1),
      .COMPRESSED_ISA(1),
      .ENABLE_MUL(1),
      .ENABLE_DIV(1),
      .ENABLE_IRQ(1),
      .ENABLE_IRQ_QREGS(1)
  ) cpu (
      .clk      (clk),
      .resetn   (resetn),
      .mem_valid(mem_valid),
      .mem_ready(mem_ready),
      .mem_addr (mem_addr),
      .mem_wdata(mem_wdata),
      .mem_wstrb(mem_wstrb),
      .mem_rdata(mem_rdata),
      .irq      (irq)
  );

  ///////////////////////////////////
  // Memory map interface

  wire mem_valid;
  wire mem_ready;
  wire [3:0] mem_wstrb;
  wire [31:0] mem_addr;
  wire [31:0] mem_wdata;
  wire [31:0] mem_rdata;
  assign mem_ready = |{ram_ready, rom_ready, rom_cfg_ready,  /* mem_ready */
      uart0_ready, gpio0_ready
      /* end */};
  assign mem_rdata = ram_ready ? ram_rdata : rom_ready ? rom_rdata : rom_cfg_ready ? rom_cfg_rdata /* mem_rdata */
      : uart0_ready ? uart0_rdata : gpio0_ready ? gpio0_rdata
      /* end */ : 32'b0;

  ///////////////////////////////////
  // Modules

  por #() por (
      .clk(clk),
      .resetn(resetn)
  );

  ram #(
      .WORDS(2048)
  ) ram (
      .clk(clk),
      .resetn(resetn),
      .valid(ram_valid),
      .ready(ram_ready),
      .wstrb(ram_valid ? mem_wstrb : 4'b0),
      .addr(mem_addr),
      .wdata(mem_wdata),
      .rdata(ram_rdata)
  );
  wire ram_sel = mem_addr[31:14] == 19'h0;
  wire ram_valid = mem_valid && ram_sel;
  wire ram_ready;
  wire [31:0] ram_rdata;

  spirom #() rom (
      .clk(clk),
      .resetn(resetn),
      .valid(rom_valid),
      .ready(rom_ready),
      .wstrb(rom_valid ? mem_wstrb : 4'b0),
      .addr (mem_addr),
      .wdata(mem_wdata),
      .rdata(rom_rdata),
      .cfg_valid(rom_cfg_valid),
      .cfg_ready(rom_cfg_ready),
      .cfg_wstrb(rom_cfg_valid ? mem_wstrb : 4'b0),
      .cfg_addr (mem_addr),
      .cfg_wdata(mem_wdata),
      .cfg_rdata(rom_cfg_rdata),
      .flash_io0_iosel(flash_io0_iosel),
      .flash_io0_in   (flash_io0_in),
      .flash_io0_out  (flash_io0_out),
      .flash_io1_iosel(flash_io1_iosel),
      .flash_io1_in   (flash_io1_in),
      .flash_io1_out  (flash_io1_out),
      .flash_io2_iosel(flash_io2_iosel),
      .flash_io2_in   (flash_io2_in),
      .flash_io2_out  (flash_io2_out),
      .flash_io3_iosel(flash_io3_iosel),
      .flash_io3_in   (flash_io3_in),
      .flash_io3_out  (flash_io3_out),
      .flash_csb(fpga_flash_csb),
      .flash_clk(fpga_flash_clk)
  );
  wire rom_sel = (mem_addr[31:20] == 12'h000) && (4'h5 <= mem_addr[19:16]);
  wire rom_valid = mem_valid && rom_sel;
  wire rom_ready;
  wire [31:0] rom_rdata;
  wire rom_cfg_sel = mem_addr[31:24] == 8'h02;
  wire rom_cfg_valid = mem_valid && rom_cfg_sel;
  wire rom_cfg_ready;
  wire [31:0] rom_cfg_rdata;
  wire flash_io0_iosel;
  wire flash_io0_in;
  wire flash_io0_out;
  wire flash_io1_iosel;
  wire flash_io1_in;
  wire flash_io1_out;
  wire flash_io2_iosel;
  wire flash_io2_in;
  wire flash_io2_out;
  wire flash_io3_iosel;
  wire flash_io3_in;
  wire flash_io3_out;
  tristate flash_io0_iobuf (
      .pin  (fpga_flash_io0),
      .iosel(flash_io0_iosel),
      .in   (flash_io0_in),
      .out  (flash_io0_out)
  );
  tristate flash_io1_iobuf (
      .pin  (fpga_flash_io1),
      .iosel(flash_io1_iosel),
      .in   (flash_io1_in),
      .out  (flash_io1_out)
  );
  tristate flash_io2_iobuf (
      .pin  (fpga_flash_io2),
      .iosel(flash_io2_iosel),
      .in   (flash_io2_in),
      .out  (flash_io2_out)
  );
  tristate flash_io3_iobuf (
      .pin  (fpga_flash_io3),
      .iosel(flash_io3_iosel),
      .in   (flash_io3_in),
      .out  (flash_io3_out)
  );

  /* instances */
  uart uart0 (
      .clk(clk),
      .resetn(resetn),
      .valid(uart0_valid),
      .ready(uart0_ready),
      .wstrb(uart0_valid ? mem_wstrb : 4'b0),
      .addr(mem_addr),
      .wdata(mem_wdata),
      .rdata(uart0_rdata),
      .rx(fpga_pin2),
      .tx(uart0_tx)
  );
  wire uart0_sel = mem_addr[31:24] == 8'h03;
  wire uart0_valid = mem_valid && uart0_sel;
  wire uart0_ready;
  wire [31:0] uart0_rdata;
  wire uart0_tx;

  gpio gpio0 (
      .clk(clk),
      .resetn(resetn),
      .valid(gpio0_valid),
      .ready(gpio0_ready),
      .wstrb(gpio0_valid ? mem_wstrb : 4'b0),
      .addr (mem_addr),
      .wdata(mem_wdata),
      .rdata(gpio0_rdata),
      .io_iosel(gpio0_io_iosel),
      .io_in   (gpio0_io_in),
      .io_out  (gpio0_io_out)
  );
  wire gpio0_sel = mem_addr[31:24] == 8'h04;
  wire gpio0_valid = mem_valid && gpio0_sel;
  wire gpio0_ready;
  wire [31:0] gpio0_rdata;
  wire gpio0_io_iosel;
  wire gpio0_io_in;
  wire gpio0_io_out;
  tristate gpio0_io_iobuf (
      .pin  (fpga_user_led),
      .iosel(gpio0_io_iosel),
      .in   (gpio0_io_in),
      .out  (gpio0_io_out)
  );
  /* end */

endmodule
