;*************************************************************** 
; Program_Directives.s  
; Copies the table from one location
; to another memory location.           
; Directives and Addressing modes are   
; explained with this program.   
;***************************************************************	
;*************************************************************** 
; EQU Directives
; These directives do not allocate memory
;***************************************************************
;LABEL		DIRECTIVE	VALUE		COMMENT
OFFSET  	EQU     	0x10
NUM	   	EQU	    	0x20000400	
;***************************************************************
; Directives - This Data Section is part of the code
; It is in the read only section  so values cannot be changed.
;***************************************************************
;LABEL		DIRECTIVE	VALUE		COMMENT
            AREA        sdata, DATA, READONLY
            THUMB

;***************************************************************
; Program section					      
;***************************************************************
;LABEL		DIRECTIVE	VALUE		COMMENT
			AREA    	main, READONLY, CODE
			THUMB
			EXTERN		OutStr	; Reference external subroutine	
			EXTERN		inputgetter
			EXTERN		upbnd
			EXPORT  	__main	; Make available

__main		PROC
start		LDR			R6,=NUM
			MOV 		R7,#1	;lower bound
			MOV 		R8,#1	;upper bound
			BL			inputgetter
			LSL			R8,R3	;2^n calculation by shifting
			STR			R8,[R6]
			STR			R7,[R6,#4]
			BL			upbnd
finish		B			finish
			

			
			ENDP
;***************************************************************
; End of the program  section
;***************************************************************
;LABEL      DIRECTIVE       VALUE                           COMMENT
			ALIGN
			END
