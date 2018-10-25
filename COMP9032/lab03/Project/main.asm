;
; main.asm
;
; Author : lingxu meng
;
; LCD settings:		1. Connect LCD data pin D0-D7 to PORTL7-0.
;					2. Connect the four LCD control pins BE-RS to PORTA4-7.
;
; LED settings:		1. Connect LED BAR pin0-2 to PORTC0-2 (three cups)
;					2. Connect LED BAR pin6-9 to PORTC4-7 (result indicators)
;
; KEYPAD settings:	1. Connect KEYPAD BAR pin R0-R3 to PORTF0-3
;					2. Connect KEYPAD BAR pin C0-C3 to PORTF4-7
;
; MOTOR settings:	1. Connect MOTOR BAR pin Mot to PORTC3
;
; BUTTON settings:	1. Connect PB0 pin to PORTD0
;
; a subroutine to drive MOTOR (lab04-task02)
; a subroutine to simulate shuffled ball (timer0)

.include "m2560def.inc"
.dseg
    KeypadValue: .byte 1
.cseg
;keypad define
.def row    =r16			; value for row number
.def col    =r17			; value for column number
.def rmask  =r18			; mask for current row during scan
.def cmask	=r19			; mask for current column during scan
.def temp1	=r20			; used as template parameter
.def temp2  =r21			; used as template parameter
   
.def score = r22			; record player's score
.def gameStatus = r23		; initial game status ==> gameStatus=0; playing game status ==> gameStatus=1
.def gameStart = r15		; flag to see whether the game has start

.equ PORTF_DIR =0xF0		; use PORTF for input/output from keypad: PF7-4, output, PF3-0, input
.equ INITCOLMASK = 0xEF		; scan from the leftmost column, the value to mask output
.equ INITROWMASK = 0x01		; scan from the bottom row
.equ ROWMASK  =0x0F			; low four bits are output from the keypad. This value mask the high 4 bits.

;lcd needed function
.equ LCD_RS = 7
.equ LCD_E = 6
.equ LCD_RW = 5
.equ LCD_BE = 4

; interrupt vector defined
.org 0x0000					; external interrupt reset
jmp RESET

.org int0addr				; external interrupt request 0 as PB0 pressed
jmp pressButton

;lcd needed command macro
.macro do_lcd_command
    push r16
	ldi r16, @0
	rcall lcd_command
	rcall lcd_wait
    pop r16
.endmacro

.macro do_lcd_data
    push r16
	ldi r16, @0
	rcall lcd_data
	rcall lcd_wait
    pop r16
.endmacro

.macro motor_start
    sbi PORTC, 4			; set bit PORTC4, make motor spin 
.endmacro

.macro motor_stop
	cbi PORTC, 4			; clear bit PORTC4, make motor stop
.endmacro

;@0 indicate which cup is up
.macro turn_on_led
	sbi PORTC, (7-@0)		; set bit in PORTC to turn on this LED
.endmacro

.macro turn_off_led
	cbi PORTC, (7-@0)		; clear bit in PORTC to turn off this LED
.endmacro

.macro  dim_light
.endmacro

.macro lcd_set
	sbi PORTA, @0
.endmacro
.macro lcd_clr
	cbi PORTA, @0
.endmacro

RESET:
    ;build up a stack
    ldi r16, low(RAMEND)
	out SPL, r16			; stack pointer low
	ldi r16, high(RAMEND)
	out SPH, r16			; stack pointer high

    ; Initialize lcd
	ser r16
	sts DDRL, r16
	out DDRA, r16
	clr r16
	sts PORTL, r16
	out PORTA, r16
	do_lcd_command 0b00000001 ; clear display
	do_lcd_command 0b00111000 ; 8-bits 2x5x7
	rcall sleep_5ms
	do_lcd_command 0b00111000 ; 8-bits 2x5x7
	rcall sleep_1ms
	do_lcd_command 0b00111000 ; 8-bits 2x5x7
	do_lcd_command 0b00111000 ; 8-bits 2x5x7
	do_lcd_command 0b00001000 ; display off
	do_lcd_command 0b00000001 ; clear display
	do_lcd_command 0b00000110 ; increment, no display shift
	do_lcd_command 0b00001110 ; Cursor on, bar, no blink

	; initialized lcd status, show 'Ready...'
	do_lcd_data 'R'
	do_lcd_data 'e'
	do_lcd_data 'a'
	do_lcd_data 'd'
	do_lcd_data 'y'
	do_lcd_data '.'
	do_lcd_data '.'
	do_lcd_data '.'
    ; Initialize Keypad
	ldi temp1, PORTF_DIR			; columns are outputs, rows are inputs
	out	DDRF, temp1

    ; Initialize LED
    ser r16							; PORTC is outputs	
    out DDRC, r16
    clr r16
    out PORTC, r16
    
    in r16, EIMSK			
	ori r16, 1<<int0		; enable interrupt 0
	out EIMSK, r16
	ldi r16, (2<<ISC00)		; set INT0 as falling edge triggered interrupt
	sts EICRA, r16			
	sei						; enable Global Interrupt
    clr gameStatus	
	clr gameStart		
    ldi YL, low(KeypadValue)
    ldi YH, high(KeypadValue)
    st Y, gameStatus		;initalize Keypad value with 0
	ldi r16, (1 << CS02)|(1 << CS00)		;config timer
	out TCCR0B, r16
	clr score
	cp gameStart, gameStatus
	breq firstTime
	
