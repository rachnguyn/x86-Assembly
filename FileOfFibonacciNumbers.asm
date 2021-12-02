TITLE Chapter 5 Exercise 10              (File_of_Fibonacci_Numbers_stub.asm)

COMMENT @
Student: Rachel Nguyen
Class: CSCI 241
Instructor: Ding
Assignment: Ch05, File_Of_Fibonacci_Numbers
Due Date: 2/25/21

Description:
This program generates the first 47 values in the Fibonacci series,
stores them in an array of doublewords, and writes the dword array
to a disk file.
@

INCLUDE Irvine32.inc

FIB_COUNT = 47	; number of values to generate

.data
BUFFERSIZE = 188
fileHandle DWORD ?
filename BYTE "fibonacci.bin",0
array DWORD FIB_COUNT DUP(?)

.code
main2sub PROC

; Generate the array of fib values
   ; Prepare your ESI and ECX
    mov   ecx, FIB_COUNT				; set loop count
	mov   esi, OFFSET array				; set array index
	call generate_Fibonacci				; Calling generateFibonacci

; Create the file, call CreateOutputFile
    mov edx, OFFSET filename			; offset of filename into EDX to call CreateOutputFile
	call CreateOutputFile				; returns valid file handle in EAX

; Write the array to the file, call WriteToFile
	mov filehandle, eax					; save file handle in EAX to filehandle before it is overwritten
    mov edx, OFFSET array				; offset of buffer
	mov ecx, BUFFERSIZE					; max # of bytes to write
	call WriteToFile					; if CF = 0, EAX contains # of bytes written (188). if CF = 1, error. 

; Close the file, call CloseFile
	mov eax, fileHandle					; update eax to contain open file handle
	call CloseFile						; EAX is nonzero if successfully closed 

   exit
main2sub ENDP

;------------------------------------------------------------
generate_fibonacci PROC USES eax ebx ecx edx
;
; Generates fibonacci values and stores in an array.
; Receives: ESI points to the array,
;           ECX = count
; Returns: nothing
;------------------------------------------------------------

   	mov   eax, 1						; fibonacci setup
	mov   ebx, 0
	mov   edx, 0

	L1:
			call WriteDec					  ; print EAX (holding fibonacci number) to console 
			call Crlf						  ; go to next output line
			mov  [esi], eax					  ; save to array
			mov  edx, eax
			add  eax, ebx
			mov  ebx, edx
			add  esi, TYPE DWORD			  ; increment array address
			Loop L1

   ret
generate_fibonacci ENDP

END main2sub