
; Registers
define reg1             0x04
define reg2             0x05
define reg3             0x06
define reg4             0x07

define spi_data         0x80
define spi_status       0x81
define status_flags     0x82
define error_flags      0x83
define interrupt_flags  0x85
define csd_input        0x85
define block_addr_1     0x86
define block_addr_2     0x87
define block_addr_3     0x88
define block_addr_4     0x89
define trans_data       0x8A
define command          0x8B

reset:
    ; busy=1 CS=H
    ldi     0x03
    st      status_flags
    ; Reset error
    ldi     0x00
    st      error_flags

restart:
    ; Send dummy data
    ldi     10
    st      reg1
init_clock_loop:
    ldi     0xFF
    st      spi_data
    ldi     wait_spi_comm.h
    call    wait_spi_comm.l
    ld      reg1
    st      a
    ldi     1
    st      b
    ldi     sub
    st      alu
    ld      alu
    st      reg1
    ldi     send_cmd0.h
    jz      send_cmd0.l
    ldi     init_clock_loop.h
    jmp     init_clock_loop.l

send_cmd0:
    ; CS=L
    ldi     0b11111101
    st      a
    ldi     clear_status_bit.h
    call    clear_status_bit.l

    ; Send CMD0 40 00 00 00 00 95
    ldi     0x40
    st      spi_data
    ldi     wait_spi_comm.h
    call    wait_spi_comm.l

    ldi     send_spi_arg_0.h
    call    send_spi_arg_0.l

    ldi     0x95
    st      spi_data
    ldi     wait_spi_comm.h
    call    wait_spi_comm.l

    ldi     10
    st      reg1
    ldi     wait_spi_r1_response.h
    call    wait_spi_r1_response.l

    ld      reg2
    st      a
    ldi     0x01
    st      b
    ldi     xor
    st      alu
    ld      alu
    ldi     mode_check.h
    jz      mode_check.l

    ldi     reset.h
    jmp     reset.l

mode_check:
    ; Is not MMC mode?
;    ld      status_flags
;    st      a
;    ldi     0x04
;    st      b
;    ldi     and
;    st      alu
;    ld      alu
;
;    ; no
;    ld      send_cmd8.h
;    jz      send_cmd8.l
;
;    ; yes
;send_cmd1:
;    ; Send CMD1 41 00 00 00 00 F9

send_cmd8:
    ; Send dummy byte
    ldi     send_1_dummy_clock.h
    call    send_1_dummy_clock.l

    ; Send CMD8 48 00 00 01 AA 87
    ldi     0x48
    st      spi_data
    ldi     wait_spi_comm.h
    call    wait_spi_comm.l
    ldi     0x00
    st      spi_data
    ldi     wait_spi_comm.h
    call    wait_spi_comm.l
    ldi     0x00
    st      spi_data
    ldi     wait_spi_comm.h
    call    wait_spi_comm.l
    ldi     0x01
    st      spi_data
    ldi     wait_spi_comm.h
    call    wait_spi_comm.l
    ldi     0xAA
    st      spi_data
    ldi     wait_spi_comm.h
    call    wait_spi_comm.l
    ldi     0x87
    st      spi_data
    ldi     wait_spi_comm.h
    call    wait_spi_comm.l

    ldi     10
    st      reg1
    ldi     wait_spi_r1_response.h
    call    wait_spi_r1_response.l

    ld      reg2
    st      a
    ldi     0x01
    st      b
    ldi     xor
    st      alu
    ld      alu
    ldi     check_cmd8_response.h
    jz      check_cmd8_response.l

    ; mmc_mode=1
    ldi     0b00000100
    st      a
    ldi     set_status_bit.h
    call    set_status_bit.l

    ldi     restart.h
    jmp     restart.l

check_cmd8_response:
    ; Recive 31-8
    ldi     send_3_dummy_clock.h
    call    send_3_dummy_clock.l

    ld      spi_data
    st      a
    ldi     0x01
    st      b
    ldi     and
    st      alu
    ld      alu
    ldi     reset.h
    jz      reset.l

    ; Recive 7-0
    ldi     0xFF
    st      spi_data
    ldi     wait_spi_comm.h
    call    wait_spi_comm.l

    ld      spi_data
    st      a
    ldi     0xAA
    st      b
    ldi     sub
    st      alu
    ld      alu
    ldi     send_cmd55.h
    jz      send_cmd55.l

    ldi     reset.h
    jmp     reset.l