firstTime:			; after the first time, the third cup LED would brighten
	turn_on_led 2
	rjmp firstTime

pressButton:
	turn_on_led 0	; bright three LEDs
	turn_on_led 1	;
	turn_on_led 2	;
    in r16, EIMSK
	andi r16, 0				; disable interrupt 0
	out EIMSK, r16
    cpi gameStatus, 0xFF 	; if game has started
    breq willGuess			; run guessing process
    rjmp beforeGuess		; otherwise go to inital start state
    beforeGuess:
        ser gameStatus	; set to playing status
		turn_on_led 0	; bright three LEDs
		turn_on_led 1	;
		turn_on_led 2	;
		;TODO, dimmed light
        do_lcd_command 0b00000001
        do_lcd_data 'S'
        do_lcd_data 't'
        do_lcd_data 'a'
        do_lcd_data 'r'
        do_lcd_data 't'
        do_lcd_data '.'
        do_lcd_data '.'
        do_lcd_data '.'
		cpi score, 0
        breq let_motor_spin
		let_motor_spin:
			motor_start
        call sleep_1s
        in r16, EIMSK
        ori r16, 1<<int0	;enable interrupt 0
        out EIMSK, r16
        sbi EIFR, 0
        reti
		willGuess:
	    in r16, EIMSK
		ori r16, 1<<int0	; enable interrupt 0
		out EIMSK, r16
		sbi EIFR, 0
		sei					; enable Global Interrupt
        jmp readKeypadValue

readKeypadValue:
	motor_stop
    call keypad					; get player's guess
	call sleep_1ms				; 
	ldi YL, low(KeypadValue)
	ldi YH, high(KeypadValue)
	ld r16, Y				    ; load the keypad value in r16
	cpi r16, 0					; if keypad have no value yet
	breq readKeypadValue		; get player to guess
	turn_off_led 0				; turn off all LEDs
	turn_off_led 1				; ...
	turn_off_led 2				; ...
	in temp1, tcnt0				; timer is a random number
	call mod3					; mod timer's value with 3
	subi r16, '1'				; r16 's value is also from 0 to 2
	cpi temp1, 1				;
	breq bright1				;
	cpi temp1, 2				;
	breq bright2				;
	bright0:					;
		turn_on_led 0			; turn on the led with ball in
		rjmp change_score		;
	bright1:					;
		turn_on_led 1			;
		rjmp change_score		;
	bright2:					;	
		turn_on_led 2			;
	change_score:					; if guess correctly, score += 1, otherwise, score -= 1; if score = 0, restart from pressButton
		cp temp1, r16				; compare temp1 with r16 (keypad value and random number)
		breq inc_score				; correct guess, get score
		dec_score:					; incorrect guess, lose score
			clr r16						
			st Y, r16
			cpi score, 0			; if score is already 0
			breq gameover			; gameover, start another game
			dec score				; otherwise, score = score - 1
			call display_score
			jmp readKeypadValue
			gameover:
				call display_score
				clr gameStatus		; score is 0, go back to initial start status
				do_lcd_command 0b00000001
				jmp pressButton
		inc_score:
			clr r16
			st Y, r16
			call indicator_flash	; flash indicator LEDs three times
			rcall sleep_250ms
			call indicator_flash
			rcall sleep_250ms
			call indicator_flash
			inc score				; score = score + 1
			call display_score
			jmp readKeypadValue


; Send a command to the LCD (r16)
lcd_command:
	sts PORTL, r16
	nop
	lcd_set LCD_E
	nop
	nop
	nop
	lcd_clr LCD_E
	nop
	nop
	nop
	ret

lcd_data:
	sts PORTL, r16
	lcd_set LCD_RS
	nop
	nop
	nop
	lcd_set LCD_E
	nop
	nop
	nop
	lcd_clr LCD_E
	nop
	nop
	nop
	lcd_clr LCD_RS
	ret

