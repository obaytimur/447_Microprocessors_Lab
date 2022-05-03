					AREA 		main, CODE, READONLY, CODE
					THUMB

TIMER1_CFG			EQU 0x40031000
TIMER1_TAMR			EQU 0x40031004
TIMER1_CTL			EQU 0x4003100C
TIMER1_IMR			EQU	0x40031018
TIMER1_RIS			EQU 0x4003101C ; Timer Interrupt Status
TIMER1_ICR			EQU 0x40031024 ; Timer Interrupt Clear
TIMER1_TAILR		EQU 0x40031028 ; Timer interval
TIMER1_TAMATCHR		EQU	0x40031030
TIMER1_TAPR			EQU 0x40031038
TIMER1_TAR			EQU	0x40031048 ; Timer register
	
SYSCTL_RCGCGPIO 	EQU 0x400FE608 ; GPIO Gate Control
SYSCTL_RCGCTIMER 	EQU 0x400FE604 ; GPTM Gate Control
					
					EXPORT	ex_timer
						
ex_timer			PROC
					LDR R1, =SYSCTL_RCGCTIMER ; Start Timer0
					LDR R2, [R1]
					ORR R2, R2, #0x02
					STR R2, [R1]
					NOP ; allow clock to settle
					NOP
					NOP
					LDR R1, =TIMER1_CTL ; disable timer during setup 
					LDR R2, [R1]
					BIC R2, R2, #0x01
					STR R2, [R1]
					
					LDR R1, =TIMER1_CFG ; set 16 bit mode
					MOV R2, #0x04
					STR R2, [R1]
					
					LDR R1, =TIMER1_TAMR
					MOV R2, #0x07 ; set to periodic, count down
					STR R2, [R1]
					
					;LDR	R1,=TIMER1_CTL
					;LDR	R2,[R1]
					;ORR	R2,R2,#0x0C
					;STR	R2,[R1]
					
					LDR R1, =TIMER1_TAILR ; initialize match clocks
					MOV	R2,#0xFFFFFFFF
					STR R2, [R1]
					
					LDR	R1,=TIMER1_CTL
					LDR	R2,[R1]
					ORR	R2,R2,#0x0F
					STR	R2,[R1]
					
					;LDR	R1,=TIMER1_IMR
					;MOV	R2,#0x01
					;STR	R2,[R1]
					
					BX	LR
					ENDP
					END
					
				