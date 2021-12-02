TITLE Drunkards_Walk_Enhanced (Chapter 10)	(Walk2.asm)

COMMENT !
Student: Rachel Nguyen
Class: CSCI 241
Instructor: Ding
Assignment: Ch10, Drunkards_Walk_Enhanced55
Due Date: 4/22/21

Description:
This program rewrites Walk.asm named as Walk2.asm with several enhancements.
!

INCLUDE Irvine32.inc
WalkMax = 30
StartX = 39
StartY = 10

DrunkardWalk STRUCT
	path COORD WalkMax DUP(<0,0>)
	pathsUsed WORD 0
DrunkardWalk ENDS

DisplayPosition2 PROTO,
	currX:WORD, 
	currY:WORD

.data
aWalk DrunkardWalk <>
msgPrompt BYTE "How many steps the Drunkard to move: ",0

.code
main PROC
	call Clrscr
	call Randomize							

	GetSteps:
		mov	edx,OFFSET msgPrompt			
		call WriteString					; prompt user for input
		call ReadDec						; get number of steps from user
	.IF eax < 30
		jmp GoodInput	
	.ELSE
		jmp GetSteps						; 30 or more? get input again 
	.ENDIF

	GoodInput:
		mov aWalk.pathsUsed, ax				; store good value

	mov	esi, OFFSET aWalk
	call TakeDrunkenWalk2					; take a walk in random directions
	call crlf					
	call WaitMsg							; display wait msg
	call ShowPath							; display steps walked 

	exit
main ENDP


;-------------------------------------------------------
TakeDrunkenWalk2 PROC
;
; Take a walk in random directions (north, south, east,
; west).
; Receives: ESI points to a DrunkardWalk structure
; Returns:  the structure is initialized with random values
;-------------------------------------------------------
	pushad

; Use the OFFSET operator to obtain the address of
; path, the array of COORD objects, and copy it to EDI.

	xor ecx, ecx								; clear ecx
	mov edi, esi
	mov	cx, (DrunkardWalk PTR [edi]).pathsUsed	; loop counter
	mov	bx, StartX								; current X-location
	mov	dx, StartY								; current Y-location

Again:
	; Insert current location in array.
	mov	(COORD PTR [edi]).X, bx
	mov	(COORD PTR [edi]).Y, dx

	INVOKE DisplayPosition2, bx, dx

	Gen:
		mov	  eax,4			; choose a direction (0-3)
		call  RandomRange

		.IF eax == 0					; North
		  dec dx
		.ELSEIF eax == 1				; South
		  inc dx
		.ELSEIF eax == 2				; West
		  dec bx
		.ELSE							; East (EAX = 3)
		  inc bx
		.ENDIF
		.IF bx == 39 && dx == 10
			mov	bx, (COORD PTR [edi]).X
			mov	dx, (COORD PTR [edi]).Y
			jmp Gen						; regenerate valid (X,Y) if (39,10)
		.ENDIF

		add	edi,TYPE COORD		; point to next COORD
	loop	Again

Finish:
	popad
	ret
TakeDrunkenWalk2 ENDP

;-------------------------------------------------------
ShowPath PROC 
; Outputs each step the Drunkard walked with O as the 
; start and * for all others
; Receives: ESI = points to DrunkardWalk structure
; Returns: nothing
;-------------------------------------------------------
	
.data
consoleHandle DWORD ?
endMsg COORD <0,20>

.code
	pushad	

; set first cursor position
	INVOKE GetStdHandle, STD_OUTPUT_HANDLE
	mov consoleHandle, eax	
	INVOKE SetConsoleCursorPosition, consoleHandle, (DrunkardWalk PTR [esi]).path	
	
; write first step 'O' with reversed color
	call GetTextColor		
	mov bl, al							; save default color in BL
	rol al, 4							; set reverse color													
	call SetTextColor
	mov al, 'O'							
	call WriteChar						; write 'O' in reverse color		

; rewrite 'O' in default color with delay
	INVOKE SetConsoleCursorPosition, consoleHandle, (DrunkardWalk PTR [esi]).path		; go back to text position
	mov eax, 300						; delay effect
	call Delay	
	mov al, bl							; set default color
	call SetTextColor			
	mov al, 'O'							
	call WriteChar						; rewrite 'O' in default color

; loop setup for following steps 
	xor edi,edi										
	mov di, (DrunkardWalk PTR [esi]).pathsUsed		; loop count = pathsUsed - 1
	dec edi								
	jz DONE											; if no paths left, quit

	L1:
		add esi, TYPE COORD																	; point to next COORD
		INVOKE SetConsoleCursorPosition, consoleHandle, (DrunkardWalk PTR [esi]).path		; update cursor position
		mov al, bl																			
		rol al, 4																			; set reverse color
		call SetTextColor	
		mov al, '*'
		call WriteChar																		; write step '*' in reverse color
		INVOKE SetConsoleCursorPosition, consoleHandle, (DrunkardWalk PTR [esi]).path		; go back to text position
		mov eax, 300
		call Delay																			; delay effect			
		mov al, bl																			; set default color
		call SetTextColor	
		mov al, '*'
		call WriteChar																		; rewrite step '*' in default color
		dec edi																				; update count
		jnz L1

	DONE: 
		INVOKE SetConsoleCursorPosition, consoleHandle, endMsg				; cursor to bottom of screen
		call WaitMsg														; display wait msg 
		INVOKE CloseHandle, consoleHandle
		popad
	ret
ShowPath ENDP

;-------------------------------------------------------
DisplayPosition2 PROC currX:WORD, currY:WORD
; Display the current X and Y positions.
;-------------------------------------------------------
.data
commaStr BYTE ",",0
leftparStr BYTE "(",0
rightparStr BYTE ") ",0

.code
	pushad
	mov	 edx,OFFSET leftparStr	; "(" string
	call	 WriteString
	movzx eax,currX			; current X position
	call	 WriteDec
	mov	 edx,OFFSET commaStr	; "," string
	call	 WriteString
	movzx eax,currY			; current Y position
	call	 WriteDec
	mov	 edx,OFFSET rightparStr	; ")" string
	call	 WriteString
	popad
	ret
DisplayPosition2 ENDP
END main