lcd_wait:
	push r16
	clr r16
	sts DDRL, r16
	sts PORTL, r16
	lcd_set LCD_RW

lcd_wait_loop:
	nop
	lcd_set LCD_E
	nop
	nop
    nop
	lds r16, PINL
	lcd_clr LCD_E
	sbrc r16, 7
	rjmp lcd_wait_loop
	lcd_clr LCD_RW
	ser r16
	sts DDRL, r16
	pop r16
	ret

.equ F_CPU = 16000000
.equ DELAY_1MS = F_CPU / 4 / 1000 - 4
; 4 cycles per iteration - setup/call-return overhead

sleep_1ms:
	push r24
	push r25
	ldi r25, high(DELAY_1MS)
	ldi r24, low(DELAY_1MS)
    delayloop_1ms:
        sbiw r25:r24, 1
        brne delayloop_1ms
        pop r25
        pop r24
	ret

sleep_5ms:
	rcall sleep_1ms
	rcall sleep_1ms
	rcall sleep_1ms
	rcall sleep_1ms
	rcall sleep_1ms
	ret

sleep_250ms:
	push r16
	ldi r16, 50
	sleeping_250:
		call sleep_5ms
		dec r16
		cpi r16, 0
		brne sleeping_250
	pop r16
	ret

sleep_1s:
    push r16
    ldi r16, 200
    sleeping:
        call sleep_5ms
        dec r16
        cpi r16, 0
        brne sleeping
    pop r16
    ret

; a subroutine to flash result indicator LED (lab03-task03)
indicator_flash:
	rcall turn_on_indicator
	rcall sleep_250ms
	rcall turn_off_indicator
	ret
	
turn_on_indicator:
	turn_on_led 4
	turn_on_led 5
	turn_on_led 6
	turn_on_led 7
	ret

turn_off_indicator:
	turn_off_led 4
	turn_off_led 5
	turn_off_led 6
	turn_off_led 7
	ret

; a subroutine to display score on LCD 
display_score:
	do_lcd_command 0b00000001
	push score
	; very unlikely to score more than 10...
    do_lcd_data 'S'
    do_lcd_data 'c'
    do_lcd_data 'o'
    do_lcd_data 'r'
    do_lcd_data 'e'
    do_lcd_data ':'
	dec score
	subi score, -'1'
	mov r16, score
	call lcd_data
	pop score
	ret

; subroutine used to generate a number(0, 1, 2) as the correct cup position
mod3:
	sb3:
	subi temp1, 3		; temp -= 3
	cpi temp1, 3		
	brsh sb3			; if temp >=3, continue the loop
	ret

; a subroutine to read in from KEYPAD (lab04-task01)
; get value from keypad input
keypad:
    ldi cmask, INITCOLMASK		; initial column mask
    clr	col						; initial column
    colloop:
    cpi col, 4
    breq Keypad
    out	PORTF, cmask			; set column to mask value (one column off)
    ldi temp1, 0xFF
    delay:
    dec temp1
    brne delay

    in	temp1, PINF				; read PORTD
    andi temp1, ROWMASK
    cpi temp1, 0xF				; check if any rows are on
    breq nextcol
                                ; if yes, find which row is on
    ldi rmask, INITROWMASK		; initialise row check
    clr	row						; initial row
    rowloop:
    cpi row, 4
    breq nextcol
    mov temp2, temp1
    and temp2, rmask			; check masked bit
    breq convert 				; if bit is clear, convert the bitcode
    inc row						; else move to the next row
    lsl rmask					; shift the mask to the next bit
    jmp rowloop

    nextcol:
    lsl cmask					; else get new mask by shifting and 
    inc col						; increment column value
    jmp colloop					; and check the next column

    convert:
    cpi col, 3					; if column is 3 we have a letter
    breq letters				
    cpi row, 3					; if row is 3 we have a symbol or 0
    breq symbols

    mov temp1, row				; otherwise we have a number in 1-9
    lsl temp1
    add temp1, row				; temp1 = row * 3
    add temp1, col				; add the column address to get the value
    subi temp1, -'1'			; add the value of character '0'
    jmp convert_end

    letters:
    ldi temp1, 'A'
    add temp1, row				; increment the character 'A' by the row value
    jmp convert_end

    symbols:
    cpi col, 0					; check if we have a star
    breq star
    cpi col, 1					; or if we have zero
    breq zero					
    ldi temp1, '#'				; if not we have hash
    jmp convert_end
    star:
    ldi temp1, '*'				; set to star
    jmp convert_end
    zero:
    ldi temp1, '0'				; set to zero

    convert_end:
    ldi YL, low(KeypadValue)
    ldi YH, high(KeypadValue)
    st Y, temp1
	clr temp1
    ret
