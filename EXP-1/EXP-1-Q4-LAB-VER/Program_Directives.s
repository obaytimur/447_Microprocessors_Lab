;LABEL		DIRECTIVE	VALUE		COMMENT
OFFSET  	EQU     	0x10
NUM		   	EQU	    	0x20000400	
;***************************************************************
;LABEL		DIRECTIVE	VALUE		COMMENT
            AREA        sdata, DATA, READONLY
            THUMB
CTR1    	DCB     	0x10
bosluk		DCB			" ",0x04
out_msg		DCB			"Your sequence is: "
;***************************************************************
;LABEL		DIRECTIVE	VALUE		COMMENT
			AREA    	main, READONLY, CODE
			THUMB
			EXTERN		convrt
			EXTERN		InChar
			EXTERN		fibo
			EXTERN		inputgetter
			EXTERN		OutStr	; Reference external subroutine	
			EXPORT  	__main	; Make available

__main		PROC
start		BL			inputgetter
			MOV			R4,R3
			BL			fibo
			LDR			R5,=out_msg
			BL			OutStr
loop		LDR			R4,[R7],#4
			PUSH		{R3}
			BL 			convrt	
			LDR			R5,=bosluk
			BL			OutStr
			POP			{R3}
			CMP			R3,#0
			BEQ			done
			SUB			R3,#1
			B			loop
			
done 		B 			done
			
			ENDP
;LABEL      DIRECTIVE       VALUE                           COMMENT
			ALIGN
			END
