TITLE Print_Fibonacci_Until_Overflow (Chapter 6)

COMMENT !
Student: Rachel Nguyen
Class: CSCI 241
Instructor: Ding
Assignment: Ch06, Print_Fibonacci_Until_Overflow
Due Date: 3/16/21

Description:
This program calculates the signed Fibonacci number 
sequence stopping only when the number is over the 
signed DWORD range. Displays each decimal integer 
value on a separate line, prefixed with an index. 
!


INCLUDE Irvine32.inc
.data
prefix BYTE ":", 0

.code
main PROC
		
	mov esi, 1			; set index number
	mov eax, 1			; fibonacci setup
	mov ebx, 0
	mov edx, 0

	L1:
		call printFibonacci		; print fib num with prefix 
		inc esi					; update index
		xchg  ebx, eax
		add  eax, ebx
		jno L1					; loop if NOT out of range signed DWORD (OF = 0)

	exit
main ENDP

;------------------------------------------------------------
printFibonacci PROC USES eax edx esi
;
; Prints fibonacci number to screen with prefix
; Receives: EAX = fibonacci number, ESI = index number
; Returns: nothing
;------------------------------------------------------------

	xchg eax, esi					  ; print index
	call WriteDec				

	mov  edx, OFFSET prefix			  ; print ":"
	call WriteString				  

    xchg eax, esi					  ; print fib num
	call WriteDec				

	call crlf						  ; new line 

   ret
printFibonacci ENDP

END main