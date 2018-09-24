


.include "m2560def.inc"
.def temp = r16
.def output = r17
.equ PATTERN = 0b00000000
; set up interrupt vectors


jmp RESET
.org INT0addr ; defined in m2560def.inc
jmp EXT_INT0
RESET:
ser temp ; set Port C as output
out DDRC, temp
out PORTC, temp
ldi output, PATTERN
ldi temp, (2 << ISC00) ; set INT0 as falling edge triggered interrupt
sts EICRA, temp
in temp, EIMSK ; enable INT0
ori temp, (1<<INT0)
out EIMSK, temp
sei ; enable Global Interrupt
jmp main
EXT_INT0:
push temp ; save register
in temp, SREG ; save SREG
push temp
com output ; flip the pattern
out PORTC, output
pop temp ; restore SREG
out SREG, temp
pop temp ; restore register
reti
main:
clr temp
loop:
cpi temp, 0x1F ; the following section in red
breq reset_temp ; shows the need to save SREG
rjmp loop ; in the interrupt service routine
reset_temp:
clr temp
rjmp loop