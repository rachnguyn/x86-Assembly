TITLE Prime_Check_with_CPP_ASM_Mixed (Chapter 13, Pr 5, Modified)        (AsmPrimeCheck.asm)

; Student: Rachel Nguyen
; Class: CSCI 241
; Instructor: Ding
; Assignment: Ch13, Prime_Check_with_CPP_ASM_Mixed 
; Due Date: 5/18/21

; Description:
; This program lets the user input numbers repeatedly to display a message for each one 
; indicating whether it is prime or not until -1 entered. It mixes both CPP and ASM.


.model flat, C

intSqrt PROTO,
    n: DWORD

.code

;--------------------------------------------------
isPrimeASM PROC, intVal:DWORD
; Accepts an integer and checks if it is prime
; Receives: intVal = integer
; Returns: EAX = returns true (1) if prime
;	             returns false (0) if nonprime
;--------------------------------------------------

    mov esi, 0               ; ret = false

    ; if (intVal >= 2)
    cmp intVal, 2
    jl quit                  ; no: quit
    INVOKE intSqrt, intVal   ; get sqrt intVal
    mov ecx, eax             ; save sqrt intVal
    cmp ecx, 2               ; 2 <= sqrt intVal? 
    jl L2                    ; no: skip
    mov eax, intVal          
    shr eax, 1               ; yes: check intVal % 2
    jnc quit                 ; rem = 0? yes: quit
    mov ebx, 3               ; no: set divisor to loop

    L1:
        cmp ebx, ecx       ; divisor <= sqrt intVal?
        jg L2              ; no: skip
        mov eax, intVal    ; high dividend 
        xor edx, edx       ; clear low dividend
        div ebx            ; intVal % divisor (edx = remainder)
        cmp edx, 0         ; rem = 0?
        jz quit            ; yes: quit
        add ebx, 2         ; no: next odd divisor
        jmp L1             

    L2:
        mov esi, 1         ; ret = true 

    quit:
        mov eax, esi       ; return eax (t/f)
        ret
isPrimeASM ENDP
END 