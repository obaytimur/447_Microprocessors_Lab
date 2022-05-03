GPIO_PORTB_DATA	EQU			0x400053FC

				AREA 		main, CODE, READONLY, CODE
				THUMB
				EXTERN		PULSE_INIT
				EXTERN		init_port_b
				EXTERN		ex_timer
				EXTERN		dalga
				EXTERN		convrt
				EXPORT		__main
					
__main			PROC
				BL			PULSE_INIT
				BL			init_port_b
				BL			ex_timer
				BL			dalga
				
loop			B			loop	
				ENDP
				ALIGN
				END
