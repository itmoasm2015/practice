default rel
global str2double
section .text

str2double:
    cmp byte [rdi], '-'
    mov rsi, 1
    jne .not_minus
    mov rsi, -1
    inc rdi
    .not_minus

    xorpd xmm0, xmm0
    cmp byte [rdi], '.'
    je .point
    .loop
        mulsd xmm0, [ten]
        xor rax, rax
        mov byte al, [rdi]
        sub al, '0'
        cvtsi2sd xmm1, rax
        addsd xmm0, xmm1
        inc rdi
        cmp byte [rdi], '.'
        jne .loop
    .point
    inc rdi
    movsd xmm1, [invTen]
    .loop1
        xor rax, rax
        mov byte al, [rdi]
        sub al, '0'
        cvtsi2sd xmm2, rax
        mulsd xmm2, xmm1
        addsd xmm0, xmm2
        mulsd xmm1, [invTen]
        inc rdi
        cmp byte [rdi], 0
        jne .loop1
    cvtsi2sd xmm2, rsi
    mulsd xmm0, xmm2
    ret 
.data
    ten dq 10.0
    invTen dq 0.1
