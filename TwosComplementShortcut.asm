TITLE Twos_Complement_Shortcut (Chapter 7) (TwosComplementShortcut.asm)

COMMENT !
Student: Rachel Nguyen
Class: CSCI 241
Instructor: Ding
Assignment: Ch07, Twos_Complement_Shortcut
Due Date: 3/18/21

Description:
This program converts a number to its two's complement
without forming its ones' complement and plus one. 
!


INCLUDE Irvine32.inc
.data
msgUserInput BYTE "Enter a 32-bit signed integer in decimal: ", 0
msgBinary BYTE "Your integer input in binary is ", 0
msgBinResult BYTE "The 2's complement in binary is ", 0
msgDecResult BYTE "The 2's complement in decimal is ", 0

.code
main PROC

		mov edx, OFFSET msgUserInput		; prompt user for signed decimal input
		call WriteString
		call ReadInt

		mov edx,  OFFSET msgBinary			; show user input in binary
		call WriteString
		call WriteBin
		call crlf

		call TwosCompShortcut				; convert binary input into its two's complement

		mov edx, OFFSET msgBinResult		; show two's complement in binary
		call WriteString
		call WriteBin
		call crlf

		mov edx, OFFSET msgDecResult		; show two's complement in decimal
		call WriteString
		call WriteInt
		call crlf


	exit
main ENDP

;---------------------------------------------------------------
TwosCompShortcut PROC
; Description: Converts a number to its two's complement without 
; forming its ones' complement and plus one.
; Recieves: EAX as a signed integer.
; Returns: EAX the 2's complement of EAX.
;---------------------------------------------------------------

	mov ebx, 1

	L1: 
		test eax, ebx				; start at LSB and check for 1
		jnz next					; if 1 found, jump
		shl ebx, 1					; else, move to next bit
		jnc L1						

	next:
		shl ebx, 1					; shift left to keep first 1 before XORing

	L2:
		XOR eax, ebx				; flip remaining bits
		shl ebx, 1
		jnz L2						

		ret
	TwosCompShortcut ENDP

END main