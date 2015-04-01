global str2double

section .text

str2double:
		xor 	eax, eax
		mov 	al, byte[rdi]
		cmp	al, '-'
		je	.set_minus_flag
.read_fp	xor 	rcx,rcx
		
.loop_fp	mov 	al, byte[rdi]
		cmp	al, 0
		je	.finish
		cmp	al, '.'
		je	.read_sp
		imul	rcx, 10
		sub	al, '0'
		add	rcx, rax
		inc	rdi
		jmp	.loop_fp
	
.read_sp	cvtsi2sd xmm1, rcx
		inc	rdi
		movsd	xmm0, qword [rel one]
		xor rax, rax
.loop_sp	divsd	xmm0, qword [rel ten]
		mov	al, byte[rdi]
		cmp	al, 0
		je 	.finish
		sub	al, '0'
		cvtsi2sd  	xmm2, rax
		mulsd	xmm2, xmm0
		addsd	xmm1, xmm2
		inc rdi
		jmp .loop_sp
		
.finish		cmp r10, 1
		je .set_minus_sign
.to_ret		movsd xmm0, xmm1
		ret


.set_minus_flag
		mov 	r10, 1
		inc 	rdi
		jmp	.read_fp

.set_minus_sign
		mulsd	xmm1, qword[rel mone]
		jmp .to_ret

section	.rodata
	ten:	 dq 10.0
	one:	 dq 1.0
	mone:	 dq -1.0		