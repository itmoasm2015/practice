default rel
global str2double
section .data
_1 dq 10.0
_2 dq -1.0

section .text

IS_NEGATIVE_FLAG equ 1<<1

%define setf(f) or ecx, f
%define testf(f) test ecx, f

; rdi - pointer to str
; xmm0 - float number
str2double:
    push rcx
    push rdx
    push rdi
    push rbx

    xor ecx, ecx
    ; xorpd xmm2, xmm2
    ; movd xmm2, 10

    xorpd xmm0, xmm0
    cmp byte [rdi], '-'
    jne .continue_parse

    setf(IS_NEGATIVE_FLAG)
    inc rdi

.continue_parse:
    cmp byte [rdi], '.'
    je .float_parse_start

    mov bl, byte [rdi]
    inc rdi
    sub bl, '0'
    cvtsi2sd xmm1, rbx
    mulsd xmm0, [_1]
    addsd xmm0, xmm1
    xorpd xmm1, xmm1
    jmp .continue_parse

.float_parse_start:
    cmp byte [rdi], 0
    je .float_parse_c
    inc rdi
    jmp .float_parse_start

.float_parse_c:
    dec rdi
    xorpd xmm2, xmm2
    cmp byte [rdi], '.'
    je .end_parse
    mov bl, byte [rdi]
    sub bl, '0'
    cvtsi2sd xmm2, rbx
    divsd xmm1, [_1]
    addsd xmm1, xmm2
    jmp .float_parse_c

.end_parse:
    divsd xmm1, [_1]
    addsd xmm0, xmm1

    testf(IS_NEGATIVE_FLAG)
    jz .positive
    mulsd xmm0, [_2]

.positive:

    pop rbx
    pop rdi
    pop rdx
    pop rcx
    ret
