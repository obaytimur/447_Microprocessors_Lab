; EQU Directives
; These directives do not allocate memory
;***************************************************************
;LABEL		DIRECTIVE	VALUE		COMMENT
OFFSET  	EQU     	0x10
NUM	   		EQU	    	0x20000400	
VALUE		EQU			0x20000300
;***************************************************************
; Directives - This Data Section is part of the code
; It is in the read only section  so values cannot be changed.
;***************************************************************
;LABEL		DIRECTIVE	VALUE		COMMENT
            AREA        sdata, DATA, READONLY
            THUMB
CTR1    	DCB     	0x10
MSG     	DCB     	"Copying table..."
			DCB			0x0D
			DCB			0x04
;***************************************************************
; Program section					      
;***************************************************************
;LABEL		DIRECTIVE	VALUE		COMMENT
			AREA    	main, READONLY, CODE
			THUMB
			EXTERN		OutStr	; Reference external subroutine	
			EXTERN		InChar
			EXPORT  	__main	; Make available
			EXTERN 		convrt

__main		PROC
start		LDR	   		R5,=VALUE	;Initilize R5 with a value
			LDR 		R7,=NUM		;Loads NUM
			STR			R5,[R7]		;Stores the number at the pointed address
			LDR			R4,[R7]		;Loads the value as a number to R4
			
input		BL			InChar
			LDR			R5,=VALUE 	;Need to reinitilize since it is disturbed by inchar subroutine
			BL			convrt		;Calls written convert subroutine
			B			input	

end			B			end
			
			ENDP
;***************************************************************
; End of the program  section
;***************************************************************
;LABEL      DIRECTIVE       VALUE                           COMMENT
			ALIGN
			END
