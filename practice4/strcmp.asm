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
        mov edi, [ebp+.s1]
        cld
        xor ecx, ecx
        not ecx
        mov edx, ecx
        xor eax, eax
        repnz scasb
        ; esi - [esp+12] = ~0 - ecx = strlen(s1)
        sub edx, ecx ; edx = strlen(s1)
        
        mov edi, [ebp+.s2]
        xor ecx, ecx
        not ecx
        mov esi, ecx
        repnz scasb
        sub esi, ecx ; esi = strlen(s2)
        mov ecx, esi
        cmp ecx, edx
        cmovg ecx, edx ; ecx = min(strlen(s1), strlen(s2))
        
        mov eax, esi ; eax = strlen(s2)
        mov esi, [ebp+.s1]
        mov edi, [ebp+.s2]
        repe cmpsb
        ; Z=1 -> at the end of string
        ; Z=0 -> char mismatch
        ja .retg
        jb .retb

        cmp edx, eax ; strlen(s1) ? strlen(s2)
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
