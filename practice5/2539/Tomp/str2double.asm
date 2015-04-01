global str2double
str2double:
        mov rsi, rdi
        xorps xmm0, xmm0
        xor eax, eax
        lodsb
        cmp al, '-'
        jne .integer
        or dl, MINUS
        lodsb
.integer:
        cmp al, '.'
        je .dot
        mulsd xmm0, qword [rel ten]
        sub al, '0'
        cvtsi2sd xmm1, eax
        addsd xmm0, xmm1
        lodsb
        jmp .integer
.dot:
        movsd xmm1, qword [rel one]
.frac:
        divsd xmm1, qword [rel ten]
        lodsb
        test al, al
        jz .finish
        sub al, '0'
        cvtsi2sd xmm2, eax
        mulsd xmm2, xmm1
        addsd xmm0, xmm2
        jmp .frac
.finish:
        test dl, MINUS
        jz .exit
        mulsd xmm0, qword [rel minusOne]
.exit:
        ret

section .rodata
one: dq 1.0
minusOne: dq -1.0
ten: dq 10.0

MINUS equ 1
