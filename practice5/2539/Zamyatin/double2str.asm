;   source: http://www.ampl.com/REFS/rounding.pdf
default rel
global double2str

section     .text

double2str:
    
    push    rbp
    push    rbx
    push    r12
    push    r13
    push    r14
    push    r15

    mov     r8, rsi
    movlps  [tmp], xmm0
    mov     rax,  [tmp]
    
    cmp     rax, 0
    jge     .no_neg
    shl     rax, 1
    shr     rax, 1
    mov     byte [r8], '-'
    inc     r8
.no_neg:
    mov     rbp, rax
    shr     rbp, 52
    cmp     rbp, (1 << 11)-1
    jz      inf_nan
    cmp     rbp, 0
    jz     denormalized

    mov     [val], rax
    mov     r9, rax
    mov     r10, rax
    shl     r9, 12
    shr     r9, 12 ; in r9 mantissa
    shr     r10, 52; in r10 exponent

    mov     [f], r9
    mov     [e], r10
    finit
    fld1
    fild     qword [f]
    fild     qword [two52]
    faddp    st1    
    fyl2x
    fild    qword [e]
    fild    qword [I075]
    fchs
    faddp   st1
    faddp   st1
    fldlg2
    fmulp   st1
    ;fld     qword [o5]
    ;fsubp  st1
    fstp    qword [tmp]
    mov     rax, [tmp]
    call    my_round_to_zero
    mov     [tmp], rax
    fld     qword [tmp]

.norm_done:

    fistp   qword [pow]
    fld     qword [ten]
    fld     qword [val]
    mov     rax, [pow]

    xor     rbx, rbx
    cmp     rax, 0
    jge     .pos_loop

.neg_loop:
    cmp   rax, 0
    jz      .finish_ten_pow
    fmul    st1
    dec     rbx
    inc     rax
    jmp     .neg_loop

.pos_loop:
    cmp     rax, 0
    jz      .finish_ten_pow
    fdiv    st1
    inc     rbx
    dec     rax
    jmp     .pos_loop

.finish_ten_pow:

    inc     rbx

    fstp    qword [f]
    mov     r15, [f]
    mov     r14, [f]
    shl     r15, 12
    shr     r15, 12
    shr     r14, 52

    mov     [f], r15
    mov     [e], r14

    mov     r12, 1
    shl     r12, 52
    mov     r10, [f]
    add     r10, r12
    
    mov     r11, [e]
    neg     r11
    add     r11, 1075
    mov     r12, 1
    mov     cl, r11b
    shl     r12, cl
    mov     r11, r12    
    
    ; r11 exp
    ; r10 man

    mov     byte [r8], '0'
    inc     r8
    mov     byte [r8], '.'
    inc     r8
    mov     r9, 14

    mov     rax, r10
    mov     rdx, 0

    mov     r10, 10
    mov     r15, 13 ; n

    mov     rsi, 1
    xchg    rsi, rax


.ten_loop:
    cmp     r15, 0
    jz      .finish_ten
    dec     r15
    mul     r10
    jmp     .ten_loop

.finish_ten:
    xchg    rsi, rax

.while:
    mov     rdx, 0
    mov     [r8], rdx

    push    r11
    push    rax
    call    check_cond
    mov     rax, [rsp]
    add     rsp, 16

    mov     rdx, 0    
    div     r11
    add     al, '0'
    add     byte [r8], al
    inc     r8
    
    cmp     rcx, 1
    jz      handle_ex

    mov     rax, rdx
    mul     r10
    dec     r9
    
    xchg    rsi, rax
    div     r10
    xchg    rsi, rax

    jnz     .while


; let write exponent
handle_ex:
    mov     byte [r8], 'e'
    inc     r8
    cmp     rbx, 0
    jge      .no_neg
    mov     byte [r8], '-'
    inc     r8
    neg     rbx
.no_neg:
    mov     rax, rbx
    mov     r10, 10
    mov     r9, 0

