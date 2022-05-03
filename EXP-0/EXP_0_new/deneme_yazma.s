			EXPORT  	__main	; Make available

__main		PROC		;Fazli Ogulcan Baytimur, 2231389

get 		BL 			InChar
			CMP			R5,#0x20
			BEQ 		done
			BL			OutChar
			B 			get
done 		B 			done

			ENDP
			ALIGN
			END