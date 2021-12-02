TITLE Color Matrix Nested Loop		(main.asm)

COMMENT !
Student: Rachel Nguyen
Class: CSCI 241
Instructor: Ding
Assignment: Ch05, Color_Matrix_Nested_Loop
Due Date: 3/02/21

Description:
This program displays a single character in all possible combinations of foreground and background colors with AL: BKGD|FRGD.
!

INCLUDE Irvine32.inc

DELAYTIME = 800

.data
count DWORD ? 

.code
main PROC
	
	mov ecx, 16					; set outer count loop 
	mov ebx, 0					; initalize EBX to black on black 

	L1: 
		mov count, ecx			; save outer loop count 
		mov ecx, 16				; set inner loop count
	L2:
		mov eax, ebx			; save color to EAX to call SetTextColor
		call SetTextColor
		mov al, "X"				; pass char to AL to call WriteChar
		call WriteChar
		inc ebx					; update new color 

		loop L2					; end of columns		

		mov eax, DELAYTIME		; initalize EAX to call Delay
		call Delay			
		call crlf				; add newline 
		mov ecx, count			; set outer loop count 

		loop L1					; end of rows	

		mov al, 0Fh				; black on white
		call SetTextColor		; restore default color

	exit
main ENDP

END main