
;LABEL		DIRECTIVE	VALUE		COMMENT
            AREA        sdata, DATA, READONLY
            THUMB
msg_intro	DCB			"Please enter a number n<32 with '/' at the end",0x04

;***************************************************************
; Program section					      
;***************************************************************
;LABEL		DIRECTIVE	VALUE		COMMENT
			AREA    	READONLY, CODE
			THUMB
			EXTERN		OutStr	; Reference external subroutine	
			EXTERN 		InChar
			EXPORT  	inputgetter	; Make available

inputgetter	PROC						;this subroutine takes an input, n, from user
			PUSH			{LR}		;and returns it's integer value
start 		LDR				R5,=msg_intro
			BL				OutStr
			MOV				R0,#0x04
			PUSH			{R0}
			
get			BL				InChar
			CMP				R5,#0x2F	;check if it is '/' or not
			BEQ				con
			PUSH			{R5}
			B				get
				
con			MOV				R0,#1
			MOV				R1,#10
			MOV				R3,#0
value		POP				{R2}
			CMP				R2,#0x04	;this value block calculates
			BEQ				check		;the integer value by simply
			SUB				R2,#48		;multiplying each digit with 10
			MUL				R2,R0		;until it sees eot=0x04
			ADD				R3,R2
			MUL				R0,R1
			B				value
			
check		CMP				R3,#32		;checks if n<32 or not
			BMI				finish
			B				start
			
finish		POP				{LR}
			BX				LR
			ENDP
;***************************************************************
; End of the program  section
;***************************************************************
;LABEL      DIRECTIVE       VALUE                           COMMENT
			ALIGN
			END
