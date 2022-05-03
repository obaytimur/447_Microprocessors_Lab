GPIO_PORTB_DATA	EQU		0x400053FC
				AREA    main, READONLY, CODE
				THUMB
				EXTERN	delay
				EXPORT	stepper
						
stepper 		PROC	
				LDR		R1,=GPIO_PORTB_DATA
				LDR		R1,[R1]
				AND		R0,R1,#0xF0
				LDR		R5,=0x20000400
				LDRB	R2,[R5]
				CMP		R2,#1
				BEQ		clockw
				LDRB	R2,[R5]
				CMP		R2,#2
				BEQ		counterw
				BX		LR
				
clockw			CMP		R0,#0x00
				MOVEQ	R0,#0x10
				BEQ		finish
				CMP		R0,#0x80
				MOVEQ	R0,#0x10
				BEQ		finish
				CMP		R0,#0x10
				MOVEQ	R0,#0x20
				BEQ		finish
				CMP		R0,#0x20
				MOVEQ	R0,#0x40
				BEQ		finish
				CMP		R0,#0x40
				MOVEQ	R0,#0x80
				BEQ		finish
			

counterw		CMP		R0,#0x80
				MOVEQ	R0,#0x40
				BEQ		finish
				CMP		R0,#0x40
				MOVEQ	R0,#0x20
				BEQ		finish
				CMP		R0,#0x20
				MOVEQ	R0,#0x10
				BEQ		finish
				CMP		R0,#0x10
				MOVEQ	R0,#0x80
				BEQ		finish

finish			BFC		R1,#4,#4
				ORR		R1,R1,R0
				LDR		R4,=GPIO_PORTB_DATA
				STR		R1,[R4]
				LDR		R1,=0x20000400
				MOV		R0,#0
				STRB	R0,[R1]
				
				BX		LR
				ENDP
				ALIGN
				END