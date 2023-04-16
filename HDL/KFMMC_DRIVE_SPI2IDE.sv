//
// KFMMC_SPI2IDE
// IDE(PIO) wrapper to access MMC(SPI)
//
// Written by kitune-san
//

module KFMMC_DRIVE_IDE #(
    parameter init_spi_clock_cycle = 8'd150,
    parameter normal_spi_clock_cycle = 8'd002,
    parameter access_block_size = 16'd512
) (
    input   logic           clock,
    input   logic           reset,

    // IDE interface
    input   logic           ide_cs1fx_n,
    input   logic           ide_cs3fx_n,
    input   logic           ide_io_read_n,
    input   logic           ide_io_write_n,

    input   logic   [2:0]   ide_address,
    input   logic   [15:0]  ide_data_bus_in,
    output  logic   [15:0]  ide_data_bus_out,

    input   logic           device_master,
    output  logic   [39:0]  storage_size,

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
    LDST_KFMMC_SPI2IDE_ROM u_ROM (
        .clock                      (clock),
        .address                    (instruction_bus_address),
        .data_out                   (instruction_bus_data_in)
    );

    // Chip Select
    wire    io_write                    = sequencer_enable & io_bus_out;
    wire    io_read                     = io_bus_in;
    wire    select_reg1                 = io_bus_address == 8'b00000100;
    wire    select_reg2                 = io_bus_address == 8'b00000101;
    wire    select_reg3                 = io_bus_address == 8'b00000110;
    wire    select_reg4                 = io_bus_address == 8'b00000111;
    wire    select_spi_data             = io_bus_address == 8'b10000000;
    wire    select_spi_status           = io_bus_address == 8'b10000001;
    wire    select_status_flags         = io_bus_address == 8'b10000010;


    wire    select_csd_input            = io_bus_address == 8'b10000101;
    wire    select_block_address_1      = io_bus_address == 8'b10000110;
    wire    select_block_address_2      = io_bus_address == 8'b10000111;
    wire    select_block_address_3      = io_bus_address == 8'b10001000;
    wire    select_block_address_4      = io_bus_address == 8'b10001001;

    wire    select_ide_fifo             = io_bus_address == 8'b11000001;
    wire    select_ide_data_request     = io_bus_address == 8'b11000010;
    wire    select_ide_status           = io_bus_address == 8'b11000011;
    wire    select_ide_error            = io_bus_address == 8'b11000100;
    wire    select_ide_features         = io_bus_address == 8'b11000101;
    wire    select_ide_sector_count     = io_bus_address == 8'b11000110;
    wire    select_ide_sector_number    = io_bus_address == 8'b11000111;
    wire    select_ide_cylinder_1       = io_bus_address == 8'b11001000;
    wire    select_ide_cylinder_2       = io_bus_address == 8'b11001001;
    wire    select_ide_head_number      = io_bus_address == 8'b11001010;
    wire    select_ide_drive            = io_bus_address == 8'b11001011;
    wire    select_ide_lba              = io_bus_address == 8'b11001100;
    wire    select_ide_command          = io_bus_address == 8'b11001101;


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
    // IDE Bus
    //
    logic   [2:0]   latch_address;
    logic   [15:0]  latch_data;
    logic           prev_read_n;
    logic           prev_write_n;
    logic           read_edge;
    logic           write_edge;
    logic           command_cs;
    logic           control_cs;
    logic           write_command;
    logic           write_control;


    always_ff @(negedge clock, posedge reset) begin
        if (reset) begin
            latch_address       <= 3'b000;
            latch_data          <= 16'h0000;
            prev_read_n         <= 1'b1;
            prev_write_n        <= 1'b1;
            read_edge           <= 1'b0;
            command_cs          <= 1'b0;
            control_cs          <= 1'b0;
        end
        else begin
            if (~ide_cs1fx_n | ~ide_cs3fx_n) begin
                latch_address   <= ide_address;
                latch_data      <= ide_data_bus_in;
            end
            else begin
                latch_address   <= latch_address;
                latch_data      <= latch_data;
            end
            prev_read_n         <= ide_io_read_n;
            prev_write_n        <= ide_io_write_n;
            read_edge           <=  prev_read_n  & ~ide_io_read_n;
            command_cs          <= ~ide_cs1fx_n;
            control_cs          <= ~ide_cs3fx_n;
        end
    end

    assign  write_edge          = ~prev_write_n &  ide_io_write_n;
    assign  write_command       = command_cs & write_edge;
    assign  write_control       = control_cs & write_edge;


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


    logic   drive_busy;
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
            mmc_mode    <= io_bus_data_out[1];
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
        else if (~io_write)
            block_address   <= block_address;
        else if (select_block_address_1)
            block_address   <= {block_address[31:8],  io_bus_data_out};
        else if (select_block_address_2)
            block_address   <= {block_address[31:16], io_bus_data_out, block_address[7:0]};
        else if (select_block_address_3)
            block_address   <= {block_address[31:24], io_bus_data_out, block_address[15:0]};
        else if (select_block_address_4)
            block_address   <= {io_bus_data_out, block_address[23:0]};
        else
            block_address   <= block_address;
    end


    //
    // IDE Registers
    //

    // IDE write data
    logic   [15:0]  ide_write_data;
    always_ff @(posedge clock, posedge reset) begin
        if (reset)
            ide_write_data  <= 15'h00;
        else if (write_command)
            ide_write_data  <= latch_data;
        else
            ide_write_data  <= ide_write_data;
    end

    // FIFO
    logic   [7:0]   fifo[0:access_block_size-1];
    logic   [7:0]   fifo_in;
    logic   [1:0]   shift_fifo;

    assign  fifo_in = select_ide_fifo ? io_bus_data_out :
                        write_command ? latch_data[7:0] : ide_write_data[15:8];

    always_ff @(posedge clock, posedge reset) begin
        if (reset)
            shift_fifo      <= 2'b00;
        else if (select_ide_fifo & (io_write | io_read))
            shift_fifo      <= 2'b01;
        else if ((ide_data_request) && (ide_address == 3'b000) && (write_command | (command_cs & read_edge)))
            shift_fifo      <= 2'b11;
        else
            shift_fifo      <= {1'b0, shift_fifo[1]};
    end

    always_ff @(posedge clock, posedge reset) begin
        if (reset)
            fifo[0] <= 8'h00;
        else if (shift_fifo[0])
            fifo[0] <= fifo_in;
        else
            fifo[0] <= fifo[0];
    end

    genvar fifo_index;
    generate
    for (fifo_index = 1; fifo_index < access_block_size; fifo_index = fifo_index + 1) begin: Fifo_Shift
        always_ff @(posedge clock, posedge reset) begin
            if (reset)
                fifo[fifo_index]    <= 8'h00;
            else if (shift_fifo[0])
                fifo[fifo_index]    <= fifo[fifo_index-1];
            else
                fifo[fifo_index]    <= fifo[fifo_index];
        end
    end
    endgenerate

    // FIFO counter
    logic   [15:0]  fifo_counter;
    always_ff @(negedge clock, posedge reset) begin
        if (reset)
            fifo_counter    <= 16'h0000;
        else if (select_ide_data_request)
            fifo_counter    <= access_block_size;
        else if (ide_data_request && (|fifo_counter) && shift_fifo[0])
            fifo_counter    <= fifo_counter - 16'h0000;
        else
            fifo_counter    <= fifo_counter;
    end

    // status
    logic           ide_busy;
    logic           ide_device_ready;
    logic           ide_data_request;
    logic           ide_error_flag;
    wire    [7:0]   ide_status  = {ide_busy, ide_device_ready, 2'b00, ide_data_request, 2'b00, ide_error_flag};

    always_ff @(negedge clock, posedge reset) begin
        if (reset)
            ide_busy            <= 1'b1;
        else if (write_command && (latch_address == 3'b111))
            ide_busy            <= 1'b1;
        else if (select_ide_status)
            ide_busy            <= io_bus_data_out[7];
        else
            ide_busy            <= ide_busy;
    end

    always_ff @(negedge clock, posedge reset) begin
        if (reset)
            ide_device_ready    <= 1'b0;
        else if (select_ide_status)
            ide_device_ready    <= io_bus_data_out[6];
        else
            ide_device_ready    <= ide_device_ready;
    end

    always_ff @(negedge clock, posedge reset) begin
        if (reset)
            ide_data_request    <= 1'b0;
        else if (select_ide_data_request)
            ide_data_request    <= io_bus_data_out[0];
        else if (~|fifo_counter)
            ide_data_request    <= 1'b0;
        else
            ide_data_request    <= ide_data_request;
    end

    always_ff @(negedge clock, posedge reset) begin
        if (reset)
            ide_error_flag      <= 1'b0;
        else if (select_ide_status)
            ide_error_flag      <= io_bus_data_out[0];
        else
            ide_error_flag      <= ide_error_flag;
    end

    // Error
    logic   [7:0]   ide_error;

    always_ff @(negedge clock, posedge reset) begin
        if (reset)
            ide_error           <= 1'b0;
        else if (select_ide_error)
            ide_error           <= io_bus_data_out;
        else
            ide_error           <= ide_error;
    end

    // Features
    logic   [7:0]   ide_features;

    always_ff @(posedge clock, posedge reset) begin
        if (reset)
            ide_features        <= 8'h00;
        else if (write_command && (latch_address == 3'b001))
            ide_features        <= latch_data;
        else if (select_ide_features)
            ide_features        <= io_bus_data_out;
        else
            ide_features        <= ide_features;
    end

    // Sector count
    logic   [15:0]  ide_sector_count;

    always_ff @(posedge clock, posedge reset) begin
        if (reset)
            ide_sector_count    <= 16'h0001;
        else if (write_command && (latch_address == 3'b010))
            ide_sector_count    <= {ide_sector_count[7:0], latch_data[7:0]};
        else if (select_ide_sector_count)
            ide_sector_count    <= io_bus_data_out;
        else
            ide_sector_count    <= ide_sector_count;
    end

    // Sector Number
    logic   [15:0]  ide_sector_number;  // in CHS mode, use only 8 bit.(S)

    always_ff @(posedge clock, posedge reset) begin
        if (reset)
            ide_sector_number   <= 16'h0001;
        else if (write_command && (latch_address == 3'b011))
            ide_sector_number   <= {ide_sector_number[7:0], latch_data[7:0]};
        else if (select_ide_sector_number)
            ide_sector_number   <= io_bus_data_out;
        else
            ide_sector_number   <= ide_sector_number;
    end

    // Cylinder
    logic   [31:0]  ide_cylinder;   // in CHS mode, use only 16 bit.(C)

    always_ff @(posedge clock, posedge reset) begin
        if (reset)
            ide_cylinder        <= 32'h00000000;
        else if (write_command && (latch_address == 3'b100))
            ide_cylinder        <= {ide_cylinder[31:24], ide_cylinder[7:0],   ide_cylinder[15:8],  latch_data[7:0]};
        else if (write_command && (latch_address == 3'b101))
            ide_cylinder        <= {ide_cylinder[15:8],  ide_cylinder[23:16], latch_data[7:0], ide_cylinder[7:0]  };
        else if (select_ide_cylinder_1)
            ide_cylinder        <= {ide_cylinder[31:24], ide_cylinder[7:0],   ide_cylinder[15:8],  io_bus_data_out};
        else if (select_ide_cylinder_2)
            ide_cylinder        <= {ide_cylinder[15:8],  ide_cylinder[23:16], io_bus_data_out, ide_cylinder[7:0]  };
        else
            ide_cylinder        <= ide_cylinder;
    end

    // Header
    logic   [3:0]   ide_head_number;        // (H)

    always_ff @(posedge clock, posedge reset) begin
        if (reset)
            ide_head_number     <= 4'h0;
        else if (write_command && (latch_address == 3'b110))
            ide_head_number     <= latch_data[3:0];
        else if (select_ide_head_number)
            ide_head_number     <= io_bus_data_out[3:0];
        else
            ide_head_number     <= ide_head_number;
    end

    // Select drive
    logic           ide_select_drive;

    always_ff @(posedge clock, posedge reset) begin
        if (reset)
            ide_select_drive    <= 1'b0;
        else if (write_command && (latch_address == 3'b110))
            ide_select_drive    <= latch_data[4];
        else if (select_ide_drive)
            ide_select_drive    <= io_bus_data_out[0];
        else
            ide_select_drive    <= ide_select_drive;
    end

    // LBA
    logic           ide_select_lba;

    always_ff @(posedge clock, posedge reset) begin
        if (reset)
            ide_select_lba      <= 1'b0;
        else if (write_command && (latch_address == 3'b110))
            ide_select_lba      <= latch_data[6];
        else if (select_ide_lba)
            ide_select_lba      <= io_bus_data_out[0];
        else
            ide_select_lba      <= ide_select_lba;
    end

    // Command
    logic   [7:0]   ide_command;

    always_ff @(posedge clock, posedge reset) begin
        if (reset)
            ide_command         <= 8'h00;
        else if (write_command && (latch_address == 3'b111) && ~ide_busy)
            ide_command         <= latch_data;
        else
            ide_command         <= ide_command;
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
        else if (select_block_address_1)
            io_bus_data_in  = block_address[7:0];
        else if (select_block_address_2)
            io_bus_data_in  = block_address[15:8];
        else if (select_block_address_3)
            io_bus_data_in  = block_address[23:16];
        else if (select_block_address_4)
            io_bus_data_in  = block_address[31:24];
        else if (select_ide_fifo)
            io_bus_data_in  = fifo[access_block_size - 1];
        else if (select_ide_status)
            io_bus_data_in  = ide_status;
        else if (select_ide_error)
            io_bus_data_in  = ide_error;
        else if (select_ide_features)
            io_bus_data_in  = ide_features;
        else if (select_ide_sector_count)
            io_bus_data_in  = ide_sector_count;
        else if (select_ide_sector_number)
            io_bus_data_in  = ide_sector_number;
        else if (select_ide_cylinder_1)
            io_bus_data_in  = ide_cylinder[7:0];
        else if (select_ide_cylinder_2)
            io_bus_data_in  = ide_cylinder[15:8];
        else if (select_ide_head_number)
            io_bus_data_in  = {4'b0000, ide_head_number};
        else if (select_ide_drive)
            io_bus_data_in  = {7'b0000000, (ide_select_drive == ~device_master)};
        else if (select_ide_lba)
            io_bus_data_in  = {7'b0000000, ide_select_lba};
        else if (select_ide_command)
            io_bus_data_in  = ide_command;
        else
            io_bus_data_in  = 8'h00;


    //
    // IDE Read
    //
    always_ff @(posedge clock, posedge reset) begin
        if (reset)
            ide_data_bus_out    <= 16'hFFFF;
        else if (~read_edge)
            ide_data_bus_out    <= ide_data_bus_out;
        else if (command_cs)
            casez (ide_address)
                3'b000: // Data Register
                    ide_data_bus_out <= {fifo[access_block_size - 2], fifo[access_block_size - 1]};
                3'b001: // Error Register
                    ide_data_bus_out <= {8'h00, ide_error};
                3'b010: // Sector Count Register
                    ide_data_bus_out <= {8'h00, ide_sector_count[7:0]};
                3'b011: // Sector Number Register (or LBAlo)
                    ide_data_bus_out <= {8'h00, ide_sector_number[7:0]};
                3'b100: // Cylinder Low Register (or LBAmid)
                    ide_data_bus_out <= {8'h00, ide_cylinder[7:0]};
                3'b101: // Cylinder High Register (or LBAhi)
                    ide_data_bus_out <= {8'h00, ide_cylinder[15:8]};
                3'b110: // Drive / Head Register
                    ide_data_bus_out <= {1'b1, ide_select_lba, 1'b1, ide_select_drive, ide_head_number};
                3'b111: // Status Register
                    ide_data_bus_out <= {8'h00, ide_status};
                default:
                    ide_data_bus_out <= 16'hFFFF;
            endcase
        else if (control_cs)
            casez (ide_address[0])
                1'b0:   // Status Register
                    ide_data_bus_out <= {8'h00, ide_status};
                1'b1:   // Drive Address Register
                    ide_data_bus_out <= {1'b0, 1'b1, ide_head_number, ~ide_select_drive, ide_select_drive};
                default:
                    ide_data_bus_out <= 16'hFFFF;
            endcase
        else
            ide_data_bus_out    <= ide_data_bus_out;
    end

endmodule

