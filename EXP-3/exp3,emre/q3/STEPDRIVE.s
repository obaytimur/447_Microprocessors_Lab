GPIO_PORTB_DATA		EQU 0x400053FC
	
		AREA	main,	READONLY,	CODE
		THUMB
		EXPORT	STEPDRIVE
		EXTERN	DELAY100ms
					
STEPDRIVE		PROC					
		LDR		R4, =GPIO_PORTB_DATA	; Check if any switch is pressed
		LDR		R0, [R4]
		AND		R0, #0x30
		CMP		R0, #0x30
		BEQ		STEPDRIVE
		
		CMP		R0, #0x20				; Check if first switch is pressed
		BNE		s2branch				; If not equal, second switch is pressed
		BLEQ	DELAY100ms				; Add delay to avoid bouncing
		LDR		R0, [R4]
		AND		R0, #0x30
		CMP		R0, #0x20
		BEQ		s1pressed
		
s2branch
		CMP		R0, #0x10				; Check if second switch is pressed
		BNE		STEPDRIVE				; Neither of the switches are pressed. Start from beginning
		BLEQ	DELAY100ms
		LDR		R0, [R4]
		AND		R0, #0x30
		CMP		R0, #0x10
		BEQ		s2pressed				; Check for bouncing then branch to switch2
		BNE		STEPDRIVE				; If not same due to bouncing start over
s1pressed
		LDR		R0, [R4]				; Obtain the input
		AND		R0, #0x30				; Check if switch1 is still pressed
		CMP		R0, #0x20
		BEQ		s1pressed				; If pressed, wait until release
		BLNE	DELAY100ms				; Add delay, check bouncing
		LDR		R0, [R4]
		AND		R0, #0x30
		CMP		R0, #0x20
		BEQ		s1pressed
		BNE		s1released				; Branch to release
s2pressed
		LDR		R0, [R4]				; Obtain the input
		AND		R0, #0x30				; Check if switch2 is still pressed
		CMP		R0, #0x10
		BEQ		s2pressed				; If pressed, wait until release
		BLNE	DELAY100ms				; Add delay, check bouncing
		LDR		R0, [R4]
		AND		R0, #0x30
		CMP		R0, #0x10
		BEQ		s2pressed
		BNE		s2released				; Branch to release
s1released
		MOV		R1, #8					; Forward rotation
		MOV		R0, #0
		LDR		R2, [R4]
		AND		R2, #0xF
		CMP		R2, R0
		MOVEQ	R2, #1
		BEQ		exit1	
		CMP		R1, R2
		MOVEQ	R2, #1
		BEQ		exit1
		LSL		R2, R2, #1
exit1	STR		R2, [R4]
		B		STEPDRIVE				; Start over
s2released
		MOV		R1, #1					; Backward rotation
		MOV		R0, #0
		LDR		R2, [R4]
		AND		R2, #0xF
		CMP		R2, R0
		MOVEQ	R2, #8
		BEQ		exit2	
		CMP		R1, R2
		MOVEQ	R2, #8
		BEQ		exit2
		LSR		R2, R2, #1
exit2	STR		R2, [R4]
		B		STEPDRIVE				; Start over
		
		BX		LR
		ALIGN
		ENDP