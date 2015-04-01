global str2double
section .text

str2double:
	enter	0, 0
	xor		rbx, rbx
	
	cmp		[rdi], byte '-'
	jne		.end_sign
	
	inc		rdi
	mov		rbx, 1
	jmp		.end_sign
.end_sign
	mov		eax, 10
	pxor	xmm0, xmm0
	cvtsi2sd xmm2, eax
	xor		rax, rax
.loop	
	cmp		[rdi], byte '.'
	je		.dot
	mov		al, [rdi]
	sub		al, '0'
	mulsd	xmm0, xmm2
	cvtsi2sd xmm1, rax
	addsd	xmm0, xmm1

	inc		rdi
	jmp		short .loop
.dot
.loop2
	inc		rdi
	cmp		[rdi], byte 0
	jnz		.loop2

	pxor	xmm3, xmm3
.loop3
	dec		rdi
	cmp		[rdi], byte '.'
	je		.sign
	mov		al, [rdi]
	sub		al, '0'
	divsd	xmm3, xmm2
	cvtsi2sd xmm1, rax
	addsd	xmm3, xmm1
	jmp		short .loop3
.sign
	divsd	xmm3, xmm2
	addsd	xmm0, xmm3
	test	rbx, rbx
	jz		.end
	mov		rax, -1
	cvtsi2sd xmm2, rax
	mulsd	xmm0, xmm2
.end



	
	leave
	ret
