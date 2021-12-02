TITLE Replace_Char_In_String (Chapter 9) (ReplaceCharInString.asm)

COMMENT !
Student: Rachel Nguyen
Class: CSCI 241
Instructor: Ding
Assignment: Ch09, Replace_Char_In_String
Due Date: 4/13/21

Description:
This program replaces an existing char with a new char in a 
string in all occurrences.
!

INCLUDE Irvine32.inc

StrReplace PROTO,
	source: PTR BYTE,
	oldch: BYTE,
	newch: BYTE

GetCharInput PROTO,
	prompt: PTR BYTE

.data
BUFMAX = 128

msgString BYTE "Enter a string: ",0
buffer BYTE BUFMAX+1 DUP(0)
msgOldChar BYTE "Enter a char to be replaced (Enter key to quit): ",0
msgNewChar BYTE "Enter a new char to replace (Enter key to quit): ",0
msgNumReplaced BYTE " char(s) replaced.",0dh,0ah,0
msgResult BYTE "Now the string is: ",0

.code
main PROC
	call Clrscr

	call GetStringInput		; get test string 

	L1:
		call crlf
		INVOKE GetCharInput, ADDR msgOldChar		; get old char
		jc QUIT										; quit if enter key pressed (CF = 1)
		mov bl, al									; save old char 

		INVOKE GetCharInput, ADDR msgNewChar		; get new char
		jc QUIT										; quit if enter key pressed (CF = 1)

		INVOKE StrReplace, ADDR buffer, bl, al		; replace old char with new char
		call DisplayResult							; display result
		jmp L1										; loop until quit 

	QUIT:

	exit
main ENDP

;------------------------------------------------------------------
GetStringInput PROC
;
; Prompt user for plain text string. Saves the string
; Receives: Nothing
; Returns:  Nothing
;------------------------------------------------------------------
	
	mov edx, OFFSET msgString		; display string prompt
	call WriteString
	mov ecx, BUFMAX					; maximum character count
	mov edx, OFFSET buffer			; point to buffer
	call ReadString					; input the string
	
	ret
GetStringInput ENDP

;------------------------------------------------------------------
StrReplace PROC USES ebx, source:PTR BYTE, oldch: BYTE, newch: BYTE
;
; Replace old char with new char in the source string
; Receives: source, a text message string address
;           oldch, a char in the string to be replaced
;           newch, a new char to replace the old one
; Returns:  EAX, the number of characters to be replaced
;------------------------------------------------------------------

	mov esi, source				
	xor ebx, ebx				; # of chars replaced = 0

	L1: 
		mov al, [esi]			; load byte into AL 
		inc esi					; update location to next byte
		cmp al, 0				; end of string?
		jz DONE					; yes: quit
		cmp al, oldch			; char to replace found?
		jnz L1					; not found: load next byte
		mov al, newch			; found: replace char		
		mov [esi-1], al	
		inc ebx					; update # of replaced chars		
		jmp L1

	DONE: 
		mov eax, ebx			; return # of chars replaced in EAX
		
	ret
StrReplace ENDP

;------------------------------------------------------------------
GetCharInput PROC, prompt:PTR BYTE
;
; Get a char and check if the Enter key
; Receives: prompt, A prompt string offset asking user to enter key
; Returns:  AL, the char the user entered
;           CF=1 if the char is Enter key, else CF=0
;------------------------------------------------------------------

	clc							; clear CF
	mov edx, prompt				; display char prompt
	call WriteString
	call ReadChar				; input the char
	call WriteChar				; echo char onto screen
	call crlf
	cmp al, 0Dh					; enter key pressed?
	jnz NOENTERKEY				; no: quit
	stc							; yes: set CF = 1

	NOENTERKEY:

		ret
GetCharInput ENDP

;------------------------------------------------------------------
DisplayResult PROC
;
; Displays the number of characters replaced and the replaced string 
; result with corresponding prompts
; Receives: EAX = number of characters replaced
; Returns:  Nothing
;------------------------------------------------------------------

	call WriteDec								
	mov edx, OFFSET msgNumReplaced		; display # of chars replaced	
	call WriteString
	mov edx, OFFSET msgResult			; display replaced string prompt
	call WriteString
	mov edx, OFFSET buffer				; display replaced string result
	call WriteString
	call crlf

		ret
DisplayResult ENDP

END main