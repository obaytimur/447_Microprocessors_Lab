		AREA	main,	READONLY,	CODE
		THUMB
		
		EXPORT 	__main
		EXTERN	PULSE_INIT

__main	PROC
		BL	PULSE_INIT
		
done	NOP
		B	done
		
		ENDP
		END