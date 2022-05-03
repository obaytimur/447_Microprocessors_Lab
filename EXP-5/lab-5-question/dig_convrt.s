					AREA		main, READONLY, CODE
					THUMB
						
					EXTERN 		OutChar	
					EXPORT		dig_convrt
						
dig_convrt			PROC
					PUSH		{LR}
					
					;000 is negative 1.65V
					;FFF is positive 1.65V
					;steps are 3.3/(2^12) = 0.806 mV	
					MOV 		R7,#0x7FF
					CMP			R7,R0
					BMI			positive
negative			SUB			R7,R0
					MOV			R0,R7
					MOV			R5,#45
					BL			OutChar
					BL			cont
positive			SUB			R0,R7
cont				MOV			R1,#806
					MUL			R5,R0,R1
					MOV			R1,#10000
					UDIV		R5,R1
					MOV			R1,#10
					UDIV		R2,R5,R1
					MUL			R12,R2,R1
					SUB			R12,R5,R12 			;Z
					UDIV		R11,R2,R1
					MUL			R11,R11,R1
					SUB			R11,R2,R11			;Y
					UDIV		R2,R1				;X
					
					MOV			R5,R2
					ADD			R5,#48
					BL			OutChar
					
					MOV			R5,#46
					BL			OutChar
					
					MOV			R5,R11
					ADD			R5,#48
					BL			OutChar
					
					MOV			R5,R12
					ADD			R5,#48
					BL			OutChar
					
					MOV			R5,#10
					BL			OutChar
					POP			{LR}
					BX			LR
					ENDP
					END