send_cmd55:
    ; Send dummy byte
    ldi     send_1_dummy_clock.h
    call    send_1_dummy_clock.l

    ; Send CMD55 77 00 00 00 00 FF
    ldi     0x77
    st      spi_data
    ldi     wait_spi_comm.h
    call    wait_spi_comm.l

    ldi     send_spi_arg_0.h
    call    send_spi_arg_0.l

    ldi     10
    st      reg1
    ldi     wait_spi_r1_response.h
    call    wait_spi_r1_response.l

    ld      reg2
    st      a
    ldi     0x01
    st      b
    ldi     xor
    st      alu
    ld      alu
    ldi     send_acmd41.h
    jz      send_acmd41.l

    ldi     reset.h
    jmp     reset.l

send_acmd41:
    ; Send dummy byte
    ldi     send_1_dummy_clock.h
    call    send_1_dummy_clock.l

    ; Send ACMD41 69 40 FF 80 00 FF
    ldi     0x69
    st      spi_data
    ldi     wait_spi_comm.h
    call    wait_spi_comm.l
    ldi     0x40
    st      spi_data
    ldi     wait_spi_comm.h
    call    wait_spi_comm.l
    ldi     0xFF
    st      spi_data
    ldi     wait_spi_comm.h
    call    wait_spi_comm.l
    ldi     0x80
    st      spi_data
    ldi     wait_spi_comm.h
    call    wait_spi_comm.l
    ldi     0x00
    st      spi_data
    ldi     wait_spi_comm.h
    call    wait_spi_comm.l

    ldi     10
    st      reg1
    ldi     wait_spi_r1_response.h
    call    wait_spi_r1_response.l

    ld      reg2
    st      a
    ldi     0x00
    st      b
    ldi     xor
    st      alu
    ld      alu
    ldi     send_cmd9.h
    jz      send_cmd9.l

    ldi     send_cmd55.h
    jmp     send_cmd55.l

send_cmd9:
    ; Send dummy byte
    ldi     send_1_dummy_clock.h
    call    send_1_dummy_clock.l

    ; Read CSD
    ; Send ACMD41 49 00 00 00 00 FF
    ldi     0x49
    st      spi_data
    ldi     wait_spi_comm.h
    call    wait_spi_comm.l

    ldi     send_spi_arg_0.h
    call    send_spi_arg_0.l

    ldi     10
    st      reg1
    ldi     wait_spi_r1_response.h
    call    wait_spi_r1_response.l

    ld      reg2
    st      a
    ldi     0x00
    st      b
    ldi     xor
    st      alu
    ld      alu
    ldi     cmd9_read_csd_1.h
    jz      cmd9_read_csd_1.l

    ldi     reset.h
    jmp     reset.l

cmd9_read_csd_1:
    ldi     10
    st      reg1
    ldi     0xFE
    st      reg2
    ldi     wait_to_start_spi_transmission.h
    call    wait_to_start_spi_transmission.l

    ld      reg3
    st      a
    ldi     0xFE
    st      b
    ldi     xor
    st      alu
    ld      alu
    ldi     cmd9_read_csd_2.h
    jz      cmd9_read_csd_2.l

    ldi     reset.h
    jmp     reset.l

cmd9_read_csd_2:
    ldi     16
    st      reg1
cmd9_read_csd_3:
    ldi     0xFF
    st      spi_data
    ldi     wait_spi_comm.h
    call    wait_spi_comm.l
    ld      spi_data
    st      csd_input
    ld      reg1
    st      a
    ldi     1
    st      b
    ldi     sub
    st      alu
    ld      alu
    st      reg1
    ldi     send_cmd58.h
    jz      send_cmd58.l

    ldi     cmd9_read_csd_3.h
    jmp     cmd9_read_csd_3.l

send_cmd58:
    ; Send dummy byte
    ldi     send_1_dummy_clock.h
    call    send_1_dummy_clock.l

    ; Read OCR
    ; Send CMD58 7A 00 00 00 00 FF
    ldi     0x7A
    st      spi_data
    ldi     wait_spi_comm.h
    call    wait_spi_comm.l

    ldi     send_spi_arg_0.h
    call    send_spi_arg_0.l

    ldi     10
    st      reg1
    ldi     wait_spi_r1_response.h
    call    wait_spi_r1_response.l

    ld      reg2
    st      a
    ldi     0x00
    st      b
    ldi     xor
    st      alu
    ld      alu
    ldi     send_cmd58_get_ccs.h
    jz      send_cmd58_get_ccs.l

    ldi     reset.h
    call    reset.l

send_cmd58_get_ccs:
    ldi     0b10111111
    st      a
    ldi     clear_status_bit.h
    call    clear_status_bit.l

    ldi     0xFF
    st      spi_data
    ldi     wait_spi_comm.h
    call    wait_spi_comm.l

    ld      spi_data
    st      a
    ldi     0x40
    st      b
    ldi     and
    st      alu
    ld      alu
    st      a
    ldi     set_status_bit.h
    call    set_status_bit.l

    ldi     send_3_dummy_clock.h
    call    send_3_dummy_clock.l

