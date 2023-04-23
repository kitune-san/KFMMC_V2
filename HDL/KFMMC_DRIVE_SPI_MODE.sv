//
// KFMMC_SPI
// Access to MMC using SPI
//
// Written by kitune-san
//
module KFMMC_DRIVE #(
    parameter init_spi_clock_cycle = 8'd150,
    parameter normal_spi_clock_cycle = 8'd002,
    parameter access_block_size = 16'd512,
    parameter timeout = 32'hFFFFFFFF
) (
    input   logic           clock,
    input   logic           reset,

    // Internal bus
    input   logic   [7:0]   data_bus,
    input   logic           write_block_address_1,
    input   logic           write_block_address_2,
    input   logic           write_block_address_3,
    input   logic           write_block_address_4,
    input   logic           write_command,
    input   logic           write_data,

    output  logic   [7:0]   read_data_byte,
    input   logic           read_data,

    // State
    output  logic           drive_busy,
    output  logic   [39:0]  storage_size,

    // Error flags
    output  logic           read_interface_error,
    output  logic           write_interface_error,

    // External input/output
    output  logic           read_byte_interrupt,
    output  logic           read_completion_interrupt,
    output  logic           request_write_data_interrupt,
    output  logic           write_completion_interrupt,

    output  logic           spi_clk,
    output  logic           spi_cs,
    output  logic           spi_mosi,
    input   logic           spi_miso
);

    //
    // Sequencer
    //
    logic           sequencer_enable;
    logic   [15:0]  instruction_bus_address;
    logic   [12:0]  instruction_bus_data_in;
    logic   [7:0]   io_bus_address;
    logic   [7:0]   io_bus_data_out;
    logic   [7:0]   io_bus_data_in;
    logic           io_bus_out;
    logic           io_bus_in;

    always_ff @(posedge clock, posedge reset) begin
        if (reset)
            sequencer_enable    <= 1'b0;
        else
            sequencer_enable    <= ~sequencer_enable;
    end

    LDST_SEQUENCER u_SEQUENCER (
        .clock                      (clock),
        .clock_enable               (sequencer_enable),
        .reset                      (reset),
        .instruction_bus_address    (instruction_bus_address),
        .instruction_bus_data       (instruction_bus_data_in),
        .io_bus_address             (io_bus_address),
        .io_bus_data_out            (io_bus_data_out),
        .io_bus_data_in             (io_bus_data_in),
        .io_bus_out                 (io_bus_out),
        .io_bus_in                  (io_bus_in)
    );

    // ROM
    LDST_KFMMC_SPI_ROM u_ROM (
        .clock                      (clock),
        .address                    (instruction_bus_address),
        .data_out                   (instruction_bus_data_in)
    );

    // Chip Select
    wire    io_write                = sequencer_enable & io_bus_out;
    wire    io_read                 = io_bus_in;
    wire    select_reg1             = io_bus_address == 8'b00000100;
    wire    select_reg2             = io_bus_address == 8'b00000101;
    wire    select_reg3             = io_bus_address == 8'b00000110;
    wire    select_reg4             = io_bus_address == 8'b00000111;
    wire    select_spi_data         = io_bus_address == 8'b10000000;
    wire    select_spi_status       = io_bus_address == 8'b10000001;
    wire    select_status_flags     = io_bus_address == 8'b10000010;
    wire    select_error_flags      = io_bus_address == 8'b10000011;
    wire    select_interrupt_flags  = io_bus_address == 8'b10000100;
    wire    select_csd_input        = io_bus_address == 8'b10000101;
    wire    select_block_address_1  = io_bus_address == 8'b10000110;
    wire    select_block_address_2  = io_bus_address == 8'b10000111;
    wire    select_block_address_3  = io_bus_address == 8'b10001000;
    wire    select_block_address_4  = io_bus_address == 8'b10001001;
    wire    select_transmit_data    = io_bus_address == 8'b10001010;
    wire    select_command          = io_bus_address == 8'b10001011;

    //
    // MMC Device
    //
    logic   [7:0]   spi_recv_data;
    logic           spi_busy_status;
    logic           spi_clock_select;

    always_ff @(posedge clock, posedge reset) begin
        if (reset)
            spi_clock_select    <= 1'b0;
        else if (select_spi_status & io_write)
            spi_clock_select    <= io_bus_data_out[1];
        else
            spi_clock_select    <= spi_clock_select;
    end

    KFMMC_SPI u_KFMMC_SPI (
        .clock                      (clock),
        .reset                      (reset),
        .send_data                  (io_bus_data_out),
        .recv_data                  (spi_recv_data),
        .start_communication        (select_spi_data & io_write),
        .busy_flag                  (spi_busy_status),
        .spi_clock_cycle            (~spi_clock_select ? init_spi_clock_cycle : normal_spi_clock_cycle),
        .spi_clk                    (spi_clk),
        .spi_mosi                   (spi_mosi),
        .spi_miso                   (spi_miso)
    );


    //
    // Registers
    //
    reg     [7:0]   reg1;
    reg     [7:0]   reg2;
    reg     [7:0]   reg3;
    reg     [7:0]   reg4;

    always @(posedge clock, posedge reset) begin
        if (reset)
            reg1    <= 8'h00;
        else if (io_write & select_reg1)
            reg1    <= io_bus_data_out;
        else
            reg1    <= reg1;
    end

    always @(posedge clock, posedge reset) begin
        if (reset)
            reg2    <= 8'h00;
        else if (io_write & select_reg2)
            reg2    <= io_bus_data_out;
        else
            reg2    <= reg2;
    end

    always @(posedge clock, posedge reset) begin
        if (reset)
            reg3    <= 8'h00;
        else if (io_write & select_reg3)
            reg3    <= io_bus_data_out;
        else
            reg3    <= reg3;
    end

    always @(posedge clock, posedge reset) begin
        if (reset)
            reg4    <= 8'h00;
        else if (io_write & select_reg4)
            reg4    <= io_bus_data_out;
        else
            reg4    <= reg4;
    end

    always_ff @(posedge clock, posedge reset) begin
        if (reset)
            drive_busy  <= 1'b1;
        else if (write_command)
            drive_busy  <= 1'b1;
        else if (io_write & select_status_flags)
            drive_busy  <= io_bus_data_out[0];
        else
            drive_busy  <= drive_busy;
    end

    always_ff @(posedge clock, posedge reset) begin
        if (reset)
            spi_cs      <= 1'b1;
        else if (io_write & select_status_flags)
            spi_cs      <= io_bus_data_out[1];
        else
            spi_cs      <= spi_cs;
    end

    logic   mmc_mode;
    always_ff @(posedge clock, posedge reset) begin
        if (reset)
            mmc_mode    <= 1'b1;
        else if (io_write & select_status_flags)
            mmc_mode    <= io_bus_data_out[2];
        else
            mmc_mode    <= mmc_mode;
    end

    logic   ccs;
    always_ff @(posedge clock, posedge reset) begin
        if (reset)
            ccs         <= 1'b0;
        else if (io_write & select_status_flags)
            ccs         <= io_bus_data_out[6];
        else
            ccs         <= ccs;
    end

    always_ff @(posedge clock, posedge reset) begin
        if (reset)
            read_interface_error    <= 1'b0;
        else if (io_write & select_error_flags)
            read_interface_error    <= io_bus_data_out[0];
        else
            read_interface_error    <= read_interface_error;
    end

    always_ff @(posedge clock, posedge reset) begin
        if (reset)
            write_interface_error   <= 1'b0;
        else if (io_write & select_error_flags)
            write_interface_error   <= io_bus_data_out[1];
        else
            write_interface_error   <= write_interface_error;
    end

    always_ff @(posedge clock, posedge reset) begin
        if (reset)
            read_byte_interrupt             <= 1'b0;
        else if (read_data)
            read_byte_interrupt             <= 1'b0;
        else if (io_write & select_interrupt_flags)
            read_byte_interrupt             <= io_bus_data_out[0];
        else
            read_byte_interrupt             <= read_byte_interrupt;
    end

    always_ff @(posedge clock, posedge reset) begin
        if (reset)
            read_completion_interrupt       <= 1'b0;
        else if (read_data)
            read_completion_interrupt       <= 1'b0;
        else if (io_write & select_interrupt_flags)
            read_completion_interrupt       <= io_bus_data_out[1];
        else
            read_completion_interrupt       <= read_completion_interrupt;
    end

    always_ff @(posedge clock, posedge reset) begin
        if (reset)
            request_write_data_interrupt    <= 1'b0;
        else if (write_data)
            request_write_data_interrupt    <= 1'b0;
        else if (io_write & select_interrupt_flags)
            request_write_data_interrupt    <= io_bus_data_out[2];
        else
            request_write_data_interrupt    <= request_write_data_interrupt;
    end

    always_ff @(posedge clock, posedge reset) begin
        if (reset)
            write_completion_interrupt      <= 1'b0;
        else if (read_data)
            write_completion_interrupt      <= 1'b0;
        else if (io_write & select_interrupt_flags)
            write_completion_interrupt      <= io_bus_data_out[3];
        else
            write_completion_interrupt      <= write_completion_interrupt;
    end

    logic   [127:0] csd;
    always_ff @(negedge clock, posedge reset) begin
        if (reset)
            csd <= 0;
        else if (io_write & select_csd_input)
            csd <= {csd[119:0], io_bus_data_out};
        else
            csd <= csd;
    end

    // Storage size
    always_ff @(negedge clock, posedge reset) begin
        if (reset)
            storage_size <= 0;
        else if (csd[127:126] == 2'b00) // V1
            storage_size <= (csd[73:62]  + 40'd1) << (csd[49:47] + csd[83:80] + 5'd2);
        else if (csd[127:126] == 2'b01) // V2
            storage_size <= {(csd[69:48] + 22'd1), 19'b0000000000000000000};
        else                            // other
            storage_size <= 0;
    end

    // Block Address
    logic   [31:0]  block_address;
    always_ff @(negedge clock, posedge reset) begin
        if (reset)
            block_address   <= 32'h00000000;
        else if (write_block_address_1)
            block_address   <= {block_address[31:8],  data_bus};
        else if (write_block_address_2)
            block_address   <= {block_address[31:16], data_bus, block_address[7:0]};
        else if (write_block_address_3)
            block_address   <= {block_address[31:24], data_bus, block_address[15:0]};
        else if (write_block_address_4)
            block_address   <= {data_bus, block_address[23:0]};
        else
            block_address   <= block_address;
    end

    // transmit data
    logic   [7:0]   transmit_data;
    always_ff @(negedge clock, posedge reset) begin
        if (reset)
            transmit_data   <= 8'h00;
        else if (write_data)
            transmit_data   <= data_bus;
        else
            transmit_data   <= transmit_data;
    end

    // receive data
    assign  read_data_byte   = spi_recv_data;

    // Command register
    logic   [7:0]   command;
    always_ff @(negedge clock, posedge reset) begin
        if (reset)
            command         <= 8'h00;
        else if (write_command)
            command         <= data_bus;
        else if (io_write & select_command)
            command         <= io_bus_data_out;
        else
            command         <= command;
    end


    //
    // Back to sequencer
    //
    always_comb
        if (~io_read)
            io_bus_data_in  = 8'h00;
        else if (select_reg1)
            io_bus_data_in  = reg1;
        else if (select_reg2)
            io_bus_data_in  = reg2;
        else if (select_reg3)
            io_bus_data_in  = reg3;
        else if (select_reg4)
            io_bus_data_in  = reg4;
        else if (select_spi_data)
            io_bus_data_in  = spi_recv_data;
        else if (select_spi_status)
            io_bus_data_in  = {7'b0000000, spi_busy_status};
        else if (select_status_flags)
            io_bus_data_in  = {1'b0, ccs , 3'b000, mmc_mode, spi_cs, drive_busy};
        else if (select_error_flags)
            io_bus_data_in  = {6'b000000, write_interface_error, read_interface_error};
        else if (select_interrupt_flags)
            io_bus_data_in  = {4'hF, write_completion_interrupt, request_write_data_interrupt, read_completion_interrupt, read_byte_interrupt};
        else if (select_block_address_1)
            io_bus_data_in  = block_address[7:0];
        else if (select_block_address_2)
            io_bus_data_in  = block_address[15:8];
        else if (select_block_address_3)
            io_bus_data_in  = block_address[23:16];
        else if (select_block_address_4)
            io_bus_data_in  = block_address[31:24];
        else if (select_transmit_data)
            io_bus_data_in  = transmit_data;
        else if (select_command)
            io_bus_data_in  = command;
        else
            io_bus_data_in  = 8'h00;

endmodule

