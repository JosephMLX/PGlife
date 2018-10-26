# Design Manual
## 9032 Project ——— Developed by Lingxu Meng (z5147810)

### Overview

1. Display LCD screen with right output
2. Display LED lights with right output
3. Control motor to spin or stop
4. Push Button 0 interrupt
5. Get the keypad input value
6. Shuffle the ‘cups’ by generating a random number
7. Determine whether the guess is correct

### LCD Display

Most of initialisation code are from sample code from Lab04 — Task01. 


> LCD settings:	1. Connect LCD data pin D0-D7 to PORTL7-0.  
>                             2. Connect the four LCD control pins BE-RS to PORTA4-7.  


Two macros are designed to cooperate with LCD command and LCD data


> do_lcd_command: @0 is a binary code indicating a command  
> do_lcd_data: @0 is a binary code indicating a data  


Other functions can deal with LCD settings and debounce the electric signal.

1. At the beginning, LCD screen would show  `Ready...`  to tell the user that the machine is ready.

2. When the player press PB0, LCD screen show `Start...`  to tell the user that this round has already start. 

3. And when the user press PB0 again and made a guess by pressing keypad, player’s score would be shown on LCD screen in this format: `Score:N`

4. When the user press PB0 again, go back to step 2 for another round.

### LED Display

LEDs are divided into two groups. 

> LED settings:		1. Connect LED BAR pin0-2 to PORTC0-2 (three cups)  
> 					2. Connect LED BAR pin6-9 to PORTC4-7 (result indicators)  


Two macros are designed to cooperate with controlling turn on and turn off the LED by setting and clearing relative bit in PORTC.

> turn_on_led: @0 is the LED supposed to be switched, set this bit  
> turn_off_led: @0 is the LED supposed to be switched, clear this bit  

LED dimmed light:


### Generate Random Number 

As there are totally three cups are shuffling, I decided to generate a number could be [0, 1, 2]. Timer0 is initialised to generate a random number according to time. To make the number become 0, 1 or 2. I designed a subroutine to imitate mod calculation. 


```asm6502
mod3:
	minus3:
	subi temp1, 3		; temp -= 3
	cpi temp1, 3		; compare temp1 with 3
	brsh minus3			; if temp >=3, continue the loop
	ret
```

Then, I get the value from the keypad ASCII that player pressed the key 0, 1 or 2 to make a guess. By comparing values in these two register, the program can make a decision whether this guess is correct. Then increase or decrease player’s score.

### Motor Control

When the game is at start status and when player’s score becomes 0 and made a wrong guess, motor would start to spin. When the player pressed PB0 to make a guess and when during the game that the player’s score is not less than 0, the motor wouldn’t spin.

PORTC PIN3 is connected to MOTOR Mot, by setting and clearing the bit PORTC 3 can control the switch of motor.

> Motor settings:	 	1. Connect MOTOR  Mot pin to PORTC PIN3  

Two macros are designed to control the switch of motor

> motor_start:  set bit PORTC3, make motor spin   
> motor_stop: clear bin PORTC3, make motor stop  

### Keypad Control

Four registers  `r16, r17, r18, r19` 

### Flow Chart

![pic](https://github.com/JosephMLX/PGlife/blob/master/COMP9032/lab03/Project/Flow%20Chart.jpg)