busy_wait:
    ldi     0xFF
    st      spi_data
    ldi     wait_spi_comm.h
    call    wait_spi_comm.l

    ld      spi_data
    st      a
    ldi     0xFF
    st      b
    ldi     xor
    st      alu
    ld      alu

    ldi     ready.h
    jz      ready.l

    ldi     busy_wait.h
    jmp     busy_wait.l

ready:
    ldi     0b11111110
    st      a
    ldi     clear_status_bit.h
    call    clear_status_bit.l




end:
    ldi     end.h
    jmp     end.l


;
; Set status bit
; args:
;       a : set bit
;
set_status_bit:
    ld      status_flags
    st      b
    ldi     or
    st      alu
    ld      alu
    st      status_flags
    ret

;
; Clear status bit
; args:
;       a : clear bit (inverse)
;
clear_status_bit:
    ld      status_flags
    st      b
    ldi     and
    st      alu
    ld      alu
    st      status_flags
    ret

;
; Wait for SPI communication termination
;
wait_spi_comm:
    ldi     0x01
    st      b
    ld      spi_status
    st      a
    ldi     and
    st      alu
    ld      alu

    ldi     wait_spi_comm_end.h
    jz      wait_spi_comm_end.l

    ldi     wait_spi_comm.h
    jmp     wait_spi_comm.l

wait_spi_comm_end:
    ret

;
; Send Dummy clock
;
send_4_dummy_clock:
    ldi     0xFF
    st      spi_data
    ldi     wait_spi_comm.h
    call    wait_spi_comm.l
send_3_dummy_clock:
    ldi     0xFF
    st      spi_data
    ldi     wait_spi_comm.h
    call    wait_spi_comm.l
send_2_dummy_clock:
    ldi     0xFF
    st      spi_data
    ldi     wait_spi_comm.h
    call    wait_spi_comm.l
send_1_dummy_clock:
    ldi     0xFF
    st      spi_data
    ldi     wait_spi_comm.h
    call    wait_spi_comm.l
    ret


;
; Send 4 bytes 0x00 data
;
send_spi_arg_0:
    ldi     0x00
    st      spi_data
    ldi     wait_spi_comm.h
    call    wait_spi_comm.l
    ldi     0x00
    st      spi_data
    ldi     wait_spi_comm.h
    call    wait_spi_comm.l
    ldi     0x00
    st      spi_data
    ldi     wait_spi_comm.h
    call    wait_spi_comm.l
    ldi     0x00
    st      spi_data
    ldi     wait_spi_comm.h
    call    wait_spi_comm.l
    ret


;
;   Wait for R1 response
;   args:
;       reg1 : try count
;   return:
;       reg2 : response data (0xFF is error)
wait_spi_r1_response:
    ldi     0xFF
    st      spi_data
    ldi     wait_spi_comm.h
    call    wait_spi_comm.l
    ld      spi_data
    st      reg2
    st      a
    ldi     0x80
    st      b
    ldi     and
    st      alu
    ld      alu
    ; Recieved response data
    ldi     wait_spi_r1_response_end.h
    jz      wait_spi_r1_response_end.l

    ld      reg1
    st      a
    ldi     1
    st      b
    ldi     sub
    st      alu
    ld      alu
    st      reg1
    ; Try count over
    ldi     wait_spi_r1_response_end.h
    jz      wait_spi_r1_response_end.l

    ; Retry
    ldi     wait_spi_r1_response.h
    jmp     wait_spi_r1_response.l

wait_spi_r1_response_end:
    ret


;
;    Wait to start spi transmission
;    args:
;        reg1 : try count
;        reg2 : check data
;    return:
;        reg3 : response data
;
wait_to_start_spi_transmission:
    ldi     0xFF
    st      spi_data
    ldi     wait_spi_comm.h
    call    wait_spi_comm.l
    ld      spi_data
    st      reg3
    st      a
    ld      reg2
    st      b
    ldi     xor
    st      alu
    ld      alu
    ; Recieved response data
    ldi     wait_to_start_spi_transmission_end.h
    jz      wait_to_start_spi_transmission_end.l

    ld      reg1
    st      a
    ldi     1
    st      b
    ldi     sub
    st      alu
    ld      alu
    st      reg1
    ; Try count over
    ldi     wait_to_start_spi_transmission_end.h
    jz      wait_to_start_spi_transmission_end.l

    ; Retry
    ldi     wait_to_start_spi_transmission.h
    jmp     wait_to_start_spi_transmission.l

wait_to_start_spi_transmission_end:
    ret

