TITLE  Improving_Binary_Search (Chapter 9, Modified) (BinarySearch2.asm)

/*-----------------------------------------------------------------------------------------
Student: Rachel Nguyen
Class: CSCI 241
Instructor: Ding
Assignment: Ch09, Improving_Binary_Search
Due Date: 4/15/21

Description:
This program is a revised procedure named BinarySearch2 to improve the textbook sample 
BinarySearch PROC.
-----------------------------------------------------------------------------------------*/

INCLUDE Irvine32.inc

.code

;-------------------------------------------------------------
BinarySearch2 PROC USES ebx edx esi edi,
	pArray:PTR DWORD,		; pointer to array
	Count:DWORD,			; array size
	searchVal:DWORD			; search value
;
; Search an array of signed integers for a single value.
; Receives: Pointer to array, array size, search value.
; Returns: If a match is found, EAX = the array position of the
; matching element; otherwise, EAX = -1.
;-------------------------------------------------------------
	mov	 eax,0				; EAX = first = 0
	mov	 edx,Count			; EDX = last = (count - 1)
	dec	 edx
	mov	 edi,searchVal		; EDI = searchVal
	mov	 esi,pArray			; ESI points to the array

L1: ; while first <= last
	cmp	 eax, edx
	jg	 L5					; exit search

; EBX = mid = (last + first) / 2
	mov ebx, eax			
	add	 ebx, edx			
	shr	 ebx, 1				; EBX = mid 

; if (values[mid] < searchVal) 
	cmp	 [esi+ebx*4],edi	; dereference mid value (scaled by 4) and compare
	jg	 L2
	je	 L3
	mov	 eax, ebx			; first = mid + 1
	inc	 eax
	jmp	 L4

; else if (values[mid] > searchVal)
L2:	
	mov	 edx, ebx				; last = mid - 1
	dec	 edx
	jmp	 L4

; else return mid (values[mid] == searchVal)
L3:	mov	 eax, ebx  				; value found
	jmp	 L9						; return (mid)

L4:	jmp	 L1						; continue the loop

L5:	mov	 eax,-1					; search failed
L9:	ret

BinarySearch2 ENDP

END