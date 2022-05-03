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
FIRST	   	EQU	    	0x20000480	;starts from the desired address
;***************************************************************
; Directives - This Data Section is part of the code
; It is in the read only section  so values cannot be changed.
;***************************************************************
;LABEL		DIRECTIVE	VALUE		COMMENT
            AREA        sdata, DATA, READONLY
            THUMB
CTR1    	DCB     	0x20		;Size doubled to count two by two
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
			EXPORT  	__main	; Make available

__main		PROC		;Fazli Ogulcan Baytimur, 2231389
	
get 		BL 			InChar
			CMP			R5,#0x20
			BEQ 		done
			BL			OutChar
			B 			get
done 		B 			done
			
			ENDP
;***************************************************************
; End of the program  section
;***************************************************************
;LABEL      DIRECTIVE       VALUE                           COMMENT
			ALIGN
			END
