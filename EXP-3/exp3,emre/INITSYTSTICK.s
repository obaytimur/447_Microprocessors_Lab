ST_CTRL 	EQU 	0xE000E010		
ST_RELOAD	EQU		0xE000E014
ST_CURRENT	EQU		0xE000E018
SYS_PRI 	EQU 	0xE000ED20
RELOAD_VAL 	EQU 	0x00010000		
		AREA	subroutine,	READONLY,	CODE,	ALIGN=2
		THUMB
		EXPORT	INITSYSTICK
			
INITSYSTICK	PROC
		
		LDR		R1, =ST_CTRL		; Disable the clock first
		MOV		R0, #0
		STR		R0, [R1]
		
		LDR 	R1, =ST_RELOAD		; Load the initial value that is decremented
		LDR 	R0, =RELOAD_VAL
		STR 	R0, [R1]
		
		LDR 	R1, =ST_CURRENT		; Load same to current
		STR 	R0, [R1]
		
		LDR		R1, =SYS_PRI		; Set priority to 2
		MOV 	R0, #0x40000000		;priority level 2
		STR 	R0, [R1]
		
		LDR		R1, =ST_CTRL		; Enable clock with interrupt
		MOV 	R0, #0x03
		STR		R0, [R1]
		BX 		LR
		
		ALIGN	
		ENDP