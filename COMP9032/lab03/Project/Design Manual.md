# Design Manual

### Overview

1. Display LCD screen with right output
2. Display LED lights with right output
3. Control motor to spin or stop
4. Get the keypad input value
5. Shuffle the ‘cups’
6. Determine whether the guess is correct

### LCD Display


### LED Display


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


![](Design%20Manual/%E4%B8%BB%E7%A8%8B%E5%BA%8F%E6%B5%81%E7%A8%8B%E5%9B%BE%20(1).jpg)