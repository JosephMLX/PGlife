# Design Manual

### Overview

1. Display LCD screen with right output
2. Display LED lights with right output
3. Control motor to spin or stop
4. Push Button interrupt
5. Get the keypad input value
6. Shuffle the ‘cups’
7. Determine whether the guess is correct

### LCD Display

Most of initialisation code are from sample code from Lab04 — Task01. 

> LCD settings:	1. Connect LCD data pin D0-D7 to PORTL7-0.  
>                             2. Connect the four LCD control pins BE-RS to PORTA4-7.  

Two macros are designed to cooperate with LCD command and LCD data

> do_lcd_command: @0 is a binary code indicating a command  
> do_lcd_data: @0 is a binary code indicating a data  

Other functions can deal with LCD settings and debounce the electric signal.

At the beginning, LCD screen would show  `Ready...`  to tell the user that the machine is ready.
When the player press PB0, LCD screen show `Start...`  to tell the user that this round has already start. 
And when the user press PB0 again and made a guess by pressing keypad, player’s score would be shown on LCD screen in this format: `Score:N`


### LED Display

LEDs are divided into two groups. 

### Generate Random Number 

As there are totally three cups are shuffling, I decided to generate a number could be [0, 1, 2]. Timer0 is initialised to generate a random number according to time. To make the number become 0, 1 or 2. I designed a subroutine to imitate mod calculation. 


```asm6502
mod3:
	sb3:
	subi temp1, 3		; temp -= 3
	cpi temp1, 3		; compare temp1 with 3
	brsh sb3			; if temp >=3, continue the loop
	ret
```

Then, I get the value from the keypad ASCII that player pressed the key 0, 1 or 2 to make a guess. By comparing values in these two register, the program can make a decision whether this guess is correct. Then increase or decrease player’s score.

### Motor Control


### Flow Chart
