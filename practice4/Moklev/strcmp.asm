global pr_strcmp
section .text

    ; int pr_strcmp(char const *s1, char const *s2);

; # Very-very-very-very high performance was just a bug,
;   my strcmp compares only first 16 bytes, I swap two
;   lines of code and it becomes correct, but only a bit
;   faster, than std::strcmp
    pr_strcmp:

    sub rsi, 16
    sub rdi, 16

.loop:
    add rsi, 16
    add rdi, 16
    movdqu xmm0, dqword [rsi] ; load 16 symbols to xmm0
    ; # pcmpistri second_str first_str imm
    ; # imm ( the immediate operand) -- mode of pcmpistri
    ; # 1000 + 10000 -- "equal each" + "negative polarity"
    ;   Compares two arguments as strings and returns to rcx 
    ;   index of first pair of different symbols 
    ;   or 16 if all symbols are equal
    pcmpistri xmm0, dqword [rdi], 11000b
    ; # zf is set if first string is over
    ; # sf is set if second string is over
    ; # cf is set if different symbols were found
    ja .loop 
    
    ; cmp rcx, 16       ; old slower code 
    ; jne .strcmp_diff

    jc .diff

    ; # If no different symbols were found
    xor rax, rax
    ret

.diff:
    ; # Note that you can jump here if there are no different symbols,
    ;   but one string is shorter, than another
    ;   Strings are null-terminated and null is the smallest symbol
    ;   So in this comparison shorter string will occur smaller as needed
    mov rax, rdi 
    movzx rax, byte [rax + rcx] ; store two symbols 
    movzx rdx, byte [rsi + rcx] ; and fill with leading zeroes
    sub rax, rdx                ; difference between symbols
    ret

; g++-multilib
