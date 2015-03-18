global pr_strcmp
section .text
    ; int pr_strcmp(char const *s1, char const *s2);
    pr_strcmp:
        push ebp
        mov  ebp, esp
        push esi
        push edi
        ; ebp + 4 -- return address
        ; ebp + 8 -- s1
        ; ebp + 12 -- s2
        .s1 equ 8
        .s2 equ 12

        mov esi, [ebp + 8]
        mov edi, [ebp + 12]
        xor eax, eax
.loop:  cmp al, [esi]
        jz .endloop
        cmp al, [edi]
        jz .endloop
        cmpsb
        je  .loop
        dec edi
        dec esi
.endloop:
        mov eax, [edi]
        cmp [esi], eax
        ja .retg
        jb .retb
    
.ret0:  mov eax, 0
        jmp .return
.retb:  mov eax, -1
        jmp .return
.retg:  mov eax, 1
.return:
        pop edi
        pop esi
        pop ebp
        ret

; g++-multilib
