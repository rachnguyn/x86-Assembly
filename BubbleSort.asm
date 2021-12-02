TITLE Improving_Bubble_Sort (Chapter 9, Modified)     (BubbleSort2.asm)

COMMENT !
Student: Rachel Nguyen
Class: CSCI 241
Instructor: Ding
Assignment: Ch09, Improving_Bubble_Sort
Due Date: 4/15/21

Description:
This program sorts an array of signed integers, using an improved Bubble Sort algorithm 
that checks if array is already sorted. The main program is in BinarySearchTest.asm.
!

INCLUDE Irvine32.inc

.code

;----------------------------------------------------------
BubbleSort2 PROC USES eax ebx ecx esi,
	pArray:PTR DWORD,		; pointer to array
	Count:DWORD				; array size
;
; Sort an array of 32-bit signed integers in ascending order
; using the bubble sort algorithm.
; Receives: pointer to array, array size
; Returns: nothing
;-----------------------------------------------------------

	mov ecx, Count
	dec ecx				; decrement count by 1

L1:	push ecx			; save outer loop count
	mov	esi, pArray		; point to first value
	xor ebx, ebx		; exchange flag = 0

L2:	mov	eax, [esi]		; get array value
	cmp	[esi+4], eax	; compare a pair of values
	jge	L3				; if [esi] <= [edi], don't exch
	xchg eax, [esi+4]	; exchange the pair
	mov	[esi], eax
	mov ebx, 1			; set exchange flag = 1 

L3:	add	esi, 4		; move both pointers forward
	loop L2			; inner loop

	pop	ecx			; retrieve outer loop count
	cmp ebx, 0		; exchanges?
	je L4			; no: exit loop, already sorted
	loop L1			; else repeat outer loop

L4:	ret
BubbleSort2 ENDP

END
