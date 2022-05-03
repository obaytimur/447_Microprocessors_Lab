					AREA 		main, CODE, READONLY, CODE
					THUMB

YAZI1				DCB	"Pulse Width (ns): ",0x04
YAZI2				DCB	"Period (ns): ",0x04
YAZI3				DCB	"Duty Cycle (%): ",0x04

TIMER1_CFG			EQU 0x40031000
TIMER1_TAMR			EQU 0x40031004
TIMER1_CTL			EQU 0x4003100C
TIMER1_RIS			EQU 0x4003101C ; Timer Interrupt Status
TIMER1_ICR			EQU 0x40031024 ; Timer Interrupt Clear
TIMER1_TAILR		EQU 0x40031028 ; Timer interval
TIMER1_TAMATCHR		EQU	0x40031030
TIMER1_TAPR			EQU 0x40031038
TIMER1_TAR			EQU	0x40031048 ; Timer register
	
GPIO_PORTB_DATA		EQU		0x40005040 	;data address to all pins
GPIO_PORTB_IM		EQU		0x40005010
GPIO_PORTB_DIR		EQU		0x40005400		
GPIO_PORTB_AFSEL	EQU		0x40005420
GPIO_PORTB_AMSEL	EQU		0x40005528
GPIO_PORTB_DEN		EQU		0x4000551C
GPIO_PORTB_PUR		EQU		0x40005510
GPIO_PORTB_PCTL		EQU		0x4000552C

SYSCTL_RCGCTIMER	EQU		0x400FE604

					EXTERN	OutStr
					EXTERN	convrt
					EXPORT	dalga
						
dalga				PROC
					PUSH	{LR}
					
					LDR		R12,=20000400
					LDR		R11,=20000500
					MOV		R10,#0
					
bas					LDR		R1,=TIMER1_RIS
start				LDR		R2,[R1]
					CMP		R2,#0x4
					BNE		bas
					ADD		R10,#1
					LDR		R1,=TIMER1_TAR
					LDR		R2,[R1]
					STR		R2,[R11],#4
					LDR		R1,=GPIO_PORTB_DATA
					LDR		R2,[R1]
					
					MOV		R3,#1
					MOV		R4,#0
					CMP		R2,#0x10
					STRBEQ	R3,[R12],#1
					STRBNE	R4,[R12],#1
					
					CMP		R10,#3
					BEQ		devam
					
					LDR		R1,=TIMER1_ICR
					MOV		R2,#0x04
					STR		R2,[R1]
					B		bas
					
devam				LDR		R12,=20000400
					LDR		R11,=20000500
					LDRB	R1,[R12]
					CMP		R1,#1
					BEQ		positive
					
					LDR		R0,[R11],#4
					LDR		R1,[R11],#4
					LDR		R2,[R11]
					
					SUB		R12,R0,R2
					SUB		R11,R1,R2
					MOV		R10,#100
					MUL		R6,R11,R10
					UDIV	R6,R6,R12
					B		out
					
positive			LDR		R0,[R11],#4
					LDR		R1,[R11],#4
					LDR		R2,[R11]
					
					SUB		R12,R0,R2
					SUB		R11,R0,R1
					MOV		R10,#100
					MUL		R6,R11,R10
					UDIV	R6,R6,R12

out					MOV		R0,#625
					MOV		R1,#10
					MUL		R12,R0
					UDIV	R12,R1
					MUL		R11,R0
					UDIV	R11,R1
					
					LDR		R5,=YAZI1
					BL		OutStr
					LDR		R5,=20000400
					MOV		R4,R12
					BL		convrt
					
					LDR		R5,=YAZI2
					BL		OutStr
					LDR		R5,=20000400
					MOV		R4,R11
					BL		convrt
					
					LDR		R5,=YAZI3
					BL		OutStr
					LDR		R5,=20000400
					MOV		R4,R6
					BL		convrt
					
					
					
					POP		{LR}
					BX		LR
					ENDP
					ALIGN
					END