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
<<<<<<< HEAD
    fyl2x
    fld1
    fscale
  
    ; print the result
    sub     esp, 8
=======
    ;faddp   st1
    call pow 

>>>>>>> a0fd4b47407bd8bfb69c69a6726d768672278543
    fstp    qword [esp]
    push    fmtOut
    call    printf
    add     esp, 12

    ; return 0
    xor     eax, eax
    ret

<<<<<<< HEAD
section .data
fmtPrompt:  db 'Enter X and Y: ', 0
fmtIn:      db '%lf%lf', 0
fmtOut:     db 'X ^ Y is %f', 10, 0
=======
pow:
    fyl2x
    ftst
    fstsw ax
    fwait
    sahf
    fld1
    fscale
    fxch
    jae .st0positive
    jb  .st0negative
    .st0positive
        fsub qword [shift]
        fist dword [intNum]
        fadd qword [shift]
        fisub dword [intNum]
        jmp .done

    .st0negative
        fadd qword [shift]
        fist dword [intNum]
        fsub qword [shift]
        fisub dword [intNum]
        jmp .done
    .done
>>>>>>> a0fd4b47407bd8bfb69c69a6726d768672278543

    ;sub esp, 8
    ;fst qword [esp]
    ;push double
    ;call printf
    ;add esp, 12

    f2xm1
    fld1
    faddp st1
    fmul st1
    ret

section .data
    fmtPrompt:  db 'Enter X and Y: ', 0
    fmtIn:      db '%lf%lf', 0
    fmtOut:     db 'X^Y is %f', 10, 0
    fmt2Pow:    db '2 in pow eq %lf', 10, 0
    format:     db 'exp = %lf mant = %lf\n', 0
    format2:    db 'int num = %d', 10, 0
    shift:      dq 0.4999999999999
    here:       db 'here', 10, 0
    double:     db 'num = %lf', 10, 0
section .bss
    dblX:       resq 1
    dblY:       resq 1
    intNum:     resd 1
