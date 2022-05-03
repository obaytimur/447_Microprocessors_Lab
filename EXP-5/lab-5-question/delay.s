			AREA    	main, READONLY, CODE
			THUMB
			EXPORT  	delay

delay		PROC
			LDR			R12,=800000			
loop		SUBS		R12,#1
			BNE			loop
			BX			LR
			ENDP
			ALIGN
			END





