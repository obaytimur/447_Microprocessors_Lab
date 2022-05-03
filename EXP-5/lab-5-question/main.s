					AREA		main, READONLY, CODE
					THUMB
						
					EXTERN		atd_conv
					EXTERN		adc_initial
					EXTERN		dig_convrt
					EXPORT		__main
						
__main				PROC
					BL			adc_initial
					LDR			R5,=0x20000400
					MOV			R1,#0
					STR			R1,[R5]
loop				LDR			R8,=0x20000500
					MOV			R9,#5
					MOV			R10,#0
mini				BL			atd_conv
					STR			R0,[R8]
					ADD			R8,#4
					ADD			R10,R0
					SUBS		R9,#1
					CMP			R9,#0
					BNE			mini
					MOV			R9,#5
					UDIV		R10,R9
					MOV			R0,R10
					BL			dig_convrt
					B			loop

					ENDP
					END