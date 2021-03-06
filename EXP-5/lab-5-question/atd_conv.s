RCGCADC 			EQU 0x400FE638 
ADC0_ACTSS 			EQU 0x40038000 
ADC0_RIS 			EQU 0x40038004 
ADC0_IM 			EQU 0x40038008
ADC0_EMUX 			EQU 0x40038014 
ADC0_PSSI 			EQU 0x40038028 
ADC0_SSMUX3 		EQU 0x400380A0
ADC0_SSCTL3 		EQU 0x400380A4
ADC0_SSFIFO3 		EQU 0x400380A8
ADC0_PC 			EQU 0x40038FC4
ADC0_ISC			EQU	0x4003800C	
			
					AREA		main, READONLY, CODE
					THUMB
					
					EXTERN		delay
					EXPORT		atd_conv


atd_conv			PROC
					PUSH	{LR}
					BL		delay
					LDR 	R3, =ADC0_RIS
					LDR 	R4, =ADC0_SSFIFO3 
					LDR 	R2, =ADC0_PSSI 
					LDR 	R6,= ADC0_ISC
					;sampling
					LDR 	R0, [R2]
					ORR 	R0, R0, #0x08 
					STR 	R0, [R2]
loop 				LDR 	R0, [R3]
					ANDS 	R0, R0, #8
					BEQ 	loop
					LDR 	R0,[R4]
					STR 	R0, [R6]
					POP		{LR}
					BX 		LR
					ENDP
					END