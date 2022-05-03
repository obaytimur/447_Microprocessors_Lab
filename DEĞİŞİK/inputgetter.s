;Label		Directive		Value		Comment
			AREA			inputgetter,READONLY, CODE
			THUMB
msg_intro	DCB				"Please enter a number n<32 with '/' at the end",0x04
			ALIGN

;Label		Directive		Value		Comment
			EXTERN			OutStr		
			EXTERN			InChar
			EXPORT 			inputgetter	
				
inputgetter	PROC	
start 		LDR				R5,=msg_intro
			MOV				R12,LR
			BL				OutStr
			MOV				R0,#0x04
			PUSH			{R0}
			
get			BL				InChar
			CMP				R5,#0x2F
			BEQ				con
			PUSH			{R5}
			B				get
				
con			MOV				R0,#1
			MOV				R1,#10
			MOV				R4,#0
value		POP				{R2}
			CMP				R2,#0x04
			BEQ				finish
			SUB				R2,#48
			MUL				R2,R0
			ADD				R3,R2
			MUL				R0,R1
			B				check
			
check		CMP				R3,#32
			BMI				finish
			B				start
			
finish		BX				R12			
			ENDP
			ALIGN
			END
			