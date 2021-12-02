TITLE Linked_List_Insertion_and_Display (Chapter 11, Pr 11)		(LinkedListInsertionAndDisplay.asm)

COMMENT !
Student: Rachel Nguyen
Class: CSCI 241
Instructor: Ding
Assignment: Ch11, Linked_List_Insertion_and_Display
Due Date: 5/11/21 

Description:
This program implements a singly linked list using
dynamic memory allocation.
!


INCLUDE Irvine32.inc
INCLUDE Macros.inc

NODE STRUCT
   intVal SDWORD ?
   pNext DWORD ?
NODE ENDS
PNODE TYPEDEF PTR NODE

.data
hHeap HANDLE ?
head NODE <0,0> ; Dummy head
pTailNode PNODE ?
pCurrNode PNODE ?

.code
main PROC

	INVOKE GetProcessHeap				; get handle to program's heap
	cmp eax, NULL						; failed?
	je error							; yes: error msg
	mov hHeap, eax						; no: save handle

	mov esi, pCurrNode					; ESI = points to current node
	mov edi, OFFSET head				; EDI = points to tail node 

read:
	mWrite "Enter a signed integer node value (zero to end): "
	call ReadInt						
	jz displayList						; zero? yes: display list
	call CreateNode						; no: create node
	jc error							; failed? yes: error msg
	mov (NODE PTR [esi]).intVal, eax	; no: fill node data
	mov (NODE PTR [edi]).pNext, esi		; tail->next = curr
	mov edi, esi						; tail = curr
	jmp read

displayList:
	mov (NODE PTR [edi]).pNext, NULL		; tail->next = NULL
	mov esi, OFFSET head					; traverse list from head
	call crlf
	mWriteLn "Contents of Linked List:"		; display prompt

nextNode:
	mov  ebx, (NODE PTR [esi]).pNext		; save pointer to next node
	mov  eax, (NODE PTR [esi]).intVal		; save node data
	.IF eax == 0							; dummy head?
		mWrite "Dummy Head"					; yes: display
	.ELSE
		call WriteInt							; no: display contents
		INVOKE HeapFree, hHeap, NULL, esi		; free the dynamically allocated node
		cmp eax, NULL							; failed? 
		je error								; yes: error msg
	.ENDIF
	cmp  ebx, NULL							; tail node?
	je   quit								; yes: quit
	mWrite " -> "							; no: display arrow "->"
	mov esi, ebx							; point to next node
	jmp nextNode

error:
	call WriteWindowsMsg					; display error msg
quit:
	call crlf
	exit
main ENDP

;--------------------------------------------------------
CreateNode PROC uses EAX
;
; Dynamically allocates space to create a node.
; Receives: nothing
; Returns: CF = 0 if allocation succeeds
;		   CF = 1 if allocation fails
;		   ESI = pointer to allocated heap (node)
;--------------------------------------------------------
	INVOKE HeapAlloc, hHeap, HEAP_ZERO_MEMORY, SIZEOF NODE
	
	.IF eax == NULL
	   stc					; return with CF = 1
	.ELSE
	   mov esi, eax			; save pointer in current node
	   clc					; return with CF = 0
	.ENDIF

	ret
CreateNode ENDP

END main