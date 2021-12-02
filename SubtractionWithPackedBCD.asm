TITLE Subtraction_with_Packed_BCD (Chapter 7)		(SubtractionWithPackedBCD.asm)

COMMENT !
Student: Rachel Nguyen
Class: CSCI 241
Instructor: Ding
Assignment: Ch07, Subtraction_with_Packed_BCD
Due Date: 3/25/21

Description:
This program performs an operation of subtraction with two 
Packed_BCD's in 32-bit, like EAX-EBX and returns its Packed 
BCD difference.
!


INCLUDE Irvine32.inc
.data
msgTitle BYTE "Packed BCD Subtraction of Unsigned Integers",0dh,0ah,0
msgMinuend BYTE "Enter your Minuend (up to 8 digits): ",0
msgSubtrahend BYTE "And the Subtrahend (up to 8 digits): ",0
borrowPrefix BYTE "1:",0
minusSign BYTE " - ",0
equalSign BYTE " = ",0

.code
main PROC

; Show program title

	mov edx, OFFSET msgTitle
	call WriteString

; Input the Minuend by reading hexadecimal 

	mov edx, OFFSET msgMinuend
	call WriteString
	call ReadHex
	mov ebx, eax								; save minuend

; Input the Subtrahend by reading hexadecimal 

	mov edx, OFFSET msgSubtrahend
	call WriteString
	call ReadHex
	xchg eax, ebx								; swap so that EAX = minuend, EBX = subtrahend 

; Call PackedBcdSub for EAX-EBX with result in EDX

	mov ecx, 4									; loop count = number of bytes to subtract  
	call PackedBcdSub
	mov ecx, edx								; save result

; Check CF to show a borrow if necessary

	jnc NoBorrow								; if CF = 0, skip borrow prefix. else, print

	mov edx, OFFSET borrowPrefix				
	call WriteString

	NoBorrow:								

; Output by writing hexadecimal   

	call WriteHex								; print minuend

	mov edx, OFFSET minusSign					; print minus sign
	call WriteString

	mov eax, ebx								; print subtrahend
	call WriteHex	

	mov edx, OFFSET equalSign					; print equal sign
	call WriteString

	mov eax, ecx								; print result
	call WriteHex
	call crlf

	exit
main ENDP

;-----------------------------------------------------------------
PackedBcdSub PROC uses EAX EBX
;
; Performs operation EAX-EBX Packed BCD to return the difference
; Receives: EAX, First number, Minuend, to be subtracted from
;           EBX, Second number, Subtrahend, to be subtracted
; Returns:  EDX, Result, the difference
;           CF=1, if need a borrow, else CF=0
;----------------------------------------------------------------

	xor edx, edx			; clear edx
	clc						; clear CF

	L1:
		sbb al, bl			; subtract with carry
		das					; adjust result
		mov dl, al			; save byte result
		pushfd				; save CF
		ror eax, 8			; next byte
		ror ebx, 8			
		ror edx, 8			
		popfd				; restore CF
		loop L1

	ret
PackedBcdSub ENDP

END main