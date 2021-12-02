TITLE Random_Color_Char_Screen_Fill (Chapter 11, Pr 4, Modified)			(RandomColorCharScreenFill.asm)

COMMENT !
Student: Rachel Nguyen
Class: CSCI 241
Instructor: Ding
Assignment: Ch10, Random_Color_Char_Screen_Fill
Due Date: 5/4/21

Description:
This program fills each screen cell with a random character, 
in a random color. The main purpose of this program is to 
reduce system I/O API calls.
!

INCLUDE Irvine32.inc
MAXCOL = 50
MAXROW = 20

.data
outHandle DWORD ?
bufColor WORD MAXCOL DUP (?)
bufChar BYTE MAXCOL DUP (?)
xyPos COORD <0,0>
cellsWritten DWORD ?

.code
main PROC

	INVOKE GetStdHandle, STD_OUTPUT_HANDLE		; get standard output handle
	mov outHandle, eax

	mov ecx, MAXROW						; outer loop count (# rows)

	L1:
		push ecx						; save outer loop count
		mov ecx, MAXCOL					; inner loop count (# col)
		mov esi, OFFSET bufColor		
		mov edi, OFFSET bufChar

		L2:
			call ChooseColor			; get random color, save to buffer
			mov [esi], ax				
			call ChooseCharacter		; get random char, save to buffer
			mov [edi], al				
			add esi, TYPE bufColor		; point to next color
			add edi, TYPE bufChar		; point to next char
			LOOP L2

		INVOKE WriteConsoleOutputAttribute, outHandle, ADDR bufColor, MAXCOL, xyPos, ADDR cellsWritten		; write color
	    INVOKE WriteConsoleOutputCharacter, outHandle, ADDR bufChar, MAXCOL, xyPos, ADDR cellsWritten		; write char

		inc xyPos.y			; move to next row
		pop ecx				; restore outer loop count
		LOOP L1
		
	INVOKE SetConsoleCursorPosition, outHandle, xyPos		; set cursor position for wait msg
	call WaitMsg
	exit
main ENDP

;-----------------------------------------------------------------------
ChooseColor PROC
; Selects a color with 50% probability of red, 25% green and 25% yellow
; Receives: nothing
; Returns:  AX = randomly selected color
;-----------------------------------------------------------------------

	mov ax, 4
	call RandomRange		; choose a color (0-3)

	.IF ax < 2				; red (0-1)
		mov ax, 04h
	.ELSEIF ax == 2			; green (2)
		mov ax, 02h
	.ELSE					; yellow (3)
		mov ax, 0Eh
	.ENDIF

ret
ChooseColor ENDP
;-----------------------------------------------------------------------
ChooseCharacter PROC
; Randomly selects an ASCII character, from ASCII code 20h to 07Ah
; Receives: nothing
; Returns:  AL = randomly selected character
;-----------------------------------------------------------------------

    mov al, 59h    
    call RandomRange		; choose a char (20h-07Ah)
    add al, 20h             ; AL gets ASCII value 

ret
ChooseCharacter ENDP
END main