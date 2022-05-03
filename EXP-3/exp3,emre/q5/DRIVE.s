ST_RELOAD			EQU		0xE000E014
ST_CURRENT			EQU		0xE000E018
GPIO_PORTB_DATA		EQU 0x400053FC	
		AREA	subroutine,	READONLY,	CODE,	ALIGN=2
		THUMB
		EXPORT	DRIVE
		EXTERN	DELAY100ms
		
DRIVE	PROC
		LDR		R4, =GPIO_PORTB_DATA		; Obtain the input
		LDR		R0, [R4]				
		AND		R0, #0xF0					; Check which key is pressed
		CMP		R0, #0xF0					; If not pressed, wait until press
		BEQ		DRIVE
		
		CMP		R0, #0x70					; If first switch is pressed
		BLEQ	DELAY100ms
		BNE		s2branch					; If first switch is not pressed, branch for second switch
		LDR		R0, [R4]
		AND		R0, #0xF0
		CMP		R0, #0x70 
		BEQ		s1pressed					; If no bouncing, branch since switch 1 is pressed
		BNE		DRIVE
		
s2branch
		CMP		R0, #0xB0					; If second switch is pressed
		BLEQ	DELAY100ms
		BNE		s3branch					; If second switch is not pressed, branch for third switch
		LDR		R0, [R4]
		AND		R0, #0xF0
		CMP		R0, #0xB0
		BEQ		s2pressed					; If no bouncing, branch since switch 2 is pressed
		BNE		DRIVE
s3branch
		CMP		R0, #0xD0					; If third switch is pressed
		BLEQ	DELAY100ms
		BNE		s4branch					; If third switch is not pressed, branch for fourth switch
		LDR		R0, [R4]
		AND		R0, #0xF0
		CMP		R0, #0xD0
		BEQ		s3pressed					; If no bouncing, branch since switch 3 is pressed
		BNE		DRIVE
s4branch
		CMP		R0, #0xE0					; If fourth switch is pressed
		BLEQ	DELAY100ms
		BNE		s3branch					; If fourth switch is not pressed, branch for third switch
		LDR		R0, [R4]
		AND		R0, #0xF0
		CMP		R0, #0xE0
		BEQ		s4pressed					; If no bouncing, branch since switch 4 is pressed
		BNE		DRIVE
s1pressed
		LDR		R0, [R4]					; Check if still pressed
		AND		R0, #0xF0
		CMP		R0, #0x70
		BEQ		s1pressed
		BLNE	DELAY100ms					; Check for bouncing
		LDR		R0, [R4]
		AND		R0, #0xF0
		CMP		R0, #0x70
		BEQ		s1pressed
		BNE		s1released					; Branch to operate
s2pressed
		LDR		R0, [R4]					; Check if still pressed
		AND		R0, #0xF0
		CMP		R0, #0xB0
		BEQ		s2pressed
		BLNE	DELAY100ms					; Check for bouncing
		LDR		R0, [R4]
		AND		R0, #0xF0
		CMP		R0, #0xB0
		BEQ		s2pressed
		BNE		s2released					; Branch to operate
s3pressed
		LDR		R0, [R4]					; Check if still pressed
		AND		R0, #0xF0
		CMP		R0, #0xD0
		BEQ		s3pressed
		BLNE	DELAY100ms					; Check for bouncing
		LDR		R0, [R4]
		AND		R0, #0xF0
		CMP		R0, #0xD0
		BEQ		s3pressed
		BNE		s3released					; Branch to operate
s4pressed
		LDR		R0, [R4]					; Check if still pressed
		AND		R0, #0xF0
		CMP		R0, #0x70
		BEQ		s4pressed
		BLNE	DELAY100ms					; Check for bouncing
		LDR		R0, [R4]
		AND		R0, #0xF0
		CMP		R0, #0x70
		BEQ		s4pressed
		BNE		s4released					; Branch to operate
s1released
		MOV		R8, #0						; Forward mode of operation, change R8 value
		B		DRIVE						; Start over
s2released
		LDR		R2, =ST_RELOAD				; Speed up by decreasing load value
		LDR		R3, =ST_CURRENT
		LDR		R0,[R2]
		LSR		R0, R0, #1
		STR		R0, [R2]
		STR		R0, [R3]
		B		DRIVE
s3released
		LDR		R2, =ST_RELOAD				; Speed down by increasing load value
		LDR		R3, =ST_CURRENT
		LDR		R0,[R2]
		LSL		R0, R0, #1
		STR		R0, [R2]
		STR		R0, [R3]
		B		DRIVE
s4released
		MOV		R8, #1						; Backward mode of operation, change R8 value
		B		DRIVE						; Start over
	
		BX		LR
		ENDP