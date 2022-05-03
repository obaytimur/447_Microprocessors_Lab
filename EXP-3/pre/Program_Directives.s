GPIO_PORTB_DATA	EQU			0x400053FC

				AREA init_isr , CODE, READONLY, ALIGN=2
				THUMB
				EXTERN		stepper
				EXTERN		delay
				EXTERN		init_port_b
				EXTERN		InitSysTick
				EXPORT		__main
					
__main			PROC
				BL			init_port_b
				BL			InitSysTick
				CPSIE		I
				LDR			R10,=0x20000400
				MOV			R1,#0
				STRB		R1,[R10]
			
			
debnc_inp		LDR			R1,=GPIO_PORTB_DATA					;Debounce algorithm for pressing
				LDR			R10,[R1]							;wait a delay between two data
				BL			delay								;samples and if they are the same
				LDR			R1,=GPIO_PORTB_DATA					;it continues to check columns
				LDR			R9,[R1]
				CMP			R9,R10								;it loads the data onto R9 reg.
				BEQ			devam
				B			debnc_inp

devam			AND			R8,R9,#0x0F
				CMP			R8,#0xF
				BEQ			debnc_inp
					
debnc_out		LDR			R1,=GPIO_PORTB_DATA					;This debounce part looks for the
				LDR			R7,[R1]								;relase of the key
				AND			R6,R7,#0xF							;if it sees an input it loops until
				CMP			R6,#0xF								;it does not see one.
				BNE			debnc_out							;It also double checks with a delayed time
				BL			delay
				LDR			R1,=GPIO_PORTB_DATA
				LDR			R9,[R1]
				AND			R6,R9,#0xF
				CMP			R6,#0xF
				BNE			debnc_out

				LDR			R10,=0x20000400
				MOV			R0,#1
				CMP			R8,#0x7
				STREQ		R0,[R10]
				BEQ			cont
				MOV			R0,#2
				CMP			R8,#0xB
				STREQ		R0,[R10]
				BEQ			cont
				
cont			B			debnc_inp	
				ENDP
				ALIGN
				END
