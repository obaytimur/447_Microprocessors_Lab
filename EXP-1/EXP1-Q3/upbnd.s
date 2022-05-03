ADRS		EQU			0x20000300
            AREA        sdata, DATA, READONLY
            THUMB
msg_guess	DCB			"Is this the number you picked, muggle?",0x04
msg_correct	DCB			"HA HA HA, I knew I could find it so easily, muggle!",0x04
;LABEL		DIRECTIVE	VALUE		COMMENT
			AREA    	READONLY, CODE
			THUMB
			EXTERN		OutStr	; Reference external subroutine	
			EXTERN 		InChar
			EXTERN		convrt
			EXPORT  	upbnd	; Make available
upbnd		PROC
			PUSH		{LR}
start		LDR			R8,[R6]		;save upper bound
			LDR			R7,[R6,#4]	;save lower bound	
			ADD			R4,R8,R7	;Upper Bound + Lower Bound
			LSR			R4,#1		;Divide the sum by 2 and use it as guess
			STR			R4,[R6,#8]	;save guess
			LDR			R5,=msg_guess
			BL			OutStr
			LDR			R5,=ADRS
			PUSH		{R6}		;in order to not lose it in cnvrt subroutine
			BL			convrt
			POP			{R6}
S			BL			InChar
			CMP			R5,#67		;if it is C, correct
			BEQ			correct
			CMP			R5,#68		;if it is D, down
			BEQ			down
			CMP			R5,#85		;if it is U, up
			BEQ			up
correct		LDR			R5,=msg_correct
			BL			OutStr
			POP			{LR}
			BX			LR
down		LDR			R8,[R6,#8]	;down and up blocks updates
			STR			R8,[R6]		;lower and upper bounds
			B			start
up			LDR			R7,[R6,#8]	
			STR			R7,[R6,#4]
			B			start
			ENDP
;***************************************************************
; End of the program  section
;***************************************************************
;LABEL      DIRECTIVE       VALUE                           COMMENT
			ALIGN
			END
