					AREA    	main, READONLY, CODE
					THUMB
					IMPORT		stepper						
SysTick_handler		PROC
					EXPORT		SysTick_handler		[WEAK]
					B			stepper
					ENDP
					ALIGN
					END