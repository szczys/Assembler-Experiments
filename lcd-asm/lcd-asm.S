#define __SFR_OFFSET 0 
#include <avr/io.h>

#define RS 0
#define E 1
#define LCD_function_set (1<<5)
#define LCD_display_on ((1<<7)|(1<<6)|(1<<5))
#define LCD_entry_mode ((1<<6)|(1<<5))

#define mp r16

.global main

main:
	;setup port pins
	ldi mp, 0xFF
	out DDRD,mp	;PORTD set to outputs
	
	;initialized lcd
	rcall Delay10ms	;wait for power-on initialization
	
	;send LCD_function_set
	ldi mp, LCD_function_set
	out PORTD,mp
	sbi PORTD,E	;Latch
	rcall Delay10ms
	cbi PORTD,E
	rcall Delay10ms
	
	;send 0x00 then LCD_function_set
	ldi mp, 0x00
	out PORTD,mp
	sbi PORTD,E	;Latch
	rcall Delay10ms
	cbi PORTD,E
	rcall Delay10ms
	ldi mp, LCD_function_set
	out PORTD,mp
	sbi PORTD,E	;Latch
	rcall Delay10ms
	cbi PORTD,E
	rcall Delay10ms
	
	;send 0x00 then LCD_display_on
	ldi mp, 0x00
	out PORTD,mp
	sbi PORTD,E	;Latch
	rcall Delay10ms
	cbi PORTD,E
	rcall Delay10ms
	ldi mp, LCD_display_on
	out PORTD,mp
	sbi PORTD,E	;Latch
	rcall Delay10ms
	cbi PORTD,E
	rcall Delay10ms
	
	;send 0x00 then LCD_entry_mode
	ldi mp, 0x00
	out PORTD,mp
	sbi PORTD,E	;Latch
	rcall Delay10ms
	cbi PORTD,E
	rcall Delay10ms
	ldi mp, LCD_entry_mode
	out PORTD,mp
	sbi PORTD,E	;Latch
	rcall Delay10ms
	cbi PORTD,E
	rcall Delay10ms
	
	;send message
	;send 0x40 | (1<<RS)
	ldi mp, (0x40 | (1<<RS))
	out PORTD,mp
	sbi PORTD,E	;Latch
	rcall Delay10ms
	cbi PORTD,E
	rcall Delay10ms

	;send 0x80 | (1<<RS)
	ldi mp, (0x80 | (1<<RS))
	out PORTD,mp
	sbi PORTD,E	;Latch
	rcall Delay10ms
	cbi PORTD,E
	rcall Delay10ms

loop:
	rjmp loop

;Delay
Delay10ms:

	LDI ZH,hi8(2998) ;Set high byte
	LDI ZL,lo8(2998) ;Set low byte

	DelayLoop:
		SBIW ZL,1 ;subtract one from word
		BRNE DelayLoop ;Branch back to DelayLoop unless zero flag was set
