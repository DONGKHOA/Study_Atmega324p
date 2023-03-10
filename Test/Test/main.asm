;S STATE MACHINE

.ORG 0

.EQU OFF_ALL = 0
.EQU ON_ALL = 255

; CONFIG PORTA, PORTC OUTPUT
; CONFIG PB0 INPUT (BUTTON)
; EFFECT -> R18
; TEMP -> R19

	SER R16
	OUT DDRA, R16
	OUT DDRC, R16
	OUT PORTB, R16

	CLR R16
	OUT DDRB, R16

	CLR R18

; SOLUTION

LOOP:
	CALL BUTTON
	INC R18
	CPI R18, 1
	BREQ BLINK
	CPI R18, 2
	BREQ VOLUME
	CPI R18, 3
;	BREQ SLAVE
	CLR R18
	RJMP LOOP

BLINK:
	LDI R16, ON_ALL
	OUT PORTA, R16
	OUT PORTC, R16
	CALL DELAY_500MS

	LDI R16, OFF_ALL
	OUT PORTA, R16
	OUT PORTC, R16
	CALL DELAY_500MS
	RJMP LOOP
VOLUME:
	LDI R16, 1
	OUT PORTA, R16
	CALL DELAY_500MS

	LDI R16, 3
	OUT PORTA, R16
	CALL DELAY_500MS

	LDI R16, 7
	OUT PORTA, R16
	CALL DELAY_500MS

	LDI R16, 15
	OUT PORTA, R16
	CALL DELAY_500MS

	LDI R16, $1F
	OUT PORTA, R16
	CALL DELAY_500MS

	LDI R16, $3F
	OUT PORTA, R16
	CALL DELAY_500MS

	LDI R16, $7F
	OUT PORTA, R16
	CALL DELAY_500MS

	LDI R16, $FF
	OUT PORTA, R16
	CALL DELAY_500MS

	CPI R16, $FF
	BREQ ON_PORTC

ON_PORTC:
	LDI R16, 1
	OUT PORTA, R16
	CALL DELAY_500MS

	LDI R16, 3
	OUT PORTA, R16
	CALL DELAY_500MS

	LDI R16, 7
	OUT PORTA, R16
	CALL DELAY_500MS

	LDI R16, 15
	OUT PORTA, R16
	CALL DELAY_500MS

	RJMP LOOP
SLAVE:
	RJMP LOOP



BUTTON:
	LDI R17, 50
DEBOUNCING_1:
	SBIC PINB, 0		;DETECTE STATUS OF BUTTON
	RJMP BUTTON
	DEC R17
	BRNE DEBOUNCING_1
	LDI R17, 10
RISE:
	LDI R17, 50
DEBOUNCING_2:
	SBIS PINB, 0		;DETECTE STATUS OF BUTTON
	RJMP RISE
	DEC R17
	BRNE DEBOUNCING_2
END:
	RET

DELAY_500MS:
	LDI R20, 5
LP3:	LDI R21, 100
LP2:	LDI R22, 250
LP1:	NOP
	DEC R22
	BRNE LP1
	DEC R21
	BRNE LP2
	DEC R20
	BRNE LP3
	RET