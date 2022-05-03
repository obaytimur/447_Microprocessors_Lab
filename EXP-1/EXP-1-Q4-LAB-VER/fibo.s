VALUE	 	EQU	    	0x20000800
;LABEL		DIRECTIVE	VALUE		COMMENT
            AREA        sdata, DATA, READONLY
            THUMB
msg_intro	DCB			"Please enter a number n<32 with '/' at the end",0x04				      
;***************************************************************
;LABEL		DIRECTIVE	VALUE		COMMENT
			AREA    	READONLY, CODE
			THUMB
			EXPORT  	fibo	; Make available
				
fibo		PROC						
			PUSH		{LR}
			LDR 		R8,=VALUE
			MOV			R7,R8
			MOV			R11,#0
			STR			R11,[R8],#4
			ADD			R11,#1
			STR			R11,[R8],#4
start		CMP			R4,#1
			MOVEQ		R10,#1
			PUSHEQ		{R10}
			SUBEQ		R4,#1
			CMP			R4,#0
			MOVEQ		R10,#0
			PUSHEQ		{R10}
			BEQ			exit
			PUSH		{LR}
			SUB			R4,#1
			BL			start
			POP			{LR}
exit		POP			{R10}
			POP			{R9}
			POP			{LR}
			MOV			R11,R9
			LSL			R9,#1
			ADD			R9,R9,R10
			MOV			R10,R11
			PUSH		{R9}
			PUSH		{R10}
			PUSH		{LR}
			STR			R9,[R8],#4
			MOV			PC,LR
			ENDP
;LABEL      DIRECTIVE       VALUE                           COMMENT
			ALIGN
			END
