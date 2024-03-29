;
; Arduino_Internal_EEPROM.asm
;
; Created: 19.10.2022. 23:57:29
; Author : Aleksandar Bogdanovic
;

// Arduino Asembler, I2C EEPROM, pisanje, citanje - Interni EEPROM, hardverski


.include "m328pdef.inc"
.org 0x0000
rjmp main

.macro delay
	ldi  r20, 82
    ldi  r21, 43
    ldi  r22, 0
L1: dec  r22
    brne L1
    dec  r21
    brne L1
    dec  r20
    brne L1
    lpm
    nop
.endmacro

main:
	setup:
    ldi   R16, 0xFF
    out   DDRD, R16         // PORTD kao output
	loop:    
	sbic EECR, 1
    rjmp loop                // Cekamo da EEWE bude 0
EEPROM_write:				// EEPROM citanje
    clr r18					
	out   EEARH, R18        // Setujemo high byte od adrese 
    ldi   R17, 0x5F         
    out   EEARL, R17        // Setujemo low byte od adrese
    ldi   R16, 0x55			// byte koji ce biti upisan u EEPROM
    out   EEDR, R16         // Cuvanje byte-a
    sbi   EECR, 2           // EEMWE = 1
    sbi   EECR, 1           // Upisivanje byte-a u EEPROM
	loop2:
    sbic EECR, 1
    rjmp loop2              // Cekamo da EEPROM bude spreman
EEPROM_read:				// Citamo EEPROM
    sbi   EECR, 0           // EERE = 1, citamo byte iz EEPROM-a
    in    R16, EEDR         
    out   PORTD, R16        // Output byte-a na PORTD
	delay
    rjmp setup