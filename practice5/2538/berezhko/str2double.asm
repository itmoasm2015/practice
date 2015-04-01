default rel;

section .text

global str2double
extern printf
; rdi - s
; xmm0 - res
str2double:
    xor r10, r10 ; r10 - '.' was detected
    xor r11, r11 ; r11 - '-' at the start was detected

    xorps xmm5, xmm5 ; xmm5=0

    movsd xmm7, [d1]; xmm7 = 1, xmm7 - power of 10

    cmp byte[rdi], '-'
    jne .loop

    inc rdi
    mov r11, 1


    .loop:
        cmp byte[rdi], 0
        je .overit

        cmp byte[rdi], '.'
        je .setcomaflag

        cmp r10, 1
        je .impl2

    .impl1:
        xor rax, rax
        mov al, byte[rdi]
        sub al, '0'
        cvtsi2sd xmm1, rax
        mulsd xmm5, [d10]
        addsd xmm5, xmm1
        jmp .nextstep
    .impl2:
        mulsd xmm7, [d10]

        xor rax, rax
        mov al, byte[rdi]
        sub al, '0'
        cvtsi2sd xmm1, rax
        divsd xmm1, xmm7

        addsd xmm5, xmm1
        jmp .nextstep
    .setcomaflag:
        mov r10, 1
        jmp .nextstep
    .nextstep:
        inc rdi
        jmp .loop
    .overit:

    movsd xmm0, xmm5

    cmp r11, 1
    jne .return

    mulsd xmm0, [dm1]

    .return
    ret

section .rodata
d10: dq 10.0
d1: dq 1.0
dm1: dq -1.0



