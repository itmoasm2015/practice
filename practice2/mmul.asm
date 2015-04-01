global squareMatrixMultply
section .text

;void squareMatrixMultply(int n, float *dst, float const *a, float const *b);
squareMatrixMultply:
    push ebp
    mov ebp, esp

    mov ecx, [ebp + 8];n
    mov ebx, [ebp + 12];dst
    mov edi, [ebp + 16];a
    mov esi, [ebp + 20];b

    mov eax, ecx
    mov edx, ecx
    shr eax, 2
    and edx, 3

    push 0
    .for1
        push 0
        .for2
            push 0
            cmp [esp], eax
            je .break

            .for3
            movups xmm0, [edi]
            mulps xmm0, [esi]
            haddps xmm0, xmm0
            haddps xmm0, xmm0
            movss [ebx], xmm0
            add edi, 4*4
            add esi, 4*4
            inc dword [esp]
            cmp [esp], eax
            jne .for3

            .break
            add esp, 4
            add ebx, 4

            ;push 0
            ;cmp [esp], edx
            ;je .break_carry
            ;.for_carry
            ;.break_carry
            ;add esp, 4
        inc dword [esp]
        cmp [esp], ecx
        jne .for2
        add esp, 4;pop

    inc dword [esp]
    cmp [esp], ecx
    jne .for1
    add esp, 4;pop

    pop ebp
    ret
