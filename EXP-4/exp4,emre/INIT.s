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
GPIO_PORTB_DATA		EQU 0x40005100 ; Access BIT6
GPIO_PORTB_DIR 		EQU 0x40005400 ; Port Direction
GPIO_PORTB_AFSEL	EQU 0x40005420 ; Alt Function enable
GPIO_PORTB_DEN 		EQU 0x4000551C ; Digital Enable
GPIO_PORTB_AMSEL 	EQU 0x40005528 ; Analog enable
GPIO_PORTB_PCTL 	EQU 0x4000552C ; Alternate Functions

;System Registers
SYSCTL_RCGCGPIO 	EQU 0x400FE608 ; GPIO Gate Control
SYSCTL_RCGCTIMER 	EQU 0x400FE604 ; GPTM Gate Control

			
			AREA 	routines, CODE, READONLY
			THUMB
			EXPORT 	My_Timer0A_Handler
			EXPORT	INIT
INIT		PROC
			LDR	R0, =SYSCTL_RCGCGPIO	; Start GPIO clock
			LDR	R1, [R0]
			ORR	R1, R1, #0x2		; Choose Port B
			STR	R1, [R0]
			NOP	
			NOP
			NOP
			LDR	R0, =GPIO_PORTB_DIR	
			LDR	R1, [R0]
			BIC	R1, R1, #0x40		; Set PB6 as input
			STR	R1, [R0]
			LDR	R0, =GPIO_PORTB_AFSEL	; Regular port function
			LDR	R1, [R0]
			BIC	R1, R1, #0x40
			STR	R1, [R0]
			LDR	R0, =GPIO_PORTB_PCTL	; No alternate function
			LDR	R1, [R0]
			BIC	R1,R1 #0x0F000000
			STR	R1, [R0]
			LDR	R0, =GPIO_PORTB_AMSEL	; Disable analog
			MOV	R1, #0
			STR	R1, [R0]
			LDR	R0, =GPIO_PORTB_DEN		; PB6 digital enable	
			LDR R1, [R0]
			ORR	R1, R1, #0x40
			STR	R1, [R0]
			
			LDR	R0, =SYSCTL_RCGCTIMER	; Start timer1
			LDR	R1, [R0]
			ORR	R1, R1, #0x2
			STR	R1, [R0]
			NOP
			NOP
			NOP
			LDR	R0, =TIMER1_CTL
			LDR	R1, [R0]
			BIC	R1, R1, #0x01
			STR	R1, [R0]
			LDR	R0, =TIMER1_CFG
			MOV	R1, #0x04
			STR	R1, [R0]
			LDR R0, =TIMER1_TAMR
			MOV R1, #0x02 ; set to periodic, count down
			STR R1, [R0]
			LDR R0, =TIMER1_TAILR ; initialize match clocks
			LDR R1, =0xFF
			STR R1, [R0]
			LDR R0, =TIMER1_TAPR
			MOV R1, #15 ; divide clock by 16 to
			STR R1, [R0] ; get 1us clocks
			LDR R0, =TIMER1_IMR ; disable timeout interrupt
			MOV R1, #0x00
			STR R1, [R0]
			LDR	R0, =TIMER1_CTL
			LDR	R1, [R0]
			ORR	R1, R1, #0x03
			STR	R1, [R0]
			BX	LR
			ENDP
			END
			