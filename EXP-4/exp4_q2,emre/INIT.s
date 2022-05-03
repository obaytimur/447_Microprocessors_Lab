; 16/32 Timer Registers
TIMER1_CFG			EQU 0x40031000
TIMER1_TAMR			EQU 0x40031004
TIMER1_CTL			EQU 0x4003100C
TIMER1_IMR			EQU 0x40031018
TIMER1_RIS			EQU 0x4003101C ; Timer Interrupt Status
TIMER1_ICR			EQU 0x40031024 ; Timer Interrupt Clear
TIMER1_TAILR		EQU 0x40031028 ; Timer interval
TIMER1_TAPR			EQU 0x40031038
TIMER1_TAR			EQU	0x40031048 ; Timer register
	
;GPIO Registers
GPIO_PORTB_DATA		EQU 0x40005040 ; Access BIT4
GPIO_PORTB_DIR 		EQU 0x40005400 ; Port Direction
GPIO_PORTB_AFSEL	EQU 0x40005420 ; Alt Function enable
GPIO_PORTB_DEN 		EQU 0x4000551C ; Digital Enable
GPIO_PORTB_AMSEL 	EQU 0x40005528 ; Analog enable
GPIO_PORTB_PCTL 	EQU 0x4000552C ; Alternate Functions
GPIO_PORTB_PDR		EQU	0X40005514 ;PULL DOWN REGISTER
GPIO_PORTB_PUR EQU 0x40005510

;System Registers
SYSCTL_RCGCGPIO 	EQU 0x400FE608 ; GPIO Gate Control
SYSCTL_RCGCTIMER 	EQU 0x400FE604 ; GPTM Gate Control

			
			AREA 	routines, CODE, READONLY
			THUMB
			EXPORT	INIT
INIT		PROC
			LDR	R1, =SYSCTL_RCGCGPIO	; Start GPIO clock
			LDR	R0, [R1]
			ORR	R0, R0, #0x2		; Choose Port B
			STR	R0, [R1]
			NOP	
			NOP
			NOP
			LDR	R1, =GPIO_PORTB_DIR	
			LDR	R0, [R1]
			BIC	R0, R0, #0x10		; Set PB4 as input
			STR	R0, [R1]
			LDR	R1, =GPIO_PORTB_AFSEL	; Enable alternate function
			LDR	R0, [R1]
			ORR	R0, R0, #0x10
			STR	R0, [R1]
			LDR	R1, =GPIO_PORTB_PCTL	; Enable T1CCP0 on PB4
			LDR	R0, [R1]
			ORR	R0,R0, #0x00070000
			STR	R0, [R1]
			LDR	R1, =GPIO_PORTB_AMSEL	; Disable analog
			MOV	R0, #0
			STR	R0, [R1]
			LDR	R1, =GPIO_PORTB_DEN		; PB4 digital enable	
			LDR R0, [R1]
			ORR	R0, R0, #0x10
			STR	R0, [R1]
			
			LDR	R1, =SYSCTL_RCGCTIMER	; Start timer1
			LDR	R2, [R1]
			ORR	R2, R2, #0x02
			STR	R2, [R1]
			NOP
			NOP
			NOP
			LDR	R1, =TIMER1_CTL
			LDR	R2, [R1]
			BIC	R2, R2, #0x01		; Disable clock
			STR	R2, [R1]
			LDR	R1, =TIMER1_CFG		; Set 16 bit mode
			MOV	R2, #0x04
			STR	R2, [R1]
			LDR R1, =TIMER1_TAMR
			MOV R2, #0x07 ; set to capture and edge time mode
			STR R2, [R1]
			LDR R1, =TIMER1_TAILR ; initialize match clocks
			MOV R2, #0xFFFFFFFF
			STR R2, [R1]
			LDR	R1, =TIMER1_CTL	; Both edges enable with stall on debug
			LDR	R2, [R1]
			ORR	R2, R2, #0x0F
			STR	R2, [R1]
			
			BX	LR
			ENDP
			END