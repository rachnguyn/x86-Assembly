TITLE Greatest_Common_Divisor (Chapter 7, Pr 6)		(GreatestCommonDivisor.asm)

COMMENT !
Student: Rachel Nguyen
Class: CSCI 241
Instructor: Ding
Assignment: Ch07, Greatest_Common_Divisor 
Due Date: 3/23/21

Description:
This program finds the GCD of two non-zero integers using
integer division in a non-resurive procedure. 
!


INCLUDE Irvine32.inc
.data
msgNumOne BYTE "Enter a 32 bit number: ", 0
msgNumTwo BYTE "Enter a 32 bit number: ", 0
msgGCD BYTE "Greatest common divisor is: ", 0

.code
main PROC

	call Clrscr

	mov edx, OFFSET msgNumOne		; get first num
	call WriteString
	call ReadInt
	mov ebx, eax					; store first num in EBX
	
	mov edx, OFFSET msgNumTwo		; get second num
	call WriteString
	call ReadInt					; second num in EAX

	call CalcGcd					; calculate GCD

	mov edx, OFFSET msgGCD			
	call WriteString
	call WriteDec					; display GCD
	call crlf

	exit
main ENDP

;----------------------------------------------------------------
CalcGcd PROC 
; Description: Calculates the GCD of two non-zero integers
; Receives: EBX = first number, EAX = second number
; Returns: EAX = GCD to display
;----------------------------------------------------------------

; find absolute value of both numbers 

	mov edx, ebx
	sar edx, 31			; shift until filled with sign bit 
	xor ebx, edx		; if pos, first num remains the same. if neg, flip bits (one's complement)
	sub ebx, edx		; if neg, add 1 (two's complement)

	mov edx, eax	
	sar edx, 31			; shift until filled with sign bit
	xor eax, edx		; if pos, second num remains the same. if neg, flip bits (one's complement)
	sub eax, edx		; if neg, add 1 (two's complement)
	 
; divide numbers while remainder > 0

	L1:
		xor edx, edx		; clear high dividend
		div ebx
		mov eax, ebx		; change dividend and divisor (x = y)
		mov ebx, edx		; y = remainder
		cmp ebx, 0		
		jbe DONE			; if remainder is <= 0, return
		jg L1				; else, continue to divide

	DONE:
		ret

CalcGcd ENDP

END main