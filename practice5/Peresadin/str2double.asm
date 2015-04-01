default rel
global str2double
global double2str

section .text
SIGN_BIT equ 1<<11
MANT_BIT equ 1<<52

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

;xmm0 - x
;rdi - s
double2str:
    movlps [num], xmm0
    mov rax, [num]
    shr rax, 52
    test rax, SIGN_BIT
    jz .plus
        mov rsi, SIGN_BIT
        dec rsi
        and rax, rsi
        mov byte [rdi], '-'
        inc rdi
        jmp .sign_done
    .plus
        mov byte [rdi], '+'
        inc rdi
    .sign_done
    sub rax, 1022

    movlps [num], xmm0
    mov rsi, [num]
    mov r8, MANT_BIT
    dec r8
    and rsi, r8
    mov byte [rdi], '0'
    inc rdi

    mov byte [rdi], '.'
    inc rdi

    mov byte [rdi], '1'
    inc rdi

    call print_chars

    xchg rsi, rax
    cmp rsi, 0
    ja .positive
        imul rsi, -1
    .positive
    
    mov byte [rdi], 'e'
    inc rdi

    call print_chars
    mov byte [rdi], 0
    ret

print_chars:
    push rax
    xor rcx, rcx
    mov rax, rsi
    mov rsi, 10
    .loop_div
        xor rdx, rdx
        div rsi
        add rdx, '0'
        mov [tmp + rcx], rdx
        inc rcx
        cmp rax, 0
        ja .loop_div
     dec rcx
    .loop_rev
        mov rax, [tmp + rcx]
        mov [rdi], rax
        inc rdi
        dec rcx
        cmp rcx, -1
        jne .loop_rev
    pop rax
    ret

section .data
    ten dq 10.0
    invTen dq 0.1
    num dq 0
section .bss
    tmp: resb 100
