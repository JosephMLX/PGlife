/*
 * task2.asm
 *
 * Created: 2018/9/12 12:28:00
 * Author: Group 5
 * Mission:
 * Use external interrupt to start or stop the display of LEDs.
 * When press the bar, trigger an external interrupt, the pattern display will halt
 * if release the bar, interrupt routine will terminate, back to main routine
 */ 
 ;we assume PORTD's pin7 is connected to bar, PORTC's store the pattern
 .include "m2560def.inc"
 .def temp = r16
 .def pattern = r17
 .def iH = r25	;these register are used in macro to achieve 0.5 second delay
 .def iL = r24	;between each pattern
 .def countH = r21
 .def countL = r20
 .equ loop_count = 1
 .equ PATTERN_1 = 0b10000000
 .equ PATTERN_2 = 0b00001000
 .equ PATTERN_3 = 0b10101010
 .equ pattern_4 = 0b11111111

.macro DELAY	;approximately 0.5 seconds
	;delay
	ldi countL, low(loop_count)	;1
	ldi countH, high(loop_count)	;1
	clr iH	;1
	clr iL	;1
	loop:	;(8196 + 18) * 1024 + 4 = 8411140 CC
		cp iL, countL	;1
		cpc iH, countH	;1
		brsh done	;1,2
		push iL	;2
		push iH	;2
		clr iL	;1
		clr iH	;1
		loop2:	;8 * 1024 + 4 = 8196
			cp iL, countL	;1
			cpc iH, countH	;1
			brsh done_2	;1, 2
			adiw iH:iL, 1	;2
			nop	;1
			rjmp loop2	;2
		done_2:
		pop iH	;2
		pop iL	;2
		adiw iH:iL, 1	;2
		nop	;1
		rjmp loop	;2
	done:
.endmacro

;set up interrupt vector
	jmp RESET
.org int0addr	;default address in m2560inc.def
	jmp EXT_INT0

RESET:
	ser temp
	out DDRC, temp	;port C to be output
	ldi temp, (1<<intf0)
	out EIFR, temp
	sbi DDRD, 0	; port D's 7 bit to be input
	sbi PORTD, 0
	ser temp
	out PORTD, temp 
	ldi temp, (0<<ISC00)	;temp is 0b00000010
	sts EICRA, temp	;make int01:int00 to be 10, 
					;which means set int0 to be an falling edge triggered interrupt
	in temp, EIMSK	;load mask register's value to temp
	ori temp, (1<<INT0)
	out EIMSK, temp	;enable int0

	sei	;enable global interrupt

	jmp main	;begin main programming

EXT_INT0:
	push temp	;save conflict register
	in temp, SREG
	push temp	;save status register

	;implementing a halt
	halt:
		ldi temp, pattern_4
		out portc, temp
		;sbic PIND, 0
		;rjmp terminate_INT0
		rjmp halt
	terminate_INT0:
		pop temp
		out SREG, temp
		pop temp
		reti

main:
	ldi pattern, PATTERN_1
	out PORTC, pattern
	DELAY
	ldi pattern, PATTERN_2
	out PORTC, pattern
	;cbi PORTD, 0
	DELAY
	ldi pattern, PATTERN_3
	out PORTC, pattern
	DELAY
	rjmp main