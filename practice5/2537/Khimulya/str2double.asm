section .text

global str2double

; double str2double(char const *s);
;
; @param rdi string to be proceed

str2double:
        push rbp                    ; cdecl routine
        push rbx
        push r12
        push r13
        push r14
        push r15

        mov r13, rdi

        xorps xmm0, xmm0
        xor rdx, rdx
        mov dl, byte [rdi]
        cmp rdx, '-'
        jne .proceed_fraction
        inc rdi

    .proceed_fraction:
        xor rbx, rbx
        mov r10, 4503599627370495   ; 2 ** 52 - 1
        mov r12, 10
        xor r11, r11                ; number of digits after '.' + 1
        xor rax, rax
        xor rcx, rcx
    .loop:                          ; loop until '\0' is reached or rbx >= 2 ** 52 - 1 (max value of fraction)
        mov cl, byte [rdi]
        inc rdi
        cmp rcx, 0
        je .done_fraction
        cmp rcx, '.'                ; omit '.'
        je .fraction_begin
        test r11, r11
        jz .add_digit
        inc r11
    .add_digit:
        sub rcx, '0'
        mul r12
        add rax, rcx
        cmp rax, r10
        jl .loop
    .fraction_begin:                ; set r11 to 1
        mov r11, 1                  ; r11 incremetns only when it's not zero
        jmp .loop
    .done_fraction:                 ; store fraction
        cvtsi2sd xmm0, rax

        dec r11
        mov r9, 10
        cvtsi2sd xmm1, r9
    .loop1:
        divsd xmm0, xmm1
        dec r11
        jnz .loop1

        xor rdx, rdx
        mov dl, byte [r13]
        cmp rdx, '-'
        jne .done
        movsd xmm1, xmm0            ; negate
        subsd xmm0, xmm1
        subsd xmm0, xmm1

    .done:
        pop r15                     ; cdecl routine
        pop r14
        pop r13
        pop r12
        pop rbx
        pop rbp
        ret
