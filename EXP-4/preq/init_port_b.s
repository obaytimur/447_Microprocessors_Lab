GPIO_PORTB_DATA		EQU		0x40005040 	;data address to all pins
GPIO_PORTB_IM		EQU		0x40005010
GPIO_PORTB_DIR		EQU		0x40005400		
GPIO_PORTB_AFSEL	EQU		0x40005420
GPIO_PORTB_AMSEL	EQU		0x40005528
GPIO_PORTB_DEN		EQU		0x4000551C
GPIO_PORTB_PUR		EQU		0x40005510
GPIO_PORTB_PCTL		EQU		0x4000552C
IOB					EQU		0x04
PUB					EQU		0x00

SYSCTL_RCGCGPIO		EQU		0x400FE608


			AREA    	main, READONLY, CODE
			THUMB	
			EXPORT  	init_port_b	; Make available

init_port_b	PROC
			LDR			R1, =SYSCTL_RCGCGPIO
			LDR			R0,[R1]
			ORR			R0,#0x02
			STR			R0,[R1]
			
			NOP
			NOP
			NOP									;Stabilize clock
			
			LDR			R1,=GPIO_PORTB_DIR
			LDR			R0,[R1]									
			BIC			R0,R0,#0x10
			STR			R0,[R1]									
																
			LDR			R1,=GPIO_PORTB_AFSEL					
			LDR			R0,[R1]
			ORR			R0,#0x10			
			STR			R0,[R1]
			
			LDR			R1,=GPIO_PORTB_PCTL
			LDR			R0,[R1]
			ORR			R0,R0,#0x00070000			
			STR			R0,[R1]
			
			LDR			R1,=GPIO_PORTB_AMSEL				;PORTB initilization part
			MOV			R0,#0
			STR 		R0,[R1]
			
			LDR			R1,=GPIO_PORTB_DEN
			LDR			R0,[R1]
			ORR			R0,R0,#0x10
			STR			R0,[R1]
			

			
			BX			LR
			ENDP
			ALIGN
			END