section .text

global str2double

str2double:
        push rbp                 
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
        jne .prep_fraction
        inc rdi

    .prep_fraction:
        xor rbx, rbx
        mov r10, 4503599627370495   
        mov r12, 10
        xor r11, r11                
        xor rax, rax
        xor rcx, rcx
    .loop:                         
        mov cl, byte [rdi]
        inc rdi
        cmp rcx, 0
        je .done_fraction
        cmp rcx, '.'              
        je .begin_fraction
        test r11, r11
        jz .next_digit
        inc r11
    .next_digit:
        sub rcx, '0'
        mul r12
        add rax, rcx
        cmp rax, r10
        jl .loop
    .begin_fraction:                
        mov r11, 1                  
        jmp .loop
    .done_fraction:                
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
        movsd xmm1, xmm0            
        subsd xmm0, xmm1
        subsd xmm0, xmm1
    .done:
        pop r15                     
        pop r14
        pop r13
        pop r12
        pop rbx
        pop rbp
        ret