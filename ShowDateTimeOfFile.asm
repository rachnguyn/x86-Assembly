TITLE Show_Date_Time_of_File (Chapter 11, Pr 9)	(ShowDateTimeOfFile.asm)

COMMENT !
Student: Rachel Nguyen
Class: CSCI 241
Instructor: Ding
Assignment: Ch11, Show_Date_Time_of_File
Due Date: 5/6/21

Description:
This program date/time stamps a file. 
!

INCLUDE Irvine32.inc
INCLUDE Macros.inc
WIN32API = 1

WriteDateTime PROTO, 
	datetimeAddr: PTR SYSTEMTIME,

SystemTimeToTzSpecificLocalTime PROTO, 
	TIME_ZONE_INFORMATION: DWORD,
	UniversalTime: PTR SYSTEMTIME,
	LocalTime: PTR SYSTEMTIME

.data
fileName BYTE 80 DUP (0)
sysTimeCreated SYSTEMTIME <>
sysTimeLastWritten SYSTEMTIME <>

.code
main PROC

	mWrite "Enter an input filename: "					; let user enter file name
	mov edx, OFFSET fileName 
	mov ecx, SIZEOF fileName - 1 
	call ReadString

	mov	esi, OFFSET sysTimeCreated
	mov	edi, OFFSET sysTimeLastWritten
	call AccessFileDateTime								; fill SYSTEMTIME structures with date/time stamps of file
    jnc next											; error? no: skip
	call WriteWindowsMsg								; yes: display error message, quit
	jmp quit

next:
	mov edx, OFFSET fileName							
	call WriteString
	mWrite " was created on: "
	INVOKE WriteDateTime, ADDR sysTimeCreated			; print creation date/time
	mWrite "And it was last written on: "
	INVOKE WriteDateTime, ADDR sysTimeLastWritten		; print last written date/time
	jmp quit

quit:
	call WaitMsg

	exit
main ENDP

;-----------------------------------------------------------------------
AccessFileDateTime PROC 
LOCAL whenCreated: FILETIME, lastWritten: FILETIME, fileHandle: HANDLE
; Receives: EDX offset of filename,
;           ESI points to a SYSTEMTIME structure of sysTimeCreated
;           EDI points to a SYSTEMTIME structure of sysTimeLastWritten
; Returns: If successful, CF=0 and two SYSTEMTIME structures contain the file's date/time data.
;          If it fails, CF=1.
;-----------------------------------------------------------------------

	call OpenInputFile							; open file
	mov fileHandle, eax

	cmp eax, INVALID_HANDLE_VALUE				; error? 
	jne file_ok									; no: skip
	stc											; yes: CF = 1, quit
	jmp quit

file_ok:
	INVOKE GetFileTime, fileHandle, ADDR whenCreated, NULL, ADDR lastWritten		; get date/time stamps of file
	INVOKE FileTimeToSystemTime, ADDR whenCreated, esi								; convert FILETIME to SYSTEMTIME
	INVOKE FileTimeToSystemTime, ADDR lastWritten, edi
	mov eax, fileHandle																; close file
	call CloseFile

	INVOKE SystemTimeToTzSpecificLocalTime, NULL, esi, ADDR sysTimeCreated			; convert UTC system time to local time
	INVOKE SystemTimeToTzSpecificLocalTime, NULL, edi, ADDR sysTimeLastWritten

quit:
	ret
AccessFileDateTime ENDP

;-----------------------------------------------------------------------
WriteDateTime PROC datetimeAddr: PTR SYSTEMTIME
; Prints out the local date/time when a particular file was created and last 
; written, such as sysTime's wMonth, wDay, until wSecond. 
; Receives: datetimeAddr = PTR to a SYSTEMTIME struct
; Returns: nothing.
;-----------------------------------------------------------------------

	mov esi, datetimeAddr

	mov ax, (SYSTEMTIME PTR [esi]).wMonth			; display month
	call WriteDec
	mWrite "/"
	mov ax, (SYSTEMTIME PTR [esi]).wDay				; display day
	call WriteDec
	mWrite "/"
	mov ax, (SYSTEMTIME PTR [esi]).wYear			; display year
	call WriteDec
	mWrite " "
	mov ax, (SYSTEMTIME PTR [esi]).wHour			; display hour
	.IF ax > 12										; past 12 hrs? convert to 12-hour clock
		sub ax, 12
		xor ebx, ebx								; set ebx = 0
	.ENDIF
	.IF ax < 10										; single digit? add prefix '0'
		mWrite "0"
	.ENDIF
	call WriteDec
	mWrite ":"
	mov ax, (SYSTEMTIME PTR [esi]).wMinute			; display minutes
	.IF ax < 10										; single digit? add prefix '0'
		mWrite "0"
	.ENDIF
	call WriteDec
	mWrite ":"
	mov ax, (SYSTEMTIME PTR [esi]).wSecond			; display seconds
	.IF ax < 10										; single digit? add prefix '0'
		mWrite "0"
	.ENDIF
	call WriteDec
	.IF ebx == 0									; if past 12 hrs, append PM
		mWrite " PM"
	.ELSE											; else, append AM
		mWrite " AM"
	.ENDIF
	call crlf

	ret
WriteDateTime ENDP

END MAIN