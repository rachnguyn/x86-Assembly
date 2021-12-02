TITLE Generating_Fibonacci_Linked_List (Chapter 10)						(FibonacciLinkedList.asm)

COMMENT !
Student: Rachel Nguyen
Class: CSCI 241
Instructor: Ding
Assignment: Ch10, Generating_Fibonacci_Linked_List
Due Date: 4/29/21

Description:
This program generates a linked list filled with 
the first 15 fibonacci numbers. 
!

INCLUDE Irvine32.inc
INCLUDE Macros.inc

ListNode STRUCT
  NodeData DWORD ?
  NextPtr  DWORD ?
ListNode ENDS

TotalNodeCount = 15
NULL = 0
Counter = 0

val1  = 1
val2  = 1
val3 = val1 + val2

.data

LinkedList LABEL PTR ListNode			; generate linked list with 15 fib values
REPT TotalNodeCount
	Counter = Counter + 1
	IF Counter LT 3						; first two fib values
		ListNode <1, ($ + Counter * SIZEOF ListNode)>		
	ELSE
		IF Counter LT 15
			ListNode <val3, ($ + Counter * SIZEOF ListNode)>
		ELSE
			ListNode <val3,0>			; tail node
		ENDIF
		val1 = val2
		val2 = val3
		val3 = val1 + val2
	ENDIF
ENDM

.code
main PROC

	mov esi, OFFSET LinkedList
	mWriteLn "Linked list with 15 Fibonacci numbers:"		; display prompt
	mDumpMem esi, %(TotalNodeCount*2), TYPE LinkedList		; display memory
	mWriteLn " "
	mWrite "List: "											; display list of fib nums

	NextNode:
		mov  eax,(ListNode PTR [esi]).NodeData		; display node data
		call WriteDec

		mov  eax,(ListNode PTR [esi]).NextPtr		; tail node?
		cmp  eax,NULL
		je   quit									; yes: quit

		mWrite "->"									; no: display arrow "->"
		mov  esi,(ListNode PTR [esi]).NextPtr		; point to next node
		jmp  NextNode

quit:
	mWriteLn " "
	call WaitMsg
	exit

main ENDP
END main