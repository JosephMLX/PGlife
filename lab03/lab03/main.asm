;
; lab03.asm
;
; Created: 5/09/2018 7:13:26 PM
; Author : cse
;
;PORTC output data to LED
;PORTD's 7 bit for input from press button
;
.include "m2560def.inc"
.equ loop_count = 0xFF
.def iH = r25
.def iL = r24
.def countH = r21
.def countL = r20
.macro oneSecondDelay
	;delay
	ldi countL, low(loop_count)
	ldi countH, high(loop_count)
	clr iH
	clr iL
	loop:
		cp iL, countL
		cpc iH, countH
		brsh done
		adiw iH:iL, 1
		nop
		rjmp loop
	done:
.endmacro

cbi DDRD, 7	;set PORTD's 7bit for input
ser r17
out DDRC, r17	;set PORTC for output

ldi r16, 0xFF
ldi r17, 0x00
ldi r18, 0x81	;Three pattern

loop:
	out PORTC, r16	;display pattern 1
	DELAY
	sbic PIND, 7
	rjmp halt_1	;if user press button, display halt.
	pattern_2:
	out PORTC, r17	;display pattern 2
	DELAY
	sbic PIND, 7
	rjmp halt_2	;if user press button, display halt.
	pattern_3:
	out PORTC, r18	;display pattern 3
	DELAY
	sbic PIND, 7
	rjmp halt_3	;if user press button, display halt.
	pattern_1:
	rjmp loop	;Go back to pattern in r16

halt_1:
	sbis PIND, 7
	rjmp pattern_2	;stop pressing, change pattern to pattern 2
	rjmp halt_1
halt_2:
	sbis PIND, 7
	rjmp pattern_3
	rjmp halt_2
halt_3:
	sbis PIND, 7
	rjmp pattern_1
	rjmp halt_3
	


