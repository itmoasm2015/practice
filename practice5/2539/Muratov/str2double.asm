global str2double

%macro mult 2
	push rax
	push rdx
	mov rax, %1
	mul %2
	mov %1, rax
	pop rdx
	pop rax
%endmacro



section .text

; rdi - pointer to char*	
; returns double in xmm0
str2double:
	;xmm0
	;mov
	;r8 - sign, if r8 = 0 number is positive else negative 
	mov r8, 0
	cmp byte[rdi], '-'
	jne .positive
	inc rdi
	mov r8, 1
.positive



	;parsing number before '.'
    mov r9, 10
    xor rcx, rcx
    xor rax, rax

.next_digit
	cmp byte [rdi], '.'
	je .break    
    mov cl, [rdi]
    sub cl, '0'
    mul r9
    add rax, rcx
    inc rdi
    jmp .next_digit
.break
	cvtsi2sd xmm0, rax


	;parsing number after '.'
	inc rdi
    xor rax, rax
    ;r10 - length of number after '.'
    mov r10, 1

.next_digit2
	cmp byte [rdi], 0
	je .break2
    mov cl, [rdi]
    sub cl, '0'
    mul r9
    add rax, rcx
    inc rdi
    mult r10, r9
    jmp .next_digit2
.break2
	cvtsi2sd xmm1, rax
	cvtsi2sd xmm2, r10
	divsd xmm1, xmm2
	
	addsd xmm0, xmm1


	cmp r8, 1
	jne .ispositive
	xorps xmm1, xmm1
	movsd xmm1, xmm0
	subsd xmm0, xmm1
	subsd xmm0, xmm1
.ispositive

    ret
