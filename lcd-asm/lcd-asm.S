#define __SFR_OFFSET 0 
#include <avr/io.h>

.global main

main:
	;setup port pins

	;initialized lcd
	;delay
	;send message

loop:
	rjmp loop

;Delay
Delay10ms:

	LDI ZH,hi8(2998) ;Set high byte
	LDI ZL,lo8(2998) ;Set low byte

	DelayLoop:
		SBIW ZL,1 ;subtract one from word
		BRNE DelayLoop ;Branch back to DelayLoop unless zero flag was set
