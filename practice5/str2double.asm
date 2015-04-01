global str2double
section .text
str2double:
	push rbx
	push rbp
	;mov rdi, [rbp + 8]	;str_ptr

	mov rbx, 0
	mov rcx, 10
	mov r9, 0		;counter
	mov r10, 0		;flag '.'
	mov r11, 0		;flag '-'
	
	.loop:			;read nuber, result stored in rbx
		xor rax, rax
		mov byte al, [rdi]
		inc rdi		;next char
		cmp al,	'.'
		je .dot
		cmp al, 0	;end of str
	 	je .end_of_loop
		cmp al, '-'
		je .negative_flag
	 	imul rbx, 10
	 	sub al, '0'
	 	add rbx, rax
		cmp r10, 1
		jne .loop
		inc r9
		jmp .loop

		.dot:
		mov r10, 1
		jmp .loop

		.negative_flag:
		mov r11, 1
		jmp .loop
	.end_of_loop:

	cmp r11, 1
	jne .sign_done
	neg rbx
	.sign_done:
	
	cvtsi2sd xmm0, rbx
	cvtsi2sd xmm1, rcx
	.div:
	 	cmp r9, 0
	 	je .end_div
	 	divsd xmm0, xmm1
	 	dec r9
	 	jmp .div
	 .end_div:
	
	pop rbp
	pop rbx
	ret
