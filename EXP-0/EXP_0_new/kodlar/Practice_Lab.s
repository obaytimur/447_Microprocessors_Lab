;***************************************************************
; Program PracticeLab.s
; Clear memory locations 0x2000.0400 - 0x2000.041F,
; then load these locations with consecutive numbers starting
; with 00.
; 'CONST' is the number of locations operated on.
; 'FIRST' is the address of first memory address.
;***************************************************************

;***************************************************************
; EQU Directives
; These directives do not allocate memory
;***************************************************************
;SYMBOL		DIRECTIVE	VALUE			COMMENT
FIRST 		EQU 		0x20000400
CONST 		EQU 		0x20
;***************************************************************
; Program section
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
            AREA 		main, READONLY, CODE
            THUMB
            EXPORT 		__main
__main 		PROC
	
get 		BL 			InChar
			CMP			R5,#0x20
			BEQ 		done
			BL			OutChar
			B 			get
done 		B 			done
			
			ENDP
;***************************************************************
; End of the program section
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
			ALIGN
            END
