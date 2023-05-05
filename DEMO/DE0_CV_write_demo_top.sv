`define POR_MAX 16'hffff

module DE0_CV_write_demo_top (
      ///////// CLOCK  "3.3-V LVTTL" /////////
      input              CLOCK_50,
      ///////// RESET "3.3-V LVTTL" /////////
      input              RESET_N,
      ///////// HEX0-5 "3.3-V LVTTL" /////////
      output      [6:0]  HEX0,
      output      [6:0]  HEX1,
      output      [6:0]  HEX2,
      output      [6:0]  HEX3,
      output      [6:0]  HEX4,
      output      [6:0]  HEX5,
      ///////// LEDR /////////
      output      [9:0]  LEDR,
      ///////// SD "3.3-V LVTTL" /////////
      output             SD_CLK,
      inout              SD_CMD,
      inout       [3:0]  SD_DATA,
      ///////// VGA  "3.3-V LVTTL" /////////
      output      [3:0]  VGA_B,
      output      [3:0]  VGA_G,
      output             VGA_HS,
      output      [3:0]  VGA_R,
      output             VGA_VS
);


    reg     clock;
    reg     reset;

    //
    // PLL
    //
    PLL PLL (
        .refclk     (CLOCK_50),
        .rst        (~RESET_N),
        .outclk_0   (clock)
    );


    //
    // Power On Reset
    //
    reg [15:0]  por_count;

    always @(posedge CLOCK_50, negedge RESET_N)
    begin
        if (~RESET_N) begin
            reset <= 1'b1;
            por_count <= 16'h0000;
        end
        else if (por_count != `POR_MAX) begin
            reset <= 1'b1;
            por_count <= por_count + 16'h0001;
        end
        else begin
            reset <= 1'b0;
            por_count <= por_count;
        end
    end


    //
    // MMC
    //
    logic   [7:0]   internal_data_bus;
    logic           write_block_address_1;
    logic           write_block_address_2;
    logic           write_block_address_3;
    logic           write_block_address_4;
    logic           write_access_command;
    logic           write_data;

    logic   [7:0]   read_data_byte;
    logic           read_data;

    logic           drive_busy;
    (* noprune *) wire    [39:0]  storage_size;

    logic           read_interface_error;
    logic           write_interface_error;

    logic           block_read_interrupt;
    logic           read_completion_interrupt;
    logic           request_write_data_interrupt;
    logic           write_completion_interrupt;

    KFMMC_DRIVE u_KFMMC_DRIVE (
        .clock                      (clock),
        .reset                      (reset),

        .data_bus                   (internal_data_bus),
        .write_block_address_1      (write_block_address_1),
        .write_block_address_2      (write_block_address_2),
        .write_block_address_3      (write_block_address_3),
        .write_block_address_4      (write_block_address_4),
        .write_command              (write_access_command),
        .write_data                 (write_data),

        .read_data_byte             (read_data_byte),
        .read_data                  (read_data),

        .drive_busy                 (drive_busy),
        .storage_size               (storage_size),
        .read_interface_error       (read_interface_error),
        .write_interface_error      (write_interface_error),

        .read_byte_interrupt        (block_read_interrupt),
        .read_completion_interrupt  (read_completion_interrupt),
        .request_write_data_interrupt   (request_write_data_interrupt),
        .write_completion_interrupt     (write_completion_interrupt),

        .spi_clk                    (SD_CLK),
        .spi_cs                     (SD_DATA[3]),
        .spi_mosi                   (SD_CMD),
        .spi_miso                   (SD_DATA[0])
    );

    assign SD_DATA[1]  = 1'b1;
    assign SD_DATA[2]  = 1'b1;


    //
    // TEST
    //
    typedef enum {INITIAL, SEND_ADDRESS_1,  SEND_ADDRESS_2, SEND_ADDRESS_3, SEND_ADDRESS_4, START_WRITE,
        WAIT_INTERRUPT, SEND_DATA, READ_RESULT, WAIT_BUSY,
        COMPLETE} test_state_t;
    test_state_t    test_state;
    test_state_t    next_test_state;
    logic   [7:0]   block;
    logic   [7:0]   data;

    // state machine
    always_comb begin
        next_test_state = test_state;

        case (test_state)
            INITIAL:
                if (~drive_busy)
                    next_test_state = SEND_ADDRESS_1;
            SEND_ADDRESS_1:
                next_test_state = SEND_ADDRESS_2;
            SEND_ADDRESS_2:
                next_test_state = SEND_ADDRESS_3;
            SEND_ADDRESS_3:
                next_test_state = SEND_ADDRESS_4;
            SEND_ADDRESS_4:
                next_test_state = START_WRITE;
            START_WRITE:
                next_test_state = WAIT_INTERRUPT;
            WAIT_INTERRUPT:
                if (write_completion_interrupt)
                    next_test_state = READ_RESULT;
                else if (request_write_data_interrupt)
                    next_test_state = SEND_DATA;
            SEND_DATA:
                if (~request_write_data_interrupt)
                    next_test_state = WAIT_INTERRUPT;
            READ_RESULT:
                next_test_state = WAIT_BUSY;
            WAIT_BUSY:
                if (~drive_busy)
                    if (block != 8'h02)
                        next_test_state = SEND_ADDRESS_1;
                    else
                        next_test_state = COMPLETE;
        endcase
    end

    always_ff @(posedge clock, posedge reset) begin
        if (reset)
            test_state = INITIAL;
        else
            test_state = next_test_state;
    end

    // Controll MMC signals
    always_comb begin
        internal_data_bus       = 8'h00;
        write_block_address_1   = 1'b0;
        write_block_address_2   = 1'b0;
        write_block_address_3   = 1'b0;
        write_block_address_4   = 1'b0;
        write_access_command    = 1'b0;
        read_data               = 1'b0;
        write_data              = 1'b0;

        case (test_state)
            INITIAL: begin
                read_data               = 1'b1;
            end
            SEND_ADDRESS_1: begin
                internal_data_bus       = block;
                write_block_address_1   = 1'b1;
            end
            SEND_ADDRESS_2: begin
                internal_data_bus       = 8'h00;
                write_block_address_2   = 1'b1;
            end
            SEND_ADDRESS_3: begin
                internal_data_bus       = 8'h00;
                write_block_address_3   = 1'b1;
            end
            SEND_ADDRESS_4: begin
                internal_data_bus       = 8'h00;
                write_block_address_4   = 1'b1;
            end
            START_WRITE: begin
                internal_data_bus       = 8'h81;
                write_access_command    = 1'b1;
            end
            WAIT_INTERRUPT: begin
            end
            SEND_DATA: begin
                internal_data_bus       = data;
                write_data              = 1'b1;
            end
            READ_RESULT: begin
                read_data               = 1'b1;
            end
            WAIT_BUSY: begin
            end
            COMPLETE: begin
            end
        endcase
    end

    always_ff @(posedge clock, posedge reset) begin
        if (reset)
            block <= 8'h00;
        else if (test_state == READ_RESULT)
            block <= block + 8'h01;
        else
            block <= block;
    end

    always_ff @(posedge clock, posedge reset) begin
        if (reset)
            data <= 8'h00;
        else if ((test_state == WAIT_INTERRUPT) && (request_write_data_interrupt))
            data <= data + 8'h01;
        else
            data <= data;
    end

    assign  LEDR[0]  = SD_CLK;
    assign  LEDR[1]  = SD_CMD;
    assign  LEDR[2]  = SD_DATA[0];
    assign  LEDR[3]  = 1'b0;
    assign  LEDR[4]  = 1'b0;
    assign  LEDR[5]  = request_write_data_interrupt;
    assign  LEDR[6]  = write_completion_interrupt;
    assign  LEDR[7]  = write_interface_error;
    assign  LEDR[8]  = 1'b0;
    assign  LEDR[9]  = drive_busy;

endmodule 

