;
; lab03.asm
;
; Created: 5/09/2018 7:13:26 PM
; Author : cse
;
;AVR board clock frequency 16MHz
;PORTC output data to LED
;PORTD's 7 bit for input from press button
;
.include "m2560def.inc"
.equ loop_count = 1024
.def iH = r25
.def iL = r24
.def countH = r21
.def countL = r20

.macro delay_more					; (4 + 8411140) / 16MHz =~ 0.5s
	ldi countL, low(loop_count)		; 1 cycle
	ldi countH, high(loop_count)	; 1
	clr iH							; 1
	clr iL							; 1
	loop:							; (9 + 8196 + 9) * 1024 + 4 =  8411140
		cp iL, countL				; 1
		cpc iH, countH				; 1
		brsh done					; 1, 2(if branch)
		push iL						; 2
		push iH						; 2
		clr iL						; 1
		clr iH						; 1
		loop_2:						; 8 * 1024 + 4 = 8196
			cp iL, countL			; 1
			cpc iH, countH			; 1
			brsh done_2				; 1, 2(if branch)	
			adiw iH:iL, 1			; 2
			nop						; 1
			rjmp loop_2				; 2
		done_2:
	pop iH							; 2
	pop iL							; 2
	adiw iH:iL, 1					; 2
	nop								; 1
	rjmp loop						; 2
	done:

.endmacro

cbi DDRF, 7	;set PORTD's 7bit for input
ser r17
out DDRC, r17	;set PORTC for output

ldi r16, 0b11111100
ldi r17, 0b01111110
ldi r18, 0b00111111	;Three pattern

loop:
	out PORTC, r16	;display pattern 1
	delay_more
	sbis PINF, 7
	rjmp halt_1	;if user press button, display halt.
	pattern_2:
	out PORTC, r17	;display pattern 2
	delay_more
	sbis PINF, 7
	rjmp halt_2	;if user press button, display halt.
	pattern_3:
	out PORTC, r18	;display pattern 3
	delay_more
	sbis PINF, 7
	rjmp halt_3	;if user press button, display halt.
	pattern_1:
	rjmp loop	;Go back to pattern in r16

halt_1:
	sbic PINF, 7
	rjmp pattern_2	;stop pressing, change pattern to pattern 2
	rjmp halt_1
halt_2:
	sbic PINF, 7
	rjmp pattern_3	;stop pressing, change pattern to pattern 3
	rjmp halt_2
halt_3:
	sbic PINF, 7
	rjmp pattern_1	;stop pressing, change pattern to pattern 1
	rjmp halt_3
	


