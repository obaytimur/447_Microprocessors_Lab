GPIO_PORTB_DATA		EQU 0x400053FC		
		AREA	subroutine,	READONLY,	CODE
		THUMB	
		EXPORT	ISR
; FORWARD			
ISR		PROC
		LDR		R5, =GPIO_PORTB_DATA
		MOV		R1, #8
		MOV		R0, #0
		LDR		R2, [R5]			; Obtain the input data
		AND		R2, #0xF			; Understand which key is pressed
		CMP		R2, R0				; Compare with 0
		MOVEQ	R2, #1				
		BEQ		exit	
		CMP		R1, R2				; If this is the last sequence start over
		MOVEQ	R2, #1
		BEQ		exit
		LSL		R2, R2, #1			; Next output port
exit	STR		R2, [R5]			; Store the value
		BX		LR
		ALIGN
		ENDP

