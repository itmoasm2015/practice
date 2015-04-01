default rel

global str2double

str2double:
    xor      eax, eax
    xorps xmm0, xmm0
    movsd    xmm3, qword [one]
    xor      edx, edx
    movsd    xmm2, qword [one]
    cmp      [rdi], byte '-'
    jne      .integer
    inc      rdi
    movsd    xmm3, qword [minusone]
.integer
    mov      al, [rdi]
    inc      rdi
    cmp      al, '.'
    je       .fractional
    test     al, al
    jz       .return
    sub      al, '0'
    cvtsi2sd xmm1, eax
    mulsd    xmm0, qword [ten]
    addsd    xmm0, xmm1
    cmp      al, 0
    jmp      .integer
.fractional
    divsd    xmm2, qword [ten]
    mov      al, [rdi]
    inc      rdi
    test     al, al
    jz       .return
    sub      al, '0'
    cvtsi2sd xmm1, eax
    mulsd    xmm1, xmm2
    addsd    xmm0, xmm1
    jmp      .fractional
.return
    mulsd    xmm0, xmm3
    ret

section .rodata
one: dq 1.0
ten: dq 10.0
minusone: dq -1.0

