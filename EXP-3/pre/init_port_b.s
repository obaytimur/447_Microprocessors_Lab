GPIO_PORTB_DATA		EQU		0x400053FC	;data address to all pins
GPIO_PORTB_DIR		EQU		0x40005400		
GPIO_PORTB_AFSEL	EQU		0x40005420
GPIO_PORTB_AMSEL	EQU		0x40005428
GPIO_PORTB_DEN		EQU		0x4000551C
GPIO_PORTB_PUR		EQU		0x40005510
IOB					EQU		0xF0
PUB					EQU		0x0F

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
			BIC			R0,#0xFF									;INPUTS			OUTPUTS
			ORR			R0,#IOB									;s1	pb3			d1	pb7						
			STR			R0,[R1]									;s2	pb2			d2	pb6
																;s3	pb1			d3	pb5
			LDR			R1,=GPIO_PORTB_AFSEL					;s4	pb0			d4	pb4
			LDR			R0,[R1]
			BIC			R0,#0xFF
			STR			R0,[R1]
			
			LDR			R1,=GPIO_PORTB_DEN
			LDR			R0,[R1]
			MOV			R0,#0xFF
			STR			R0,[R1]
			
			LDR			R1,=GPIO_PORTB_AMSEL				;PORTB initilization part
			LDR			R0,[R1]								
			BIC			R0,#0xFF
			STR 		R0,[R1]
			
			LDR			R1,=GPIO_PORTB_PUR
			MOV			R0,#PUB
			STR			R0,[R1]
			
			BX			LR
			ENDP
			ALIGN
			END