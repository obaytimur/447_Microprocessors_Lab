;LABEL		DIRECTIVE	VALUE		COMMENT
			AREA    	main, READONLY, CODE
			THUMB
ADDRESS		EQU			0x20002000
			EXTERN		OutStr	; Reference external subroutine	
			EXPORT  	convrt	; Make available

convrt		PROC
			PUSH		{LR}		;Since it is a subroutine, LR whould be saved
			LDR			R5,=ADDRESS
			MOV    		R0,#10
			MOV			R6,R5		;Both R6 and R5 shows the same address
			LDR			R12, =0x04	;end of string
			PUSH 		{R12}
			
calc_loop	UDIV		R1,R4,R0	;Divide R4 by 10   	
			MUL			R1,R0,R1	;Multiple R1 by 10
			SUB			R2,R4,R1	;Substract R1 from R4 resulting the least significant decimal
			ADD			R2,R2,#48	;Makes R2 to its ASCII value.
			PUSH 		{R2}			;Pushes least significant decimal value to stack
			CMP			R1,#0
			BEQ			str_loop
			UDIV		R4,R1,R0	;Store R1/10 to R4 for the next digit calculation
			BL 			calc_loop

str_loop   	POP			{R3}
			STR			R3,[R6]		;Popped digit stored in the address
			CMP			R3,R12		;check if it is end of transmission
			BEQ			finish		;if it is goes to finish
			ADD			R6,#1		;if it is not increment one since we can use single byte
			BL			str_loop

			

finish		BL			OutStr		;since R5 position is not changed we can safely print string
			POP			{LR}		;Pop to return to called address
			BX			LR
			ENDP

;LABEL      DIRECTIVE       VALUE                           COMMENT
			ALIGN
			END
