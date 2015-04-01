global main

extern printf
extern scanf

section .text

; int main()
; Read two doubles and print their sum.
main:
    ; print prompt
    push    fmtPrompt
    call    printf
    add     esp, 4

    ; read X and Y
    push    dblY
    push    dblX
    push    fmtIn
    call    scanf
    add     esp, 12

    ; add X and Y into ST0
    fld     qword [dblY]
    fld     qword [dblX]
    fyl2x
    fld1
    fscale
  
    ; print the result
    sub     esp, 8
    fstp    qword [esp]
    push    fmtOut
    call    printf
    add     esp, 12

    ; return 0
    xor     eax, eax
    ret

section .data
fmtPrompt:  db 'Enter X and Y: ', 0
fmtIn:      db '%lf%lf', 0
fmtOut:     db 'X ^ Y is %f', 10, 0

section .bss
dblX:       resq 1
dblY:       resq 1
