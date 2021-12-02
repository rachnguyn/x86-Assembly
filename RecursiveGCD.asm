TITLE Recursive_Greatest_Common_Divisor (Chapter 8, Pr 7) (RecursiveGCD.asm)

COMMENT ! 
Student: Rachel Nguyen
Class: CSCI 241
Instructor: Ding
Assignment: Ch08, Recursive_Greatest_Common_Divisor
Due Date: 4/6/21

Description:
This program finds the greatest common divisor (GCD) of two unsigned
integers using a recursive implementation of Euclid's algorithm. 
!

INCLUDE Irvine32.inc

CalcGcd PROTO,
	int1: DWORD,
	int2: DWORD

ShowResult PROTO,
	int1: DWORD,
	int2: DWORD,
	gcd: DWORD

.data
array DWORD 5,20, 10,24, 24,18, 11,7, 438,226, 26,13
msg1 BYTE "GCD of ",0
msg2 BYTE " and ",0
msg3 BYTE " is ",0

.code
main PROC
	call Clrscr

	mov ecx, LENGTHOF array / 2		; set loop count (num of integer pairs) 
	mov esi, OFFSET array			; offset of array, beginning

	L1:
		INVOKE CalcGcd, [esi], [esi+4]				; calculate GCD of single pair
		INVOKE ShowResult, [esi], [esi+4], eax		; display result

		add esi, TYPE array * 2						; update location to next pair 
		loop L1

	exit
main ENDP

;---------------------------------------------------
CalcGcd PROC, int1:DWORD, int2:DWORD
; Calculate the greatest common divisor, of
;     two nonnegative integers in recursion.
; Receives: int1, int2
; Returns:  EAX = Greatest common divisor
;---------------------------------------------------

	xor edx, edx		; clear high dividend 
	mov eax, int1		; set low dividend		
	mov ebx, int2		; set divisor
	div ebx				; divide int1 / int2 
	cmp edx, 0			; check if remainder = 0 
	jz DONE				; if yes, quit

	INVOKE CalcGcd, ebx, edx		; recursive call 

	DONE: 
		mov eax, ebx	; set EAX = gcd
		ret

CalcGcd ENDP 

;---------------------------------------------------
ShowResult PROC, int1:DWORD, int2:DWORD, gcd:DWORD
; Show calculated GCD result as
;      "GCD of 5 and 20 is 5"
; Receives: int1, int2, gcd
;---------------------------------------------------

	mov edx, OFFSET msg1		; display "GCD of "
	call WriteString

	mov eax, int1				; display first int
	call WriteDec

	mov edx, OFFSET msg2		; display " and "
	call WriteString

	mov eax, int2				; display second int 
	call WriteDec

	mov edx, OFFSET msg3		; display " is "
	call WriteString

	mov eax, gcd				; display GCD result
	call WriteDec
	call Crlf				
	
	ret
ShowResult ENDP


END main