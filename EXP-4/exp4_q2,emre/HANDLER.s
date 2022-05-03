; 16/32 Timer Registers
TIMER1_RIS			EQU 0x4003101C ; Timer Interrupt Status
TIMER1_ICR			EQU 0x40031024 ; Timer Interrupt Clear
TIMER1_TAR			EQU	0x40031048 ; Timer register
	
;GPIO Registers
GPIO_PORTB_DATA		EQU 0x40005040 ; Access BIT4

			AREA	sdata, READONLY, CODE
			THUMB
MSG1				DCB	"Period (ns):"
					DCB	0x04
					DCB	0x0D
MSG2				DCB	"Pulse Width (ns):"
					DCB	0x04
					DCB	0x0D
MSG3				DCB	"Duty Cycle (%):"
					DCB	0x04
					DCB	0x0D						
			
			AREA 	routines, CODE, READONLY
			THUMB

			EXPORT	HANDLER
			EXTERN	OutStr
			EXTERN	CONVRT
HANDLER		PROC
			PUSH	{LR}
			; Memory for positive-negative edge values
			LDR	R3, =0x20000400
			; Memory for timer values
			LDR	R7, =0x20000500
			; Capture amount
			MOV	R8, #0

mainloop		LDR	R1, =TIMER1_RIS	; Constantly check the CAERIS bit
waitforcapture	LDR	R2, [R1]		; If there is no capture 
				CMP	R2, #0x04		; wait for capture
				BNE	mainloop
				
				ADD	R8, R8, #1		; Increment capture amount
				
				LDR	R1, =TIMER1_TAR	; Get timer value
				LDR	R2, [R1]
				STR	R2, [R7], #4	; Store time value when edge is detected
				
				LDR	R1, =GPIO_PORTB_DATA	;Obtain the input data
				LDR	R2, [R1]
				
				MOV	R4, #0
				MOV	R5, #1
				
				CMP	R2, #0x10	; Compare PB4 with 1
				STRBEQ	R5, [R3], #1	; If positive edge store value
				STRBNE	R4, [R3], #1	; If negative edge store value
				
				CMP		R8, #3
				BEQ		exit
				
				LDR	R1, =TIMER1_ICR		; Clear Timer1 CAERIS bit
				MOV	R0, #0x04
				STR	R0, [R1]
				
				B	mainloop
				
exit			; Memory for positive-negative edge values
				LDR	R3, =0x20000400
				; Memory for timer values
				LDR	R7, =0x20000500	
				
				LDRB	R1, [R3]
				CMP		R1, #1	
				BNE		Negedge
				LDR	R0, [R7], #4	; First pos edge
				LDR	R1, [R7], #4	; First neg edge
				LDR	R2, [R7]		; Second pos edge
				
				SUB	R3, R0, R2		; Period
				SUB	R7, R0, R1		; Pulse width
				MOV	R8, #100
				MUL	R6, R7, R8		; find duty cycle
				UDIV R6, R6, R3		; D = (Pulse Width *100)/Period
				B	out
				; If first edge is negative edge
Negedge			LDR	R0, [R7], #4	; First neg edge
				LDR	R1, [R7], #4	; First pos edge
				LDR	R2, [R7]		; Second neg edge
				
				SUB	R3, R0, R2		; Period
				SUB	R7, R1, R2		; Pulse width
				MOV	R8, #100
				MUL	R6, R7, R8		; find duty cycle
				UDIV R6, R6, R3		; D = (Pulse Width *100)/Period
				
				; If first edge is positive edge
				; Since 1 cycle is 62.5ns find period and pulse width as nanoseconds
out				MOV	R0, #625
				MOV	R1, #10
				MUL	R3, R0
				UDIV R3, R1			; Find period as seconds
				MUL	R7, R0
				UDIV R7, R1			; Find pulse width as seconds
				
				; Period print
				LDR	R5, =MSG1
				BL	OutStr
				LDR	R5, =0x20005000
				MOV	R4, R3
				PUSH	{R5}			; CONVRT and OutStr changes R5, R6. So, in order not to lose them
				PUSH	{R6}			; push them into stack
				BL		CONVRT
				POP		{R6}
				BL		OutStr
				POP		{R5}	
				
				; Pulse width print
				LDR	R5, =MSG2
				BL	OutStr
				LDR	R5, =0x20005000
				MOV	R4, R7
				PUSH	{R5}			; CONVRT and OutStr changes R5, R6. So, in order not to lose them
				PUSH	{R6}			; push them into stack
				BL		CONVRT
				POP		{R6}
				BL		OutStr
				POP		{R5}	
				
				; Duty Cycle print
				LDR	R5, =MSG3
				BL	OutStr
				LDR	R5, =0x20005000
				MOV	R4, R6
				PUSH	{R5}			; CONVRT and OutStr changes R5, R6. So, in order not to lose them
				PUSH	{R6}			; push them into stack
				BL		CONVRT
				POP		{R6}
				BL		OutStr
				POP		{R5}	
				
				POP	{LR}
				BX	LR
				ENDP
				END
				