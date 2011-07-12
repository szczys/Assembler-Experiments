#include <avr/io.h>

;Define register names
#define myReg r16
#define outerwait r17
#define innerwait r18

.global main

main:
;Setup output pins
	LDI myReg,0xFF
	OUT DDRB,myReg

;Setup stack pointer so we can jump to subroutines
	;LDI myReg,hi8(RAMEND)
	;OUT SPH,myReg
	;LDI myReg,lo8(RAMEND)
	;OUT SPL,myReg

;Start loop
loop:
	;Switch LEDs on
	LDI myReg,0xFF
	OUT PORTB,myReg

	;wait
	RCALL Delay200ms

	;Switch LEDs off
	LDI myReg,0x00
	OUT PORTB,myReg
	
	;wait
	RCALL Delay200ms

	;repeat
	RJMP loop

Delay200ms:
        ldi outerwait,0x77
waitouterloop:
        ldi innerwait,0xFF
waitinnerloop:
        subi innerwait,0x01
        brne waitinnerloop
        subi outerwait,0x01
        brne waitouterloop
        ret

/*
;Delay
Delay200ms:

	LDI ZH,hi8(59998) ;Set high byte
	LDI ZL,lo8(59998) ;Set low byte

	DelayLoop:
		SBIW ZL,1 ;subtract one from word
		BRNE DelayLoop ;Branch back to DelayLoop unless zero flag was set
RET ;Go on with the rest of life
*/
