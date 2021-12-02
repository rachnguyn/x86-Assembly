TITLE Multiple_Byte_Key_Encryption				(main.asm)

COMMENT !
Student: Rachel Nguyen
Class: CSCI 241
Instructor: Ding
Assignment: Ch05, Multiple_Byte_Key_Encryption
Due Date: 3/11/21

Description:
This program demonstrates simple Symmetric-key Encryption using 
the XOR instruction with a multi-byte key entered by the user.
!

INCLUDE Irvine32.inc

.data
BUFMAX = 128

prompt1  BYTE  "Enter the plain text: ",0
prompt2  BYTE  "Enter the encryption key: ",0
sEncrypt BYTE  "Cipher text:         ",0
sDecrypt BYTE  "Decrypted:           ",0

keyStr   BYTE   BUFMAX+1 DUP(0)
keySize  DWORD  ?
buffer   BYTE   BUFMAX+1 DUP(0)
bufSize  DWORD  ?

.code
main PROC
      mov edx,OFFSET prompt1  ; display plain text prompt
      mov ebx,OFFSET buffer   ; point to the buffer
      call InputTheString
      mov bufSize,eax         ; save the buffer length

      mov edx,OFFSET prompt2  ; display key prompt
      mov ebx,OFFSET keyStr   ; point to the key
      call InputTheString
      mov keySize,eax         ; save the key length

      call TranslateBuffer    ; encrypt buffer

      mov edx, OFFSET sEncrypt      ; display cipher prompt
      call WriteString      
      mov edx, OFFSET buffer        ; display ciphered text
      call WriteString  
      call crlf
      call crlf

      call TranslateBuffer          ; decrypt buffer

      mov edx, OFFSET sDecrypt      ; display decrypt prompt
      call WriteString
      mov edx, OFFSET buffer        ; display decrypted text
      call WriteString
      call crlf

	exit
main ENDP

;------------------------------------------------------
InputTheString PROC
; Prompt user for plain text string. Saves the string
; and its length. 
; Receives: Nothing
; Returns: Nothing
;------------------------------------------------------

    call WriteString
    mov ecx, BUFMAX          ; maximum character count
    mov edx, ebx            
    call ReadString          ; input the string, returns size in EAX
    call crlf

    ret
InputTheString ENDP

;------------------------------------------------------
TranslateBuffer PROC
; Translates the string by exclusive-ORing each byte
; with the eyncryption key byte.
; Receives: Nothing
; Returns: Nothing
;------------------------------------------------------

    mov ecx, bufSize        ; loop counter
    xor esi, esi            ; index 0 in buffer
    xor edi, edi            ; index 0 in keyStr

    L1:
        mov al, keyStr[edi]     
        xor buffer[esi], al     ; translate a byte
        inc esi                 ; update next char in message
        inc edi                 ; point to next keyStr byte
        cmp keyStr[edi], 0      ; check for null terminator in keyStr 
        jnz next                 ; if not, jump to next
        xor edi, edi            ; if yes, reset keyStr index
   next:
        loop L1

    ret
TranslateBuffer ENDP

END main