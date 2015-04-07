;default rel

extern printf

global str2double

%define set_flag(x)     or r8, x
%define test_flag(x)    test r8, x
%assign minus_flag      1 << 1

section .data
FORMAT1:    db '%d', 10, 0
divider:    dq 0.1

section .text

;double str2double(char const * s)
;
;Parameters:
;   RDI - address of string
;Returns:
;   xmm0 - double value
str2double:
    xor     rax, rax ;cur char
    xor     r8, r8   ;flag minus?
    xor     r9, r9   ;high
    xor     r10, r10 ;low
    xor     rcx, rcx ;number of chars in low part
    mov     byte al, [rdi]
    cmp     byte al, '-'
    jne     .not_minus
    set_flag(minus_flag)
    inc     rdi
.not_minus:

.loop_high:
    mov     byte al, [rdi]
    cmp     byte al, '0'
    jnge    .end_loop_high
    cmp     byte al, '9'
    jnle    .end_loop_high
    sub     byte al, '0'
    lea     r9, [r9 + r9 * 4]
    shl     r9, 1
    add     r9, rax
    inc     rdi
    jmp     .loop_high
    
.end_loop_high:
    cmp     byte al, 0
    je      .end_parsing
    cmp     byte al, '.'
    jne     .end_parsing
    inc     rdi
.loop_low:
    mov     byte al, [rdi]
    cmp     byte al, '0'
    jnge    .end_parsing
    cmp     byte al, '9'
    jnle    .end_parsing
    sub     byte al, '0'
    lea     r10, [r10 + r10 * 4]
    shl     r10, 1
    add     r10, rax
    inc     rcx
    inc     rdi
    jmp     .loop_low

.end_parsing:
    ;;r8 - minus flag?
    ;;r9 - high part
    ;;r10 - low part
    xorpd   xmm0, xmm0 ;result
    xorpd   xmm1, xmm1

    cvtsi2sd xmm0, r9 ;load high part
    cvtsi2sd xmm1, r10 ;divide low part on 10 rcx times 

.loop_divide_low:
    cmp     rcx, 0
    je      .almost_return
    dec     rcx
    mulsd   xmm1, [divider]
    jmp     .loop_divide_low
            
.almost_return:
    addsd   xmm0, xmm1      ;result = high + low * 10^(rcx)
    test_flag(minus_flag)
    jz      .not_negative
    xorpd   xmm2, xmm2
    mov     rcx, -1
    cvtsi2sd xmm2, rcx
    mulsd   xmm0, xmm2    

.not_negative:
    ret

