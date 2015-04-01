global str2double

default rel

str2double:
	xor eax, eax
	xor edx, edx
	movsd xmm2, qword [one]
	cmp [rdi], byte '-'
	jne .plus
	inc rdi
	mov dl, 1
.plus
	xorps xmm0, xmm0
.int_part
	mov al, [rdi]
	inc rdi
	cmp al, '.'
	jz .frac_part

	sub al, '0'
	mulsd xmm0, qword [ten]
	cvtsi2sd xmm1, eax
	addsd xmm0, xmm1
	jmp .int_part
.frac_part
	divsd xmm2, qword [ten]
	mov al, [rdi]
	inc rdi
	test al, al
	jz .finish
	sub al, '0'
	cvtsi2sd xmm1, eax
	mulsd xmm1, xmm2
	addsd xmm0, xmm1
	jmp .frac_part
.finish
	test dl, 1
	jz .return
	mulsd xmm0, qword [minusOne]
.return
	ret

section .rodata
one: dq 1.0
ten: dq 10.0
minusOne: dq -1.0
