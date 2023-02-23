;
; CHUONG_2.asm
;
; Created: 2/4/2023 12:05:37 PM
; Author : thanh
;


; Replace with your application code
;****************************************************************************************
;V�NG GPRs(Ri:i=0-31)
;****************************************************************************************
LDI R16,0xAB ;R16=ABH
LDI R17,$CD ;R17=CDH
LDI R18,50 ;R18=32H
LDI R19,0b00001111 ;R19=0FH
;ldi r0,0xffh ;error
MOV R0,R16 ;R0=ABH
MOV R1,R17 ;R1=CD
MOVW R2,R18 ;BYTE
MOVW R5:R4,R19:R18 ; word r,d:ch?n
;****************************************************************************************
;V�NG IORs{P:0-63(3F)}
;****************************************************************************************
OUT PORTB,R1 ;R1=CDH
OUT 5,R16 ;PORTB=05H(IO_ADDR)=25H(SRAM_ADDR)
OUT $25,R17 ;TCCR0B=25H(IO_ADDR)
IN R1,PORTA
IN R2,0x02 ;PORTA=02H(IO_ADDR)
;IN R5,$60 ;ERROR: ngo�i ph?m vi IO_ADDR
;****************************************************************************************
;V�NG DATA{$100-$8FF}
;****************************************************************************************
LDI R20,0X05 ;R20=R16(SRAM_ADDR=16=10H)
LDI R19,0XCD
STS $5D,R19 ;SPL=3DH(IO_ADDR)=5DH(SRAM_ADDR)
STS $5E,R20 ;SPH=3EH(IO_ADDR)=5EH(SRAM_ADDR)
;STS SPL,R19 ;s? t�c ??ng v�o ??a ch? 3DH
;STS SPH,R20 ;v� 2EH
; l?nh kh�ng b�o l?i nh?ng s? sai nhu c?u th?c hi?n
;****************************************************************************************
;V�NG STACK(SP)
;****************************************************************************************
LDI R16,HIGH(RAMEND) ;l?y byte cao c?a RAMEND
OUT SPH,R16 ;l?u v�o SPH
LDI R16,LOW(RAMEND) ;l?y byte th?p
OUT SPL,R16
LDI R20,0X2A
LDI R21,0X95
LDI R22,0X4C
PUSH R20
PUSH R21
PUSH R22
POP R22
;****************************************************************************************
;V�NG FLASH(CODE)
;****************************************************************************************
LDI ZL,LOW(MYDATA<<1)
LDI ZH,HIGH(MYDATA<<1)
LPM R1,Z
LDI ZL,LOW((MYDATA<<1)|1)
LDI ZH,HIGH((MYDATA<<1)|1)
LPM R2,Z
MYDATA: .DW $ABCD
MYDATA1:.DB 10,$20,'A','B',"cdef"
MYDATA2:.DW 10,$20,'A','B'
MYDATA3:.DD 10,$20,'A','B'
MYDATA4:.DQ 10,$20,'A','B'
;****************************************************************************************
;C?U TR�C C�C T.GHI IO PORT
;****************************************************************************************
LDI R16,0
OUT DDRA,R16 ;portA nh?p
LDI R16,0xFF
OUT PORTA,R16 ;c� ?i?n tr? k�o l�n
OUT DDRC,R16 ;portC xu?t
IN R25,PINA ;??c data t? portA


LDI R16,$0F
OUT DDRB,R16 ;PB0-PB3: xu?t, PB4-PB7: nh?p
LDI R16,$F0
OUT PORTB,R16 ;PB4-PB7: c� ?i?n tr? k�o l�n
;****************************************************************************************
;THANH GHI SREG
;****************************************************************************************
LDI R16,$6E ;+110D
LDI R17,$5A ;+90D
ADD R16,R17 ;+200D>+127 --> c? C=1
LDI R20,$8 ;R20=0000 1000B
LDI R21,$8 ;R21=0000 1000B
ADD R20,R21 ;KQ =0001 0000B, c� carry t? bit3 -->H=1
;th??ng ???c quan t�m khi th?c hi?n c�c ph�p to�n tr�n s? BCD
;n?u xem ph�p to�n tr�n th?c hi?n tr�n 2 s? BCD
;LDI R22,6 ;th� c?n hi?u ch?nh KQ ?? ?�ng v?i BCD khi ph�t hi?n c� c? H=1
;ADD R20,R22 ;R20=0001 0110(16)
LDI R22,$80 ;R22=-128
LDI R23,10 ;R23=10=0AH
ADD R22,R23 ;KQ=8AH=-118 --> c? N=1(s? �m:KQ ?�ng), S=1(KQ ?�ng l� s? �m),V=0
SUBI R22,20 ;KQ=76H=+118 --> c? N=0(s? d??ng:KQ sai),V=1(tr�n)
;S=1(KQ ?�ng l� s? �m (-138))
;--> V=0:KQ ?�ng, V=1: KQ sai
;--> V=S?N
LDI R24,10 ;
CP R24,R23 ;KQ=0 --> c? Z=1
CP R24,R22 ;KQ<0 --> c? N=1, C=1, S=1(KQ ?�ng)
;****************************************************************************************
;C�C L?U �
;****************************************************************************************
MOV R0,R1
;MOV 0x00,0x01
IN R5,PINA
IN R5,$0
OUT PORTD,R5
OUT 0x0B,R5
;OUT TCNT1L,R5 ;TCNT1L=84H(SRAM_ADDR)
;OUT $84,R5
STS TCNT1L,R5
STS $84,R17
STS 0X2B,R5
;STS PORTD,R5 ;�nh x? ??a ch? portD s? sai