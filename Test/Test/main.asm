;
; Test.asm
;
; Created: 2/27/2023 11:37:29 AM
; Author : thanh
;


; Replace with your application code
.ORG 0

;CONFIG PD1 AND PD0 INPUT

CLR R16
OUT DDRD, R16
LDI R16,  $3
OUT PORTD, R16

; SOLUTION

IN R16, PIND