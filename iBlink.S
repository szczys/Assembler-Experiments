#define __SFR_OFFSET 0 
#include <avr/io.h>

#define myReg r16
#define intReg r17
#define intReg2 r18
#define ovfFlag 0

.global main
;.global TIM0_OVF_vect
.global TIM0_COMPA_vect

main:
	;setup I/O
	ldi myReg, 0xFF
	out DDRB, myReg
	out PORTB, myReg
	ldi intReg, 0xFA ;Count down 250 interrupts
	ldi intReg2, 0x04 ;Count four sets of 250 interrupts (1000 interrupts)
	
	;setup CTC mode
	ldi myReg, (1<<WGM01)
	out TCCR0A, myReg
	;set top
	ldi myReg, 0x96
	out OCR0A, myReg
	;setup prescaler clk/8
	ldi myReg, (1<<CS01)
	out TCCR0B, myReg
	;enable compare interrupt
	ldi myReg, (1<<OCIE0A)
	out TIMSK0, myReg
	;enable global interrupts
	sei

Loop:
	
	rjmp Loop

/*
TIM0_OVF_vect:
	push myReg
	ldi myReg, 0xFF
	in intReg, PORTB
	eor intReg, myReg
	out PORTB, intReg
	pop myReg
	reti
*/

TIM0_COMPA_vect:
	subi intReg,1
	brne ExitCompA

		ldi intReg, 0xFA	;reset for new count
		subi intReg2,1
		brne ExitCompA

			ldi intReg2, 0xFF	;temporarity use intReg2 as a bit mask
			out PINB, intReg2	;writing to PINB effectivley does an Exclusive OR on PORTB
			ldi intReg2, 0x04	;reset fo new count

	ExitCompA:
	reti
