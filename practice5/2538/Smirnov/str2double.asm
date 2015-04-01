global str2double

section .bss

section .text
;rdi - pointer to char
;xmm0 - result
str2double:       
    ; r8 multiplier for negative/positive
    mov     r8, 1
    cmp     byte[rdi], '-'
    jne     .positive
    inc     rdi
    mov     r8, -1
    .positive

    mov     r9, 10

    xor     rax, rax
    xor     rcx, rcx
    .next_number:
        mov     cl, [rdi]
        inc     rdi
        cmp     cl, '.'
        je      .break        
        sub     cl, '0'
        mul     r9
        add     rax, rcx        
    jmp     .next_number

    .break:

    cvtsi2sd xmm0, rax    

    xor     rax, rax
    xor     rcx, rcx
    mov     r10, 1

    .next_number2:
        mov     cl, [rdi]
        inc     rdi        
        cmp     cl, 0
        je      .break2        
        sub     cl, '0'
        mul     r9
        add     rax, rcx
        
        push    rax      
        mov     rax, r10
        mul     r9
        mov     r10, rax
        pop     rax
    jmp .next_number2

    .break2:
        cvtsi2sd    xmm1, rax
        cvtsi2sd    xmm2, r10
        divsd   xmm1, xmm2
    

    addsd   xmm0, xmm1

    cvtsi2sd    xmm1, r8
    mulsd       xmm0, xmm1

ret