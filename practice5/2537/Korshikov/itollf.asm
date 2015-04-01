global str2double

%macro read_symbool 0
    mov al, [rsi]               ;read symbol
    inc rsi
%endmacro




%assign     FLAG_PRINT_SIGN                         01h
%assign     TEN                                     10
%assign     ONE                                     1
%assign     NEGATIVE_ONE                            -1
%assign     ZERO                                    0


;rsi  - now position at str registr
;xmm0 - result registr
;rax.al - now symbol registr
;rdx - flaf registr

str2double:
        push rbp
        push rbx
        push r12
        push r13
        push r14
        push r15
        mov rsi, rdi                ;now position
        xorps xmm0, xmm0            ;set 0 to xmm0
        xor rax, rax                ;set 0 to rax
        read_symbool
        cmp al, '-'
        jne .natural_dec
        or rdx, FLAG_PRINT_SIGN
        read_symbool


.natural_dec:
        cmp al, '.'
        je .dot
        mov r8, TEN
        cvtsi2sd xmm3, r8
        mulsd xmm0, xmm3
        sub al, '0'
        cvtsi2sd xmm1, eax
        addsd xmm0, xmm1
        read_symbool
        jmp .natural_dec
.dot:
        mov r8, ONE
        cvtsi2sd xmm3, r8
        movsd xmm1, xmm3


.real_number:
        read_symbool
        cmp al, ZERO
        je .end_of_string
        mov r8, TEN
        cvtsi2sd xmm3, r8
        divsd xmm1, xmm3
        sub al, '0'
        cvtsi2sd xmm2, eax
        mulsd xmm2, xmm1
        addsd xmm0, xmm2
        jmp .real_number
.end_of_string:
        test rdx, FLAG_PRINT_SIGN
        jz .return
        mov r8, NEGATIVE_ONE
        cvtsi2sd xmm3, r8
        mulsd xmm0, xmm3
.return:
        pop r15
        pop r14
        pop r13
        pop r12
        pop rbx
        pop rbp
        ret