.loop:
    mov     rdx, 0
    div     r10
    add     dl, '0'
    push    rdx
    inc     r9
    cmp     rax, 0
    jg      .loop

.while:
    cmp     r9, 0
    jle     finish
    pop     rax
    mov     byte [r8], al
    dec     r9
    inc     r8
    jmp     .while

finish:

    mov    byte [r8], 0
    pop    r15
    pop    r14
    pop    r13
    pop    r12
    pop    rbx
    pop    rbp
    
    ret

; inf in rax
inf_nan:
    shl     rax, 12
    shr     rax, 12
    cmp     rax, 0
    jg      .nan
    cmp     byte [r8-1], '-'
    jz      .minus
    mov     byte [r8], '+'
    inc     r8  

.minus
    mov     byte [r8], 'i'
    mov     byte [r8+1], 'n'
    mov     byte [r8+2], 'f'
    add     r8, 3
    jmp     finish
.nan
    cmp     byte [r8-1], '-'
    jnz     .not_minus
    dec     r8
.not_minus
    mov     byte [r8], 'n'
    mov     byte [r8+1], 'a'
    mov     byte [r8+2], 'n'
    add     r8, 3
    jmp     finish

denormalized:
    mov     byte [r8], '0'
    inc     r8
    jmp     finish

; at top stack -- n
; at top stack -- b
; next on stack -- s
; r8 -- out pointer
; need break? -> rcx
; in r10 10
; r12 - r14 can be changed, rdx
; in rsi power of 10

check_cond:

    mov     r12, rsi ; r12 = ten
    mov     rax, [rsp + 16]
    mov     r13, 5
    mul     r13
    mov     r13, rax; r13 = s5

    mov     rax, [rsp+8]
    mov     r14, [rsp+16]
    mov     rdx, 0
    div     r14
    mov     r14, rdx ; r14 = b%s
    
    mov     rax, r13
    mov     rdx, 0
    div     r12

    cmp     r14, rax ; rax = s5/ten
    jl      .make_ans0
    jnz     .no_ans
    cmp     rdx, 0
    jg      .make_ans0
    jmp     .no_ans
    
.no_ans:
    mov     rcx,    [rsp + 16]
    sub     rcx,    r14
    cmp     rax,    rcx
    jg      .make_ans1

    jz      .try_one_else
    mov     rcx, 0
    ret

.try_one_else:
    cmp     rdx, 0 ; s5%ten in rdx
    jg      .make_ans1
    mov     rcx, 0
    ret
    
.make_ans0:
    mov     rcx, 1
    ret

.make_ans1:
    mov     rcx, 1
    add     [r8], rcx
    ret


; in rax double that should be rounded
; ans in rax

my_round_to_zero:
    push    r10
    push    r11
    push    rcx
    push    r12
    
    mov     r12, rax

    mov     r10, rax
    shl     r10, 1
    shr     r10, 53
    sub     r10, 1075
    cmp     r10, 0
    jge     .finish

    cmp     r10, -52
    jl      .zero
    neg     r10
    mov     r11, 1
    mov     cl, r10b
    shl     r11, cl
    neg     r11
    and     rax, r11
    jmp     .finish
.zero:
    mov     rax, [zero]
.finish:
    cmp     r12, 0
    jge     .equal
    cmp     rax, r12
    jz      .equal
    mov     qword [tmp], rax
    fld     qword [tmp]
    fld1
    fsubp  st1
    fstp    qword [tmp]
    fwait 
    mov     rax, [tmp]
.equal
    pop     r12
    pop     rcx
    pop     r11
    pop     r10
    ret


section .data
ten:    dq      10.0
msg:    db     '%lf', 10, 0
msg1:   db     '!!!', 10, 0
msgd:   db     '%lld', 10, 0
iten:   dq      10
two52:  dq      1 << 52
I075:   dq      1075
o5:     dq      0.5
n:      dq      13
zero:   dq      0.0


section .bss
e:   resq    1
f:   resq    1
val: resq    1
pow: resq    1
tmp: resq    1





