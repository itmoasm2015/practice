default rel
global str2double
section .text

%macro isByte 1
    cmp byte [rsi], %1
%endmacro

%macro zero 1
    xor %1, %1
%endmacro

%macro zero 2
    xor%2 %1, %1
%endmacro

%macro makeAlDigit 0
    sub al, '0'
%endmacro

%macro stRegToXmm 2 
    cvtsi2sd xmm%2, %1
%endmacro

str2double:
    mov rsi, rdi ; rdi - minus flag
    isByte '-'
    mov rdi, 1
    jne .after_m
    
    mov rdi, -1
    inc rsi 
    .after_m

    zero xmm0, pd
    isByte '.'
    je .dot

    .before_dot
        mulsd xmm0, [ten]
        zero rax
        lodsb
        makeAlDigit
        stRegToXmm rax, 1
        addsd xmm0, xmm1
        isByte '.'
    jne .before_dot
   
    .dot
    inc rsi
    movsd xmm1, [tenth]
    
    .after_dot
        zero rax
        lodsb
        makeAlDigit
        stRegToXmm rax, 2
       
        mulsd xmm2, xmm1
        addsd xmm0, xmm2
        mulsd xmm1, [tenth]
        
        isByte 0
    jne .after_dot
   
    stRegToXmm rdi, 2
    mulsd xmm0, xmm2
    ret 


.rodata
    tenth dq 0.1
    ten dq 10.0
